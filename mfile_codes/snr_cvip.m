function snr = snr_cvip(inimage1,inimage2)
% SNR_ERROR_CVIP - computes signal to noise ratio between two images.
% This is one of the commonly used objective measure in which we need to
% first define the error between an original or standard pixel value and
% the reconstructed pixel value as 
%      
%           error(r,c) = Iˆ(r,c) ? I(r,c)
%
% where
%    I(r,c) = the original or standard image.
%    Iˆ(r,c) = the reconstructed image.
%
%  we can define total error in an N*N reconstructed image as
%
%  
%
% Syntax :
% --------
% snr = snr_cvip(inimage1,inimage2)
%
% Input parameters include :
% ------------------------
%  'inimage1'     image of M*N size.
%  'inimage2'     image of M*N size.
%   
%   
% Output parameter include :
% ------------------------
%  'snr'        signal to noise ratio between two images.
% 
% Example :
% -------
%   inimage1 = imread('Butterfly.tif');
%   inimage2 = imread('castle.bmp');
%   snr = snr_cvip(inimage1,inimage2)
% 
%   see also, rms_error_cvip,peak_snr_cvip
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
% 
%           Author:                 Lakshmi Gorantla
%           Initial coding date:    06/27/2017
%           Latest update date:     06/27/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%
%==========================================================================
%
%

%changing the data type of input images to double
inimage1 = double(inimage1);
inimage2 = double(inimage2);

%finding the size of image 1 and image 2
[M1,N1,~]=size(inimage1);
[M2,N2,~]=size(inimage2);

%checking if size of both images are same
if M1 == M2 && N1 == N2
    %squaring of image1
    y = (inimage1).^2;
    %summing of image1
    temp1=sum(sum(y));
    %compute difference between two images
    diff = inimage1-inimage2;

    %squaring the difference
    diff = diff.^2;

    %sum the difference
    temp2 = sum(sum(diff));

    %computer SNR 
    snr = sqrt(temp1./temp2);
    
    %number of bands
    Band = size(snr,3);
    
    %converting D1*D2*D3 into column/row vector
    if Band == 3
        snr = [snr(:,:,1) snr(:,:,2) snr(:,:,3)];
    end
else 
    error('Images have different size!');
end

end