function binImage = graycode2bin_cvip(varargin)
% GRAYCODE2BIN_CVIP- Performs gray code to binary code conversion on an input image
%  Z = GRAYCODE2BIN_CVIP(X) This function performs a gray to binary code 
%  conversion on an input image.Gray code is binary numerical system where
%  two consecutive values differ in only one bit.Gray code is also known as 
%  Reflected binary code.
%
% Syntax:
% -------
% binImage = graycode2bin_cvip(varargin)
%
%  
% Example 1 :
% ---------
%   Perform binary to gray code conversion on input grayscale image:
%
%                   X = imread('Cam.bmp');
%                   S1 = bin2graycode_cvip(X);
%                   S2 = graycode2bin_cvip(S1);
%                   figure;imshow(X,[]);
%                   figure;imshow(S1,[]);
%                   figure;imshow(S2,[]);
%
% Example 2 :
% ---------
%   Perform binary to gray code conversion on a color image:
%
%                   X = imread('Car.bmp');
%                   S1 = bin2graycode_cvip(X);
%                   S2 = graycode2bin_cvip(S1);
%                   figure;imshow(X,[]);
%                   figure;imshow(S1,[]);
%                   figure;imshow(S2,[]);
%                   
%
%   See also, halftone_cvip , vipmread_cvip, vipmwrite_cvip
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Deependra Mishra
%           Initial coding date:    10/20/2017
%           Latest update date:     10/20/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

%---------- Argument Check -----------------------------------------
    if nargin<1,
        error('Too few arguments for bin2graycode operation');
    elseif nargin>1,
        error('Too many arguments for bin2graycode operation');
    end;
    
%--------- Data Type Check and Conversion --------------------------- 
    if isa(varargin{1},'double') && (max(max(max(varargin{1})))<=255)
        varargin{1}=uint8(varargin{1});
    elseif isa(varargin{1},'double') && (max(max(max(varargin{1})))>=255)
        varargin{1}=uint16(varargin{1});
    end;
%     if ~isa(varargin{1},'uint8')
%         varargin{1}= uint8(varargin{1});
%     end;
    
    binImage = bitxor(varargin{1}, bitshift(varargin{1}, -8));
    binImage = bitxor(binImage, bitshift(binImage,-4));
    binImage = bitxor(binImage, bitshift(binImage,-2));
    binImage = bitxor(binImage, bitshift(binImage,-1));
end