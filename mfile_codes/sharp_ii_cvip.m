function [OutIma] = sharp_ii_cvip(InIma,varargin)
%SHARP_II_CVIP - performs the sharpening II algorithm based on the algortim
%                in CVIPtools. Info can be viewed in the help pages.
%
%Syntax :
% -------
% OutIma = shapr_ii_cvip(InIma);
%
% Input Parameters:
% -----------------
%
% 'InIma'               Input image to the algorithm. Can be either color or gray
%                       scale image.
%
% 'varargin'            variable input as to whether or not include the
%                       original image. Default includes the original 
%
% Output Parameters:
% ------------------
%
% 'OutIma'      Output image result of the algorithm
%
% Example:
% --------
%
%               InIma = imread('cameraman.tif');
%               OutIma = sharp_ii_cvip(InIma);
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Joey Olden
%           Initial coding date:    04/30/2020
%           Latest update date:     04/30/2020
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

%hist stretch 10-100
stretch = hist_stretch_cvip(InIma,10,100,0.01,0.01);

%Roberts ed detection
Roberts = roberts_ed_cvip(stretch,1);

%need to round to integers and remap to [0 255]
OutIma = double(InIma) + Roberts;
OutIma = remap_cvip(OutIma,[0 255]);

%hist eq
[~,~,zI] = size(InIma);

if zI == 1
    OutIma = histeq_cvip(round(OutIma),0);    
elseif zI == 3
    hsl_space = rgb2hsl_cvip(OutIma,1);
    Lightness_band = floor(hsl_space(:,:,3));
    Lightness_band = double(histeq_cvip(Lightness_band,0));
    hsl_space(:,:,3) = Lightness_band;
    OutIma = hsl2rgb_cvip(hsl_space);
end

%add to original or not
if isempty(varargin) || any(varargin{1})
    OutIma = uint8(remap_cvip(double(InIma) + double(OutIma),[0 255]));
else
    OutIma = uint8(OutIma);
end

end

