function [ outImage ] = translate_cvip( inImage, shiftOffset, grayFill)
% TRANSLATE_CVIP- Translates or moves the entire image or a part of the image.
% Translate can perform two different operations,  horizontal and vertical
% translation of an image.Translation moves the image as a whole; it can
% either wrap the image around the 'edges' or fill vacated areas with a
% constant value. 
%
%
% Syntaxes :
% --------
% outImage = translate_cvip(inImage)
% outImage = translate_cvip( inImage, shiftOffset)
% outImage = translate_cvip( inImage, shiftOffset, grayFill)
%   
% 
% Input Parameters include :
% -------------------------
%   'inImage'       1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. The input image can be of uint8 or uint16 
%                   or double class. 
%   'shiftOffset'   Row and column co-ordinates of upper-left pixel to move
%                   Row or column vector of length 2. 
%                   shiftOffset(1): row co-ordinate               
%                   shiftOffset(2): column co-ordinate             
%                                                     ([M/2 N/2] | default)
%   'grayFill'      Gray value from 0 to 255 to fill vacated area or string 
%                   'Not' to fill with the translated original image.                                       
%                                                         ('Not' | default)
%
%
% Output Parameter include :  
% ------------------------
%   'outImage'      Translated image
%                                         
%
% Example :
% -------
%        % Translate the image with default parameters
%              I = imread('butterfly.tif');    
%              O1 = translate_cvip(I);  
%              figure;imshow(O1/255);      %O1 is of double class and the 
%                                          %range [0 255]
%        % Translate the image with user defined parameters
%              O2 = translate_cvip(I,[256 256],0);  
%              figure;imshow(O2/255); 
%
%
% Reference 
% ---------
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications 
%     with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    04/14/2017
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     08/28/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
 % Revision 1.3  08/28/2018  18:10:15  jucuell
 % start adding revision history and deleting old commented code
%
 % Revision 1.2  04/03/2018  16:25:15  jucuell
 % change definition of default_grayFill = 'Not'; (original was 128) and 
 % change the order of the verification filling value
%
 % Revision 1.1  01/21/2018  10:30:55  jucuell
 % Initial revision:
 % problems with color and non-square images
%

%check number of input arguments
if nargin ~=1 && nargin ~= 2 && nargin ~= 3  
    error('Too many or too few input arguments!');
end

%check number of output arguments
if nargout ~= 1 && nargout ~= 0
    error('Too many output arguments!');
end

%find size of input image
[M, N, B] = size(inImage);

%set up the default parameters
default_shiftOffset = ceil([M/2 N/2]); %default right shift and down shift offset
default_grayFill = 'Not';              %not wrap the image around the edge

if ~exist('shiftOffset','var') || isempty(shiftOffset)
    shiftOffset = default_shiftOffset;
end
if ~exist('grayFill','var') || isempty(grayFill)
    grayFill = default_grayFill;   
end

%if grayFill option is not selected 
if strcmp(default_grayFill,grayFill)
    %create output image without gray fill value
    outImage = zeros(M,N,B);
    %translate the image
    outImage (shiftOffset(1)+1:M,1:shiftOffset(2),:) = inImage(1:M-shiftOffset(1),...
        N-shiftOffset(2)+1:N,:);        %bottom-left portion  
    outImage (1:shiftOffset(1),shiftOffset(2)+1:N,:) = inImage(M-shiftOffset(1)+1:M,...
        1:N-shiftOffset(2),:);          %top-right portion
    outImage (1:shiftOffset(1),1:shiftOffset(2),:) = inImage(M-shiftOffset(1)+1:M,...
        N-shiftOffset(2)+1:N,:);        %top-left portion
else
    %create output image with gray fill value
    outImage = zeros(M,N,B) + grayFill;
end

%translate the image
outImage (shiftOffset(1)+1:M,shiftOffset(2)+1:N,:) = inImage(1:M-shiftOffset(1),...
1:N-shiftOffset(2),:);            %bottom-right portion

end % end of function