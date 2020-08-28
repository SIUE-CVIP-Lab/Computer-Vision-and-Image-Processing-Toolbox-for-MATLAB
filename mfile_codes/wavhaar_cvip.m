function [ out_mat ] = wavhaar_cvip( img,dec )
% WAVHAAR_CVIP - perform forward wavelet transform based on Haar wavelet.
%
% Syntax :
% ------
% out_mat = wavhaar_cvip( img, dec )
%   
% Input Parameters include :
% ------------------------
% 'img'           The orignial image which can be grayscale or RGB.
%
% 'dec'           The decomposition level.
%                 An integer greater than or equal to 1.
%
%
% Output Parameters include :
% ------------------------- 
%
% 'out_mat'       The wavelet transform of the image using Daubechies 4
%                 wavelet coefficients.
%                   
% Example :
% -------
%                      a = imread('butterfly.tif');
%                      dec = 2;
%                      w = wavhaar_cvip(a,dec);
%                      S = logremap_cvip(abs(w));    % log remap output
%                      figure;imshow(a);title('Input Image');
%                      % display tranform result
%                      figure;imshow(S,[]);title('Output Image');  
%
% Reference 
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    10/13/2016
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     07/17/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.3  07/17/2019  18:55:46  jucuell
 % zero pad function was replaced to zeropad at power of 2 and use the
 % padarray_cvip function
%
 % Revision 1.2  10/09/2018  10:53:56  jucuell
 % fixed outler and inner subimages transposed after performing the haar
 % transform by transposing again the result y. Update example with
 % logremap_cvip to use more toolbox functions.
%
 % Revision 1.1  10/13/2016  15:23:31  mehrdad
 % Initial coding and testing.
 % 
%

img = double(img);
img = padd_cvip(img);
[m,n,d] = size(img);
out_mat= zeros(m,n,d);
for band = 1:d
    x = img(:,:,band);
    for i=1:dec
        hor = one_level_wav(x);
        y = one_level_wav(hor.')';      %transpose result
        
        temp_m = m/(2^i);
        temp_n = n/(2^i);
        x = y(1:temp_m,1:temp_n);
        
        temp_m = (m/(2^(i-1)));
        temp_n = (n/(2^(i-1)));
        out_mat(1:temp_m,1:temp_n,band) = y ;
    end
end

end


function y = one_level_wav(x)
[~,n,~] = size(x);

if n == 2
    y = [(x(:,1) + x(:,2))/ sqrt(2)  (x(:,1) - x(:,2))/sqrt(2)];
else
    a = x(:,1:2: (n-1));
    b = x(:,2:2:n);

    sum_new = (a+b)/sqrt(2);
    diff_new = (a-b)/sqrt(2);


    y = [sum_new, diff_new];
end

end

function out_img_padd = padd_cvip(img)
[m,n,~] = size(img);

% if m > n
%     diff = m - n;
%     pad = zeros(m,diff,d);
%     out_img_padd = [img,pad];
% elseif n > m
%     diff = n - m;
%     pad = zeros(diff,n,d);
%     out_img_padd = [img;pad];
% else
%     %nopading
%     out_img_padd = img;
% end

%zero pad at power of 2
siz = 2.^nextpow2([m n]);   % find the next power of 2 greater than m,n to zeropad the input_img.
M = siz(1);
N = siz(2);
out_img_padd = padarray_cvip(img,M,N); %pad input image with zeros

end