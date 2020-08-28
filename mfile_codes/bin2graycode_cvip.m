function grayCodeImage = bin2graycode_cvip(varargin)
% BIN2GRAYCODE_CVIP - Performs a binary code to gray code conversion on an input image.
%
% Syntax :
% --------
% Z = bin2graycode_cvip(X)
%
% This function performs a  binary code to gray code conversion on an  input image.
% Gray code is binary numerical system where
% two consecutive values differ in only one bit. Gray code is also known as 
% Reflected binary code.
%
%   'X'       Input Image
%   'Z'       Output Image
%
% Example 1 :
% -------
%   Perform binary to gray code conversion on input grayscale image:
%
%                   X = imread('Cam.bmp');
%                   S = bin2graycode_cvip(X);
%                   figure;imshow(S,[]);
%
% Example 2 :
% ---------
%   Perform binary to gray code conversion on a color image:
%
%                   X = imread('Car.bmp');
%                   S1 = bin2graycode_cvip(X);
%                   figure;imshow(X,[]);
%                   figure;imshow((S1),[]);
%                   
%
%   See also, halftone_cvip , vipmread_cvip, vipmwrite_cvip
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Deependra Mishra
%           Initial coding date:    10/20/2017
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     09/28/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.1  09/28/2018  19:12:11  jucuell
 % adjusting of double data to uint 8 conversion, removing unnecessary 
 % colons and semi-colons
 % 
%


%---------- Argument Check -----------------------------------------
    if nargin<1
        error('Too few arguments for bin2graycode operation');
    elseif nargin>1
        error('Too many arguments for bin2graycode operation');
    end
    
%--------- Data Type Check and Conversion ---------------------------
    if isa(varargin{1},'double') && (max(max(max(varargin{1})))>1)
        varargin{1}=uint8(varargin{1});
    elseif isa(varargin{1},'double') && (max(max(max(varargin{1})))<=1)
        varargin{1}=uint8(varargin{1}*255);
    elseif isa(varargin{1},'double') && (max(max(max(varargin{1})))>=255)
        varargin{1}=uint16(varargin{1});
    end
%     if ~isa(varargin{1},'uint8')
%         varargin{1}= uint8(varargin{1});
%     end;
    grayCodeImage = bitxor(bitshift(varargin{1},-1),varargin{1});
end