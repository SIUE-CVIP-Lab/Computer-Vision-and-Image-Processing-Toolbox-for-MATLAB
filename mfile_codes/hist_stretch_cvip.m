function output = hist_stretch_cvip(im,low,high, lowClip, highClip)
% HIST_STRETCH_CVIP - This function stretches a histogram.
%
% Syntax :
% -------
% outputImage = hist_stretch_cvip(inputImage, low, high, lowClip, highClip);
% 
% Description :
% ------------
%
% This function stretches a histogram of an input image.This histogram 
% stretch technique can be used to improve the contrast of an image.
% By clipping a small percentage at the ends,you can avoid the possibility 
% of a few high or low pixel values compromising the stretch effect.
% The mapping function for a histogram stretch can be 
% found in the function documentation page.
%
% Input Parameters Include :
% -------------------------
%
%  'inputImage'    - input image.
%  'low'           - lower limit for stretch.
%  'high'          - higher limit for stretch.
%  'lowClip'       - percentage of low values to clip before stretching.
%  'highClip'      - percentage of high values to clip before stretching.
%
% Output Parameter Include :
% -------------------------
%
%  'Output Image'    Output hist stretch image.
%
% Example 1 :              
% ---------
%   Stretches the histogram of the input grayscale image
% 
%                    X = imread('Cam.bmp');
%                    low = 0;
%                    high = 255;
%                    lowClip = 0.025;
%                    highClip = 0.025;
%                    S = hist_stretch_cvip(X,low,high,lowClip,highClip);
%                    figure;imshow(X);title('Input Image');
%                    figure;imshow(S,[]);title('Output Hist stretch Image');
%
% Example 2 :
% ---------
%   Stretches the histogram of the input color image:
%                    X = imread('Car.bmp');
%                    low = 0;
%                    high = 255;
%                    lowClip = 0.025;
%                    highClip = 0.025;
%                    S = hist_stretch_cvip(X,low,high,lowClip,highClip);
%                    figure;imshow(X);title('Input Image');
%                    figure;imshow(S,[]);title('Output Hist stretch Image');
%
% Reference
% ---------
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

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
%% RETURN Values
% A stretched image.

%---------- Argument Check -----------------------------------------
    if nargin<5
        error('Too few arguments for histogram stretch operation');
    elseif nargin>5
        error('Too many arguments for histogram stretch operation');
    end
%--------- Data Type Check and Conversion ---------------------------    
    if ~isa(im,'double')
        im=im2double(im);
    end
%-----Logic to clip high end and low end pixels----------------------
    total = length(im(:));
    fig=figure;
    
    h = histogram(im,'visible','off');
    
    counts = h.Values;
    edges = h.BinEdges;

    cdf = cumsum(counts)/total;
    
    l = find(cdf < lowClip);
    
    h = find(cdf > (1 - highClip));
    
     if ~isempty(l)
        l = edges(l(end) + 1);
    end
    if ~isempty(h)
        h = edges(h(1)-1);
    end
%------For 3-band image-------------------    
    if size(im,3)==3
        y1=im(:,:,1);
        y2=im(:,:,2);
        y3=im(:,:,3);
        if ~isempty(l)
            y1(im(:,:,1) < l) = l;
            y2(im(:,:,2) < l) = l;
            y3(im(:,:,3) < l) = l;
        end
        if ~isempty(h)
            y1(im(:,:,1) > h) = h;
            y2(im(:,:,2) > h) = h;
            y3(im(:,:,3) > h) = h;
        end
        Z(:,:,1) = y1;
        Z(:,:,2) = y2;
        Z(:,:,3) = y3;
%-------For single band image----------------
    else       
        Z=im;
        if ~isempty(l)
            Z(im < l) = l;
        end
        if ~isempty(h)
            Z(im > h) = h;
        end
    end
    close(fig);
%--------Histogram stretch Logic-----------    
    Min=min(Z(:));
    Max=max(Z(:));
    output = (((Z-Min)/(Max-Min))*(high-low))+low;
end