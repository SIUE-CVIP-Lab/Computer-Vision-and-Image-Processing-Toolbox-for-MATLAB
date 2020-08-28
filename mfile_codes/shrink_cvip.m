function [ outImage ] = shrink_cvip( inImage, factor)
% SHRINK_CVIP - Shrink an image by a factor specified by user.
% The function reduces the image by a given factor.The reductions will be
% performed by same factor in both horizontal and vertical directions.The
% scaling factor must be in between 0.1 and 1.0.  
%
% Syntax:
% -------
% outImage = shrink_cvip( inImage, factor)
%   
% Input Parameters include :
% -------------------------
%   'inImage'       1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. The input image can be of uint8 or uint16 
%                   or double class. 
%   'factor'        Reduction factor (0.1 - 1.0).  
%                                                           (0.5 | default)
%
%
% Output Parameter include :  
% ------------------------
%   'outImage'      Shrinked image.
%                                         
%
% Example :
% -------
%          I = imread('butterfly.tif');    %original image
%          O1 = shrink_cvip(I);            %default factor    
%          figure; imshow(O1/255);
%          O2 = shrink_cvip(I,0.7);      %user defined factor     
%          figure; imshow(O2/255);
%
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
if nargin ~=1 && nargin ~= 2
    error('Too many or too few input arguments!');
end

%check number of output arguments
if nargout ~= 1 && nargout ~= 0
    error('Too many output arguments!');
end

%set up default parameters
default_factor = 0.5;       %default scaling factor


%check if input argument exist or is not empty
if ~exist('factor','var') || isempty(factor) || factor < 0.1 || factor > 1
    factor = default_factor;    
end

%Perform the shrink operation
[nrow,ncol,~] = size(inImage);
nrow = fix(factor*nrow);
ncol = fix(factor*ncol);
outImage = spatial_quant_cvip(inImage, nrow,ncol,3);

    
end % end of function
