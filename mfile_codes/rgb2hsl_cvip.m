function hsl = rgb2hsl_cvip(varargin)
% RGB2HSL_CVIP - Converts Red-Green-Blue Color value to Hue-Saturation-Luminance Color value.
%  
% Syntax :
% ------
% outputImage = rgb2hsl_cvip(InputImage, type)
%
% Description :
% -----------
% This function converts RGB Color value to HSL (Hue-Saturation-Lightness) 
% Color value.The HSL color transform allows us to describe colors in 
% terms that we can more readily understand. The lightness (also referred
% to as intensity or value) is the brightness of the color, and the hue is
% what we normally think of as "color" (e.g. green, blue, or orange).The 
% saturation is a measure of how much white is in the color; for example, 
% pink is red with more white, so it is less saturated than a pure red. Since
% the HSL color space was developed based on heuristice relating to human
% perception, various methods are available to transform RGB pixel values 
% into the HSL color space.Most of these are algorithmic in nature and are
% geometric approximations to mapping the RGB color cube into some HSL-type
% color space.HSL color values are found as follows:
%
%                   M = max(R,G,B)
%                   m = min(R,G,B)
%                   C = M - m
%
%                        undefined,     if C=0
%                   H' = (G-B)/C mod 6, if M = R
%                        (B-R)/C + 2,   if M = G
%                        (R-G)/C + 4,   if M=B
%                   H = 60 * H'
%                   
%                   S = 0, if L=1
%                       C/(1-|2L-1|), otherwise
% 
%                   L = (M+m)/2
%
%
% Input parameters include :
% ------------------------       
%   'InputImage'      RGB Image
%   'type'            output image preference (0,1)
%                     (0 = Forward non normalized output)
%                     (1 = gives normalized output)   
%
%   To view the 8-bit image of type double, divide by 255.
%   To view the 16-bit image of type double, divide by 65535.
% 
% Example :
% -------
% Converts the RGB color value to HSL color value:
%
%                   X = imread('Car.bmp');
%                   S1 = rgb2hsl_cvip(X,0);
%                   S2 = rgb2hsl_cvip(X,1);
%                   figure;imshow(S1,[]);
%                   figure;imshow(S2,[]);
%
%
%  See also, rgb2sct_cvip, rgb2cct_cvip, sct2rgb_cvip, rgb2hsv_cvip, 
%  rgb2lab_cvip, rgb2luv_cvip, rgb2xyz_cvip, pct_cvip, ipct_cvip, 
%  cct2rgb_cvip, hsl2rgb_cvip, hsv2rgb_cvip, lab2rgb_cvip, luv2rgb_cvip
%
% Reference
% ---------
% https://en.wikipedia.org/wiki/HSL_and_HSV

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

% data range NaN (need to resolve this)
%-------------------------------------------------------------------
    
%---------- Argument Check -----------------------------------------
    if nargin<1
        error('Too few arguments for rgb2hsl_cvip');
    elseif nargin>2
        error('Too many arguments for rgb2hsl_cvip');
    end
    
%--------- RGB Image Input Check -----------------------------------
    if size(varargin{1},3)~=3
        error('Invalid Image Input: Requires Color(RGB) Image');
    end

%--------- Data Type Check and Conversion ---------------------------    
    if nargin==2
        if (varargin{2}) % for normalized output
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
%--------- RGB to HSL conversion ------------------------------------
    r=varargin{1}(:,:,1);
    g=varargin{1}(:,:,2);
    b=varargin{1}(:,:,3);
    Min = min(varargin{1},[],3);
    Max = max(varargin{1},[],3);
    d=Max-Min;

%---Calculating H-Band-------------
    H=zeros(size(r));
    z=~d;
    d(~d)=1;
%     index = d==0;
%     H(index) = 0;
    index = find(r==Max);
    H(index) = mod(((g(index)-b(index))./(d(index)+1e-6)),6);
    index = find(g==Max);
    H(index) = ((b(index)-r(index))./(d(index)+1e-6))+2;
    index = find(b==Max);
    H(index) = ((r(index)-g(index))./(d(index)+1e-6))+4;
%     index = d==0;
%     H(index) = 0;
    H=(60*H)/360;
    index = H<0;
    H(index) = H(index) +1;
    H(z) = 0;
    H=reshape(H,size(r));
%     hsv=rgb2hsvCVIP(rgb);
%     H=hsv(:,:,1);
    
%---Calculating L-Band------------
    L = (Min+Max)/2.0;
    
    index = d==0;
    S(index) = 0;
    index = L<=0.5;
    S(index) = (Max(index)-Min(index))./((Max(index)+Min(index))+1e-6);
    index = L>0.5;
    S(index) = (Max(index)-Min(index))./((2-(Max(index)+Min(index)))+1e-6);
    S = reshape(S,size(Min));

%---Calculating S-band-------------
%     S=L;
%     S(S==1)=0;
%     x=d./((1-abs((2*L)-1))+1e-6);
%     S(S~=1)=x;

    hsl=zeros(size(varargin{1}));
    hsl(:,:,1)=H;
    hsl(:,:,2)=S;
    hsl(:,:,3)=L;

end