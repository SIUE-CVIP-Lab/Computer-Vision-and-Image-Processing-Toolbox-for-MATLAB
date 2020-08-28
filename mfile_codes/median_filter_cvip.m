function new_image = median_filter_cvip( imageP,  mask_size)
% MEDIAN_FILTER_CVIP - performs a fast histogram-method median filter.
%
% Syntax :
% ------
% new_image = median_filter_cvip( imageP,  mask_size)
%   
% Input Parameters include :
% ------------------------
%   'imageP'        Input image can be gray image or rgb image of MxN size. 
%                                  
%   'mask_size'     Block size of the filter. An odd integer between 3-11.
%                    
%
% Output Parameter include :  
% ------------------------ 
%   'new_image'     The output image after filtering
% 
%
% Example :
% -------
%                   imageP = imread('salt_pep.bmp');
%                   new_image = median_filter_cvip( imageP,7);
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
if (rem(mask_size,2) < 1) || (mask_size > 11 && mask_size <3)
    error('mask_size should be an odd number between 3 and 11');
end
[m,n,o] = size(imageP);

c = (mask_size+1)/2; % coordinate of the center pixel of the window
new_image = imageP;
for i= c: (m+1 -c)
  for j=c:(n+1 - c) 
    block = imageP(i - (c-1): i+ (c-1) , j - (c-1): j+ (c-1), 1:o) ; % W-block of the image with as many bands as the originial
    new_image(i,j,:) = median(reshape(block,[mask_size^2 1 o]));
  end
end

end
