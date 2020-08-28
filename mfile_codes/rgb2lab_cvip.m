function LAB = rgb2lab_cvip(varargin)
% RGB2LAB_CVIP - Converts Red-Green-Blue Color value to L* a* b* Color value
%
% Syntax :
% ------
% OutputImage = rgb2lab_cvip(InputImage, type)
% 
% Input parameters include :
% ------------------------
%  'InputImage'     RGB Image
%   'type'          output image preference (0,1))
%                   (0 = Forward non normalized output)
%                   (1 = gives normalized output)   
%
%   To view the 8-bit image of type double, divide by 255.
%   To view the 16-bit image of type double, divide by 65535.
%
%   Tristimulus values of the reference white
%   Xo = 95.047/100 ;Yo =100.00/100 ;Zo = 108.883/100;% Using   D65 
%   Xo = 96.42/100 ;Yo =100.00/100 ;Zo = 82.51/100;%D50
%   Xo = 1 ;Yo =1 ;Zo = 1; 
% 
% 
% Example 1 :
% ---------
%   Converts the RGB color value to L*a*b* color value:
%
%                   X = imread('Car.bmp');
%                   S1 = rgb2lab_cvip(X,0);
%                   S2 = rgb2lab_cvip(X,1);
%                   figure;imshow(S1,[]);
%                   figure;imshow(S2,[]);
%
%   See also, rgb2sct_cvip, rgb2cct_cvip, rgb2hsl_cvip, rgb2hsv_cvip, 
%   sct2rgb_cvip, rgb2luv_cvip, rgb2xyz_cvip, pct_cvip, ipct_cvip, 
%   cct2rgb_cvip, hsl2rgb_cvip, hsv2rgb_cvip, lab2rgb_cvip, luv2rgb_cvip
%
% Reference
% ---------
% 1. Jain, Anil K., Fundamentals of Digital Image Processing,Prentice-Hall,
% ISBN 0-13-336165-9, 1989.

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
        error('Too few arguments for rgb2lab_cvip');
    elseif nargin>2,
        error('Too many arguments for rgb2lab_cvip');
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
%---------- RGB to L* a* b* Conversion ------------------------------
    r=varargin{1}(:,:,1);
    g=varargin{1}(:,:,2);
    b=varargin{1}(:,:,3);
    Xo = 95.047/100 ;Yo =100.00/100 ;Zo = 108.883/100;% D65 Tristimulus values of the reference white
%    Xo = 96.42/100 ;Yo =100.00/100 ;Zo = 82.51/100;%D50
%     Xo = 1 ;Yo =1 ;Zo = 1; %Gives the closest matching output
    X = r * 0.490 + g * 0.310 + b * 0.200;
    Y = r * 0.177 + g * 0.813 + b * 0.011;
    Z = r * 0.000 + g * 0.010 + b * 0.990; 

    L = (25*(((100*Y)/Yo).^(1/3))) - 16;
    A = 500*(((X/Xo).^(1/3))-((Y/Yo).^(1/3)));
    B = 200 * (((Y/Yo).^(1/3))- ((Z/Zo).^(1/3)));
    LAB(:,:,1)=L;
    LAB(:,:,2)=A;
    LAB(:,:,3)=B;
end