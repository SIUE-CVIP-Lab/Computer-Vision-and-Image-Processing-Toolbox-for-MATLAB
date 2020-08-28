function rgb = lab2rgb_cvip(varargin)
% LAB2RGB_CVIP -  Converts L* a* b* Color value to RGB Color value.
%
% Syntax :
%  ------
%   OutputImage = lab2rgb_cvip(InputImage, type)
%       
%   'InputImage'       L* a* b* color value Image.
%  
%    'type'             output image preference (0,1)
%                      (0 = Forward non normalized output)
%                      (1 = gives normalized output)   
%
%   To view the 8-bit image of type double, divide by 255.
%   To view the 16-bit image of type double, divide by 65535.
% 
% Example 1 :
% ----------
%   Converts the L* a* b* color value to RGB color value:
%
%                   X = imread('Car.bmp');
%                   S1 = rgb2lab_cvip(X,0);
%                   S2 = lab2rgb_cvip(S1,0);
%                   figure;imshow(X,[]);
%                   figure;imshow(S1,[]);
%                   figure;imshow(remap_cvip(S2,[]));
%
%   See also, rgb2sct_cvip, rgb2cct_cvip, rgb2hsl_cvip, rgb2hsv_cvip, 
%   rgb2lab_cvip, rgb2luv_cvip, rgb2xyz_cvip, pct_cvip, ipct_cvip, 
%   cct2rgb_cvip, hsl2rgb_cvip, hsv2rgb_cvip, sct2rgb_cvip, luv2rgb_cvip.
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
        error('Too few arguments for lab2rgb_cvip');
    elseif nargin>2,
        error('Too many arguments for lab2rgb_cvip');
    end;
    
%--------- RGB Image Input Check -----------------------------------
    if size(varargin{1},3)~=3
        error('Invalid Image Input: Requires 3 Band L* a* b* color value Image');
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
%     if ~isa(lab,'double')
%         lab=double(lab);
%     end
%-------Conversion form L*a*b* to RGB color value------------------------
    l=varargin{1}(:,:,1);
    a=varargin{1}(:,:,2);
    b=varargin{1}(:,:,3);
    Xo = 95.047/100 ;Yo =100.00/100 ;Zo = 108.883/100;
    delta = 6/29;
    
    t1=(((l+16)/116)+(a/500));
    index = find(t1>delta);
    finv1(index) = t1(index).^3;
    index = find(t1<=delta);
    finv1(index) = 3*delta^2*(t1(index)- (4/29));
    finv1 = reshape(finv1,size(l));
    x = Xo * finv1;
    
    t2 = (l+16)/116;
    index = find(t2>delta);
    finv2(index) = t2(index).^3;
    index = find(t2<=delta);
    finv2(index) = 3*delta^2*(t2(index)- (4/29));
    finv2 = reshape(finv2,size(l));
    y = Yo * finv2;
    
    t3 = (((l+16)/116)-(b/200));
    index = find(t3>delta);
    finv3(index) = t3(index).^3;
    index = find(t3<=delta);
    finv3(index) = 3*delta^2*(t3(index)- (4/29));
    finv3 = reshape(finv3,size(l));
    z = Zo * finv3;
    
    r = x * 2.3706743 + y * (-0.9000405) + z * (-0.4706338);
    g = x * (-0.5138850) + y * 1.4253036 + z * 0.0885814;
    b = x * 0.0052982 + y * (-0.0146949) + z * 1.0093968;
    
    rgb(:,:,1)=r;
    rgb(:,:,2)=g;
    rgb(:,:,3)=b;
    
   

end