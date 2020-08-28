function output = hist_slide_cvip(im,offset)
% HIST_SLIDE_CVIP - This function performs histogram slide operation.
%  Z = HIST_SLIDE_CVIP(X, offset) This function slides a histogram of
%  an input image. This histogram slide technique can be used to make an 
%  image either darker or brighter, however it retains the relationship 
%  between gray-level values. This operation is accomplished by simply 
%  adding or subtracting a fixed number from all the gray-level values as follows:
%
%  Slide[I(r,c)] = I(r,c) + offset
% 
%  where the $$offset$ value is the amount to slide the histogram.
%
%  A positive offset value will increase the overall brightness, while a
%  negative offset will create a darker image.
%
% Syntax :
% --------
% outputImage = hist_slide_cvip(inputImage, offset);
% 
% Input Parameters include :
% --------------------------
%
%   'inputImage'  input image
%   'offset'      amount of slide
%
%   Note:
%   Negative Offset value reduces the overall brightness
%   Positive offset value increases the overall brightness
%
% Example 1 :
% ---------
%   Slides the histogram of the input grayscale image:
%
%                   X = imread('Cam.bmp');
%                   offset = 50;
%                   S = hist_slide_cvip(X,offset);
%                   figure;imshow(S,[]);
%
% Example 2 :
% ---------
%   Slides the histogram of the input color image:
%
%                   X = imread('Car.bmp');
%                   offset = -50;
%                   S = hist_slide_cvip(X,offset);
%                   figure;imshow(S,[]);
%
%
%   See also, get_hist_image_cvip, gray_linear_cvip, hist_create_cvip,
%   hist_spec_cvip, hist_shrink_cvip, histeq_cvip, hist_stretch_cvip,
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
    if nargin<2,
        error('Too few arguments for histogram slide operation');
    elseif nargin>2,
        error('Too many arguments for histogram slide operation');
    end;
%--------- Data Type Check and Conversion ---------------------------    
%     if ~isa(im,'double')
%         im=double(im);
%     end;
%     if ~isa(offset,'uint8')
%         offset=uint8(offset);
%     end;

    if isa(im,'double') && (max(im(:))<=1),
        if ~(offset<=1),
            offset = offset/255;
        end;
        output = im +offset;
    else
        
        output = im + offset;
%         output = uint8(output);
    end
end