function new_image = yp_mean_cvip( imageP,  mask_size, P)
% YP_MEAN_CVIP - performs a Yp mean filter.
% This filter removes salt noise for negative values of P and pepper noise
% for positive values of P.
%
% Syntax :
% ------
% new_image = yp_mean_cvip( imageP,  mask_size)
% new_image = yp_mean_cvip( imageP,  mask_size, ignore_zeros)        
%   
% Input Parameters include :
% ------------------------
% 'imageP'        Input image can be gray image or rgb image of MxN size. 
%                                  
% 'mask_size'     Block size of the filter. An odd integer between 3-11.
%              
% 'P'             The P value in Yp mean formula.
%                   
%
% Output Parameter include :  
% -------------------------
% 'new_image'     The output image after filtering.
% 
%
% Example :
% -------
%                   imageP = imread('Flowers_saltnoise.bmp');
%                   mask_size = 7;
%                   p = -3;
%                   new_image = yp_mean_cvip( imageP,mask_size,p);
%                   figure; imshow(new_image/255);
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

if (rem(mask_size,2) < 1) || (mask_size > 11 && mask_size <3)
    error('mask_size should be an odd number between 3 and 11');
end
[m,n,o] = size(imageP);

c = (mask_size+1)/2; % coordinate of the center pixel of the window
new_image = double(imageP);
for i= c: (m+1 -c)
  for j=c:(n+1 - c) 
    block = double(imageP(i - (c-1): i+ (c-1) , j - (c-1): j+ (c-1), 1:o)) ; % W-block of the image with as many bands as the originial
%     for k = 1:o
        %one_band = block(:,:,k);
        % perform the algorithm on one_band
        % and store the result in new_image(i,j,o);
%         display(size(block))
%         new_image(i,j,k) = ( sum(sum(block(:,:,k).^P))/(mask_size^2) )^(1/P);
     num = block.^P;
     num = sum(sum(num))/(mask_size^2);
     new_image(i,j,:) = num.^(1/P);
%     end
  end
end
%new_image = uint8(new_image);
end
