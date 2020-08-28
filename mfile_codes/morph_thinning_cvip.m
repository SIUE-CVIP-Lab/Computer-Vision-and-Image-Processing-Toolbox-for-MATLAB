function [outImage] = morph_thinning_cvip(inImage, thinningFilt)
% MORPH_THINNING_CVIP - Morphological thinning of a binary image.
% The function performs morphological thinning operation on a binary
% image.If input image color or gray-scale image, binary thresholding is
% performed before the thinning operation. The thinning filter is a
% structuring element containing 0's, 1's and NaN's or "don't care".
% Don't care element is represented by NaN value in this case.And,don't
% care elements in the structuring element match with either 0s or 1s.
%
% Syntax :
% ------
% [outImage, struct_el] = morph_thinning_cvip(inImage, thinningFilt)
%    
% Input Parameters include :
% ------------------------
%   'inImage'       Binary image of MxN size. If not binary image, binary  
%                   thresholding is performed on input image before 
%                   thinning operation.    
%
%   'thinningFilt'  Thinning filter or Structure Element of K*K size. And k
%                   must be a positive odd integer. (use structel_cvip
%                   function to create structuring element) 
%                   (Default: thinningFilt = [0 0 0; nan 1 nan; 1 1 1];)
%                                                               
%
% Output Parameter include :  
% ------------------------
%   'outImage'      Output image of Morphological thinning operation. It is 
%                   of logical class. It will be a binary image even if
%                   input image is color or grayscale image.
%
%
% Example 1 :
% ---------
%     %Perform thinning operation using default thinning filter
%       I = imread('binary.jpg');         %original image
%       O1 = morph_thinning_cvip(I);             
%       figure;imshow(O1,[]);
% Example 2 :
% ---------
%     %Perform thinning operation using user specified thinning filter
%       I = imread('binary.jpg');          %original image
%       kernel = [0 0 nan; 0 1 1; nan 1 1];
%       O2 = morph_thinning_cvip(I,kernel); 
%       figure;imshow(O2,[]);        
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    6/2/2017
%           Latest update date:     6/6/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

%check number of input and output arguments
if nargin ~= 1 && nargin ~= 2 
    error('Too many or too few input arguments!')
end
if nargout ~= 0 && nargout ~= 1 
    error('Too many or too few output arguments!')
end

%check if thinning filter arguments are existed or empty
if ~exist('thinningFilt','var') || isempty(thinningFilt) 
    thinningFilt = [0     0   0;  ...
                    nan   1   nan;  ...
                    1     1   1];   %default case
end

%check if thinning filter is a square matrix 
%Also, the length of side must be positive odd integer.
[num_rows, num_cols] = size(thinningFilt);

if (num_rows ~= num_cols) && mod(num_rows, 2) ~= 1
    error('Hitt-miss filter is not K*K matrix or K is not odd & positive integer!');
end

%convert input image type to logical array
inImage = logical(inImage);

%perform thinning operation
% thin(I(r,c), SE) = I(r,c) - hit_or_miss(I(r,c), SE)
% I(r,c)-> input image
% SE -> structuring element
outImage = inImage & (~(morph_hitmiss_cvip(inImage, thinningFilt)));

end

