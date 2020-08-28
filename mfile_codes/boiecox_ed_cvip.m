function [ out_img, TH_img, hTH_img ] = boiecox_ed_cvip( input_img, va, hys_th, thin, high_th, low_th )
% BOIECOX_ED_CVIP - Boiecox edge detection of an input image.
%
% Syntax :
% --------
% [ out_img ] = boiecox_ed_cvip( input_img, va, hys_th, thin, high_th, low_th )
% 
% Description :
% -------------
% The function performs the Boiecox edge detection on an image. The Boiecox
% edge detection algorithm was developed by R.A. Boie and I.J. Cox in 1987. 
% The algorithm is similar to that of Canny's edge detection algorithm. It 
% is a multistep algorithm where the image is first blurred with a Gaussian 
% kernel and then a matched filter is applied to the image. The matched 
% filter is used to find and detect the edges in an image and localize them
% to subpixel accuracy. The image is then operated by a wiener filter which
% boosts the signal amplitude and reduces the noise that may be present in 
% the image. Matched filter is applied in an edge normal direction whereas 
% wiener filter is applied along the edge contour.
%
% Input Parameters Include:
% ------------------------
% 
%             'input_img'     The Input Image. Can be Single band or Multi band.
%             
%                    'va'     Variance of the Gaussian blur Kernel.                              
%                             It decides the size of the Gaussian kernel used.
%                             Ranges from 0.5 to 10.          
%             
%                    
%                 'hys_th'    Hysteresis Threshold. It is either 0 or 1.
%                             '1' indicates Hysteresis thresholding.
%                             '0' indicates no hysteresis thresholding.
%                             Default value : 1.
%                     
%                   'thin'    Morphological thinning of output. It is either 0 or 1.
%                             '1' indicates thinning operation.
%                             '0' indicates no thinning operation.
%                             Default value : 1.
%                   
%               'high_th'     High Threshold value used in Hysteresis Thresholding.
%                             Ranges from 1 to 10. When Hysteresis threshold is not selected,
%                             used as a threshold value for ordinary thresholding.
%              
%                 'low_th'    Low Threshold value used in hysteresis thresholding.
%                             Ranges from 0 to 1.
%                      
% Example:          
% -------                 
%                          input_img = imread('car.bmp');
%                          va = 1;
%                          hys_th = 1;
%                          thin = 1;
%                          high_th = 1;
%                          low_th = 0.2;
%                          output = boiecox_ed_cvip(input_img,va,hys_th,thin,high_th,low_th);
%                          figure; imshow(output);
% Reference
% ----------   
%  1. R.A. Boie, I.J. Cox, Two Dimensional Optimum Recognition Using Matched Filters and Wiener
%  Filters for Machine Vision, IEEE First International Conference on Computer Vision,
%  IEEE, pp.450-456, 1987.
 
% =========================================================================
%                     
%           Author:                 Akhila Karlapalem
%           Initial coding date:    11/22/2017
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     01/20/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
% 
% 
% =========================================================================  

% Revision History
%
 % Revision 1.2  01/20/2019  15:41:56  jucuell
 % intermadite variables for Thresholding image output anf hysteresis TH.
%
 % Revision 1.1  11/22/2017  15:21:14  akarlap
 % function creation, coding and initial testing
%

global EDGEX EDGEY EDGE45 EDGE135 diag_scale m n d

input_img = remap_cvip(input_img,[0 255]);
[m,n,d] = size(input_img);
diag_scale = 1.414;
EDGEX = 252;
EDGEY = 253;
EDGE45 = 254;
EDGE135 = 255;

if isempty(hys_th)
    hys_th = 1;
end
if isempty(thin)
    thin = 1;
end
%% create a gaussian filter mask
hlf = int8(sqrt(-log(0.05)*2*va*va));
sze = 2*hlf + 1;
sze = double(sze);

gau = zeros(sze,sze);


for i = 1:sze
    for j = 1:sze
        r = double(i);
        c = double(j);
        u1 = r - (sze + 1)/2;
        u2 = c - (sze + 1)/2;
        gau(i,j) = gaussboie(double(u1), va)* gaussboie(double(u2),va);
    end
end
gau = double(gau);


temp_img = input_img;
%% convovle gaussian filter with image
img_x = convn(temp_img,gau,'same');
%% Find determinants in four different directions
imgdetx = img_detx(img_x);
imgdety = img_dety(img_x);
imgdet135 = img_det135(img_x);
imgdet45 = img_det45(img_x);

