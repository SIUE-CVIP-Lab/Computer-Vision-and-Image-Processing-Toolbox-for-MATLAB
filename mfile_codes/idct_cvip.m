function img = idct_cvip(input_spect,block_size)
% IDCT_CVIP - perform inverse discrete cosine transform
% 
% Syntax :
% --------
% img = idct_cvip( input_spect, block_size )
%   
% Input  Parameters include :
% -------------------------
%   'input_spect'   The DCT spectrum of an image. This spectrum must be obtained
%                   by dct_cvip(). Also the same variable block_size that
%                   is used in forward transform should be used here.
%
%   'block_size'    Should be a power of 2 or []. if empty, then functions
%                   finds the nearest power of 2 and zero pad the image, to
%                   that block size. Any other value smaller than image
%                   size will partiotion the image to windows of that block
%                   size and DCT will be calculated separately in each
%                   window.
%
%
%
% Output Parameter include : 
% ------------------------
%
%   'Spect'         The inverse fourier transform of the input spectrum.
%                   
%
%
% Example :
% -------
%                 I = imread('butterfly.tif');
%                 spect = dct_cvip( I,[] );
%                 I_hat = idct_cvip( spect,[] );   % the inverse transform
%                 figure;imshow(I);title('Input Image');
%                 figure;imshow(remap_cvip(log(1+abs(spect))));title('DCT output Image');
%                 figure; imshow(hist_stretch_cvip(I_hat,0,1,0,0));title(' output image after Idct transform');
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
                img(is_ind:ie_ind,js_ind:je_ind,:) = real ( idct2_cvip ( input_spect(is_ind:ie_ind,js_ind:je_ind,:)) ) ;
    %             Y = fftshift(X)
            end
        end
    else    % 0 block_size means, input_spect contains only one fourier window, thus the inverse transform is straightforward.
%         img = ifftshift(input_spect);
        img = real(idct2_cvip(input_spect));
    end
    
       

end


function img = idct2_cvip(input_spect)

d = size(input_spect,3);
img = zeros(size(input_spect));
for i=1:d
    img(:,:,i) = basic_alg(input_spect(:,:,i));
end

end




function a = basic_alg(arg1)

a = CVIPidct1(CVIPidct1(arg1).').';

end

function a = CVIPidct1(b)
%   References: 
% 1) A. K. Jain, "Fundamentals of Digital Image Processing", pp. 150-153.
% 2) Wallace, "The JPEG Still Picture Compression Standard", Communications of the ACM, April 1991.


if nargin == 0,
	error('Not enough input arguments.');
end

if isempty(b),
   a = [];
   return
end

% If input is a vector, make it a column:
do_trans = (size(b,1) == 1);
if do_trans, b = b(:); end
   

n = size(b,1);

m = size(b,2);

n =  2^nextpow2(n);

bb=b;

% Compute wieghts
ww = sqrt(2*n) * exp(1i*(0:n-1)*pi/(2*n)).';

if rem(n,2)==1 || ~isreal(b), % odd case
  % Form intermediate even-symmetric matrix.
  ww(1) = ww(1) * sqrt(2);
  W = ww(:,ones(1,m,class(b)));
  yy = zeros(2*n,m,class(b));
  yy(1:n,:) = W.*bb;
  yy(n+2:2*n,:) = -1i*W(2:n,:).*flipud(bb(2:n,:));
  
  y = ifft(yy);

  % Extract inverse DCT
  a = y(1:n,:);

else % even case
  % Compute precorrection factor
  ww(1) = ww(1)/sqrt(2);
  W = ww(:,ones(1,m,class(b)));
  yy = W.*bb;

  % Compute x tilde using equation (5.93) in Jain
  y = ifft(yy);
  
  % Re-order elements of each column according to equations (5.93) and
  % (5.94) in Jain
  a = zeros(n,m,class(b));
  a(1:2:n,:) = y(1:n/2,:);
  a(2:2:n,:) = y(n:-1:n/2+1,:);
end

if isreal(b)
  a = real(a); 
end
if do_trans
  a = a.';
end
end