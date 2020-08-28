function [ out_img ] = highfreqemphasis_cvip (input_img, filter_type, block_size,cutoff, alfa, keep_DC, order)
% HIGHFREQEMPHASIS_CVIP - Performs high frequency emphasis filtering.
% 
% syntax :
% --------
% [ out_img ] = highfreqemphasis_cvip (input_img, filter_type, block_size,cutoff, alfa, keep_DC,order)
%
% Description :
% ----------
%  High_frequency_emphasis performs a two-dimensional high frequency
%  emphasis filtering in transform domain on input image.It is implemented
%  by adding a constant to a butterworth high pass filter transfer
%  function.This preserves the low frequency components of the image and at
%  the same time,amplifies the high-frequency components.The result of this
%  process is better tonality in the final image. The  cut-off frequency 
%  and filter order <order> is for the butter worth high pass filter used 
%  in this high frequency emphasis filter.Experiment revealed that the 
%  constant alfa in the range of 1.0 to 2.0 yields good result.
%  If dc equals 1,the dc component will be retained,if it equals 0,
%  the dc compenent will be dropped.
%
% Input Parameters include :
% -------------------------
% 
%  'input_img'      Input Image
%  
%  'block_size'     desired block size.
%
%  'cutoff'         Cutoff frequency .
%
%  'Alfa'           a constant typically from 1.0 to 2.0.
%
%  'keep_DC'        'y'/'n' to keep or ignore
%
%  'order'          filter order,range has to be from 1 to 8.
%
%  'filter_type'    the type of filter, FFT, DCT, Walsh-Hadamard, Haar
%
% output Parameters include:
% -------------------------
%  'out_img'         Output image. 
%
% Example:
% -------
%
%      input_image =  imread('butterfly.tif');
%      filter_type = 'fft';
%      block_size = [];
%      cutoff = 128;
%      Alfa = 1.5;
%      keep_DC = 'y';
%      order = 5;
%      out_img  = highfreqemphasis_cvip (input_image, filter_type, block_size,cutoff, Alfa,keep_DC,order);
%      figure;imshow(remap_cvip(out_img,[]));
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    10/13/2016
%           Latest update date:     05/04/2020
%           Updated by:             Joey Olden
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

%modified to allow for more than just a fft transform
%the change was made to fit the parameters desired in the GUI

[height, width, ~] = size(input_img);

%% 1- Fourier
switch filter_type
    case 'FFT'
        X = fft_cvip(input_img,block_size);
        origin = 'center';
    case 'DCT'
        X = dct_cvip(input_img,block_size);
        origin = 'uppleft';
    case 'Walsh-Hadamard'
        X = walhad_cvip(input_img,block_size);
        origin = 'uppleft';
    case 'Haar'
        X = haar_cvip(input_img,block_size);
        origin = 'uppleft';
end

%% 2- Filtering
[m,n,d] = size(X);
H = butterworth_h_cvip( 'high', [m n] , origin, keep_DC,order, cutoff );
H = H + alfa;
X = X.*repmat(H,[1 1 d]);

%% 3- Inverse Fourier
switch filter_type
    case 'FFT'
        X = ifft_cvip(X, block_size);
    case 'DCT'
        X = idct_cvip(X, block_size);
    case 'Walsh-Hadamard'
        X = iwalhad_cvip(X, block_size);
    case 'Haar'
        X = ihaar_cvip(X, block_size);
end
out_img = real(X);

%% prepare the output size
out_img = out_img(1:height,1:width,:);

end

