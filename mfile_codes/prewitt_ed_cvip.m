function [ edge_mag, edge_dir ] = prewitt_ed_cvip( input_image, kernel_size )
% PREWITT_ED_CVIP- perform prewitt edge detection
%
% SYNTAX :
% ------  
% [ edge_mag, edge_dir ] = prewitt_ed_cvip( input_image, kernel_size )
%   
% Input Parameters include :
% ------------------------
%   'input_image'      Input image can be gray image or rgb image of MxN size. 
%                   
%   'kernel_size'      Filter block size.  
%                   
%                   
%                      
% Output Parameters include :
% -------------------------
%
%   'edge_mag'     The magnitude of the edges.
%                  An image with the same size as the input image.
%   'edge_dir'     The direction of the edges.
%                  An image with the same size as the input image.
%
% Example :
% -------
%                   input_image = imread('butterfly.tif');
%                   kernel_size = 7;
%                   [edge_mag, edge_dir] = prewitt_ed_cvip(input_image, kernel_size);
%                   figure; imshow(hist_stretch_cvip(edge_mag,0,1,0,0),[]);
%                   figure; imshow(hist_stretch_cvip(edge_dir,0,1,0,0),[]);
%
% Reference
% ---------
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    3/23/2017
%           Latest update date:     4/4/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

if (rem(kernel_size,2) < 1) || (kernel_size > 11 && kernel_size <3)
    error('mask_size should be an odd number between 3 and 11');
end



hor = [-1 0 1; -1 0 1; -1 0 1];
ver = [-1 -1 -1; 0 0 0; 1 1 1];

hor = extend_cvip(hor,kernel_size - 3);
ver = extend_cvip(ver,kernel_size - 3);

[m,n,o] = size(input_image);
input_image = double(input_image);

s1 = zeros(m,n,o);
s2 = zeros(m,n,o);
for i=1:o
    s1(:,:,i) = conv2(input_image(:,:,i), hor,'same');
    s2(:,:,i) = conv2(input_image(:,:,i), ver,'same');
end

edge_mag = sqrt((s1.^2) + (s2.^2));     % high range output. needs hist stretch to 0-1
edge_dir = atan2(-s2,-s1);                %this edge direction differs with cviptools output


end

function B = extend_cvip(A, n)
% n: number of extended columns or rows in corresponding direction
    n = n/2;
    [r, c] = size(A);
    A = A([ones(1,n) 1:r r*ones(1,n)],:);
    B = A(:,[ones(1,n) 1:c c*ones(1,n)]);
    
end
