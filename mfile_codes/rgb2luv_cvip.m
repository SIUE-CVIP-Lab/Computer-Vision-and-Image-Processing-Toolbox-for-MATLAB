function LUV=rgb2luv_cvip(varargin)
% RGB2LUV_CVIP - Converts Red-Green-Blue Color value to L*u*v* Color value
% 
% Syntax :
% ------
% OutputImage = rgb2luv_cvip(InputImage, type)
%  
% Input parameters include :
% ------------------------
%   'InputImage'    RGB Image
%   'type'          output image preference (0,1)
%                   (0 = Forward non normalized output)
%                   (1 = gives normalized output)   
%
%   To view the 8-bit image of type double, divide by 255.
%   To view the 16-bit image of type double, divide by 65535.
% 
% Example 1 :
% ---------
%   Converts the RGB color value to L*u*v* color value:
%
%                   X = imread('Car.bmp');
%                   S1 = rgb2luv_cvip(X,0);
%                   S2 = rgb2luv_cvip(X,1);
%                   figure;imshow(S1,[]);
%                   figure;imshow(S2,[]);
%
%   See also, rgb2sct_cvip, rgb2cct_cvip, rgb2hsl_cvip, rgb2hsv_cvip, 
%   rgb2lab_cvip, rgb2xyz_cvip, pct_cvip, ipct_cvip, sct2rgb_cvip 
%   cct2rgb_cvip, hsl2rgb_cvip, hsv2rgb_cvip, lab2rgb_cvip, luv2rgb_cvip
%
% Reference
% ---------
% Jain, Anil K., Fundamentals of Digital Image Processing, Prentice-Hall, ISBN 0-13-336165-9, 1989.

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
        error('Too few arguments for rgb2luv_cvip');
    elseif nargin>2,
        error('Too many arguments for rgb2luv_cvip');
    end;
    
%--------- RGB Image Input Check -----------------------------------
    if size(varargin{1},3)~=3
        error('Invalid Image Input: Requires Color(RGB) Image');
    end

%--------- Data Type Check and Conversion ---------------------------    
%     if ~isa(rgb,'double')
%         rgb=im2double(rgb);
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
% forward non normalized output for default case            
    else
        if ~isa(varargin{1},'double')
            varargin{1}=double(varargin{1}); 
        end
    end
%---------- RGB to L* a* b* Conversion ------------------------------
    r=varargin{1}(:,:,1);
    g=varargin{1}(:,:,2);
    b=varargin{1}(:,:,3);
%     Xo = 95.047/100 ;Yo =100.00/100 ;Zo = 108.883/100;% D65 Tristimulus values of the reference white
%    Xo = 96.42/100 ;Yo =100.00/100 ;Zo = 82.51/100;%D50
%     Xo = 1 ;
    Yo =1 ;
%     Zo = 1; %Gives the closest matching output
    X = r * 0.490 + g * 0.310 + b * 0.200;
    Y = r * 0.177 + g * 0.813 + b * 0.011;
    Z = r * 0.000 + g * 0.010 + b * 0.990; 
    
    index=find((Y/Yo)<=(6/29)^3);
    L(index) = ((29/3)^3).*(Y(index)./Yo);
    index=find((Y/Yo)>(6/29)^3);
    L(index)= 116 * ((Y(index)./Yo).^(1/3)) - 16;
    L=reshape(L,size(r));
    ud = 4*X./(X+15*Y+3*Z);
    vd = 9*Y./(X+15*Y+3*Z);
    U = 13 * L.*(ud - 0.2009);
    V = 13 * L.* (vd - 0.4610);
    
    LUV(:,:,1)=L;
    LUV(:,:,2)=U;
    LUV(:,:,3)=V;

end