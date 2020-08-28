function CCT = rgb2cct_cvip(varargin)
% RGB2CCT_CVIP - Converts Red-Green-Blue Color value to CCT, Cylindrical Coordinate Color value.
%  
% SYNTAX :
% -------
%  OutputImage = rgb2cct_cvip(InputImage, type)
%       
%   'InputImage'    RGB Image
%
%   'type'          output image preference (0,1)
%                   (0 = Forward non normalized output)
%                   (1 = gives normalized output)   
%
%   To view the 8-bit image of type double, divide by 255.
%   To view the 16-bit image of type double, divide by 65535.
% 
% Example 1 :
% ---------
%   Converts the RGB color value to CCT color value:
%
%                   X = imread('Car.bmp');
%                   S1 = rgb2cct_cvip(X,0); % forward transform image
%                   S2 = rgb2cct_cvip(X,1); % forward transform, normalized
%                   figure;imshow(S1,[]);
%                   figure;imshow(S2,[]);
%
%   See also, rgb2sct_cvip, sct2rgb_cvip, rgb2hsl_cvip, rgb2hsv_cvip, 
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
        error('Too few arguments for rgb2cct_cvip');
    elseif nargin>2,
        error('Too many arguments for rgb2cct_cvip');
    end;
    
%--------- RGB Image Input Check -----------------------------------
    if size(varargin{1},3)~=3
        error('Invalid Image Input: Requires Color(RGB) Image');
    end

%--------- Data Type Check and Conversion ---------------------------    
%     if ~isa(rgb,'double')
%         rgb=double(rgb);
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
%---------- RGB to CCT Conversion ------------------------------
    r=varargin{1}(:,:,1);
    g=varargin{1}(:,:,2);
    b=varargin{1}(:,:,3);
    z=b;
    d=(r.^2+g.^2).^(1/2);
    theta = atan(g./r);
    CCT(:,:,1)=d;
    CCT(:,:,2)=theta;
    CCT(:,:,3)=z;

end