TH_img = zeros(m,n,d);

sx = abs(imgdetx(:,:,:));
sy = abs(imgdety(:,:,:));
s45 = int8(double(abs(imgdet45(:,:,:))./diag_scale));
s135 = int8(double(abs(imgdet135(:,:,:))./diag_scale));

%% Apply Ordinary Thresholding   
    
    threshold = image_threshold(imgdetx(:,:,:));   
    
        thresholdValue = high_th*threshold;   
   
    for r = 1:m 
        for c = 1:n      
           
            big = sx(r,c,:);
            orient_flag = EDGEX;
            
            if (sy(r,c,:) > big)
                big = sy(r,c,:);
                orient_flag = EDGEY;
            end
            if (s45(r,c,:) > big)
                big = s45(r,c,:);
                orient_flag = EDGE45;
            end
            if (s135(r,c,:) > big)
                big = s135(r,c,:);
                orient_flag = EDGE135;
            end
           
           for b = 1:d
               if (big(b) > thresholdValue(b))
                switch orient_flag
                    case EDGEX
                        TH_img(r,c,b) = image_zc_x(r,c,imgdetx,b);
                        
                    case EDGEY
                        TH_img(r,c,b) = image_zc_y(r,c,imgdety,b);
                        
                    case EDGE45
                        TH_img(r,c,b) = image_zc_45(r,c,imgdet45,b);
                        
                    case EDGE135
                        TH_img(r,c,b) = image_zc_135(r,c,imgdet135,b);
                end
               end
           end
        end
    end        
    out_img = TH_img;    

%% Apply Hysteresis Thresholding
hTH_img = 0;
if isequal(hys_th,1)
    low_threshold = double(thresholdValue.*low_th);   
    hTH_img = image_hysteresis(imgdetx,imgdety,imgdet45,imgdet135,out_img,low_threshold);
    out_img = hTH_img;
end
%% Apply thinning 
if isequal(thin,1)
    out_img = image_thin(out_img);
end

end


function [ z ] = gaussboie( x,va )

x = double(x);
if isequal(va,0)
    z = double(zero(size(x)));
    return;
end
z1 = (-x.*x)/(2*va*va);
z2 = (va*sqrt(2*pi));
z = double(exp(double(z1))/z2);
end

function [imgdetx] = img_detx(img_x)
global m n d
imgdetx = zeros(m,n,d);

image2 = img_x;


% Middle Columns
j = 3:n-1;

        imgdetx(:,j,:) = image2(:,j+1,:) - image2(:,j-1,:);

end

function [imgdety] = img_dety(img_x)
global m n d

imgdety = zeros(m,n,d);

image2 = img_x;

% Middle Rows

i = 3:m-1;
   
        imgdety(i,:,:) = image2(i+1,:,:) - image2(i-1,:,:);


end

function [imgdet135] = img_det135(img_x)
global m n d
imgdet135 = zeros(m,n,d);

image2 = img_x;

j = 3:n-1;



% Diagonal
for i = 3:m-1

        imgdet135(i,j,:) = image2(i+1,j+1,:) - image2(i-1,j-1,:);

end



i = 3:m-1;

% Right Column

    imgdet135(i,n,:) = image2(i+1,n,:) - image2(i-1,n-1,:);


% Bottom Row Without Corner Pixels

    j = 3:n-1;
    imgdet135(m,j,:) = image2(m,j+1,:) - image2(m-1,j-1,:);


% Top Left Corner
imgdet135(1,1,:) = image2(2,2,:) - image2(1,1,:);

% Bottom Left Corner
imgdet135(m,1,:) = image2(m,2,:) - image2(m-1,1,:);

% Bottom Right Corner
imgdet135(m,n,:) = image2(m,n,:) - image2(m-1,n-1,:);

% Top Right Corner
imgdet135(1,n,:) = image2(2,n,:) - image2(1,n-1,:);

imgdet135(:,:,:) = imgdet135;


end

function [imgdet45] = img_det45(img_x)
global m n d
imgdet45 = zeros(m,n,d);

image2 = img_x;
    j = 3:n-1;
% Diagonal
for i = 3:m-1

        imgdet45(i,j,:) = image2(i+1,j-1,:) - image2(i-1,j+1,:);

end


    i = 3:m-1;

% Right Column

    imgdet45(i,n,:) = image2(i+1,n-1,:) - image2(i-1,n,:);


% Bottom Row without Corner Pixels

    j = 3:n-1;
    imgdet45(m,j,:) = image2(m,j-1,:) - image2(m-1,j+1,:);


