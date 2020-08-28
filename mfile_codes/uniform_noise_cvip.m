function [ outImage ] = uniform_noise_cvip( inImage, noiseArgs, noiseImgSize)
% UNIFORM_NOISE_CVIP - Add Uniform noise to an image.
% The function adds Uniform noise to an image or creates Uniform noise
% image.If user wants to add Uniform noise to the image,the user needs
% to pass only two input arguments (input image,and Uniform noise 
% arguments).The Uniform noise arguments consists of mean and variance 
% value.If user wants to create a Uniform noise image only,pass input 
% image as an empty matrix [].And,the size of the noise image can be 
% defined by passing additional parameter (size of noise image).If not
% passed,default size of 256*256 will be selected. 
%
% Syntax :
% -------
% outImage = uniform_noise_cvip(inImage, noiseArgs, noiseImgSize)
%   
% 
% Input Parameters include :
% -------------------------
%   'inImage'       1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. The input image can be of uint8 or uint16 
%                   or double class. 
%   'noiseArgs'   Uniform noise arguments.   
%                   uniformArgs(1): mean value         (default 0)
%                   uniformArgs(2): variance value     (default 100)
%   'noiseImgSize'  Size of Uniform noise image. Only needed when noise
%                   is added to black image. 
%                   noiseImgSize(1): height              (default 256)
%                   noiseImgSize(2): width               (default 256)
%
%
% Output Parameter include :  
% ------------------------
%   'outImage'      Uniform noise added image or Uniform noise image 
%                                         
%
% Example :
% -------
%                   I = imread('butterfly.tif');      %original image
%                   O1 = uniform_noise_cvip(I);       %default parameters  
%                   noise_parameter = [20 100];       %mean = 20, variance = 100
%                   % Uniform noise added image
%                   O2 = uniform_noise_cvip(I,noise_parameter);
%                   % Uniform noise image
%                   image_size = [300 400];        %height = 300, width = 400
%                   O3 = uniform_noise_cvip([],noise_parameter, image_size); 
%                   figure; imshow(remap_cvip(O1));             
%                   figure; imshow(remap_cvip(O2)); 
%                   figure; imshow(remap_cvip(O3)); 
%
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

%check number of output arguments
if nargout ~= 1 && nargout ~= 0
    error('Too many output arguments!');
end


default_noiseArgs = [0 100]; %default mean and variance
default_noiseImgSize = [256 256];  %default size of black image

%set up the default parameters
if nargin == 1                 
    noiseArgs = default_noiseArgs;
    noiseImgSize = default_noiseImgSize;         
elseif nargin == 2                 
    if isempty(noiseArgs)      %check enough elements in input argument #2
        noiseArgs = default_noiseArgs;
    elseif length(noiseArgs)==1
        noiseArgs = [noiseArgs default_noiseArgs(2)];
    elseif length(noiseArgs)> 2
        noiseArgs = noiseArgs(1:2);
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
    if isempty(noiseArgs)      
        noiseArgs = default_noiseArgs;
    elseif length(noiseArgs)==1
        noiseArgs = [noiseArgs default_noiseArgs(2)];
    elseif length(noiseArgs)> 2
        noiseArgs = noiseArgs(1:2);
    end 
end

mean = noiseArgs(1);
var = noiseArgs(2);

%check if user wants Noise image only
if isempty(inImage)      
    inImage = zeros(noiseImgSize);    
end 

%Uniform noise image
%find interval [a,b] for uniform distribution 
%where mean = (a+b)/2 and variance = (b-a)^2/12
b= mean + 0.5 *sqrt(var*12);              %
a= b-sqrt(12*var);
%generate uniformly distributed pseudo random sequence for interval [a,b] 
uniform_noise = a + (b-a)*rand(size(inImage));

%add uniform noise image to input image (or black image)
outImage = double(inImage) + uniform_noise;

end % end of function
