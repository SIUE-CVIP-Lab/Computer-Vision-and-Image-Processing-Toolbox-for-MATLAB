function psnr = peak_snr_cvip(inimage1,inimage2,L)
% PEAK_SNR_CVIP -computes peak signal to noise ratio between two images.
%
% Syntax :
% ------
%  psnr = peak_snr_cvip(inimage1,inimage2,L)
%
% Input parameters include :
% ------------------------
%  'inimage1'        image of M*N size.
%  'inimage2'        image of M*N size.
%  'L'               number of gray levels(e.g., for 8-bits L=256).
%  Inimage1 and Inimage2 both has to be of same size  and of same band in order to compute
%  Peak_snr.If both inimage1 and inimage2 are same then Peak_snr will be infinity.
% 
% Output parameter include :
% ------------------------
%  'Peak_snr'      Peak signal to noise ratio between two images.
%
% Example :
% -------
%
%   inimage1 = imread('Butterfly.tif');
%   inimage2 = imread('castle.bmp');
%     L      =  256;
%   psnr = peak_snr_cvip(inimage1,inimage2,L)
%
%
%   see also, rms_error_cvip,snr_error_cvip
%
%
% Reference
% ---------
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

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
L= double(L);

%finding the size of image 1 and image 2
[M1,N1,~]=size(inimage1);
[M2,N2,~]=size(inimage2);

%checking if size of both images are same
if M1 == M2 && N1 == N2
    %compute difference between two images
    diff = inimage1-inimage2;

    %squaring the difference
    diff = diff.^2;

    %sum the difference
    temp = (sum(sum(diff)));
    err = (temp/(M1*N1));
    
     L = (L-1)^2;

    %computer peak snr
    psnr =(10*log10((L)/(err)));
     %number of bands
    Band = size(psnr,3);
    
    %converting D1*D2*D3 into column/row vector
    if Band == 3
        psnr = [psnr(:,:,1) psnr(:,:,2) psnr(:,:,3)];
    end
    
else 
    error('Images have different size!');
end

end