% Top Left Corner
imgdet45(1,1,:) = image2(2,1,:) - image2(1,2,:);

% Bottom Left Corner
imgdet45(m,1,:) = image2(m,1,:) - image2(m-1,2,:);

% Bottom Right Corner
imgdet45(m,n,:) = image2(m,n-1,:) - image2(m-1,n,:);

% Top Right Corner
imgdet45(1,n,:) = image2(2,n-1,:) - image2(1,n,:);

imgdet45(:,:,:) = imgdet45;


end

function [threshold] = image_threshold(imagedetx)
global m n d
threshold = zeros(1,1,d);
for b = 1:d
a = imagedetx(:,:,b);
s = sum(a(:));
mad2 = s/numel(imagedetx);
mad1 = abs(imagedetx(:,:,b) - mad2);
mad = sum(mad1(:));
threshold(:,:,b) = int8(double((3*mad/m/n))/0.8);
end
end

function [outImage] = image_thin(out_img)
global m n d
for b = 1:d
    for j = 2:n-1
        for i = 2:m-1
            b01 = out_img(i-1,j,b) > 0;
            b12 = out_img(i,j+1,b) > 0;
            b21 = out_img(i+1,j,b) > 0;
            b10 = out_img(i,j-1,b) > 0;
            
            if ((b01 + b12 + b21 + b10) > 1)
                b00 = out_img(i-1,j-1,b) > 0;
                b02 = out_img(i-1,j+1,b) > 0;
                b20 = out_img(i+1,j-1,b) > 0;
                b22 = out_img(i+1,j+1,b) > 0;
                
                p1 = b00|b01;
                p2 = b02|b12;
                p3 = b22|b21;
                p4 = b20|b10;
                
                nlinks(1) = b01 & p2;
                nlinks(2) = b12 & p3;
                nlinks(3) = b21 & p4;
                nlinks(4) = b10 & p1;
                
                nlinks = sum(nlinks(:));
                
                npieces = p1 + p2 + p3 + p4;
                
                if ((npieces - nlinks) < 2)
                    out_img(i,j,b) = 0;
                end
            end
        end
    end
end

outImage = out_img;
end

function [out] = image_zc_x(r,c,imgdetx,b)
global EDGEX
a1 = image_locx(c,r,imgdetx,b);
a2 = image_locx(c+1,r,imgdetx,b);

    if ~isequal((a1 > 0),a2 > 0)
        out = EDGEX;
    else
        out = 0;
    end
end


function [out] = image_zc_y(r,c,imgdety,b)
global EDGEY
a1 = image_locy(c,r+1,imgdety,b);
a2 = image_locy(c,r,imgdety,b);

    if ~isequal(a1 > 0,a2 > 0)
        out = EDGEY;
    else
        out = 0;
    end
end


function [out] = image_zc_45(r,c,imgdet45,b)
global EDGE45
a1 = image_loc45(c-1,r+1,imgdet45,b);
a2 = image_loc45(c,r,imgdet45,b);


if ~isequal(a1 > 0,a2 > 0)
    out = EDGE45;
else
    out = 0;
end

end

function [out] = image_zc_135(r,c,imgdet135,b)
global EDGE135
a1 = image_loc135(c+1,r+1,imgdet135,b);
a2 = image_loc135(c,r,imgdet135,b);

if ~isequal(a1> 0,a2 > 0)
    out = EDGE135;
else
    out = 0;
end

end

function [out] = image_locx(c,r,imgdetx,b)
global m n 


if (r < 2) || (r > m - 2) || (c < 2) || (c > n-1)
    out = 0;
    return;
end
out = imgdetx(r,c,b) - imgdetx(r,c-1,b);

end

function [out] = image_locy(c,r,imgdety,b)
global m n 


if (r < 2) || (r > m-1) || (c < 2) || (c > n-2)
    out = 0;
    return;
end
out = imgdety(r,c,b) - imgdety(r-1,c,b);
end

function [out] = image_loc45(c,r,imgdet45,b)
global m n 

if (r < 2) || (r > m-2) || (c < 2) || (c > n-2)
    out = 0;
    return;
end
out = imgdet45(r,c,b) - imgdet45(r-1,c+1,b);

end

function [out] = image_loc135(c,r,imgdet135,b)
global m n 

if (r < 2) || (r > m-2) || (c < 2) || (c > n-2)
    out = 0;
    return;
