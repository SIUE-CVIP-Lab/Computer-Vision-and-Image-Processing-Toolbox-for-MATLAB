function lumAvg = lum_average_cvip(inputImage)
% LUM_AVERAGE_CVIP- Creates a gray-scale image from a color image.
%
%  Performs an  RGB to luminance  transform  according  to  the formula
%           P = (band1 + band2 + band3)/3
% 
% Syntax :
% -------
% OutputImage = lum_average_cvip(InputImage)
%       
% Input parameter include :
% ------------------------
%  'InputImage'              RGB Image (color image)
%   
%
%   To view the 8-bit image of type double, divide by 255.
%   To view the 16-bit image of type double, divide by 65535.
% 
% Example :
% -------
%   Converts the RGB color image to gray scale image:
%
%                   X = imread('Car.bmp');
%                   S1 = lum_average_cvip(X);
%                   figure;imshow(X,[]);
%                   figure;imshow(S1,[]);
%
%   See also, luminance_cvip 
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

% Checking number of input arguments    
    if nargin<1,
        error('Too few arguements for lum_average_cvip');
    elseif nargin>1,
        error('Too many arguements for lum_average_cvip');
    end;
%--------- RGB Image Input Check -----------------------------------    
    if size(inputImage,3)~=3
        error('Invalid Image Input: Requires 3 band Image');
    end;
%----------------------------------------------------------------
% Checking data type of input image and converting to type double if
% necessary    
    if ~isa(inputImage,'double')
        ipImage=double(inputImage);
    else
        ipImage = inputImage;
    end
%-------Luminance average logic-----------------------------------------
    lumAvg = floor((ipImage(:,:,1)+ ipImage(:,:,2)+ipImage(:,:,3))/3);

%----------Logic to support different input image type    
    if isa(inputImage,'uint8')
        lumAvg = uint8(lumAvg);
    elseif isa(inputImage,'uint16')
        lumAvg = uint16(lumAvg);
    elseif isa(inputImage,'double')
        lumAvg = double(lumAvg);
    elseif isa(inputImage,'single')
        lumAvg = single(lumAvg);
    end
end

