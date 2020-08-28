function spect = fft_cvip( input_img, block_size )
% FFT_CVIP - performs fast Fourier transform.Fourier transform decomposes a
% complex signal in to a weighted sum of a zero frequency term and sinusolidal terms,
% the basis functions,where each sinusolidal is a harmonic of the fundamental.
% The fundamental is the basis or lowest frequency and the harmonics are frequency multiples of the fundamental.
% The fundamental is also called first harmonic.Original signal can be recreated by adding fundamental and all harmonics,
% with each term weighted by its corresponding transform coefficient. 
%   
% Syntax:
% -------
% spect = fft_cvip( input_img, block_size )
%   
% Input Parameters include:
% -------------------------
%
%   'input_img'       The orignial image which can be grayscale or RGB.
%
%   'block_size'      Should be a power of 2 or []. if empty, then functions
%                     finds the nearest power of 2 and zero pad the image, to
%                     that block size. Any other value smaller than image
%                     size will partiotion the image to windows of that block
%                     size and FT will be calculated separately in each
%                     window.
%
% Output Parameters include :
% -------------------------
%
%     'Spect'         The fourier transform of the input image.
%                   
%
%
% Example :
% -------
%                     input_img = input_image();
%                     block_size = [];
%                     spect = fft_cvip( input_img, block_size );
%                     S2 = logremap_cvip(abs(spect)); % use abs to compute the magnitude (handling imaginary) and use log to brighten display                    
%                     figure; imshow(input_img,[]); title('Input Image')
%                     figure; imshow(S2,[]); title('FFT Output Image')
%                  
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

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
%
 % Revision 1.2  04/23/2019  16:11:53  sbista, maslan
 % Replace the padarray functions that belong to the Image processing toolbox
 % for the padarray_cvip CVIP toolbox function
%
 % Revision 1.1  05/29/2017  16:33:22  malvan
 % Initial coding:
 % function writting and testing.
%  

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

input_img = padarray_cvip(input_img,M,N); %pad input image with zeros

spect = zeros(size(input_img));

if block_size % if user has given a block size, we need a loop to go through  all the windows
    [m,n,~] = size(input_img);
    for i=1:(m/block_size)
        for j=1:(n/block_size)
            is_ind = block_size*(i-1) + 1;
            ie_ind = block_size*i;
            js_ind = block_size*(j-1) + 1;
            je_ind = block_size*j;
            spect(is_ind:ie_ind,js_ind:je_ind,:) = fftshift(fft2(input_img(is_ind:ie_ind,js_ind:je_ind,:)));
%             Y = fftshift(X)
        end
    end
else    %  if block size is 0 at this line, it means block size was give [] or 0 by the user, so there is only one window to comput fft.
    spect = fftshift(fft2(input_img));
end

% siz = 2.^nextpow2([m n]);

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