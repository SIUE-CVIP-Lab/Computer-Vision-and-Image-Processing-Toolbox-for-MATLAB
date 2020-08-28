function hsv = rgb2hsv_cvip(varargin)
% RGB2HSV_CVIP - Converts Red-Green-Blue Color value to Hue-Saturation-Value Color value
% 
% Syntax :
% ------
% OutputImage = rgb2hsv_cvip(InputImage, type)
% 
% Input parameters include :
% ------------------------
%   InputImage - RGB Image
%   type       - output image preference (0,1)
%               (0 = Forward non normalized output)
%               (1 = gives normalized output)   
%
%   To view the 8-bit image of type double, divide by 255.
%   To view the 16-bit image of type double, divide by 65535.
% 
% Example 1 :
% ---------
%   Converts the RGB color value to HSV color value:
%
%                   X = imread('Car.bmp');
%                   S1 = rgb2hsv_cvip(X,0);
%                   S2 = rgb2hsv_cvip(X,1);
%                   figure;imshow(S1,[]);
%                   figure;imshow(S2,[]);
%
%
%  See also, rgb2sct_cvip, rgb2cct_cvip, rgb2hsl_cvip, sct2rgb_cvip, 
%  rgb2lab_cvip, rgb2luv_cvip, rgb2xyz_cvip, pct_cvip, ipct_cvip, 
%  cct2rgb_cvip, hsl2rgb_cvip, hsv2rgb_cvip, lab2rgb_cvip, luv2rgb_cvip
%
% Reference
% ---------
%  https://en.wikipedia.org/wiki/HSL_and_HSV

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
        error('Too few arguments for rgb2hsv_cvip');
    elseif nargin>2,
        error('Too many arguments for rgb2hsv_cvip');
    end;
    
%--------- RGB Image Input Check -----------------------------------
    if size(varargin{1},3)~=3
        error('Invalid Image Input: Requires Color(RGB) Image');
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
%--------- RGB to HSV Conversion ------------------------------------    
    r=varargin{1}(:,:,1);
    g=varargin{1}(:,:,2);
    b=varargin{1}(:,:,3);
    Min = min(varargin{1},[],3);
    Max = max(varargin{1},[],3);
    d=Max-Min;
%---Computing V-band------------------------------------------------------    
    V = Max;
%---Computing H-band------------------------------------------------------    
    t=~d;
    
    d(~d)=1;
%     index = Min==Max;
%     H(index) = 0;
    index = r==Max;
    H(index) = mod(((g(index)-b(index))./d(index)),6);
    index = g==Max;
    H(index) = (b(index)-r(index))./d(index)+2;
    index = b==Max;
    H(index) = (r(index)-g(index))./d(index)+4;
    H=(60*H)/360;
    index = H<0;
    H(index) = H(index) +1;
    H(t) = 0;
    H=reshape(H,size(r));
%---Computing S-band-------------------------------------------------------    
    S = d./Max;
    S(t) = 0;
    index = find(Max);
    d(index)= S(index);
    d(~Max) = 0;
    d=reshape(d,size(r));
    
    hsv = zeros(size(varargin{1}));
    hsv(:,:,1)=H;
    hsv(:,:,2)=d;
    hsv(:,:,3)=V;

end