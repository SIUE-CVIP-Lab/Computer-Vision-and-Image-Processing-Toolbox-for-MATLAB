function img = ihaar_cvip( input_spect, block_size )
% IHAAR_CVIP - perform inverse Haar transform.
%
% Syntax :
% -------
% img = ihaar_cvip( input_spect, block_size )
%   
% Input Parameters include :
% ------------------------
%   'input_spect'   The image haar spectrum. This spectrum must be obtained
%                   by haar_cvip(). Also the same variable block_size that
%                   is used in forward transform should be used here.
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
%   'Spect'         The inverse haar transform of the input spectrum.
%                   
%
%
% Example :
% -------
%
%                 I = imread('car.bmp');
%                 spect = haar_cvip( I,[] );
%                 X=log(1+abs(spect)); % use abs to compute the magnitude (handling imaginary) and use log to brighten display
%                 X = remap_cvip(X);
%                 figure;imshow(I);title('Input image');
%                 figure;imshow(X);title('haar transform output')
%                 Output = ihaar_cvip(spect,[]);   % the inverse transform
%                 figure;imshow(hist_stretch_cvip(Output,0,1,0,0));title('Output Image after Inverse Haar Transform');
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
[m,n,~] = size(input_spect);

if ~isempty(block_size) && block_size ~= 0 % if block_size is given by the user and it is not 0, then it has to be a power of 2. Also the size of the spectrum should be a multiple of block_size.
    
    [F,~] = log2(block_size);
    if F~=.5
        error('block size should be a power of 2');
    end
    if mod(m, block_size) ~= 0 || mod(n, block_size) ~= 0
        error('The given block size does not match the size of the spectrum.');
    end
else        % block_size is 0 or emtpy, thus the given spectrum contains only one fourier window and its size is a power of 2.
    block_size = 0;
    siz = 2.^nextpow2([m n]);
    M = siz(1);
    N = siz(2);
    
    if M~=m || N~= n
        error('The spectrums created by fft_cvip() have heights and width that are power of 2. The given spectrum does not match this criteria.');
    end
end


    if block_size   % non-zero block_size, means we have multiple fourier window. To compute the inverse transform, we need for-loop.
        
        for i=1:(m/block_size)
            for j=1:(n/block_size)
                is_ind = block_size*(i-1) + 1;
                ie_ind = block_size*i;
                js_ind = block_size*(j-1) + 1;
                je_ind = block_size*j;
                img(is_ind:ie_ind,js_ind:je_ind,:) = real ( ihaar2d_cvip ( input_spect(is_ind:ie_ind,js_ind:je_ind,:)) ) ;
    %             Y = fftshift(X)
            end
        end
    else    % 0 block_size means, input_spect contains only one fourier window, thus the inverse transform is straightforward.
%         img = ifftshift(input_spect);
        img = real(ihaar2d_cvip(input_spect));
    end


end

function out_mat = ihaar2d_cvip(input_spect)

d = size(input_spect,3);
out_mat = zeros(size(input_spect));
for i=1:d
    A = ihaar1d_cvip(input_spect(:,:,i).');   % first take the inverse of the columns
    out_mat(:,:,i) = ihaar1d_cvip(A.');   % Then each row.
end

  
end

function out_sig = ihaar1d_cvip( x )
%IHAAR1D_CVIP Summary of this function goes here
%   Detailed explanation goes here
[~,n,~] = size(x);

p = log2(n);
for i=1:p
    siz = 2^i;
    old = x(:,1:siz);
    sum_old = old(:,1:siz/2);
    diff_old = old(:,siz/2 + 1:end);
    
    a = sqrt(2)*(sum_old + diff_old)/2;
    b = sqrt(2)*(sum_old - diff_old)/2;
    
    old(:,1:2:siz-1) = a;
    old(:,2:2:siz) = b;
    x = [old, x(:,siz+1:end)];
end
    

out_sig = x;

end
