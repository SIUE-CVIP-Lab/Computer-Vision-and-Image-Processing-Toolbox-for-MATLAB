function [ out_mat ] = iwavhaar_cvip( img,dec )
% IWAVHAAR_CVIP - perform inverse wavelet transform based on Haar wavelet.
%
% Syntax :
% -------
% [ out_mat ] = iwavhaar_cvip( img,dec )
%
% Input Parameters Include :
% ------------------------
%
%  'img'           The orignial image which can be grayscale or RGB.
%
%  'dec'           The decomposition level.
%                  An integer greater than or equal to 1.                  
%
% Output Parameter Include :
% -------------------------
%
%  'out_mat'       The wavelet transform of the image using Daubechies 4
%                   wavelet coefficients.     
% Example :
% ---------
%                         a = imread('butterfly.tif');
%                         b = double(a);
%                         dec = 2;
%                         w = wavhaar_cvip(b,dec);
%                         figure;imshow(a);title('Input Image');
%                         figure;imshow(remap_cvip(log(1+abs(w))),[]);title('Output Image');
%                         k = iwavhaar_cvip(w,dec);
%                         figure;imshow(remap_cvip(k),[]);
%
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    6/3/2017
%           Latest update date:     6/9/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

[~,~,d] = size(img);
out_mat = zeros(size(img));
for band=1:d
    x= img(:,:,band);
    [m,n,~] = size(x);
    m= m/ (2^(dec));
    n = n/ (2^(dec));

    for i=1:dec
        m = m*2;
        n = n*2;
        xx = x(1:m,1:n);
    %     hor = one_level_wav(x);
    %     y = one_level_wav(hor.').';
        ver = one_level_iwd(xx.');
        y = one_level_iwd(ver.');

        x(1:m,1:n) = y;


    end
    out_mat(:,:,band) = x;

end

end


function old = one_level_iwd(x)
[~,n,~] = size(x);


    siz = n;
    old = x;
    sum_old = old(:,1:siz/2);
    diff_old = old(:,siz/2 + 1:end);
    
    a = sqrt(2)*(sum_old + diff_old)/2;
    b = sqrt(2)*(sum_old - diff_old)/2;
    
    old(:,1:2:siz-1) = a;
    old(:,2:2:siz) = b;  

end