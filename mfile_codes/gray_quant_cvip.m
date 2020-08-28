function [ outImage ] = gray_quant_cvip( inImage, graylevel)
% GRAY_QUANT_CVIP - Gray level quantization of an image.
% The function performs the gray level quantization of an image using
% standard method.The number of gray-level must be a power of 2.
%
% Syntax :
% ------
% outImage = gray_quant_cvip(inImage, graylevel)
%    
% Input Parameters include:
% -------------------------
%   'inImage'       1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. The input image can be of uint8 or double
%                   class. If double class, the function assumes
%                   the data range of image is from 0 to 1.
%   'graylevel'     Number of gray levels. It must be a power of 2, but not
%                   greater than 256.
%
%
% Output Parameter includes:  
% --------------------------
%   'outImage'      Quantized image having same size and same class of
%                   input image. 
%                                         
%
% Example :
% -------
%                   I = imread('butterfly.tif');           %original image
%                   O1 = gray_quant_cvip(I);                %default graylevel = 4          
%                   graylevel = 16;                        %new graylevel
%                   O2 = gray_quant_cvip(I,graylevel);      %user specified graylevel
%                   figure; imshow(O2,[]);
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    2/15/2017
%           Latest update date:     3/27/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

if nargin ~= 1 && nargin ~= 2 
    error('Too many or too few input arguments!')
end
if nargout ~= 0 && nargout ~= 1
    error('Too many or too few output arguments!')
end

%set up default parameters
if nargin == 1
    graylevel = 4;
else      
    %check if the gray level is power of 2
    if mod(log2(graylevel),1)
        warning('The number of gray levels must be power of 2! Default option for number of gray levels is selected!');
        graylevel = 4;
    elseif graylevel>256
        warning('The number of gray levels must be less than 256! Default option for number of gray levels is selected!');
        graylevel = 4;
    end
end

%check image data is of unsigned integer type
if ~isa(inImage,'uint8')
    inImage = double(inImage);
end

%compute gray level quantized images
[n_rows, n_cols, n_bands] = size(inImage);
outImage = inImage;
msk = (256/graylevel)-1;
for b=1:n_bands
    outImage(:,:,b)=bitand(inImage(:,:,b),...
        uint8(repmat(bitxor(255,msk,'uint8'),[n_rows n_cols])),'uint8');
end

end

%end of function grayquantCVIP