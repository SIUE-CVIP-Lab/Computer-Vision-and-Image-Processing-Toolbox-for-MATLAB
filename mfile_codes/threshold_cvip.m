function [ outImage ] = threshold_cvip( inImage, threshval )
% THRESHOLD_CVIP - Perform binary thresholding of an image.
% The user has option to define threshold value or use the default threshold value.
% The default threshold value is the average of minimum and maximum gray
% level of the image.The class of output image will be uint8.
%
% Syntax :
% -------
% outImage = threshold_cvip(inImage, threshval)
%   
% Input Parameters include :
% ------------------------
%   'inImage'       1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. The input image can be of uint8 or uint16
%                   or double class. 
%   'threshval'     Threshold value.
%
%
% Output Parameter include :  
% ------------------------
%   'outImage'      Binary thresholded image of uint8 class.
%                                         
%
% Example :
% -------
%                   I = imread('butterfly.tif');     %original image
%                   O1 = threshold_cvip(I);          %default threshold value
%                   O2 = threshold_cvip(I,200);      %user defined threshold value
%                   figure;imshow(O1,[]);
%                   figure;imshow(O2,[]); 
% Reference 
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    3/20/2017
%           Latest update date:     3/23/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================
MAX_Gray = 255;
MIN_Gray = 0;

if nargin~= 1 && nargin ~=2
    error('Too many or too few arguments!')
end

%Check the data type of the input Image
max_gray = max(inImage(:));
min_gray = min(inImage(:));

if nargin == 1
    threshval = (max_gray + min_gray)/2;
elseif nargin == 2
    if ~isnumeric(threshval)
        error('Threshold value must be numeric!')
    elseif threshval < min_gray && threshval > max_gray
        warning('Threshold value is either small than minimum gray value of image or large than maximum gray value of image!')
    end
end

%create output image same as input image
outImage = inImage;
%compare each pixel value with threshold value, if greater, then set that pixel as WHITE
outImage(outImage>threshval) = MAX_Gray;
%compare each pixel value with threshold value, if greater, then set that pixel as BLACK
outImage(outImage<=threshval) = MIN_Gray; 
outImage = uint8(outImage);

end %end of function
    

