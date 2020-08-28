 function xyz = rgb2xyz_cvip(varargin)
% RGB2XYZ_CVIP - Converts Red-Green-Blue Color value to XYZ Chromaticity Color value.
% 
% Syntax:
% ------
% OutputImage = rgb2hsv_cvip(InputImage, type)
% 
% Input parameters include :
% ------------------------
%   'InputImage'       RGB Image
%   'type'             output image preference (0,1)
%                      (0 = Forward non normalized output)
%                      (1 = gives normalized output)   
%
%   To view the 8-bit image of type double, divide by 255.
%   To view the 16-bit image of type double, divide by 65535.
% 
% Example :
% -------
%   Converts the RGB color value to XYZ color value:
%
%                   X = imread('Car.bmp');
%                   S1 = rgb2xyz_cvip(X,0); % forward transform image
%                   S2 = rgb2xyz_cvip(X,1); % forward transform, normalized
%                   figure;imshow(S1,[]);
%                   figure;imshow(S2,[]);
%
%   See also, rgb2cct_cvip, rgb2hsl_cvip, rgb2hsv_cvip, rgb2lab_cvip, 
%   rgb2luv_cvip,rgb2sct_cvip, pct_cvip, ipct_cvip, cct2rgb_cvip, 
%   hsl2rgb_cvip, hsv2rgb_cvip, lab2rgb_cvip, luv2rgb_cvip, sct2rgb_cvip,
%   
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Deependra Mishra
%           Initial coding date:    03/17/2017
%           Latest update date:     01/21/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.2  06/02/2019  15:54:41  jucuell
 % Removing unnecessary punctuation symbols and fixing the function
 % normalization.
%
 % Revision 1.1  03/17/2017  18:25:38  jucuell
 % Initial coding and testing.
%

%---------- Argument Check -----------------------------------------
    if nargin<1
        error('Too few arguments for rgb2xyz_cvip');
    elseif nargin>2
        error('Too many arguments for rgb2xyz_cvip');
    end
%--------- RGB Image Input Check -----------------------------------
    if size(varargin{1},3)~=3
        error('Invalid Image Input: Requires Color(RGB) Image');
    end
%--------- Data Type Check and Conversion ---------------------------
    if ~isa(varargin{1},'double')
        varargin{1}=double(varargin{1});
    end
     if nargin==2
            if (varargin{2})  % for normalized output
                if ~isa(varargin{1},'double')
                varargin{1}=im2double(varargin{1});
                end
            else                % for Forward non normalized output
                if ~isa(varargin{1},'double')
                varargin{1}=double(varargin{1});
                end
            end
% forward non normalized output for default case            
    else
        if ~isa(varargin{1},'double')
            varargin{1}=double(varargin{1}); 
        end
    end
%---------RGB to XYZ Conversion--------------------------------------    
    r=varargin{1}(:,:,1);
    g=varargin{1}(:,:,2);
    b=varargin{1}(:,:,3);
    
    x = r./(r+g+b);
    y = g./(r+g+b);
    z = b./(r+g+b);
    
    xyz=zeros(size(varargin{1}));
    xyz(:,:,1)=x;
    xyz(:,:,2)=y;
    xyz(:,:,3)=z;
    if varargin{2}
    	xyz = xyz*255; % Gives normalized output 
    end
end
    
   