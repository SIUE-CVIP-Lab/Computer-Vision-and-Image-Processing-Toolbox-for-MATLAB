function [ outImage ] = autothreshold_cvip( inImage, limit )
% AUTOTHRESHOLD_CVIP - Automatic thresholding of an image.
% The function performs the automatic threshold operation of an image.
% The threshold value depends on the limit.The threshold value will be 
% updated repeatedly until the error between new threshold and old 
% threshold is equal or less than limit.Usually the limit value is the 
% small value (typically 0 to 20.0).If the limit value is less, the
% threshold value is good.
%
% Syntax:
% -------
% outImage = autothreshold_cvip(inImage, limit)
%    
% Input Parameters include :
% ------------------------
%   'inImage'       1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. The input image can be of uint8 or double
%                   class. If double class, the function assumes
%                   the data range of image is from 0 to 1.
%   'limit'         Limit to stop the threshold update. Usually, it is
%                   small value that ranges from 0 to 20.0.
%                   limit = 10.0 (default)
%
%
% Output Parameter include :  
% ------------------------
%   'outImage'      Thresholded image having same size and same class of
%                   input image. 
%                                         
%
% Example :
% -------
%                   I = imread('raphael.jpg');       %original image
%                   O1 = autothreshold_cvip(I);      %default: limit = 10.0          
%                   limit = 2.5;                        %new limit
%                   O2 = autothreshold_cvip(I,limit);   %user specified limit
%                   figure; imshow(hist_stretch_cvip(O2,0,1,0,0),[]);
%
% Reference
% ---------
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    1/30/2017
%           Latest update date:     3/27/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

WHITE_LAB = 255;
BLACK_LAB = 0;

%check number of input and output arguments
if nargin ~= 1  && nargin ~= 2
    error('Too many or too few input arguments!')
end
if nargout ~= 0 && nargout ~= 1 
    error('Too many or too few output arguments!')
end

%check input image type is either complex or real
if nargin == 1    
     limit = 10.0;
elseif nargin == 2
    if limit < 0 && limit > 20
        warning('Limit typically ranges from 0 to 20.0')
    end
end 

%convert input image class as double 
inImage = double(inImage);
% size of inputImage
[nrow, ncol,nbands] = size(inImage);


%create outputimage
outImage = zeros(nrow,ncol,nbands);

%perform autothreshold segmentation
for band = 1:nbands       
    tempImage = inImage(:,:,band);      
    % unique value which is not in original image
    unique_val = max(tempImage(:))+5; 
    % initialize threshold value
    thresh_old = sum(tempImage(:))/(nrow*ncol);

    % repeat till (thresh_old-thresh_new) > limit
    while 1
        tempImage = inImage(:,:,band); 
        % Group 1- the pixels that are equal or greater than old threshold value        
        tempImage(tempImage<thresh_old)= unique_val;   
        %total pixels in group 1
        pixelcount1 = nrow*ncol-length(find(tempImage==unique_val));  
        tempImage(tempImage==unique_val)=0;
        mean1 = sum(tempImage(:))/pixelcount1;

        % Group 2- the pixels that are less than old threshold value
        tempImage = inImage(:,:,band);
        tempImage(tempImage>=thresh_old)= 0;   
        %total pixels in group 1
        pixelcount2 = nrow*ncol-pixelcount1;        
        mean2 = sum(tempImage(:))/pixelcount2;
        
        if (mean1 == 0)
            mean2 = 2*mean2;
        end
        if (mean2 == 0)
            mean1 = 2*mean1;
        end
        
        % New threshold value
        thresh_new = (mean1+mean2)/2;
        if abs(thresh_old-thresh_new) > limit
            thresh_old = thresh_new;
        else
            auto_threshval = thresh_new;
            break;
        end  
    
    end % threshold the image using auto threshold value

    tempImage = inImage(:,:,band);
    tempImage(tempImage>=auto_threshval)=WHITE_LAB;
    tempImage(tempImage<auto_threshval)=BLACK_LAB;
    outImage(:,:,band)=tempImage;      
end

outImage =uint8(outImage);
end

