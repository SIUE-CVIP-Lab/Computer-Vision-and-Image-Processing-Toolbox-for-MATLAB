function mag = fft_mag_cvip( input_img, block_size )
% FFT_MAG_CVIP - extract magnitude of Fourier spectrum.
%
% Syntax :
% ------
% mag = fft_mag_cvip( input_img, block_size )
%   
% Input Parameters include :
% ------------------------
%
%   'input_img'     The orignial image which can be grayscale or RGB.
%
%   'block_size'    Should be a power of 2 or []. if empty, then functions
%                   finds the nearest power of 2 and zero pad the image, to
%                   that block size. Any other value smaller than image
%                   size will partiotion the image to windows of that block
%                   size and FT will be calculated separately in each
%                   window.
%
%
%
% Output Parameter include :
% ------------------------
%  
%  'mag'            Magnitude of FFT 
%                   
%
% Example :
% -------
%                     input_img = imread('Car.bmp');
%                     block_size = [];
%                     spect = fft_mag_cvip( input_img, block_size );
%                     S2=log(1+spect); 
%                     S2 = remap_cvip(S2);
%                     figure;imshow(S2,[]);
%                  
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    5/29/2017
%           Latest update date:     6/1/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

X = fft_cvip(input_img, block_size);
mag = abs(X);

end
