function new_image = adaptive_contrast_cvip( imageP,W, k1,k2,min_gain, max_gain)
% ADAPTIVE_CONTRAST_CVIP - Adaptive contrast enhancement method is to perform a histogram
% modification technique,but instead of doing it globally,applying it to
% the image on a block by block basis.block size corresponds to the local
% neighborhood and the enhancement is adaptive because the output depends
% only on the local histogram.So this technique is also called local
% enhancement.The adaptive contrast enhancement filter is used
% to adjust the contrast differently in different regions of the
% image.This filter use local image statistics to improve images with
% uneven contrast.
%
% Syntax:
% -------
% new_image = adaptive_contrast_filter_cvip( imageP,W, k1,k2,min_gain, max_gain)
%   
% Input Parameters Include :
% --------------------------
% 'imageP'        Input image can be gray image or rgb image of MxN size. 
%                   
% 'W'             Filter block size.  
%                   
% 'k1'            Local gain factor constant, between 0 and 1.
%                    
% 'k2'            Local mean constant, between 0 and 1.
%                   
% 'min_gain'      Local gain minimum value.
%                    
% 'max_gain'      Local gain maximum value. 
%                      
% Output Parameters Include :  
% --------------------------
% 'new_image'     The output image after adaptive contrast filtering
%                 
% Example :
% -------
%                   imageP = imread('Butterfly.tif');
%                   W = 11;
%                   k1 = .8;
%                   k2 = 0.5;
%                   min_gain = 5;
%                   max_gain = 10;
%                   new_image = adaptive_contrast_cvip( imageP,W,k1,k2,min_gain, max_gain);
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
      
% new_image = adaptive_contrast_filter_cvip( imageP,W, k1,k2,min_gain, max_gain)

if (rem(W,2) < 1) || (W > 11 && W <3)
    error('mask_size should be an odd number between 3 and 11');
end
[m,n,o] = size(imageP);


c = (W+1)/2;    % coordinate of the center pixel of the window
new_image = double(imageP);
global_mean = mean(mean(new_image));
for i= c: (m+1-c)
  for j=c:(n+1-c) 
    for k = 1:o
        block = double( imageP( i - (c-1): i+ (c-1) , j - (c-1): j+ (c-1), k ) ) ; % W-block of the image. Only one band.
        ml = mean(block(:));
        mg = global_mean(k);
        sigmal = std(block(:));
        
        cst = k1*mg/sigmal;
        if ~(cst >= min_gain)
            cst = min_gain;
        elseif ~(cst <= max_gain)
            cst = max_gain;
        end
        
        new_image(i,j,k) = cst*(new_image(i,j,k) - ml) + k2*ml;
    end
  end
end

end