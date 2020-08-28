function [ outImage ] = sct_split_cvip( inImage, nColorsA, nColorsB, option)
% SCT_SPLIT_CVIP - Perform Sphere Coordinate Transform/Center color segmenation
% The function performs the image segmentation using spherical coordinate
% transform(SCT) method (also termed as Center sgmentation).The 
% algorithm performs the Spherical Coordinate Transform, and divides the 
% color space by splitting the 2-D space created by angles A and B.This
% division is done by a simple center split - that is, evenly divided 
% along each angle axis based on the numbers specified.Note that only 
% the subspace contained in the image is used (this means the maximums 
% and minimums are found along each axis and these limit the subspace 
% used for the division).After this is done, we implemented two methods
% to map original color vectors to new colors.In first method, i.e. 
% option = 1, it finds the pixels that belong to each subspace, finds the   
% RGB color vectors associated to those pixels, computes the  mean of 
% color vectors, and assigns the average color to all pixels that belong
% to the subspace.In second method, i.e. option = 2, it computes the 
% average color in SCT domain.The average is found for each color in
% each subdivision, assigns each average color to corresponding subspace,
% and performs the inverse-SCT.
%
% Syntax :
% -------
%  outImage = sct_split_cvip(inImage, Asplit, Bsplit, option)
%   
% 
% Input Parameters include :
% ------------------------
%   'inImage'       1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. The input image can be of uint8 or uint16 
%                   or double class. 
%   'nColorsA'      Number of colors along axis A. 
%                   NumColors = 2(default)
%   'nColorsB'      Number of colors along axis B. 
%                   NumColors = 2(default)
%   'option'        Option for mapping of color vectors method. 
%                   If Option = 1, it computes mean in RGB domain. 
%                   If Option = 2, it computes mean in SCT domain.
%                   Option = 1(default)
%
%
% Output Parameter include :  
% ------------------------
%   'outImage'      Segmented image having same size and same class of
%                   input image
%                                         
%
% Example :
% -------
%                   I = imread('butterfly.tif');   %original image
%                   O1 = sct_split_cvip(I);        %default parameters         
%                   nA = 4;                        %number of colors along axis A
%                   nB = 6;                        %number of colors along axis B
%                   O2 = sct_split_cvip(I,nA,nB);     %still option is default
%                   O3 = sct_split_cvip(I,nA,nB,2);   %user defined parameters                 
%                   figure;imshow(O1,[]);
%                   figure;imshow(O2,[]);
%                   figure;imshow(O3,[]);
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    2/17/2017
%           Latest update date:     3/28/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================
if nargin ~=1 && nargin ~= 3 && nargin ~= 4 
    error('Too many or too few input arguments!');
end
if nargout ~=1 && nargout ~=0
    error('Too many or too few output arguments!');
end

%set up the default parameters
if nargin == 1
    nColorsA = 2;
    nColorsB = 2;
    option = 1;      
elseif nargin == 3    
    if ~isnumeric(nColorsA)|| ~isnumeric(nColorsB)
        nColorsA = 2;
        nColorsB = 2;       
        warning('nColorsA or nColorsB is not numeric');
    end
    option = 1;  
elseif nargin == 4
    if ~isnumeric(nColorsA)|| ~isnumeric(nColorsB)
        nColorsA = 2;
        nColorsB = 2;       
        warning('nColorsA or nColorsB is not numeric');
    end
    if option ~= 1 && option ~= 2
        warning('No such option available!');
        option = 1;
    end
end

if nargout ~= 1 && nargout ~= 0
    error('Too many output arguments!');
end

%check if input image is RGB image
[nrow,ncol,bands] = size(inImage);
if bands ~= 3
    inImage(:,:,2) = inImage(:,:,1);
    inImage(:,:,3) = inImage(:,:,1);   
end

%convert M*N*B input image into 3 vectors corresponding to red, green and
%blue band
red_band = inImage(:,:,1);
green_band = inImage(:,:,2);
blue_band = inImage(:,:,3);
rgb = double([red_band(:) green_band(:) blue_band(:)]); 

