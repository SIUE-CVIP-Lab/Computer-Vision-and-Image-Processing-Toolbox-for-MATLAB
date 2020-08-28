function Y = geometric_mean_xformfilter_cvip(d,h,cutoff,limitGain,noiseImage,originalImage,alpha,gamma)
% GEOMETRIC_MEAN_XFORMFILTER_CVIP - performs the geometric mean restoration filter.
%  
% Syntax :
% -------
% Y = geometric_mean_xformfilter_cvip(d,h,cutoff,limitGain,noiseImage,originalImage,alpha,gamma)
%   
% Input Parameters include:
% ------------------------
%
%   'd'             The degraded image. A single or multiband image.
%                                  
%   'h'             The degradation function. It can be single band.
%
%   'cutoff'        Cutoff frequency for filtering.
% 
%   'limitGain'     Sets the maximum gain using the DC value as a baseline.
%                   limitGain=1 --> DC value is the maximum gain.
%                   limitGain>1 --> DC_value*limitGain is the maximum gain.
% 
%   'noiseImage'    The noise image. It can be single band.
% 
%   'originalImage' The original image. A single or multiband image. The
%                   number of bands should match with the input 'd'.
% 
%   'alpha'         'alpha' in the  generalized  restoration  equation.
% 
%   'gamma'         'gamma' in the generalized restorationequation.
% 
%
% Output Parameter Include:  
% -------------------------
%
%   'Y'              output image after restoration filtering.
% 
%
% Example :
% -------
%           originalImage = imread('cam.bmp');
%           d   = imread('cam_noise.bmp');
%           h = [2.250 4.500 2.250; 4.500 9.001 4.500; 2.250 4.500 2.250]
%           noiseImage = imread('cam_noise.bmp');
%           cutoff = 32;
%           alpha = 0.5;
%           gamma = 0.5;
%           limitGain = 10;
%           Y =geometric_mean_xformfilter_cvip(d,h,cutoff,limitGain,noiseImage,originalImage,alpha,gamma);
%           figure;imshow(remap_cvip(Y));title('Output Image');
%
%
% Reference
%  ---------
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    10/13/2016
%           Latest update date:     10/19/2016
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================



% alpha = .5;
% gamma = .5;

[m , n, o] = size(d);



if o>size(h,3)
    h = repmat(h,[1 1 o]);
end

[~,~,noiseImageSize] = size(noiseImage);
if o>noiseImageSize
    noiseImage = repmat(noiseImage,[1 1 o]);
end



D = fft2(d,m,n);

%%%%%%%%%%%%%%%%%%%%%%%% Create R(u,v) %%%%%%%%%%%%%%%%%%%%%%%%%
H = fft2(h,m,n);    % change the size
Hstar = conj(H);
Hpower = Hstar.*H;

Im = fft2(originalImage,m,n);  %original image
N = fft2(noiseImage,m,n);    %noise

Sn = conj(N).*N;
SIm = conj(Im).*Im;

Rgm = ( (Hstar./Hpower).^(alpha) ).* ( (Hstar./(Hpower + (gamma* ( Sn./SIm)) ) ).^(1-alpha) );

% a = Rgm > 100*Rgm(1,1); % Limit gain of R to a multiple of
% Rgm(a) = 100*Rgm(1,1);  % the DC gain

%%%%%%%%%%%%%%%%%%%%% Limit gain of R to a multiple of the DC gain
M = Rgm;
for i=1:o
    bitPlane = Rgm(:,:,i);
    a = bitPlane > limitGain*bitPlane(1,1); 
    bitPlane(a) = limitGain*bitPlane(1,1);
    M(:,:,i) = bitPlane;
end
Rgm = M;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ihat = Rgm.*D;          % Apply R(u,v)

Ihat = myFilter2(Ihat,cutoff);  %low pass filter

Y = real(ifft2(Ihat));

end

function Y = myFilter2(X, cutoff)
    [m , n, o] = size(X);
    Y = zeros(m,n,o);
    [U, V] = dftuv(m, n);

    % Compute the distances D(U, V).
    D = sqrt(U.^2 + V.^2);

    H = double(D <=cutoff);
    for i=1:o
        Y(:,:,i) = H.*X(:,:,i);
    end
    
end

function [U, V] = dftuv(M, N)
%DFTUV Computes meshgrid frequency matrices.
%   [U, V] = DFTUV(M, N) computes meshgrid frequency matrices U and
%   V. U and V are useful for computing frequency-domain filter 
%   functions that can be used with DFTFILT.  U and V are both M-by-N.

% Set up range of variables.
u = 0:(M-1);
v = 0:(N-1);

% Compute the indices for use in meshgrid
idx = find(u > M/2);
u(idx) = u(idx) - M;
idy = find(v > N/2);
v(idy) = v(idy) - N;

% Compute the meshgrid arrays
[V, U] = meshgrid(v, u);
end