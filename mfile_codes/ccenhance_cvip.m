function cce = ccenhance_cvip(varargin)
% CCENHANCE_CVIP - Improves the color of the image.
%
% Syntax :
% ------
% Z = ccenhance_cvip(im, low_limit, high_high_limit, lowClip, highClip)
%
% Color Contrast Enhance is an algorithm used to create brighter and better images. 
% This takes color image as input.This performs the HSL transform and performs
% different processes in step by step process.First,transform the image
% to HSL color space, next extract the hue band, saturation band, and
% lightness band. Then perform the histogram equalization on saturation
% band,which improves and intesifies color richness.Perform histogram
% stretch on the luminance band to improve the contrast.After, the
% histogram stretch, combine the processed HSL bands and then apply inverse
% HSL transform.This function increases contrast in an image by stretching
% the histogram to span the range low_limit to high_limit.To improve
% performance of the function when outliers are present, percentage
% lowClip and highClip pixel values can be removed before the stretch takes
% place.
%
% Input parameters include :
% ------------------------
%   im         - Input Image
%   low_limit  - lower limit for stretch
%   high_limit - higher limit for stretch
%   lowClip    - percentage of low values to clip before stretching 
%   highClip   - percentage of high values to clip before stretching
%
%
% Example 1 :
% ---------
%   Perform color contrast enhancement on input color image:
%
%                   X1 = imread('Car.bmp');
%                   S1 = ccenhance_cvip(X1, 0, 255, 0.025, 0.025);
%                   figure;imshow(S1,[]);
%
% Example 2 :
% ---------
%   Perform color contrast enhancement on input color image: 
%
%                   X2 = imread('butterfly.tif');
%                   S2 = ccenhance_cvip(X2, 0, 255, 0.01, 0.01);
%                   figure;imshow(S2,[]);
%
%
%   See also, get_hist_image_cvip, rgb2hsl_cvip, hist_create_cvip,
%   hsl2rgb_cvip, hist_shrink_cvip, hist_slide_cvip, hist_stretch_cvip,
%   histeq_cvip
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Deependra Mishra
%           Initial coding date:    07/01/2017
%           Latest update date:     07/01/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

%------------Number of Argument Check--------------------------------------
    if nargin<5,
            error('Too few arguements for ccenhance_cvip');

        elseif nargin>5,
            error('Too many arguements for ccenhance_cvip');

    end;
%--------- RGB Image Input Check ------------------------------------------
    if size(varargin{1},3)~=3
        error('Invalid Image Input: The input image must be a color image');
    end
%--------- Data Type Check and Conversion ---------------------------------
    if ~isa(varargin{1},'uint8')
        varargin{1}=uint8(varargin{1});
    end;
%---------Color Contrast Enhance Algorithm---------------------------------    
    hsl = rgb2hsl_cvip(varargin{1},1); % RGB to HSL transform
    %------Extracting H, S and L band from HSL Image
    h = extract_band_cvip(hsl,1);   
    s = extract_band_cvip(hsl,2);
    l = extract_band_cvip(hsl,3);
    
    nh = uint8(h*255); 
    ns = histeq_cvip(uint8(s*255)); % Histogram equalization on S band
    % Histogram stretch on L band
    nl = hist_stretch_cvip(l,varargin{2}, varargin{3}, varargin{4}, varargin{5});
    % Assembling the processed HSL band 
    nhsl= assemble_bands_cvip(nh,ns,nl);
    cce = hsl2rgb_cvip(nhsl,1); % Inverse HSL transform
end