function Y = least_squares_filter_cvip(d,h,cutoff,limitGain,p,gamma)
% LEAST_SQUARES_FILTER_CVIP - performs the least squares restoration filtering.
%
% Syntax :
% ------
% Y = least_squares_filter_cvip(d,h,cutoff,limitGain,p,gamma)
%   
% Input Parameters include :
% -------------------------
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
%   'p'             Smoothness criterion function. 
% 
%   'gamma'         'gamma' in the generalized restorationequation. 
%
%
% Output Parameter include :  
% ------------------------
%
%   'Y'             The output image after restoration filtering.
% 
%
% Example :
% -------                                          
%                             d = imread('cam_noise.bmp');
%                             cutoff = 32;
%                             limitGain = 10;
%                             h = [2.250 4.500 2.250; 4.500 9.001 4.500; 2.250 4.500 2.250];                            
%                             gamma = 0.5;
%                             p = 1;
%                             Y =least_squares_filter_cvip(d,h,cutoff,limitGain,p,gamma);
%                             figure;imshow(d);title('Degraded Image');
%                             figure;imshow(remap_cvip(Y));title('Output Image');
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.
    
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

alpha = 0;

[m , n, o] = size(d);

%%%%%%%%%%%%%%%%%%% corrections for images with more than one band
if o>1
    h = repmat(h,[1 1 o]);
    p = repmat(p,[1 1 o]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

D = fft2(d,m,n);

%%%%%%%%%%%%%%%%%%%%%%%% Create R(u,v) %%%%%%%%%%%%%%%%%%%%%%%%%
H = fft2(h,m,n);    % change the size
Hstar = conj(H);
Hpower = Hstar.*H;

P = fft2(p,m,n);

Ppower = conj(P).*P;
Rgm = ( (Hstar./Hpower).^(alpha) ).* ( (Hstar./(Hpower + (gamma* ( Ppower)) ) ).^(1-alpha) );


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
