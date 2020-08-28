function new_image = alpha_filter_cvip( imageP,  mask_size, p)
% ALPHA_FILTER_CVIP - performs an alpha-trimmed mean filtering operation.
% The alpha trimmed mean is the average of the pixel values with in the
% block size,but with some of the end point ranked values excluded.This
% filter ranges from a mean to median filter,depending on the value
% selected for 'p'.This filter is used when an image contains both 
% short and long tailed types of noise such as Gaussian and 
% salt and peppper noises.This filter varies between a median and a mean filter.
%
% Syntax :
% -------
% new_image = alpha_filter_cvip( imageP,  mask_size, p)
%   
% Input Parameters include :
% ------------------------
% 'imageP'        Input image can be gray image or rgb image of MxN size. 
%                                  
% 'mask_size'     Block size of the filter. An odd integer between 3-11.
%            
% 'p'             The p value in alpha trimmed mean formula.
%
%
% Output Parameters Include :  
% ------------------------
% 'new_image'     The output image after filtering
% 
%
% Example :
% -------
%                   imageP = imread('salt_pep.bmp');
%                   mask_size = 3;
%                   p = 2;
%                   new_image = alpha_filter_cvip( imageP,  3, 2);
%                   figure; imshow(hist_stretch_cvip(new_image,0,1,0,0),[]);
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

% percent  = 2*p*100/(mask_size^2);
if (rem(mask_size,2) < 1) || (mask_size > 11 && mask_size <3)
    error('mask_size should be an odd number between 3 and 11');
end
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
        new_image(i,j,:) = trimmean_cvip( reshape(block,[mask_size^2 1 o]) , p);
    %end
  end
end

end

function tm = trimmean_cvip(A,p)
    A = sort(A);
    A(1:p,:,:) = [];
    A(end-p+1:end,:,:) = [];
    tm = mean(A);
end
