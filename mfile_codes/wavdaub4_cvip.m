function out_mat = wavdaub4_cvip( img, dec )
% WAVDAUB4_CVIP- perform forward wavelet transform based on Daubechies wavelet.
%
% Syntax :
% ------
%  out_mat = wavdaub4_cvip( img, dec )
%   
% Input Parameters include :
% ------------------------
%
%   'img'           The orignial image which can be grayscale or RGB.
%
%   'dec'           The decomposition level.
%                   An integer greater than or equal to 1.
%
%
% Output parameters include :
% -------------------------
%
%   'out_mat'       The wavelet transform of the image using Daubechies 4
%                   wavelet coefficients.
%                   
%
%
% Example :
% -------
%                     a = imread('butterfly.tif');                     
%                     dec = 4;
%                     w = wavdaub4_cvip(a,dec);                   
%                     figure;imshow(remap_cvip(1+log(abs(w))));  % tranforms for display.
%                  
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    06/03/2017
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     07/17/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.2  07/17/2019  18:55:46  jucuell
 % zero pad function was replaced to zeropad at power of 2 and use the
 % padarray_cvip function
%
 % Revision 1.1  06/03/2017  15:23:31  mehrdad
 % Initial coding and testing.
 % 
%

img = double(img);
img = padd_cvip(img);
[m,n,d] = size(img);
out_mat= zeros(m,n,d);
if ~(mod(m,2)==0)
    img = padarray(img,[1 0],1,'post');
end
if ~(mod(n,2)==0)
    img = padarray(img,[0 1],1,'post');
end
[m1,n1,~] = size(img);
for band = 1:d
    x = img(:,:,band);
    for i=1:dec
        hor = one_level_wav(x);
        y = one_level_wav(hor.').';            
       if ~isequal(size(x,1),size(y,1))
           y = padarray(y,[1 0],0,'post');
       end
       if ~isequal(size(x,2),size(y,2))
           y = padarray(y,[0 1],0,'post');
       end
       
        x = y(round(1:m1/2^i),round(1:n1/2^i));
        out_mat(1:size(y,1),1:size(y,2),band) = y;
    end
end

end

function y = one_level_wav(x)
[~,n,~] = size(x);
p0 = (1+sqrt(3))/4;
p1 = (3+sqrt(3))/4;
p2 = (3-sqrt(3))/4;
p3 = (1-sqrt(3))/4;

    a = x(:,1:2: (n-1));
    b = x(:,2:2:n);
    c = [x(:,3:2:(n-1)) x(:,1)];
    d = [x(:,4:2:n) x(:,2)];

    sum_new = (p0*a + p1*b + p2*c + p3*d)/2;
    
    a = x(:,1:2: (n-1));
    b = x(:,2:2:n); 
    c = [ x(:,n) x(:,2:2:(n-2))]; 
    d = [x(:,n-1) x(:,1:2:n-3) ]; 
    diff_new = ( p1*a + (-p0)*b + (-p2)*c + p3*d )/2 ;

    y = [sum_new, diff_new];
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
%     out_img_padd = img;
% end

%zero pad at power of 2
siz = 2.^nextpow2([m n]);   % find the next power of 2 greater than m,n to zeropad the input_img.
M = siz(1);
N = siz(2);
out_img_padd = padarray_cvip(img,M,N); %pad input image with zeros

end