%transform RGB values to spherical coordinate values
Ep = 1e-6; %to avoid divide by zero condition, add very small value in denominator
radius = (rgb(:,1).^2 + rgb(:,2).^2 + rgb(:,3).^2).^0.5;
angleA = acos(rgb(:,3)./(radius+Ep));
angleB = atan(rgb(:,2)./(rgb(:,1)+Ep));

%compute the minima and maxima of angle A nad angle B
minA = min(angleA);
maxA = max(angleA);
minB = min(angleB);
maxB = max(angleB);

edgesA = minA: (maxA-minA)/nColorsA: maxA;
edgesB = minB: (maxB-minB)/nColorsB: maxB;

%if the image is completely black image, both edges will be empty
if isempty(edgesA)&& isempty(edgesB)
    outImage = inImage;
    return;
end

switch option
    case 1         %computes mean in RGB domain
        
        %Divide the subspace, define by the maxima and minima, into equal-sized
        %blocks
        for i=1:nColorsA    
            if i==1  %to count pixel value equal to edge value only once        
                [rNotA,~] = find(angleA >= edgesA(i+1));
            elseif i == nColorsA
                [rNotA,~] = find(angleA < edgesA(i));
            else        
                [rNotA,~] = find(angleA < edgesA(i) | angleA >= edgesA(i+1));
            end
            
           if length(rNotA) == nrow*ncol, continue;
           end
     
            for j=1:nColorsB
                temp= angleB;
                temp(rNotA)=nan;
                if j==1
                    temp(temp >= edgesB(j+1)) = nan;
                elseif j == nColorsB
                    temp(temp < edgesB(j)) = nan;
                else
                    temp(temp < edgesB(j) | temp >= edgesB(j+1)) = nan;
                end            

                [r_nan,~] = find(isnan(temp));
                [r,~] = find(~isnan(temp));
                if isempty(r), continue;
                end
                temp2 = rgb;
                temp2(r_nan,:) = 0;
                pixel_count=length(r);        
                meanval = sum(temp2)./pixel_count; 
                %replacing the original pixel values with the corresponding RGB means
                rgb(r,:) = ones(pixel_count,1)*meanval;                  
            end
        end
    case 2         %computes mean in SCT domain
        %Divide the subspace, define by the maxima and minima, into equal-sized
        %blocks
        sctimg = [radius angleA angleB];
        for i=1:nColorsA    
            if i==1  %to count pixel value equal to edge value only once        
                [rNotA,~] = find(angleA >= edgesA(i+1));
            elseif i == nColorsA
                [rNotA,~] = find(angleA < edgesA(i));
            else        
                [rNotA,~] = find(angleA < edgesA(i) | angleA >= edgesA(i+1));
            end
        
            for j=1:nColorsB
                temp= angleB;
                temp(rNotA)=nan;
                if j==1
                    temp(temp >= edgesB(j+1)) = nan;
                elseif j == nColorsB
                    temp(temp < edgesB(j)) = nan;
                else
                    temp(temp < edgesB(j) | temp >= edgesB(j+1)) = nan;
                end     
                [r_nan,~] = find(isnan(temp));
                [r,~] = find(~isnan(temp));
                temp2 = sctimg;
                temp2(r_nan,:) = 0;
                pixel_count=length(r);        
                meanval = sum(temp2)./pixel_count; 
                %replacing the original pixel values with the corresponding RGB means
                sctimg(r,:) = ones(pixel_count,1)*meanval;        
            end
        end
        rgb = [sctimg(:,1).*sin(sctimg(:,2)).*cos(sctimg(:,3)) sctimg(:,1).*sin(sctimg(:,2)).*sin(sctimg(:,3)) sctimg(:,1).*sin(sctimg(:,2))];
    
end
%reshape into original M*N*B pixels
outImage(:,:,1) = reshape(rgb(:,1),[nrow ncol]);
outImage(:,:,2) = reshape(rgb(:,2),[nrow ncol]);
outImage(:,:,3) = reshape(rgb(:,3),[nrow ncol]);

%make the output class type as the class of input image
%or in default option, output image is of double class

if isa(inImage,'uint8')
    outImage = uint8(outImage);
elseif isa(inImage,'uint16')
    outImage = uint16(outImage);
end

end