end
out = imgdet135(r,c,b) - imgdet135(r-1,c-1,b);
end


function [out_img] = image_hysteresis(imgdetx,imgdety,imgdet45,imgdet135,out_img,low_threshold)

global tempHyst m n d
tempHyst = zeros(m,n,d);
tempHyst(2:m,2:n,1) = out_img(2:m,2:n,1);
if (d > 1)
    for f = 2:d
    tempHyst(2:m,2:n,f) = out_img(2:m,2:n,f);   
    end
end

[row,col] = find(tempHyst);
for i = 1:length(row)    
if (col(i) <= n )
    b = 1;
elseif (col(i)> n) && (col(i) <= n*2)
    b = 2;
else
    b = 3;
end    
    image_neighbor_fwd(imgdetx,imgdety,imgdet45,imgdet135,col(i),row(i),low_threshold(b));
    image_neighbor_bwd(imgdetx,imgdety,imgdet45,imgdet135,col(i),row(i),low_threshold(b));

end
out_img = tempHyst;
end

function [] = image_neighbor_fwd(imgdetx,imgdety,imgdet45,imgdet135,j,i,low_threshold)

global tempHyst EDGEX EDGEY EDGE45 EDGE135  m n d
choice = tempHyst(i,j);
switch choice
    case EDGEY
        [Fout11] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j,i+1,low_threshold);
        [Fout21] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j,i+2,low_threshold);
        [Fout31] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j-1,i+1,low_threshold);
        [Fout41] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j+1,i+1,low_threshold);
        [Fout51] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j-1,i+2,low_threshold);
        [Fout61] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j+1,i+2,low_threshold);
        if ~(Fout11) && (Fout21)
            if ((i+1 < m+1 ) && (tempHyst(i-1,j+1) == 0))                
                tempHyst(i,j+1) = 5;                           
            end
        elseif (~(Fout31) || (Fout41)) && ((Fout51) || (Fout61))
            if ((i+1 < m+1 ) && (tempHyst(i-1,j+1) == 0))       
                
                tempHyst(i,j+1) = 5;              
           
            end
        end
        
    case EDGE135
        [Fout11] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j-1,i+1,low_threshold);
        [Fout21] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j-2,i+2,low_threshold);
        [Fout31] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j,i+1,low_threshold);
        [Fout41] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j-1,i,low_threshold);
        [Fout51] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j-2,i+1,low_threshold);
        [Fout61] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j-1,i+2,low_threshold);
        if ~(Fout11) && (Fout21)
            if ((j-1) >= 1 ) && (i+1 < m+1 ) && (tempHyst(i-1,j+1) == 0)               
                tempHyst(i-1,j+1) = 5;           
            end
        elseif (~(Fout31) || (Fout41)) && ((Fout51) || (Fout61))
            if ((j-1) >= 1 ) && (i+1 < m+1 ) && (tempHyst(i-1,j+1) == 0)            
               
                tempHyst(i-1,j+1) = 5;
          
            end
        end
       
    case EDGEX
        [Fout11] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j-1,i,low_threshold);
        [Fout21] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j-2,i,low_threshold);
        [Fout31] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j-1,i-1,low_threshold);
        [Fout41] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j-1,i+1,low_threshold);
        [Fout51] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j-2,i-1,low_threshold);
        [Fout61] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j-2,i+1,low_threshold);
        if ~(Fout11) && (Fout21)
            if ((j-1 >= 1) && (tempHyst(i-1,j) == 0))
               
                tempHyst(i-1,j) = 5;
           
            end
        elseif (~(Fout31) || (Fout41)) && ((Fout51) || (Fout61))
            if ((j-1 >= 1) && (tempHyst(i-1,j) == 0))              
                tempHyst(i-1,j) = 5;
          
            end
        end
        
        
    case EDGE45
        [Fout11] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j+1,i+1,low_threshold);
        [Fout21] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j+2,i+2,low_threshold);
        [Fout31] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j,i+1,low_threshold);
        [Fout41] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j+1,i,low_threshold);
        [Fout51] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j+1,i+2,low_threshold);
        [Fout61] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j+2,i+1,low_threshold);
        if ~(Fout11) && (Fout21)
            if ((j+1) < n*d+1 ) && (i+1 < m+1) && (tempHyst(i+1,j+1) == 0)              
                tempHyst(i+1,j+1) = 5;
         
            end
        elseif (~(Fout31) || (Fout41)) && ((Fout51) || (Fout61))
            if ((j+1) < n*d+1 ) && (i+1 < m+1 ) && (tempHyst(i+1,j+1) == 0)
              
                tempHyst(i+1,j+1) = 5;
            end
        end
        return;      
    otherwise
        return;        
