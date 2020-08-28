function rgb = luv2rgb_cvip(varargin)
% LUV2RGB_CVIP - Converts  L*u*v* Color value to Red-Green-Blue Color value.
% 
% Syntax :
% ------  
% OutputImage = luv2rgb_cvip(InputImage, type)
%  
% Input parameters include :
% ------------------------
%  'InputImage'     L*u*v* color value Image
%   type            output image preference (0,1)
%                   (0 = Forward non normalized output)
%                   (1 = gives normalized output)   
%
%   To view the 8-bit image of type double, divide by 255.
%   To view the 16-bit image of type double, divide by 65535.
% 
% Example :
% -------
%   Converts the  L*u*v* color value to RGB color value:
%
%                   X = imread('Car.bmp');
%                   S1 = rgb2luv_cvip(X,0);
%                   S2 = luv2rgb_cvip(S1,0);
%                   figure;imshow(X,[]);
%                   figure;imshow(S1,[]);
%                   figure;imshow(remap_cvip(S2,[]));
%
%
% See also, rgb2sct_cvip, rgb2cct_cvip, rgb2hsl_cvip, rgb2hsv_cvip, 
% rgb2lab_cvip, rgb2xyz_cvip, pct_cvip, ipct_cvip, sct2rgb_cvip 
% cct2rgb_cvip, hsl2rgb_cvip, hsv2rgb_cvip, lab2rgb_cvip, rgb2luv_cvip
%
% Reference
% ---------
% Jain, Anil K., Fundamentals of Digital Image Processing,Prentice-Hall, ISBN 0-13-336165-9, 1989.

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
        error('Too few arguments for luv2rgb_cvip');
    elseif nargin>2,
        error('Too many arguments for luv2rgb_cvip');
    end;
    
%--------- RGB Image Input Check -----------------------------------
    if size(varargin{1},3)~=3
        error('Invalid Image Input: Requires 3 Band L* u* v* color value Image');
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
    
%     if ~isa(luv,'double')
%         luv=double(luv);
%     end
    l=varargin{1}(:,:,1);
    u=varargin{1}(:,:,2);
    v=varargin{1}(:,:,3);
    Yo = 1;
    ud = (u./(13*l))+0.2009;
    vd = (v./(13*l))+0.4610;
    index =  find(l<=8);
    y(index) = Yo*l(index)*(3/29)^3;
    index = find(l>8);
    y(index) = Yo*((l(index)+16)/116).^3;
    y = reshape(y,size(l));
    x=y.*((9*ud)./(4*vd));
    z=y.*((12-3*ud-20*vd)./(4*vd));
    
%     x = (9*ud)./(6*ud - 16*vd + 12);
%     y =(4*vd)./(6*ud - 16*vd + 12);
%     z = y.*(12 - 3*ud - 20*vd)./(4*vd);
    
    r = x * 2.3706743 + y * (-0.9000405) + z * (-0.4706338);
    g = x * (-0.5138850) + y * 1.4253036 + z * 0.0885814;
    b = x * 0.0052982 + y * (-0.0146949) + z * 1.0093968;
    
    rgb(:,:,1)=r;
    rgb(:,:,2)=g;
    rgb(:,:,3)=b;
end