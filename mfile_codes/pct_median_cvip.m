function [ outImage ] = pct_median_cvip( inImage, numColors )
% PCT_MEDIAN_CVIP- Image segmentation using PCT/Median cut algorithm.
% The function performs the principal components transform (PCT) of the
% input image, and then performs the Median cut segmentation. The
% segmented image in PCT domain will be mapped back to original 3-D color
% space by taking inverse-PCT.
%
% Syntax :
% ------
% [ outImage ] = pct_median_cvip( inImage, numColors )
%    
% Input Parameters include :
% ------------------------
%   'inImage'       1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. The input image can be of uint8 or uin16 or 
%                   double class. 
%   'numColors'     Number of colors. 
%                   NumColors = 2(default)
%
%
% Output Parameter include :  
% ------------------------
%   'outImage'      Segmented image having same size of input image.
%                                         
%
% Example :
% -------
%                   I = imread('butterfly.tif');   %original image
%                   O1 = pct_median_cvip(I);       %default numColors = 2       
%                   N = 8;                         %number of colors
%                   O2 = pct_median_cvip(I,N);     %numColors = 8
%                   figure;imshow(remap_cvip(O2,[]));
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    2/25/2017
%           Latest update date:     3/28/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

if nargin ~= 1 && nargin ~= 2
    error('Too many or too few input arguments!')
end

if nargout ~= 1 && nargout ~= 2
    error('Too many output arguments!')
end

%setup default parameters
if nargin ==1
    numColors = 2;
elseif nargin ==2
    if ~isnumeric(numColors)
        numColors =2;
        warning('Number of colors must be numeric and integer!')
    end
end

%convert RGB color space to PCT space
[pctimg,ee] = pct_cvip(inImage);   
%convert floating point values to integer
pctImg = fix(pctimg);    
%perform Median Cut segmentation of PCT image
outImage = median_cut_cvip(pctImg,numColors);
%perform inverse PCT to map back to RGB color space 
outImage = ipct_cvip(outImage,ee);

if ~numColors > 256
    outImage = uint8(outImage);
else
    if isa(inImage,'uint16')
        outImage = uint16(outImage);
    end
end
   
end

