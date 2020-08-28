function [ outImage ] = gray_linear_cvip( inImage, startGray, endGray, s_gray, slope, change, band)
% GRAY_LINEAR_CVIP -Performs linear gray level modification.
% The function performs gray level modification on a range of values in
% an image. The user specifies a range of values to change with startGray
% and endGray, the new gray level to apply at the startGray value, and
% the function calculates a new value for each subsequent gray value by
% applying userspecified slope to s_gray, until endGray is reached. Slope
% can be positive, negative,  or zero. Those values not within the range
% startGray ... endGray can be set to zero or left unmodified.
% The parameter band specifies which band to modify, which can be a
% non-negative integer for a specific band or -1 representing all bands.
%
%
% Syntax:
% -------
% outImage = gray_linear_cvip( inImage, startGray, endGray, s_gray, slope, change, band)
%   
% 
% Input Parameters include:
% -------------------------
%   'inImage'       1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. The input image can be of uint8 or uint16 
%                   or double class. 
%   'startGray'     Initial gray level to modify.
%   'endGray'       Final gray level to modify.
%   's_gray'        New initial gray level.
%   'slope'         Slope of modifying line.
%   'change'        Change out-of_range pixels to black or keep without
%                   modyfing it (1 -> change to black, 0 -> no
%                   modification) 
%   'band'          The band number to modify.
%
%
% Output Parameter includes:  
% --------------------------
%   'outImage'      Linearly modified image.
%                                         
%
% Example :
% -------
%                   I = imread('butterfly.tif');    %original image
%                   O = gray_linear_cvip( I, 10, 200, 30, 1.2, 0, 1);
%                   figure; imshow(uint8(O));  %function returns as double
%                                              %type (range = 0-255) 
%
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    04/14/2017
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     06/01/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.2  06/15/2019  13:14:49  jucuell
 % Help description for change input parameter was updates according to
 % code in the file.
%
 % Revision 1.1  04/14/2017  15:10:28  jucuell
 % Initial revision: Coding and initial testing.
%

MAX_BYTE = 255;
MAX_UINT16 = 2^16 - 1;

%check number of input arguments
if nargin ~=1 && nargin ~= 2 && nargin ~= 3 && nargin ~= 4 && ...
        nargin ~= 5 && nargin ~= 6 && nargin ~= 7     
    error('Too many or too few input arguments!');
end

%check number of output arguments
if nargout ~= 1 && nargout ~= 0
    error('Too many output arguments!');
end

%select the band to modify it
inImage = double(inImage);
switch band 
    case 1
        tempImage = inImage(:,:,1);
    case 2
        tempImage = inImage(:,:,2);
    case 3
        tempImage = inImage(:,:,3);
    case -1
        tempImage = inImage;
    otherwise
        error('No such band available!');
end
      
%find the pixels in range of [startGray endGray]
tempPels = (tempImage >= startGray & tempImage <= endGray);

%find max value for data type
if isa(inImage, 'uint8') || isa(inImage, 'double')
    MAX = MAX_BYTE;
elseif isa(inImage,'uint16')
    MAX = MAX_UINT16;
end

%Modify the pixel valuss that falls in the range of [startGray endGray] 
tempImage = (slope*(tempImage-startGray) + s_gray).*tempPels;
tempImage(tempImage < 0) = 0;
tempImage(tempImage > MAX) = MAX;

%change out-of-range pixels to black if option is selected
outImage = inImage;
if change    %out-of-range pixels set to BLACK
    switch band 
        case 1
            outImage(:,:,1) = tempImage;
        case 2
            outImage(:,:,2) = tempImage;
        case 3
            outImage(:,:,3) = tempImage;
        case -1
            outImage = tempImage; 
    end    
else         %out-of-range pixels remains unmodified
    
    %put modified values back in the image    
    switch band 
        case 1
            outImage(:,:,1) = outImage(:,:,1).* (~tempPels) + tempImage;
        case 2
            outImage(:,:,2) = outImage(:,:,2).* (~tempPels) + tempImage;
        case 3
            outImage(:,:,3) = outImage(:,:,3).* (~tempPels) + tempImage;
        case -1
            outImage = outImage.* (~tempPels) + tempImage; 
    end
end

end % end of function
