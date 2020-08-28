function [ outImage ] = unsharp_cvip( inImage, shrinkRange, cutoffLim)
% UNSHARP_CVIP - Performs unsharp masking algorithm.
% Unsharp masking is a technique that combines  filtering  and histogram 
% modification.The input image is lowpass filtered using 3x3 arithmetic
% mean filter;a histogram shrink is then performed on the filtered image.
% The resultant image is subtracted from the original,and a histogram
% stretch completes the process.The histogram stretch range is 0 to 255,
%(considering 8-bit image).   
%
% Syntax :
% -------
% outImage = unsharp_cvip( inImage, stretchRange, cutoffLim)
%   
% 
% Input Parameters include :
% -------------------------
%   'inImage'       1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. The input image can be of uint8 or uint16 
%                   or double class. 
%   'shrinkRange'   Histogram shrink range. A vector of length 2. 
%                   shrinkRange(1): lower limit                 
%                   shrinkRange(2): upper limit              
%                                                       ([0 100] | default)
%   'cutoffLim'     Percentage of low and high values to clip during
%                   hist_stretch. A vector of length 2.
%                   cutoffLim(1): low_clip                     
%                   cutoffLim(2): high_clip                    
%                                                         ([0 0] | default)
%
%
% Output Parameter include :  
% ------------------------
%   'outImage'      Unsharp-filtered image.
%                                         
%
% Examples :
% --------
%   %Perform unsharp masking with default parameters
%         I = imread('cam.bmp');    
%         O1 = unsharp_cvip(I);   
%         figure;imshow(O1,[]);
%   %Perform unsharp masking with user specified parameters
%         I = imread('car.bmp');    
%         O2 = unsharp_cvip(I,[2 120], [0.025 0.025]);          
%         figure;imshow(remap_cvip(O2,[]));
%
% Reference 
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    4/14/2017
%           Latest update date:     4/14/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

%check number of input arguments
if nargin ~=1 && nargin ~= 2 && nargin ~= 3
    error('Too many or too few input arguments!');
end

%check number of output arguments
if nargout ~= 1 && nargout ~= 0
    error('Too many output arguments!');
end

%set up default parameters
default_shrinkRange = [0 100];       %default range for histogram stretch
default_cutoffLim = [0 0];            %default cut-off limits at low end and high end
stretchRange = [0 255];                %default range, [low high], for histogram shrink
mask_size = 3;                        %default mask size for low pass filter 


%check if input argument exist or is not empty
if ~exist('shrinkRange','var') || isempty(shrinkRange) 
    shrinkRange = default_shrinkRange;
end
if ~exist('cutoffLim','var') || isempty(cutoffLim) 
    cutoffLim = default_cutoffLim;
end

%Perform unsharp masking
outImage = arithmetic_mean_cvip(inImage, mask_size);  %LPF
outImage = hist_shrink_cvip(outImage, shrinkRange(1), shrinkRange(2));   %hist. shrink
outImage = inImage - outImage;   %subtraction
outImage = hist_stretch_cvip(outImage, stretchRange(1), stretchRange(2),...
    cutoffLim(1), cutoffLim(2));   %hist. shrink
    
end % end of function
