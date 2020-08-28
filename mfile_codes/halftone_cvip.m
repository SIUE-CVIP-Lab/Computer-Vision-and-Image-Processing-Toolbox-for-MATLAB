function [ out_img ] = halftone_cvip( input_img, method , varargin)
% HALFTONE_CVIP - convert image to binary with halftone technique.
%
% Syntax:
% -------
% [ out_img ] = halftone_cvip( input_img, method , varargin)
%
%  Description :
%  -------------
%
%  This function converts the image to binary using one of the following
%  halftoning techniques:
% 
%  # Floyd–steinberg dithering
%  # Bayer's ordered dither
%  # Clustered-dot-ordered
%  # Simple threshold
% 
%
%  method 4 (simple threshold) needs an extra argument, a number between
%  0 and 1, which determines the threshold level. Based on the data type
%  of the input image, this number is multiplied to the full range of the
%  image to find the threshold level. 
%
%  Regardless of the method used, the full range of the image is reported in
%  the commmand window as the value of the variable _max_val_
%
%
% Input Parameters include :
% ------------------------
%     
%  'input_img'      The input image. Can be multi band.
%
%   'method'        an integer between 1,2,3,4 corresponsing 
%                   to FS, Bayer, Cluster, and simple threshold
%                   methods.
%  'varargin'       An extra input which is used only when method is
%                   simple threshold (4). This value is the threshold
%                   level and is a rational number between [0,1];
%
% Output Parameter include :
% ------------------------
%
%   'Output'        Output Image.
%  
%  Example :
%  -------
%             img = imread('Stripey.jpg');
%             method = 4;
%             varargin = 0.3;
%             [ out_img ] = halftone_cvip( img ,method,varargin);
%             figure; imshow(out_img);
%
%
% Reference
% ---------
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    7/11/2017
%           Latest update date:     7/14/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

set_max_val(class(input_img));
d = size(input_img,3);
out_img = zeros(size(input_img));
for band=1:d
    switch method
        case 1
            out_img(:,:,band) = FS_alg(input_img(:,:,band));
        case 2
            out_img(:,:,band) = Bayer(input_img(:,:,band));
        case 3
            out_img(:,:,band) = Cluster(input_img(:,:,band));
        case 4
            if nargin ~= 3
                error('threshold value should also be given as input.');
            end
            val = varargin{1};
            out_img(:,:,band) = thresh(input_img(:,:,band), val);
     end

end

end

function out_I = thresh(I, val)
global max_val
    I = double(I)/max_val;
    out_I = I >= val;
end

function out_I = Bayer(I)
global max_val

	U = ones(3);
	D = [8 4 5;
		  3 0 1;
		  7 2 6];

	S = [4*D 4*D+2*U;
		  4*D+3*U 4*D+U];
      % Size of image and S
si = size(I);
ss = size(S);

% Create an image with the same size as I, 
% which has the matrix S replicated. Replicate it using the ceiling
% of their size ratio and then discard the last extra elements (if any).
ts = ceil(si ./ ss);
SImg = repmat(S, ts);
SImg = SImg(1:si(1), 1:si(2));

% Shift the values by 0.5 so that we can compare without floor.
SImg = SImg + 0.5;

% Number of levels N
N = max(S(:)) - min(S(:)) + 2;
% Quantization step and quantized image (with values in 0,1,2,...,N-1)
D = max_val ./ (N-1);
Q = double(I) ./ D;

% Threshold image 
% Pixels with value greater than that of S (at the same position) become 1,
% the rest 0
out_I = Q > SImg;
end

function out_I = Cluster(I)
global max_val
S = [34 29 17 21 30 35;
		 28 14 9 16 20 31;
		 13 8 4 5 15 19;
		 12 3 0 1 10 18; 
		 27 7 2 6 23 24;
		 33 26 11 22 25 32];

% Size of image and S
si = size(I);
ss = size(S);

% Create an image with the same size as I, 
% which has the matrix S replicated. Replicate it using the ceiling
% of their size ratio and then discard the last extra elements (if any).
ts = ceil(si ./ ss);
SImg = repmat(S, ts);
SImg = SImg(1:si(1), 1:si(2));

% Shift the values by 0.5 so that we can compare without floor.
SImg = SImg + 0.5;

% Number of levels N
N = max(S(:)) - min(S(:)) + 2;
% Quantization step and quantized image (with values in 0,1,2,...,N-1)
D = max_val ./ (N-1);
Q = double(I) ./ D;

% Threshold image 
% Pixels with value greater than that of S (at the same position) become 1,
% the rest 0
out_I = Q > SImg;
end

function out_I = FS_alg(I)
global max_val
    [m,n] = size(I);
    out_I = double(I)/max_val;
    for i=1:m
        for j=1:n
            old_val = out_I(i,j);
%             new_val  = round(double(old_val));
            new_val = double(old_val > .1);
            out_I(i,j) = new_val;
            err = old_val - new_val;
            if i == m %% last line - forget about diffusion
                continue;
            end
            
            out_I(i+1,j) = out_I(i+1,j) + ( (5/16)*err ); %% bottom
            
            if j < n    %% if next col exist -> take care of right and bottom right pixel
                out_I(i,j+1) = out_I(i,j+1) + ( (7/16)*err );   %% right
                out_I(i+1,j+1) = out_I(i+1,j+1) + ( (1/16)*err );   %% bottom right
            end
            
            if j > 1    %% if not at the left edge -> set the bottom left
                out_I(i+1,j-1) = out_I(i+1,j-1) + ( (3/16)*err );
            end
        end
    end
end

function set_max_val(data_type)
global max_val

switch(data_type)
    case 'uint8'
        max_val = 255;
    case 'uint16'
        max_val = 65535;
    case 'double'
        max_val = realmax('double');    % This is silly
end

%display(max_val)
end

% function out_val = round_color(val)
% out_val = round(double(val));
% end