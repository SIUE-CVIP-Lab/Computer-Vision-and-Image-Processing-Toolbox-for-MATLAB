function spect = dct_cvip(input_img, block_size)
% DCT_CVIP - perform block-wise discrete cosine transform.
%
% Syntax :
% --------
% spect = dct_cvip(input_img, block_size)
%   
% Input Parameters include:
% ------------------------
%   'input_img'      The orignial image which can be grayscale or RGB.
%
%   'block_size'     Should be a power of 2 or []. If empty,then functions
%                    finds the nearest power of 2 and zero pad the image, to
%                    that block size.Any other value smaller than image
%                    size will partiotion the image to windows of that block
%                    size and DCT will be calculated separately in each
%                    window.
%
%
% Output Parameter include :  
% ------------------------ 
%   'Spect'          The discrete cosine transform of the input image.
%                   
%
%
% Example :
% -------
%                     input_img = input_image();
%                     block_size = [];
%                     spect = dct_cvip( input_img, block_size );
%                     S2=logremap_cvip(abs(spect));
%                     figure; imshow(input_img,[]); title('Input Image')
%                     figure; imshow(S2,[]); title('DCT Output Image')
%                  
%
% Reference
% --------- 
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    5/29/2017
%           Updated by:             Sujata Bista
%                                   Murat Aslan
%           Latest update date:     04/23/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.2  04/23/2019  14:11:53  sbista, maslan
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
            spect(is_ind:ie_ind,js_ind:je_ind,:) = dct2d_cvip(input_img(is_ind:ie_ind,js_ind:je_ind,:));
        end
    end
else    %  if block size is 0 at this line, it means block size was give [] or 0 by the user, so there is only one window to comput fft.
    spect = dct2d_cvip(input_img);
end


end


function out_img = dct2d_cvip(input_img)
d = size(input_img,3);
out_img = zeros(size(input_img));

for iter=1:d
   out_img(:,:,iter) = basic_alg(input_img(:,:,iter));
end
end


function b = basic_alg(arg1)

b = CVIPdct1(CVIPdct1(arg1).').';

end

%CVIPdct1
function b=CVIPdct1(a)
%   References: 
% 1) A. K. Jain, "Fundamentals of Digital Image Processing", pp. 150-153.
% 2) Wallace, "The JPEG Still Picture Compression Standard", Communications of the ACM, April 1991.


if nargin == 0,
	error('Not enough input arguments.');
end


if isempty(a)
   b = [];
   return
end

% If input is a vector, make it a column:
do_trans = (size(a,1) == 1);
if do_trans, a = a(:); end


n = size(a,1);
n =  2^nextpow2(n);
m = size(a,2);

% Pad or truncate input if necessary
if size(a,1)<n,
  aa = zeros(n,m,class(a)); %
  aa(1:size(a,1),:) = a;
else
  aa = a(1:n,:);
end

% Compute weights to multiply DFT coefficients
ww = (exp(-1i*(0:n-1)*pi/(2*n))/sqrt(2*n)).';
if (isa(a,'single'))
  % Cast to enforce precision rules
  ww = single(ww);
end
ww(1) = ww(1) / sqrt(2);

if rem(n,2)==1 || ~isreal(a), % odd case
  % Form intermediate even-symmetric matrix
  y = zeros(2*n,m,class(a));
  y(1:n,:) = aa;
  y(n+1:2*n,:) = flipud(aa);
  
  % Compute the FFT and keep the appropriate portion:
  yy = fft(y);  
  yy = yy(1:n,:);

else % even case
  % Re-order the elements of the columns of x
  y = [ aa(1:2:n,:); aa(n:-2:2,:) ];
  yy = fft(y);  
  ww = 2*ww;  % Double the weights for even-length case  
end

% Multiply FFT by weights:
b = ww(:,ones(1,m)) .* yy;

if isreal(a)
  b = real(b);
end
if do_trans
  b = b.';
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