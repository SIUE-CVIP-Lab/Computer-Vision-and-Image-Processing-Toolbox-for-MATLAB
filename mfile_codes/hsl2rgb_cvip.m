function rgb=hsl2rgb_cvip(varargin)
% HSL2RGB_CVIP- converts an HSL image to the equivalent RGB image. 
%
% This function converts HSL (Hue-Saturation-Lightness) Color value to RGB
% Color value.The RGB color model is an additive color model in which red,
% green and blue light are addd together in various ways to reproduce a 
% broad array of colors.RGB color values are found from HSL color values 
% as follows:
%
%                   C = (1-|2L-1|) * S
%                   H' = H/60
%                   X = C * (1-|H' mod 2 - 1|)
% 
%                               (0,0,0)
%                               (C,X,0)
%                               (X,C,0)
%                   R1,G1,B1 = (0,C,X)
%                               (0,X,C)
%                               (X,0,C)
%                               (C,0,X)
%                    
%                   m = L - 0.5*C
%                     
%                   (R,G,B) = (R1+m, G1+m, B1+m)
% Syntax :
% --------
% OutputImage = hsl2rgb_cvip(InputImage, type)
%
% Input parameters include :
% --------------------------
%       
%   'InputImage'      HSL Color value image
%   'type'            output image preference (0,1)
%                    (0 = Forward non normalized output)
%                    (1 = gives normalized output)   
%
%   To view the 8-bit image of type double, divide by 255.
%   To view the 16-bit image of type double, divide by 65535.
% 
% Example 1 :
% ----------
%   Converts the HSL color value to RGB color value:
%
%                   X = imread('Car.bmp');
%                   S1 = rgb2hsl_cvip(X);
%                   S2 = hsl2rgb_cvip(S1);
%                   figure;imshow(S1,[]);
%                   figure;imshow(remap_cvip(S2,[]));
%
%  
%
% See also, rgb2sct_cvip, rgb2cct_cvip, rgb2hsl_cvip, rgb2hsv_cvip, 
% rgb2lab_cvip, rgb2luv_cvip, rgb2xyz_cvip, pct_cvip, ipct_cvip, 
% cct2rgb_cvip, sct2rgb_cvip, hsv2rgb_cvip, lab2rgb_cvip, luv2rgb_cvip
%
% Reference 
% ---------
% https://en.wikipedia.org/wiki/HSL_and_HSV

%==========================================================================
%
%           Author:                 Deependra Mishra
%           Initial coding date:    03/17/2017
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     01/21/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.5  10/23/2018  17:59:41  jucuell
 % Function documentation updating, removing of unnecessary punctuation
 % symbols and removing l, s, C values such as l(123,159)
%
 % Revision 1.1  03/17/2017  16:28:15  demish
 % Initial coding and testing.
%

    if nargin<1
        error('Too few arguements for hsl2rgb_cvip');
        
    elseif nargin>2
        error('Too many arguements for hsl2rgb_cvip');
        
    end
%--------- RGB Image Input Check -----------------------------------
    if size(varargin{1},3)~=3
        error('Invalid Image Input: Requires 3 band HSL color value Image');
    end

%--------- Data Type Check and Conversion ---------------------------    
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
    else
        if ~isa(varargin{1},'double')
            varargin{1}=double(varargin{1});
        end
     end
%--------- HSL to RGB conversion ------------------------------------
    h=varargin{1}(:,:,1);
    s=varargin{1}(:,:,2);
    l=varargin{1}(:,:,3);
    
    h=h*360;
    hd=h/60;
    
    C = (1-abs((2*l)-1)).*s;
    X = C .* (1-abs((mod(hd,2)-1)));
    
    A0 = zeros(size(varargin{1}));
    A1 = zeros(size(varargin{1}));
    A1(:,:,1)=C;A1(:,:,2)=X;A1(:,:,3)=0;
    A2 = zeros(size(varargin{1}));
    A2(:,:,1)=X;A2(:,:,2)=C;A2(:,:,3)=0;
    A3 = zeros(size(varargin{1}));
    A3(:,:,1)=0;A3(:,:,2)=C;A3(:,:,3)=X;
    A4 = zeros(size(varargin{1}));
    A4(:,:,1)=0;A4(:,:,2)=X;A4(:,:,3)=C;
    A5 = zeros(size(varargin{1}));
    A5(:,:,1)=X;A5(:,:,2)=0;A5(:,:,3)=C;
    A6 = zeros(size(varargin{1}));
    A6(:,:,1)=C;A6(:,:,2)=0;A6(:,:,3)=X;
    
    iH = cat(3,hd,hd,hd);
    rgb0 = A0.*(and(iH<0, iH>6));
    rgb1 = rgb0 + A1.*(and(iH>=0, iH<=1));
    rgb2 = rgb1 + A2.*(and(iH>=1, iH<=2));
    rgb3 = rgb2 + A3.*(and(iH>=2, iH<=3));
    rgb4 = rgb3 + A4.*(and(iH>=3, iH<=4));
    rgb5 = rgb4 + A5.*(and(iH>=4, iH<=5));
    rgb6 = rgb5 + A6.*(and(iH>=5, iH<=6));
    
    m = l - C/2.0;
    m3 = cat(3,m,m,m);
    rgb= rgb6+m3;   
end