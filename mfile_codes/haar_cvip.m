function spect = haar_cvip( input_img, block_size )
% HAAR_CVIP -perform forward Haar transform
%
% Syntax :
% -------
% spect = haar_cvip( input_img, block_size )
%   
% Input Parameters include:
% ------------------------
%  'input_img'     The orignial image which can be grayscale or RGB.
%
%  'block_size'    Should be a power of 2 or []. if empty, then functions
%                  finds the nearest power of 2 and zero pad the image, to
%                  that block size. Any other value smaller than image
%                  size will partiotion the image to windows of that block
%                  size and FT will be calculated separately in each
%                  window.
%
%
%
% Output Parameters include:  
% -------------------------
%  'Spect'         The haar transform of the input image.
%                   
%
% Example :
% -------
%                 I = imread('car.bmp');
%                 spect = haar_cvip( I,[] );
%                 S2=log(1+abs(spect)); % use abs to compute the magnitude (handling imaginary) and use log to brighten display
%                 S2 = remap_cvip(S2);
%                 figure; imshow(S2);
%                  
%
% Reference
% --------- 
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    05/29/2017
%           Updated by:             Sujata Bista
%                                   Murat Aslan
%           Latest update date:     04/23/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
 % Revision 1.2  04/23/2019  17:33:53  sbista, maslan
 % Replace the padarray functions that belong to the Image processing toolbox
 % for the padarray_cvip CVIP toolbox function
%
 % Revision 1.1  05/29/2017  16:33:22  malvan
 % Initial coding:
 % function writting and testing.
%      



input_img = double(input_img);

[m,n,~] = size(input_img);
if ~isempty(block_size)     % block size given by the user. ---> multiple windows for fft computation
    
    [F,~] = log2(block_size);
    if F~=.5
        error('block size should be a power of 2');
    end
    siz = padd_siz_cvip([m n],block_size); % To fit windows of size block_size to input_img, it needs to have the size M,N computed below
    M = siz(1);
    N = siz(2);
else    % block size is determined by size of the image. --> one window to comput fft
    block_size = 0;
    siz = 2.^nextpow2([m n]);   % find the next power of 2 greater than m,n to zeropad the input_img.
    M = siz(1);
    N = siz(2);
end
input_img = padarray_cvip(input_img, M, N);

spect = zeros(size(input_img));

if block_size % if user has given a block size, we need a loop to go through  all the windows
    [m,n,~] = size(input_img);
    for i=1:(m/block_size)
        for j=1:(n/block_size)
            is_ind = block_size*(i-1) + 1;
            ie_ind = block_size*i;
            js_ind = block_size*(j-1) + 1;
            je_ind = block_size*j;
            spect(is_ind:ie_ind,js_ind:je_ind,:) = haar2d_cvip(input_img(is_ind:ie_ind,js_ind:je_ind,:));
        end
    end
else    %  if block size is 0 at this line, it means block size was give [] or 0 by the user, so there is only one window to comput fft.
    spect = haar2d_cvip(input_img);
end


end




function y = haar2d_cvip(x)

d = size(x,3);
y = zeros(size(x));
for i=1:d
    A = haar1d_cvip(x(:,:,i));      % Transform each row
    y(:,:,i) = haar1d_cvip(A.').';  % Transform each column of the result
end

end


function out_sig = haar1d_cvip( x )
%HAAR1D_CVIP Summary of this function goes here
%   Detailed explanation goes here
%
%





% if isempty(n)
%     n=
[~,n,~] = size(x);

if n == 2
    out_sig = [(x(:,1) + x(:,2))/ sqrt(2)  (x(:,1) - x(:,2))/sqrt(2)];
else
    a = x(:,1:2: (n-1));
    b = x(:,2:2:n);

    sum_new = (a+b)/sqrt(2);
    diff_new = (a-b)/sqrt(2);

    a_new = haar1d_cvip(sum_new);
    out_sig = [a_new, diff_new];
end

end



function Ap = padd_siz_cvip(A,block_size)       % a helper function to return the desired size of the image for the given block_size.
    Ap = A;
    for i=1:length(A)
       x = A(i);
       if mod(x,block_size) ~= 0
           Ap(i) = ceil(x/block_size)*block_size;
       end
      
    end
end
