function output = hist_shrink_cvip(im, low, high)
% HIST_SHRINK_CVIP- This function shrinks a histogram.
% Z = HIST_SHRINK_CVIP(X) This function shrink a histogram of
% an input image.It decreases contrast in an image by shrinking
% the  histogram to span the range low_limit to high_limit.It may be a 
% useful preprocessing step in a compression algorithm (followed by a 
% stretch after decompression).The mapping function for a histogram 
% shrink can be found in the function documentation page.
% 
% Syntax:
% -------
% outputImage = hist_shrink_cvip(ipImage, low, high);
% 
% Input Parameters include:
% ------------------------
%   'inputImage'  input image
%   'low'         lower limit for stretch
%   'high'        higher limit for stretch
%  
% Output parameter include:
% ------------------------
%  'Output'    -  Histogram shrink image.
%
% Example 1 :
% ---------
%   Shrinks the histogram of the input image
%
%                   X = imread('Cam.bmp');
%                   low_limit = 60;
%                   high_limit = 180;
%                   S = hist_shrink_cvip(X,low_limit,high_limit);
%                   figure;imshow(S,[]);
%
% Example 2 :
% ---------
%   Shrinks the histogram of the input image:
%
%                  X = imread('Car.bmp');
%                  low_limit = 60;
%                  high_limit = 180;
%                  S = hist_shrink_cvip(X,low_limit,high_limit);
%                  figure;imshow(S,[]);
%
%
%   See also, get_hist_image_cvip, gray_linear_cvip, hist_create_cvip,
%   hist_spec_cvip, histeq_cvip, hist_slide_cvip, hist_stretch_cvip,
%   local_hist_eq_cvip, unsharp_cvip
%
% Example 3 :
% ---------
%   Shrinks the histogram of the input image:
%
%                  X = imread('Car.bmp');
%                  low_limit = 60;
%                  high_limit = 180;
%                  S = hist_shrink_cvip(X,low_limit,high_limit);
%                  figure;imshow(S,[]);
%
%
%   See also, get_hist_image_cvip, gray_linear_cvip, hist_create_cvip,
%   hist_spec_cvip, histeq_cvip, hist_slide_cvip, hist_stretch_cvip,
%   local_hist_eq_cvip, unsharp_cvip
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Deependra Mishra
%           Initial coding date:    03/17/2017
%           Latest update date:     03/17/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================
%---------- Argument Check -----------------------------------------
    if nargin<3
        error('Too few arguments for histogram stretch operation');
    elseif nargin>3
        error('Too many arguments for histogram stretch operation');
    end
%--------- Data Type Check and Conversion ---------------------------    
    if ~isa(im,'double')
        im=im2double(im);
    end
    
    Min=min(min(min(im)));
    Max=max(max(max(im)));
    output = (((high-low)/(Max-Min))*(im-Min))+low;
    output = uint8(output);
end