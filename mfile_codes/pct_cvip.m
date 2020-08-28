function [PCT,E,e] = pct_cvip(varargin)
% PCT_CVIP - performs the pricipal component transform in RGB space.
%
% Syntax :
% ------
% [outputImage,EigenVector,EigenValues] = pct_cvip(inputImage);
%       
%  'InputImage'      -       RGB Image
%   
%  Note: Mandatory output arguments: outputImage and EigenVector
%         Optional output arguments: EigenValues 
%
%   To view the 8-bit image of type double, divide by 255.
%   To view the 16-bit image of type double, divide by 65535.
% 
% Example :
% -------
%   Converts the RGB color value to PCT color value:
%
%                    X = imread('Car.bmp');
%                   [S1 E e] = pct_cvip(X);
%                   figure;imshow(X,[]);
%                   figure;imshow(S1,[]);
%
%   See also, ipct_cvip
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

%----------  Input/Output Argument Check -----------------------------------------
    if nargin<1,
        error('Too few arguments for pct_cvip');
    elseif nargin>1,
        error('Too many arguments for pct_cvip');
    end;    
    if nargout<2,
        error('Too few output arguments for pct_cvip');
    elseif nargout>3,
        error('Too many output arguments for pct_cvip');
    end;   
%--------- RGB Image Input Check -----------------------------------
    if size(varargin{1},3)~=3
        error('Invalid Image Input: Requires Color(RGB) Image');
    end;    
%--------- Data Type Check and Conversion ---------------------------    
    if ~isa(varargin{1},'double')
        varargin{1}=double(varargin{1});
    end;    
%---------- RGB to PCT Conversion ------------------------------
        r=varargin{1}(:,:,1); %r band
        g=varargin{1}(:,:,2); %g band
        b=varargin{1}(:,:,3); %b band
        p = size(r,1)*size(r,2);
%----------red mean, green mean and blue mean--------------------
        mr = sum(sum(r))/p;
        mg = sum(sum(g))/p;
        mb = sum(sum(b))/p;
%         mr = mean2(r); Cannot use mean2 (Image processing toolbox function)
%         mg = mean2(g);
%         mb = mean2(b);            
%Autocovariance terms of covariance matrix
        Crr = sum(sum((r-mr).^2))/p;
        Cgg = sum(sum((g-mg).^2))/p;
        Cbb = sum(sum((b-mb).^2))/p;
%Cross-covariance terms of covariance matrix
        Cgr = sum(sum((g-mg).*(r-mr)))/p;
        Cbr = sum(sum((b-mb).*(r-mr)))/p;
        Cbg = sum(sum((b-mb).*(g-mg)))/p;
%Covariance matrix
        COVrgb = [Crr Cgr Cbr;Cgr Cgg Cbg;Cbr Cbg Cbb];
%EigenVector and EigenValues (E and e)
        [E,e] = eigs(COVrgb);
        E = E';        
%Components of PCT
        P = r*E(1,1)+g*E(1,2)+b*E(1,3);
        C = r*E(2,1)+g*E(2,2)+b*E(2,3);
        T = r*E(3,1)+g*E(3,2)+b*E(3,3);
%assembleing individual component into PCT
        PCT(:,:,1)=P;
        PCT(:,:,2)=C;
        PCT(:,:,3)=T;
        
end
