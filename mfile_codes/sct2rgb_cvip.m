function rgb = sct2rgb_cvip(varargin)
% SCT2RGB_CVIP -Converts SCT Color value to RGB Color value
%  Z = sct2rgb_cvip(InputImage,type) converts an SCT color value image to 
%  the equivalent RGB image.
%
% Syntax :
% --------
% OutputImage = sct2rgb_cvip(InputImage, type)
%   
% Input parameters include :
% --------------------------
%
% 'InputImage'  SCT colr value Image.
%
% 'type'        output image preference (0,1)
%               (0 = Forward non normalized output)
%               (1 = gives normalized output)   
%
% To view the 8-bit image of type double,divide by 255.
% To view the 16-bit image of type double,divide by 65535.
% 
% Example 1 :
% ---------
%   Converts the SCT color value to RGB color value:
%
%                   X = imread('Car.bmp');
%                   S1 = rgb2sct_cvip(X,0);
%                   S2 = sct2rgb_cvip(S1,0);
%                   figure;imshow(X,[]);
%                   figure;imshow(S1,[]);
%                   figure;imshow(remap_cvip(S2,[]));
%
%   See also, rgb2sct_cvip, rgb2cct_cvip, rgb2hsl_cvip, rgb2hsv_cvip, 
%   rgb2lab_cvip, rgb2luv_cvip, rgb2xyz_cvip, pct_cvip, ipct_cvip, 
%   cct2rgb_cvip, hsl2rgb_cvip, hsv2rgb_cvip, lab2rgb_cvip, luv2rgb_cvip 
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

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
        error('Too few arguments for sct2rgb_cvip');
    elseif nargin>2,
        error('Too many arguments for sct2rgb_cvip');
    end;
    
%--------- RGB Image Input Check -----------------------------------
    if size(varargin{1},3)~=3
        error('Invalid Image Input: Requires Color(RGB) Image');
    end

%--------- Data Type Check and Conversion ---------------------------    
%     if ~isa(sct,'double')
%         sct=im2double(sct);
%     end
    if nargin==2,
        if (varargin{2}),  % for normalized output
            if ~isa(varargin{1},'double')
            varargin{1}=im2double(varargin{1});
            end
        else                % for Forward non normalized output
            if ~isa(varargin{1},'double')
            varargin{1}=double(varargin{1});
            end
        end
    else
        if ~isa(varargin{1},'double')
            varargin{1}=double(varargin{1});
        end
    end
    
%---------- SCT to RGB Conversion ------------------------------
    L=varargin{1}(:,:,1);
    angleA=varargin{1}(:,:,2);
    angleB=varargin{1}(:,:,3);
    R = L.*sin(angleA).*cos(angleB);
    G = L.*sin(angleA).*sin(angleB);
    B = L.*cos(angleA);
    rgb(:,:,1)=R;
    rgb(:,:,2)=G;
    rgb(:,:,3)=B;


end