end
end


function [] = image_neighbor_bwd(imgdetx,imgdety,imgdet45,imgdet135,j,i,low_threshold)
global tempHyst EDGEX EDGEY EDGE45 EDGE135   n d



choice = tempHyst(i,j);

switch choice
    case EDGEY
        [Bout11] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j,i-1,low_threshold);
        [Bout21] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j,i-2,low_threshold);
        [Bout31] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j-1,i-1,low_threshold);
        [Bout41] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j+1,i-1,low_threshold);
        [Bout51] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j-1,i-2,low_threshold);
        [Bout61] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j+1,i-2,low_threshold);
        if ~(Bout11) && (Bout21)
            if ((i-1 >= 1) && (tempHyst(i,j-1) == 0))
              
                tempHyst(i,j-1) = 5;
        
            end
        elseif (~(Bout31) || (Bout41)) && ((Bout51) || (Bout61))
            if ((i-1 >= 1) && (tempHyst(i,j-1) == 0))
                
                tempHyst(i,j-1) = 5;
     
            end
        end
        
    case EDGE135
        [Bout11] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j+1,i-1,low_threshold);
        [Bout21] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j+2,i-2,low_threshold);
        [Bout31] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j,i-1,low_threshold);
        [Bout41] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j+1,i,low_threshold);
        [Bout51] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j+1,i-2,low_threshold);
        [Bout61] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j+2,i-1,low_threshold);
        if ~(Bout11) && (Bout21)
            if ((j+1) < n*d+1 ) && (i-1 >= 1) && (tempHyst(i+1,j-1) == 0)
                
                tempHyst(i+1,j-1) = 5;
         
            end
        elseif (~(Bout31) || (Bout41)) && ((Bout51) || (Bout61))
            if ((j+1) < n*d+1) && (i-1 >= 1) && (tempHyst(i+1,j-1) == 0)
              
                tempHyst(i+1,j-1) = 5;        
            end
        end
        
    case EDGEX
        [Bout11] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j+1,i,low_threshold);
        [Bout21] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j+2,i,low_threshold);
        [Bout31] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j+1,i-1,low_threshold);
        [Bout41] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j+1,i+1,low_threshold);
        [Bout51] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j+2,i-1,low_threshold);
        [Bout61] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j+2,i+1,low_threshold);
        if ~(Bout11) && (Bout21)
            if ((j+1 < n*d+1 ) && (tempHyst(i+1,j) == 0))
              
                tempHyst(i+1,j) = 5;
        
            end
        elseif (~(Bout31) || (Bout41)) && ((Bout51) || (Bout61))
            if ((j+1 < n*d+1 ) && (tempHyst(i+1,j) == 0))               
                tempHyst(i+1,j) = 5;      
            end
        end
        
    case EDGE45
        [Bout11] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j-1,i-1,low_threshold);
        [Bout21] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j-2,i-2,low_threshold);
        [Bout31] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j,i-1,low_threshold);
        [Bout41] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j-1,i,low_threshold);
        [Bout51] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j-1,i-2,low_threshold);
        [Bout61] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j-2,i-1,low_threshold);
        if ~(Bout11) && (Bout21)
            if ((j-1) >= 1 ) && (i-1 >= 1) && (tempHyst(i-1,j-1) == 0)
                
                tempHyst(i-1,j-1) = 5;   
            end
        elseif (~(Bout31) || (Bout41)) && ((Bout51) || (Bout61))
            if ((j-1) >= 1 ) && (i-1 >= 1) && (tempHyst(i-1,j-1) == 0)
              
                tempHyst(i-1,j-1) = 5;
       
            end
        end       
    
    otherwise
         return;
end
end

function [out] = Fcontour(imgdetx,imgdety,imgdet45,imgdet135,j,i,low_threshold)

global tempHyst  m n d

if (i <= 1)||(i >= m)||(j <= 1)||(j >= n*d)
    out = 0;
   
    return;
end

if ~(tempHyst(i,j)==0)
    out = 1;    
    return;
elseif ~(image_edge_map_lo(imgdetx,imgdety,imgdet45,imgdet135,i,j,low_threshold) == 0)
    tempHyst(i,j) = image_edge_map_lo(imgdetx,imgdety,imgdet45,imgdet135,i,j,low_threshold);
    image_neighbor_fwd(imgdetx,imgdety,imgdet45,imgdet135,j,i,low_threshold);
    out = 1;
    
    return;
