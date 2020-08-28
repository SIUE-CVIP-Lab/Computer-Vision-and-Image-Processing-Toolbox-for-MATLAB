function [ outImage ] = gamma_noise_cvip( inImage, gammaArgs, noiseImgSize)
% GAMMA_NOISE_CVIP -  Add Gamma noise to an image.
% The function adds Gamma noise to an image or creates Gamma noise
% image.If user wants to add Gamma noise to the image,the user needs
% to pass only two input arguments(input image, and Gamma noise 
% argument).The Gamma noise argument consists of alpha and variance 
% value.If user wants to create a Gamma noise image only, pass input 
% image as an empty matrix []. And, the size of the noise image can be 
% defined by passing additional parameter (size of noise image).If not
% passed, default size of 256*256 will be selected. 
%
% Syntax :
% -------
% outImage = gamma_noise_cvip(inImage, gammagArgs, noiseImgSize)
%   
% Input Parameters include :
% -------------------------
%   'inImage'         1-band input image of MxN size or 3-band input image of   
%                     MxNx3 size. The input image can be of uint8 or uint16 
%                     or double class. 
%   'gammaArgs'       Gamma noise arguments.   
%                     gammaArgs(1): alpha value         (default 2)
%                     gammaArgs(2): variance value     (default 100)
%   'noiseImgSize'    Size of Gamma noise image. Only needed when noise
%                     is added to black image. 
%                     noiseImgSize(1): height              (default 256)
%                     noiseImgSize(2): width               (default 256)
%
%
% Output Parameter include :  
% ------------------------
%   'outImage'        Gamma noise added image or Gamma noise image 
%                                         
%
% Example :
% -------
%                   I = imread('butterfly.tif');      %original image
%                   O1 = gamma_noise_cvip(I);         %default parameters  
%                   figure;imshow(remap_cvip(O1,[]));
%                   noise_parameter = [20 100];       %alpha = 3, variance = 200
%                   %Gamma noise added image
%                   O2 = gamma_noise_cvip(I,noise_parameter);
%                   %Gamma noise image
%                   image_size = [300 400];        %height = 300, width = 400
%                   figure;imshow(remap_cvip(O2,[]));
%                   O3 = gamma_noise_cvip([],noise_parameter, image_size);               
%                   figure;imshow(O3,[]);
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

default_gammaArgs = [2 100]; %default alpha and variance
default_noiseImgSize = [256 256];  %default size of black image

%set up the default parameters
if nargin == 1                   
    gammaArgs = default_gammaArgs;
    noiseImgSize = default_noiseImgSize;
          
elseif nargin == 2               
    
    if isempty(gammaArgs)      %check enough elements in input argument #2
        gammaArgs = default_gammaArgs;
    elseif length(gammaArgs)==1
        gammaArgs = [gammaArgs default_gammaArgs(2)];
    elseif length(gammaArgs)> 2
        gammaArgs = gammaArgs(1:2);
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
    if isempty(gammaArgs)      
        gammaArgs = default_gammaArgs;
    elseif length(gammaArgs)==1
        gammaArgs = [gammaArgs default_gammaArgs(2)];
    elseif length(gammaArgs)> 2
        gammaArgs = gammaArgs(1:2);
    end 
end

%check number of output arguments
if nargout ~= 1 && nargout ~= 0
    error('Too many output arguments!');
end

alpha = gammaArgs(1);
var = gammaArgs(2);


%check if user wants black image
if isempty(inImage)      
    inImage = zeros(noiseImgSize);    
end 

%Gamma noise image
A = sqrt(var/alpha)/2;
gamma_noise = zeros(size(inImage));
for i = 1:alpha
    %generate uniformly distributed pseudo-random sequence
    PN1 = rand(size(inImage));  
    PN2 = rand(size(inImage));      
    noise = (-2)*A*log(1-PN1);
    theta = PN2*2*pi - pi;
    gamma_noise = gamma_noise + noise.*((cos(theta)).^2+(sin(theta)).^2);
end

outImage = double(inImage) + gamma_noise + 0.5;
end