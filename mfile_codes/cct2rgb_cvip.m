function rgb = cct2rgb_cvip(varargin)
% CCT2RGB_CVIP - Converts CCT (Cylindrical Coordinate) Color value to RGB Color value
% The CCT transform is different than most color mappings because it does not
% completely decouple brightness from color information.
% With this transform we can align the z-axis along the R, G,
% or B axis of choice; this choice will be application dependent. The 
% cylindrical coordinates are found as follows, assuming z-axis aligned 
% the blue axis:
%
%                   z = B
%                   d = (R^2+G^2)^(1/2)
%                   theta = atan(G/R)
%
% The CCT may be useful in applications where one of the RGB colors is of 
% primary importance, since it can be mapped directly to the z component,
% and the ratio of the other two is significant. Here the brightness
% information is now contained in the d and z coordinates, while the color
% information is still distributed across all three components, but in a
% different manner than with the original RGB data.
%
% Syntax : 
% -------
%  OutputImage = cct2rgb_cvip(InputImage, type)
%  
% Input Parameters include :
% --------------------------
%
%   InputImage - CCT color value Image
%   type       - output image preference (0,1)
%               (0 = Forward non normalized output)
%               (1 = gives normalized output)   
%
%   To view the 8-bit image of type double, divide by 255.
%   To view the 16-bit image of type double, divide by 65535.
% 
% Example 1 :
% ---------
%   Converts the CCT color value to RGB color value:
%
%                   X = imread('Car.bmp');
%                   S1 = rgb2cct_cvip(X,1);
%                   S2 = cct2rgb_cvip(S1,1);
%                   figure;imshow(S1,[]);
%                   figure;imshow(S2,[]);
%
%   See also, rgb2sct_cvip, rgb2cct_cvip, rgb2hsl_cvip, rgb2hsv_cvip, 
%   rgb2lab_cvip, rgb2luv_cvip, rgb2xyz_cvip, pct_cvip, ipct_cvip, 
%   sct2rgb_cvip, hsl2rgb_cvip, hsv2rgb_cvip, lab2rgb_cvip, luv2rgb_cvip
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
        error('Invalid Image Input: Requires 3 band CCT color value Image');
    end

%--------- Data Type Check and Conversion ---------------------------    
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
    
%---------- CCT to RGB Conversion ------------------------------
    d=varargin{1}(:,:,1);
    theta=varargin{1}(:,:,2);
    z=varargin{1}(:,:,3);
    R = d.*cos(theta);
    G = d.*cos((pi/2)-theta);
    B = z;
    rgb(:,:,1)=R;
    rgb(:,:,2)=G;
    rgb(:,:,3)=B;

end