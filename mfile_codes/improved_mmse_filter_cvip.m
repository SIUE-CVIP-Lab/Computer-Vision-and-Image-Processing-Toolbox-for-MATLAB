function new_image = improved_mmse_filter_cvip( imageP, noise_var, kernel_size, threshval)
% IMPROVED_MMSE_FILTER_CVIP - An improved algorithm for MMSE filter.
%
% Syntax :
% --------
% new_image = improved_mmse_filter_cvip( imageP, noise_var, kernel_size, threshval)
%   
% Input Parameters include:
% --------------------------
%
%   'imageP'        Input image can be gray image or rgb image of MxN size. 
%                   
%   'noise_var'     The variance of the noise.  
%                   
%   'kernel_size'   Block size of the filter.
%                    
%   'threshval'     The threshold in the algorithm.
%                   The block size is reduced until the gain factor is 
%                   greater than threshold.         
%
%                      
% Output Parameter include :
% ------------------------ 
%
% 'new_image'     The output image after filtering
% 
%
% Example :
% -------
%                   imageP = imread('imp_mmse.bmp');
%                   new_image = improved_mmse_filter_cvip( imageP, 300,  9, 0.6);
%                   figure; imshow(new_image/255);
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

if (rem(kernel_size,2) < 1) || (kernel_size > 11 && kernel_size <3)
    error('mask_size should be an odd number between 3 and 11');
end
[m,n,o] = size(imageP);

c = (kernel_size+1)/2; % coordinate of the center pixel of the window
new_image = double(imageP);

for i= c: (m+1 -c)
  for j=c:(n+1 - c) 
    block = double( imageP( i - (c-1): i+ (c-1) , j - (c-1): j+ (c-1), 1:o ) ) ; % W-block of the image with as many bands as the originial
    for k = 1:o
        one_band = block(:,:,k);
        cst = var(one_band(:));
        cst = noise_var/cst;
        while ( (size(one_band,1) ~= 3) && cst < threshval )
            one_band = one_band(2:end-1,2:end-1);
            cst = var(one_band(:));
            cst = noise_var/cst;
        end
        new_image(i,j,k) = (new_image(i,j,k) - cst.*(new_image(i,j,k) - mean(one_band(:))));
       
    end
  end
end

end

