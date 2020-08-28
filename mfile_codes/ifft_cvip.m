function img = ifft_cvip( input_spect, block_size )
% FFT_CVIP - perform inverse fast fourier transform.
%
% SYNTAX :
% ------
% img = ifft_cvip(spect,block_size)
%
% Description :
% -----------
%
% Initially fft has to be performed on the input image then that image will
% be input for performing inverse fft transform and the block size has to
% be same as considered for fft while doing inverse fft.
% 
% Input parameters include :
% ------------------------
%
%  'input_Image'    The orignial image which can be grayscale or RGB.
%
%  
%  'block_size'     Should be a power of 2 or [].if empty,then functions
%                   finds the nearest power of 2 and zero pad the image,to
%                   that block size.Any other value smaller than image
%                   size will partiotion the image to windows of that block
%                   size and FT will be calculated separately in each
%                   window. 
%
%  'Spect'         The fourier transform of the input image.
%
% Output parameters include :
% -------------------------
%
%  'I_hat'   Output image after inverse fft. 
%
% Example :
% ---------
%         I = imread('butterfly.tif');
%         spect = fft_cvip( I,[] );
%         I_hat = ifft_cvip( spect,[] );   % the inverse transform
%         figure;imshow(I);title('Input Image');
%         figure;imshow(remap_cvip(log(1+abs(spect))));title('ffT output Image');
%         figure; imshow(hist_stretch_cvip(I_hat,0,1,0,0));title(' output image after Ifft transform');
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
% 
%           Author:                Mehrdad Alvandipour
%           Initial coding date:    06/27/2017
%           Latest update date:     06/27/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
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
                img(is_ind:ie_ind,js_ind:je_ind,:) = real ( ifft2 ( ifftshift(input_spect(is_ind:ie_ind,js_ind:je_ind,:)) ) );
    %             Y = fftshift(X)
            end
        end
    else    % 0 block_size means, input_spect contains only one fourier window, thus the inverse transform is straightforward.
        img = ifftshift(input_spect);
        img = real(ifft2(img));
    end

end

