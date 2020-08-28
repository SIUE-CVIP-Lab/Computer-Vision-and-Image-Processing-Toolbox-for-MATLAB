function err = rms_error_cvip(inimage1,inimage2)
% RMS_ERROR_CVIP - Calculates Root Mean Square error  between two images.
%
% Syntax :
% ------
% err = rms_error_cvip(inimage1,inimage2)
%
% Input parameters include :
% ------------------------
%  'inimage1'     image of M*N size.
%  'inimage2'     image of M*N size.
%   
%   
%  Inimage1 and Inimage2 both has to be of same size  and of same band in order to compute
%  rms error.If both inimage1 and inimage2 are same then rms error will be zero.
%
%   
% Output parameter include :
% ------------------------
%
%  'err'       Root mean square error between two images.
%
%
% Example :
% --------
%   inimage1 = imread('Butterfly.tif');
%   inimage2 = imread('castle.bmp');
%   err = rms_error_cvip(inimage1,inimage2)
%
%   see also, peak_snr_cvip,snr_error_cvip
%
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

%changing the data type of input images to double
inimage1 = double(inimage1);
inimage2 = double(inimage2);

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
    temp = sum(sum(diff));

    %computer rms error
    err = sqrt(temp/(M1*N1));
     %number of bands
    Band = size(err,3);
    
    %converting D1*D2*D3 into column/row vector
    if Band == 3
        err = [err(:,:,1) err(:,:,2) err(:,:,3)];
    end
    
else 
    error('Images have different size!');
end

end