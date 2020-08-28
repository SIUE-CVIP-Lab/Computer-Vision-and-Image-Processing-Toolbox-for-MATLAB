function heq = histeq_cvip(varargin)
% HISTEQ_CVIP - Performs a histogram equalization on an input image
% Z = HISTEQ_CVIP(X, Band)This function performs a histogram equalization on an  input  
% image.Histogram equalization distributes the gray level values within an
% image as evenly as possible.The goal of histeq is a flat histogram.The 
% function works with color or grayscale images.With  a color image, 
% the user specifies band 0,1, or 2 as the band to use for histogram 
% calculations.For a grayscale image,specify band '0' or pass only
% image as input parameter.
%
% Syntax:
% -------
% heq = histeq_cvip(varargin)
% 
% Input Parameters include:
% ------------------------
%   'X'      Input Image
%   'Band'   Indicate which band (0,1, and 2) to operate on;
%
% NOTE: For gray-scale image use 0 band or pass only image as input
% parameter.
%
% Example 1 :
% ---------
%   Perform histogram equalization on input grayscale image:
%
%                   X = imread('Cam.bmp');
%                   S = histeq_cvip(X);
%                   figure;imshow(S,[]);
%
% Example 2 :
% ---------
%   Perform histogram equalization on a color image with user specified
%   band value
%
%                   X = imread('Car.bmp');
%                   S1 = histeq_cvip(X,0);
%                   S2 = histeq_cvip(X,1);
%                   S3 = histeq_cvip(X,2);
%                   figure;imshow(remap_cvip(S1),[]);
%                   figure;imshow(remap_cvip(S2),[]);
%                   figure;imshow(remap_cvip(S3),[]);
%
%
%   See also, get_hist_image_cvip, gray_linear_cvip, hist_create_cvip,
%   hist_spec_cvip, hist_shrink_cvip, hist_slide_cvip, hist_stretch_cvip,
%   local_hist_eq_cvip, unsharp_cvip
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
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     09/12/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.2  09/12/2018  16:48:22  jucuell
 % 255 pixels fixing by increasing no_bins = 256; Old comented code deleted
%
 % Revision 1.1  09/10/2018  16:45:28  jucuell
 % Initial revision: when equalizing images with pixels with 255 value, the
 % function returns 0 for that gray levels.
 % 
%

%---------- Argument Check -----------------------------------------
    if nargin<1
        error('Too few arguments for histogram equalization operation');
    elseif nargin>2
        error('Too many arguments for histogram equalization operation');
    end

%--------- Data Type Check and Conversion ---------------------------    
    if ~isa(varargin{1},'double')
        varargin{1}= double(varargin{1});
    end
%---------Logic to create histogram equalized image for color image-------    
    if nargin==2
        if (size(varargin{1},3)==3)
            r = varargin{1}(:,:,1);
            g = varargin{1}(:,:,2);
            b = varargin{1}(:,:,3);
            if (varargin{2}==0)
                rEq = double(createHeq(r));
                gEq1 = (rEq./(r+0.32)).*g;
                bEq1 = (rEq./(r+0.32)).*b;
                heq(:,:,1)=rEq;
                heq(:,:,2)=gEq1;
                heq(:,:,3)=bEq1;
            elseif (varargin{2}==1)
                gEq = double(createHeq(g));
                rEq1 = (gEq./(g+0.1425)).*r;
                bEq1 = (gEq./(g+0.1425)).*b;
                heq(:,:,1)=rEq1;
                heq(:,:,2)=gEq;
                heq(:,:,3)=bEq1;
            elseif (varargin{2}==2)
                bEq = double(createHeq(b));
                rEq1 = (bEq./(b+0.535)).*r;
                gEq1 = (bEq./(b+0.535)).*g;
                heq(:,:,1)=rEq1;
                heq(:,:,2)=gEq1;
                heq(:,:,3)=bEq;
            end
        else
            
            heq = createHeq(varargin{1});
        end
    else
        heq = createHeq(varargin{1});
    end
end

%-------Function to create histogram equalized image for single band image
function eq = createHeq(a)
    %--------- Data Type Check and Conversion ---------------------------    
    if ~isa(a,'double')
        a= double(a);
    end
    numOfPixels = numel(a); % Total number of pixels
    eq = uint8(zeros(size(a,1),size(a,2)));
    freq = zeros(256,1);
    probc = zeros(256,1);
    cum = zeros(256,1);
    output = zeros(256,1);
%---Scanning the image to get the frequency distribution of image pixels    
    for i=1:size(a,1)
        for j=1:size(a,2)
            value = a(i,j);
            freq(value+1) = freq(value+1) + 1; % Frequency
        end
    end
    sum = 0;
    no_bins = 256;              %number of bins == number of gray levels
    maxGray=max(max(max(a)));
%----Finiding the cumulative, normalized and output    
    for i = 1:size(freq)
        sum=sum+freq(i);  
        cum(i)=sum; % cumulative frequency
        probc(i)=cum(i)/numOfPixels; % Normalized Frequency
        output(i) = round(probc(i)*maxGray); %Hist Equalized pixel value
    end
    t=0:no_bins;
%----Mapping the original pixels to hist equalized pixel value
    for i=1:no_bins
                eq(a==t(i))=output(i);
    end
        eq = reshape(eq,size(a));    
end