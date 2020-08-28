function iPCT = ipct_cvip(varargin)
% IPCT_CVIP - Performs inverse priciple component transform. 
% Z = ipct_cvip(varargin), Converts priciple component transform image
% value to RGB image value.This function accepts variable input argument.
%
% Syntax :
% --------
% OutputImage = ipct_cvip(InputImage, EigenVector)
%
% Input parameters include :
% --------------------------
%       
%   'InputImage'        PCT Image
%   'EigenVector'       EigenVector, 3x3 matrix, generated while performing PCT operation.
%  
%
%   To view the 8-bit image of type double, divide by 255.
%   To view the 16-bit image of type double, divide by 65535.
% 
% Example 1 :
% ---------
%   Converts the PCT color value to RGB color value:
%
%                   X = imread('Car.bmp');
%                   [S1 E e] = pct_cvip(X);
%                   S2 = ipct_cvip(S1,E);
%                   figure;imshow(X,[]);
%                   figure;imshow(S1,[]);
%                   figure;imshow(remap_cvip(S2,[]));
%
%   See also, pct_cvip
%
% Reference
% ---------
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Deependra Mishra
%           Initial coding date:    03/17/2017
%           Latest update date:     03/17/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================
    
%---------- Argument Check -----------------------------------------
    if nargin<1,
        error('Too few arguments for ipct_cvip');
    elseif nargin>2,
        error('Too many arguments for ipct_cvip');
    end;
    
    
%--------- RGB Image Input Check -----------------------------------
    if size(varargin{1},3)~=3
        error('Invalid Image Input: Requires 3 band Image');
    end;
    
%--------- Data Type Check and Conversion ---------------------------    
    if ~isa(varargin{1},'double')
        varargin{1}=double(varargin{1});
    end
    if numel(varargin{2})~=9,
        error('EigenVector Error: Hint:- Enter 3x3 Eigen Vector Matrix');
    end;
    
%---------- RGB to PCT Conversion ------------------------------
    r=varargin{1}(:,:,1); %r band
    g=varargin{1}(:,:,2); %g band
    b=varargin{1}(:,:,3); %b band
    E = varargin{2}';
%-----------Components of iPCT------------------------------------
    P = r*E(1,1)+g*E(1,2)+b*E(1,3);
    C = r*E(2,1)+g*E(2,2)+b*E(2,3);
    T = r*E(3,1)+g*E(3,2)+b*E(3,3);
%-------------assembleing individual component into PCT-------------
    iPCT(:,:,1)=P;
    iPCT(:,:,2)=C;
    iPCT(:,:,3)=T;
end
