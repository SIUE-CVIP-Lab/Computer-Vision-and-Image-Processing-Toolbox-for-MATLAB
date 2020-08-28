function [ CRF ] = harris_corner_cvip( input_img , threshold, std, alfa, maxsupress)
% HARRIS_CORNER_CVIP - a spatial edge detecting filter.
%
% Syntax :
% -------
% [ CRF ] = harris_corner_cvip( input_img , threshold, std, alfa, maxsupress)
%
% Input Parameters include :
% --------------------------
%
%  'input_img'   The input image.Can be multiband
%
%  'threshold'   A rational value in the interval [0,1].
%                It is used in the thresholding step as a coefficeient
%                multiplied to the maximum gray level in the input  image.
%                   
%
%       'std'    The Standard Deviation of the Gaussian blur kernel.
%                the size of the gaussian is related to std by:
%                size = 4*std Thus we have 2 standard deviation of the gaussian
%                inside the kernel.
% 
%      'alfa'    Sensitivity value.
%         
% 'maxsupress'   Option to supress non-maxima either in a neighbourhood
%                or based on direction. It is either '1' or '2'.
%                Default: 2.
%                     
%
% Output Parameter include :
% -------------------------
%  'CRF'       Corner response function.
%
% Example:
% ------- 
%        I = imread('Shapes.bmp');
%        threshold = 0.2;
%        std = 4;
%        alfa = 0.5;
%        maxsupress = 2;
%        [ CRF ] = harris_corner_cvip( I, threshold, std,alfa, maxsupress);
%        figure;imshow(I);title('Input Image');
%        figure; imshow(CRF);title('Resultant Image from corner response function');
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    7/11/2017
%           Latest update date:     7/14/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================


%fprintf('The size of the gaussian is: %d \n', floor(4*std));
if isempty(maxsupress)
    maxsupress = 2;
end
%% Blur input image --- Gaussian
input_img = blur_gauss(input_img, std);

%% User Prewit or Sobel to find s1,s2
hor = [-1 0 1; -1 0 1; -1 0 1];
ver = [-1 -1 -1; 0 0 0; 1 1 1];
[m,n,o] = size(input_img);
s1 = zeros(m,n,o);
s2 = zeros(m,n,o);
for i=1:o
    s1(:,:,i) = conv2(input_img(:,:,i), hor,'same');
    s2(:,:,i) = conv2(input_img(:,:,i), ver,'same');
    
end
edge_dir = atan2(s1,s2);

%% Blur s1,s2 with Gaussian
    s1 = blur_gauss(s1, std);
    s2 = blur_gauss(s2, std);
    s1_2 =  blur_gauss(s1.*s1, std);
    s2_2 =  blur_gauss(s2.*s2, std);
    
    s1_s2 = blur_gauss(s1.*s2, std);

%% compute CRF
    CRF = ((s1_2).*(s2_2) - (s1_s2.^2)) - ( alfa*( (s1 + s2).^2 ) );

%% Threshold CRF and apply nonmaxima suppression
x = threshold*max(CRF(:));
%fprintf('The threshold value is: %f \n', x);
new_edge_mag = CRF;
directions = [0 pi/4 pi/2 3*pi/4 pi -pi -3*pi/4 -pi/2 -pi/4];
switch maxsupress
    case 1
        % non-maxima supression in a eight different directions
        for k=1:o
            for i=2:(m-1)
                for j=2:(n-1)
                    [~,dir] = min(abs(edge_dir(i,j,k) -  directions));
                    if dir ==5 || dir == 6 || dir ==1
                        if CRF(i,j,k) < CRF(i+1,j,k) || CRF(i,j,k) < CRF(i-1,j,k)
                            new_edge_mag(i,j,k) = 0;
                        end
                    elseif dir == 3 || dir == 8
                        if CRF(i,j,k) < CRF(i,j+1,k) || CRF(i,j,k) < CRF(i,j-1,k)
                            new_edge_mag(i,j,k) = 0;
                        end
                    elseif dir == 4 || dir ==9
                        if CRF(i,j,k) < CRF(i-1,j+1,k) || CRF(i,j,k) < CRF(i+1,j-1,k)
                            new_edge_mag(i,j,k) = 0;
                        end
                    elseif dir == 2 || dir == 7
                        if CRF(i,j,k) < CRF(i+1,j+1,k) || CRF(i,j,k) < CRF(i-1,j-1,k)
                            new_edge_mag(i,j,k) = 0;
                        end
                    end
                end
            end
        end
        
    case 2
        % non-maxima supression in a 3x3 neighbourhood
        for k=1:o
            for i=2:(m-1)
                for j=2:(n-1)
                    if (CRF(i,j,k) < CRF(i-1,j-1,k))  || (CRF(i,j,k) < CRF(i-1,j,k)) || (CRF(i,j,k) < CRF(i-1,j+1,k))...
                            || (CRF(i,j,k) < CRF(i,j-1,k)) || (CRF(i,j,k) < CRF(i,j+1,k)) || (CRF(i,j,k) < CRF(i+1,j-1,k))...
                            || (CRF(i,j,k) < CRF(i+1,j,k)) || (CRF(i,j,k) < CRF(i+1,j+1,k))
                        new_edge_mag(i,j,k) = 0;
                    end
                end
            end
        end
end
                    
CRF = new_edge_mag;
CRF(CRF < x) = 0;
CRF(CRF > x) = 1;





end

function I_blured = blur_gauss(I,std)
I = double(I);
I_blured = zeros(size(I));
    height = floor(4*std);
    width = height;
    %std = min([width,height])/4;
    h = h_image_cvip( 3,   height, width);
    for i=1:size(I,3)
        I_blured(:,:,i) = conv2(I(:,:,i),h,'same');
    end
end