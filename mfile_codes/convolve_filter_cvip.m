function conv_filter = convolve_filter_cvip( I,M )
% CONVOLVE_FILTER_CVIP - convolves an image with a user specified convolution mask.
%
% Syntax :
% ------
% conv_filter = convolve_filter_cvip(I,M)
%
% Input parameters Include :
% ------------------------
% 'I'          Input Image.
% 'M'          Serves as mask in the convolution .
%
% Output parameter include :
% ------------------------
% 'conv_filter'  Output image.
%
%
% Example :
% -------
%             I = imread('car.bmp');
%             M = ones(3,3);
%             conv_filter = convolve_filter_cvip( I,M );
%             figure; imshow(hist_stretch_cvip(conv_filter,0,1,0,0));
%
% Reference
% ---------
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%%==========================================================================
% 
%           Author:                 Lakshmi Gorantla
%           Initial coding date:    07/18/2017
%           Latest update date:     07/18/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%
%==========================================================================


if size(M,3) ~= 1
    error('The mask should be 2 dimensional.');
end

I = double(I);
M = double(M);

d = size(I,3);
conv_filter = zeros(size(I));
for i=1:d
    conv_filter(:,:,i) = conv2(I(:,:,i),M,'same'); 
end

end