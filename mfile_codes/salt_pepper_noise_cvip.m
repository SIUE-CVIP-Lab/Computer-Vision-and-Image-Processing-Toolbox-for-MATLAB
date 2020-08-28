function [ outImage ] = salt_pepper_noise_cvip( inImage, noiseArgs, noiseImgSize)
% SALT_PEPPER_NOISE_CVIP - add speckle(Salt & Pepper) noise to an image.
% The function adds Salt & Pepper noise to an image or creates Salt & 
% Pepper noise image.If user wants to add Salt & Pepper noise to the 
% image, the user needs to pass only two input arguments (input image, 
% and Salt & Pepper noise arguments).The Salt & Pepper noise arguments 
% consists of mean and variance value.If user wants to create a Salt & 
% Pepper noise image only, pass input image as an empty matrix [].And, 
% the size of the noise image can be defined by passing additional 
% parameter (size of noise image).If not passed, default size of 256*256
% will be selected. 
%
% Syntax :
% ------
% outImage = salt_pepper_noise_cvip(inImage, noiseArgs, noiseImgSize)
%   
% 
% Input Parameters include:
% -------------------------
%   'inImage'       1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. The input image can be of uint8 or uint16 
%                   or double class. 
%   'noiseArgs'     Salt & Pepper noise arguments.   
%                   noiseArgs(1): Probability of Salt       (default 0.03)
%                   noiseArgs(2): Probability of Pepper     (default 0.03)
%   'noiseImgSize'  Size of Salt & Pepper noise image. Only needed when noise
%                   is added to black image. 
%                   noiseImgSize(1): height              (default 256)
%                   noiseImgSize(2): width               (default 256)
%
%
% Output Parameter includes:  
% --------------------------
%   'outImage'      Salt & Pepper noise added image or Salt & Pepper noise image 
%                                         
%
% Example :
% -------
%                   I = imread('butterfly.tif');        %original image
%                   O1 = salt_pepper_noise_cvip(I);           %default parameters  
%                   noise_parameter = [0.03 0.2];       %Prob. of Salt = 0.03, Prob. of Pepper = 0
%                   figure;imshow( O1,[]);
%                   % Salt & Pepper noise added image
%                   O2 = salt_pepper_noise_cvip(I,noise_parameter);
%                   figure;imshow( O2,[]);
%                   % Salt noise image
%                   image_size = [300 400];             %height = 300, width = 400
%                   noise_parameter = [0.03 0];
%                   O3 = salt_pepper_noise_cvip([],noise_parameter, image_size);  
%                   figure;imshow( O3,[]);
%                   % Pepper noise image
%                   noise_parameter = [0 0.02];
%                   O4 = salt_pepper_noise_cvip(ones(image_size)*255,noise_parameter);   
%                   figure;imshow( O4,[]);
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    4/10/2017
%           Latest update date:     4/20/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================


%check number of input arguments
if nargin ~=1 && nargin ~= 2 && nargin ~= 3 
    error('Too many or too few input arguments!');
end
if nargout ~=1 && nargout ~=0
    error('Too many or too few output arguments!');
end

default_noiseArgs = [0.03 0.03]; %default Prob. of Salt and Prob. of pepper
default_noiseImgSize = [256 256];  %default size of black image

%set up the default parameters
if nargin == 1                  
    noiseArgs = default_noiseArgs;  
elseif nargin == 2         
    noiseImgSize = default_noiseImgSize;
elseif nargin == 3  
    if isempty(noiseImgSize) %check enough elements in input argument #3
        noiseImgSize = default_noiseImgSize;
    elseif length(noiseImgSize) == 1
        noiseImgSize = [noiseImgSize default_noiseImgSize(2)];
    elseif length(noiseImgSize)> 2
        noiseImgSize = noiseImgSize(1:2);
    end               
end

%check if input argument #2 is empty or not numeric
if isempty(noiseArgs) || ~isnumeric(noiseArgs)      
    noiseArgs = default_noiseArgs;
end 
%check if input argument #1 is empty or not numeric
if isempty(inImage)      
    inImage = uint8(zeros(noiseImgSize));    
end 

%check number of output arguments
if nargout ~= 1 && nargout ~= 0
    error('Too many output arguments!');
end

%check for the valid probability values
if (noiseArgs(1)+noiseArgs(2) - 1) > 0.000001
    error('Invalid probability values');
end

%setup salt & pepper noise probabilities to use
ps = 1-noiseArgs(1);
pp = noiseArgs(2);

%find MIN and MAX value
if isa(inImage,'uint8')
    MIN = 0; MAX = 255;
elseif isa(inImage,'uint16')
    MIN = 0; MAX = 2^16-1;
elseif isa(inImage,'double')
    maxPixVal = max(inImage(:));
    if maxPixVal <=  1   %considering maximum number of bands = 3
        MAX = 1.0;
    elseif maxPixVal <= 255.0
        MAX = 255.0;
    else
        MAX = maxPixVal;
    end
    MIN = 0;
end

% generate Salt & Pepperly distributed pseudo-random sequences PN1 
PN = rand(size(inImage)); 
outImage = double(inImage);
outImage(PN >= ps) = MAX;
outImage(PN < pp) = MIN;

%change class of ouputImage  (double class for other cases)
if isa(inImage,'uint8')
    outImage = uint8(outImage);
elseif isa(inImage,'uint16')
    outImage = uint16(outImage);
end

end