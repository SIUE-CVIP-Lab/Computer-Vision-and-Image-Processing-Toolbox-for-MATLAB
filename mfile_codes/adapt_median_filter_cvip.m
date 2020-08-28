function new_image = adapt_median_filter_cvip(imageP,wmax)
% ADAPT_MEDIAN_FILTER_CVIP - a ranked-order based adaptive median filter.
% The primary strength of the adaptive median filter is the removal of salt
% and pepper noise but also attempts to smooth other types of noise and to
% avoid the distortion of small image structures seen with the standard
% median filter.This filter is algorithmic in nature and has a variable
% block size that increases until a certain criterion is met.we start by
% considering only immediate neighbors of the current pixel,a block size of
% 3*3.The purpose of this is to determine if the standard median filter
% output is impulse noise for this initial block size.If it equals the max
% or min it might be impulse noise,so we increase the block size and try
% again.If it is not we go to next lvel and test to see if the current
% pixel is impulse noise.If it is we output the median value,if not we
% output the current value.This will tend to preserve edges.
%
% Syntax :
% -------
% new_image = adapt_median_filter_cvip( imageP,wmax)
%   
% Input Parameters Include :
% ------------------------
% 'imageP'        Input image can be gray image or rgb image of MxN size. 
%                   
% 'wmax'          The maximum value for filter block size.
%                 An odd integer between 3-11.
%
%                      
% Output Parameter Include :  
% ------------------------
% 'new_image'     The output image after adaptive contrast filtering
%                 
%
%
% Example :
% -------
%                   imageP = imread('Flowerspepper.bmp'); % inputImage with pepper noise                   
%                   wmax = 11;
%                   new_image = adapt_median_filter_cvip( imageP,wmax);
%                   figure; imshow(hist_stretch_cvip(new_image,0,1,0,0));
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
      

if (rem(wmax,2) < 1) || (wmax > 11 && wmax <3)
    error('mask_size should be an odd number between 3 and 11');
end
[m,n,o] = size(imageP);

% c = (3+1)/2; % coordinate of the center pixel of the window
W = 3;
c = (W+1)/2;
new_image = double(imageP);

for i= 2: (m-1)
  for j=2:(n-1) 
    for k = 1:o
        while (W <= wmax) && ( i - (c-1) >= 1 ) && ( i+ (c-1) <= m ) && ( j - (c-1) >= 1 ) && ( j+ (c-1) <= n )
            block = double( imageP( i - (c-1): i+ (c-1) , j - (c-1): j+ (c-1), k ) ) ; % W-block of the image. Only one band.
            gmax = max(block(:));
            gmed = median(block(:));
            gmin = min(block(:)) ;
            if ( gmin < gmed) && (gmed < gmax ) %go to level 2
                if ~ ( ( gmin < new_image(i,j,k)) && ( gmax > new_image(i,j,k)) )
                    new_image(i,j,k) = gmed;
                end
                break;
            else
                W = W + 2;
                c = (W+1)/2;
            end
        end
        
        W = 3;
        c = 2;
    end
  end
end

end

