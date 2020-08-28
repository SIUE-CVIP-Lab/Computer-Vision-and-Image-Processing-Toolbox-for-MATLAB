function [ img ] = iwalhad_cvip( input_spect, block_size )
% IWALHAD_CVIP -perform inverse Walsh/Hadamard transform
%   
% Syntax :
% --------
% [ img ] = iwalhad_cvip( input_img, block_size )
%
% Input Parameters Include :
% ------------------------
%
%  'input_spect'   The Walsh/Hadamard spectrum of an image, 
%                   obtained by walhad_CVIP().
%
%  'block_size'    Should be a power of 2 or [].if empty,then functions
%                   finds the nearest power of 2 and zero pad the image,to
%                   that block size.Any other value smaller than image
%                   size will partiotion the image to windows of that block
%                   size and inverse WHT will be calculated separately in each
%                   window.
%                 
%
% Output Parameter  Include :
% -------------------------
%
%  'img'           The original image with the given spectrum.
%
% Example :
% --------
% 
%            input_img = imread('Butterfly.tif');
%            block_size = 4;
%            spect = walhad_cvip(input_img,block_size);
%            v = iwalhad_cvip(spect,block_size);
%            img = remap_cvip(v);
%            figure;imshow(input_img);title('Input Image');
%            figure;imshow(remap_cvip(log(1+abs(spect))),[]);title('Output Transformed Image');
%            figure;imshow(img,[]);title('Output  Inverse Transformed Image');
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    7/17/2017
%           Latest update date:     7/17/2017
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
                img(is_ind:ie_ind,js_ind:je_ind,:) = real ( iwalhad_2 ( input_spect(is_ind:ie_ind,js_ind:je_ind,:)) ) ;
    %             Y = fftshift(X)
            end
        end
    else    % 0 block_size means, input_spect contains only one fourier window, thus the inverse transform is straightforward.
%         img = ifftshift(input_spect);
        img = real(iwalhad_2(input_spect));
    end

end

function x = iwalhad_2(Y)
%   perform the inverse transform on each band.
%
%   In the inverse transform, we first take the inverse of columns,
%   and then take the inverse for each row of the result.

d = size(Y,3);
x = zeros(size(Y));
for i=1:d
    A = iwalhad1(Y(:,:,i).');   % first take the inverse of the columns
    x(:,:,i) = iwalhad1(A.');   % Then each row.
end
end

function X = iwalhad1(Y)
Y = double(Y);
[m,n] = size(Y);

%% basis
hadamardMatrix = hadamard(n);
HadIdx = 0:n-1;                          % Hadamard index
M = log2(n)+1;                           % Number of bits to represent the index
binHadIdx = fliplr(dec2bin(HadIdx,M))-'0'; % Bit reversing of the binary index
binSeqIdx = zeros(n,M-1);                  % Pre-allocate memory
for k = M:-1:2
    % Binary sequency index 
    binSeqIdx(:,k) = xor(binHadIdx(:,k),binHadIdx(:,k-1));
end
SeqIdx = binSeqIdx*pow2((M-1:-1:0)');    % Binary to integer sequency index
walshMatrix = hadamardMatrix(SeqIdx+1,:); % 1-based indexing

%%
X = zeros(m,n);
for i=1:m
    x = repmat(Y(i,:).',[1,n]);
    y = sum(x.*walshMatrix,1);
    X(i,:) = y/n;     % If each row in forward transform had (1/n) coeff, then here we don't have any coef.
end

end
