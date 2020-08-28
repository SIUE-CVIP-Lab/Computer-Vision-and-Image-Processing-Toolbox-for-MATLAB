function new_image = arithmetic_mean_cvip( imageP,  mask_size)
% ARITHMETIC_MEAN_CVIP - finds the arithmetic average of the pixel values.
% This filter smooths out local variations with in an image,so it is
% essentially a low pass filter.This filter will tend to blur an image,
% while mitigating the noise effects.Larger the mask size,the more
% pronounced the bluring effect.This works best with gaussian,gamma and
% uniform noise.
% Syntax :
% ------
%   new_image = arithmetic_mean_cvip( imageP,  mask_size)
%   
% Input Parameters Include :
% -------------------------
%   'imageP'        Input image can be gray image or rgb image of MxN size. 
%                                  
%   'mask_size'     Block size of the filter. An odd integer between 3-11.
%                    
%
% Output Parameters Include :  
% -------------------------
%   'new_image'     The output image after filtering.
% 
%
% Example :
% -------
%                   imageP = imread('Flowersuniform.bmp');
%                   mask_size = 7;
%                   new_image = arithmetic_mean_cvip( imageP,mask_size);
%                   figure; imshow(new_image,[]);
%
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    3/13/2017
%           Latest update date:     3/19/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================
[m,n,o] = size(imageP);
c = (mask_size+1)/2; % coordinate of the center pixel of the window
new_image = imageP;
for i= c: (m+1 -c)
  for j=c:(n+1 - c) 
    block = imageP(i - (c-1): i+ (c-1) , j - (c-1): j+ (c-1), 1:o) ; % W-block of the image with as many bands as the originial
    %for k = 1:o
        %one_band = block(:,:,k);
        % perform the algorithm on one_band
        % and store the result in new_image(i,j,o);
        new_image(i,j,:) = mean(mean(block));
    %end
  end
end
end