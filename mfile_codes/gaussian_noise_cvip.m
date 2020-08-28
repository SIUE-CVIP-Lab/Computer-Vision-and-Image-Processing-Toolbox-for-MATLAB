function [ outImage ] = gaussian_noise_cvip( inImage, gaussianArgs, noiseImgSize)
% GAUSSIAN_NOISE_CVIP - Add Gaussian noise to an image.
% The function adds Gaussian noise to an image or creates Gaussian noise
% image.If user wants to add Gaussian noise to the image, the user needs
% to pass only two input arguments (input image, and gaussian noise 
% arguments).The gaussian noise arguments consists of mean and variance 
% value.If user wants to create a Gaussian noise image only, pass input 
% image as an empty matrix [].And, the size of the noise image can be 
% defined by passing additional parameter (size of noise image).If not
% passed, default size of 256*256 will be selected.
%
% Syntax :
% -------
% outImage = gaussian_noise_cvip(inImage, gaussiangArgs, noiseImgSize)
%    
% Input Parameters include :
% -------------------------
%  'inImage'        1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. The input image can be of uint8 or uint16 
%                   or double class. 
%  'gaussianArgs'   Gaussian noise arguments.   
%                   gaussianArgs(1): mean value         (default 0)
%                   gaussianArgs(2): variance value     (default 100)
%  'noiseImgSize'   Size of Gaussian noise image. Only needed when noise
%                   is added to black image. 
%                   noiseImgSize(1): height              (default 256)
%                   noiseImgSize(2): width               (default 256)
%
%
% Output Parameter includes:  
% --------------------------
%     'outImage'       Gaussian noise added image or Gaussian noise image 
%                                         
%
% Example :
% -------
%                   I = imread('butterfly.tif');      %original image
%                   O1 = gaussian_noise_cvip(I);      %default parameters  
%                   figure;imshow(remap_cvip(O1,[]));
%                   noise_parameter = [20 100];       %mean = 20, variance = 100
%                   %Gaussian noise added image
%                   O2 = gaussian_noise_cvip(I,noise_parameter);
%                   figure;imshow(remap_cvip(O2,[]));
%                   %Gaussian noise image
%                   image_size = [300 400];        %height = 300, width = 400
%                   O3 = gaussian_noise_cvip([],noise_parameter, image_size);               
%                   figure;imshow(remap_cvip(O3,[]));
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
if nargin ~=1 && nargin ~= 2 && nargin ~= 3 && nargin ~= 4 
    error('Too many or too few input arguments!');
end

%check number of output arguments
if nargout ~= 1 && nargout ~= 0
    error('Too many output arguments!');
end


default_gaussianArgs = [0 100]; %default mean and variance
default_noiseImgSize = [256 256];  %default size of black image

%set up the default parameters
if nargin == 1                   
    gaussianArgs = default_gaussianArgs;
    noiseImgSize = default_noiseImgSize;     
elseif nargin == 2               
    if isempty(gaussianArgs)      
        gaussianArgs = default_gaussianArgs;
    elseif length(gaussianArgs)==1
        gaussianArgs = [gaussianArgs default_gaussianArgs(2)];
    elseif length(gaussianArgs)> 2
        gaussianArgs = gaussianArgs(1:2);
    end    
elseif nargin == 3      
    if isempty(noiseImgSize) 
        noiseImgSize = default_noiseImgSize;
    elseif length(noiseImgSize)==1
        noiseImgSize = [noiseImgSize default_noiseImgSize(2)];
    elseif length(noiseImgSize)> 2
        noiseImgSize = noiseImgSize(1:2);
    end           
    %check enough elements in input argument #2
    if isempty(gaussianArgs)      
        gaussianArgs = default_gaussianArgs;
    elseif length(gaussianArgs)==1
        gaussianArgs = [gaussianArgs default_gaussianArgs(2)];
    elseif length(gaussianArgs)> 2
        gaussianArgs = gaussianArgs(1:2);
    end 
end

mean = gaussianArgs(1);
var = gaussianArgs(2);

%check if user wants black image
if isempty(inImage)      
    inImage = zeros(noiseImgSize);    
end 

%Gaussian white noise image
%first, generate uniformly distributed pseudo random sequences PN1 and PN2
PN1 = rand(size(inImage));
PN2 = rand(size(inImage));
noise = sqrt((-2)*var*log(1-PN1));
theta = PN2*2*pi-pi;
noise = noise.*cos(theta);
gaussian_noise = noise+mean+0.5;

%add gaussian noise image to input image (or black image)
outImage = double(inImage) + gaussian_noise;

end