else
    out = 0;    
    return;
end
end

function [out] = Bcontour(imgdetx,imgdety,imgdet45,imgdet135,j,i,low_threshold)

global tempHyst m n d

if (i <= 1)||(i >= m)||(j <= 1)||(j >= n*d)
    out = 0;
    
    return;
end
if ~(tempHyst(i,j)==0)
    out = 1;
   
    return;
elseif ~(image_edge_map_lo(imgdetx,imgdety,imgdet45,imgdet135,i,j,low_threshold) == 0)
    tempHyst(i,j) = image_edge_map_lo(imgdetx,imgdety,imgdet45,imgdet135,i,j,low_threshold);
    image_neighbor_bwd(imgdetx,imgdety,imgdet45,imgdet135,j,i,low_threshold);
   
    out = 1;
    return;
else
    out = 0;
    
    return;
end
end

function [out] = image_edge_map_lo(imgdetx,imgdety,imgdet45,imgdet135,i,j,low_threshold)
global EDGEX EDGEY EDGE45 EDGE135 diag_scale
sx = abs(imgdetx(i,j));
sy = abs(imgdety(i,j));
s45 = int8(double(abs(imgdet45(i,j)))/diag_scale);
s135 = int8(double(abs(imgdet135(i,j)))/diag_scale);
out = 0;
big = sx;
orient_flag = EDGEX;

if (sy > big)
    big = sy;
    orient_flag = EDGEY;
end
if (s45 > big)
    big = s45;
    orient_flag = EDGE45;
end
if (s135 > big)
    big = s135;
    orient_flag = EDGE135;
end

if (big > low_threshold)
    switch orient_flag
        case EDGEX
            out = image_zc_x_hys(i,j,imgdetx);
        case EDGEY
            out = image_zc_y_hys(i,j,imgdety);
        case EDGE45
            out = image_zc_45_hys(i,j,imgdet45);
        case EDGE135
            out = image_zc_135_hys(i,j,imgdet135);
    end
else
   out = 0; 
end
end



function [out] = image_zc_x_hys(r,c,imgdetx)
global EDGEX
a1 = image_locx_hys(c,r,imgdetx);
a2 = image_locx_hys(c+1,r,imgdetx);

    if ~isequal((a1 > 0),a2 > 0)
        out = EDGEX;
    else
        out = 0;
    end
end


function [out] = image_zc_y_hys(r,c,imgdety)
global EDGEY
a1 = image_locy_hys(c,r+1,imgdety);
a2 = image_locy_hys(c,r,imgdety);

    if ~isequal(a1 > 0,a2 > 0)
        out = EDGEY;
    else
        out = 0;
    end
end


function [out] = image_zc_45_hys(r,c,imgdet45)
global EDGE45
a1 = image_loc45_hys(c-1,r+1,imgdet45);
a2 = image_loc45_hys(c,r,imgdet45);


if ~isequal(a1 > 0,a2 > 0)
    out = EDGE45;
else
    out = 0;
end

end

function [out] = image_zc_135_hys(r,c,imgdet135)
global EDGE135
a1 = image_loc135_hys(c+1,r+1,imgdet135);
a2 = image_loc135_hys(c,r,imgdet135);

if ~isequal(a1> 0,a2 > 0)
    out = EDGE135;
else
    out = 0;
end

end

function [out] = image_locx_hys(c,r,imgdetx)
global m n d


if (r < 2) || (r > m - 2) || (c < 2) || (c > n*d-1)
    out = 0;
    return;
end
out = imgdetx(r,c) - imgdetx(r,c-1);

end

function [out] = image_locy_hys(c,r,imgdety)
global m n d


if (r < 2) || (r > m-1) || (c < 2) || (c > n*d-2)
    out = 0;
    return;
end
out = imgdety(r,c) - imgdety(r-1,c);
end

function [out] = image_loc45_hys(c,r,imgdet45)
global m n d

if (r < 2) || (r > m-2) || (c < 2) || (c > n*d-2)
    out = 0;
    return;
end
out = imgdet45(r,c) - imgdet45(r-1,c+1);

end

function [out] = image_loc135_hys(c,r,imgdet135)
global m n d

if (r < 2) || (r > m-2) || (c < 2) || (c > n*d-2)
    out = 0;
    return;
end
out = imgdet135(r,c) - imgdet135(r-1,c-1);
end