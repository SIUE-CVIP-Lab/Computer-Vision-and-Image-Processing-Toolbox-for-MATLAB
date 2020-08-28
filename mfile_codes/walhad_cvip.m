function [ spect ] = walhad_cvip( input_img, block_size )
% WALHAD_CVIP - perform forward Walsh/Hadamard transform.
%  
% Syntax :
% ------  
% [ spect ] = walhad_cvip( input_img, block_size )    
%
% Input Parameters include :
% ------------------------
%
% 'input_img'     The orignial image which can be grayscale or RGB.
%
% 'block_size'    Should be a power of 2 or [].if empty, then functions
%                 finds the nearest power of 2 and zero pad the image, to
%                 that block size.Any other value smaller than image
%                 size will partiotion the image to windows of that block
%                 size and WHT will be calculated separately in each
%                 window.
%
% Output Parameters include :
% ------------------------- 
%
% 'Spect'         The Walsh/Hadamard transform of the input image.
%                   
% Example :
% -------
%   
%             input_img = imread('Butterfly.tif');
%             block_size = 4;
%             spect = walhad_cvip(input_img,block_size);
%             figure;imshow(input_img);title('Input Image');
%             figure;imshow(remap_cvip(log(1+abs(spect))),[]);title('Output Transformed Image');
%
%
% Reference 
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    07/17/2017
%           Updated by:             Sujata Bista
%                                   Murat Aslan
%           Latest update date:     04/25/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.2  04/25/2019  16:30:53  sbista, maslan
 % Replaced the padarray functions that belongs to the Image processing toolbox
 % for the padarray_cvip CVIP toolbox function
 % Replaced the imread() functions that belongs to the Image processing toolbox
 % by input_image() CVIP toolbox function
%
 % Revision 1.1  07/17/2017  16:33:22  malvan
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
            spect(is_ind:ie_ind,js_ind:je_ind,:) = walhad2(input_img(is_ind:ie_ind,js_ind:je_ind,:));
        end
    end
else    %  if block size is 0 at this line, it means block size was give [] or 0 by the user, so there is only one window to comput fft.
    spect = walhad2(input_img);
end

end


function y = walhad2(X) 
% performs the transform on each band of the input X.
%
%   Since W/H is seperable, first we transform each row of the input,
%   and then transform each column of the result.
%   This process should exactly bee reversed for the inverse transform.
%

d = size(X,3);
y = zeros(size(X));
for i=1:d
    A = walhad1(X(:,:,i));      % Transform each row
    y(:,:,i) = walhad1(A.').';  % Transform each column of the result
end

end

function Y = walhad1(X)
%   Given a 2d input X, This function computes W/H transform for each row
%   of X and returns at the corresponding row in Y.
%   For more info regarding the used method, look at 
%   https://www.mathworks.com/help/signal/examples/discrete-walsh-hadamard-transform.html

X = double(X);
[m,n] = size(X);

% basis
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

%
Y = zeros(m,n);
for i=1:m
    x = repmat(X(i,:),[n,1]);
    y = sum(x.*walshMatrix,2);
    y = y.';
    Y(i,:) = y;   
    % This coefficient 'n' can be applied in different places, based on your choice of formula.
    %   You just need to be consistent in taking the inverse transform as
    %   well.
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

