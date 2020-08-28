function out_img = homomorphic_cvip(input_img, upper,  lower, cutoff)
% HOMOMORPHIC_CVIP -Homomorphic filtering is used to reduce the effect of
% illumination  variations in a scene while emphasizing the
% reflectance components.
% 
% Syntax :
% --------
% out_img = homomorphic_cvip(input_img, upper,  lower, cutoff)
%
% Description :
% -------------
%  The upper limit should be greater than 1;the lower limit should
%  be less than 1.Typical values range between 2.0 and 0.5.
%  The function has 5 steps
%   1- Natural Log
%   2- Fourier Transform
%   3- Filtering
%   4- Inverse Fourier
%   5- Inverse Log
%
% Input Parameters Include :
% -------------------------
%
%  'Input_img'   Input Image .
%
%  'Upper'         Upper limit has to be greater than 1.
%     
%  'Lower'         Lower limit has to be less than 1.
%
%  'cutoff'        Cutoff frequency.
%
%
% output Parameter Include :
% -------------------------
%
%  'Out_img'       Output Image.
%
% Example :
% ---------
%
%       Input_img = imread('butterfly.tif');
%       upper = 1.5;
%       lower = 0.5;
%       cutoff = 32;
%       outputImage = homomorphic_cvip(Input_img,upper,lower,cutoff);
%       figure;imshow(remap_cvip(outputImage,[]));
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
% 
%           Author:                Mehrdad Alvandipour
%           Initial coding date:    06/27/2017
%           Latest update date:     06/27/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%==========================================================================

[height, width, ~] = size(input_img);

%% 1- Natural Log
% input_img = condremap_cvip(input_img,[0 1],'double');
input_img = double(input_img);
input_img = log(1+input_img);

%% 2- Fourier
X = fft_cvip(input_img,[]);

%% 3- Filtering
c = upper - lower;
[m,n,d] = size(X);
H = butterworth_h_cvip( 'high', [m n] , 'center','', 6,cutoff );

H = c*H + lower;
X = X.*repmat(H,[1 1 d]);

%% 4- Inverse Fourier
X = ifft_cvip(X, []);
out_img = real(X);

%% 5- Inverse Log
out_img = exp(out_img);

%% prepare the output size
out_img = out_img(1:height,1:width,:);

end