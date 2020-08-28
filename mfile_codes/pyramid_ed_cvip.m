function [edge_mag, edge_dir] = pyramid_ed_cvip( input_image )
% PYRAMID_ED_CVIP - perform a pyramid edge detection.
%
% Syntax :
% ------
% [edge_mag, edge_dir] = pyramid_ed_cvip( input_image )
%   
% Input Parameter include:
% -----------------------
%   'input_image'   Input image can be gray image or rgb image of MxN size.                
%                        
% Output Parameters include :  
% --------------------------- 
%   'edge_mag'     The magnitude of the edges.
%                  An image with the same size as the input image.
%
%   'edge_dir'     The direction of the edges.
%                  An image with the same size as the input image.
%
% Example :
% -------
%                   input_image = imread('butterfly.tif');
%                   edge_mag = pyramid_ed_cvip(input_image);
%                   figure; imshow(hist_stretch_cvip(edge_mag,0,1,0,0),[]);
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

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


[m,n,o] = size(input_image);

input_image = double(input_image);

mask = [1 1 1 0 -1 -1 -1;
        1 2 2 0 -2 -2 -1;
        1 2 3 0 -3 -2 -1;
        1 2 3 0 -3 -2 -1;
        1 2 3 0 -3 -2 -1;
        1 2 2 0 -2 -2 -1;
        1 1 1 0 -1 -1 -1];
edge_mag = zeros(m,n,o);

s1 = zeros(m,n,o);  
s2 = zeros(m,n,o);  

for i=1:o
    s1(:,:,i) = conv2(input_image(:,:,i), mask,'same'); % horizontal
    s2(:,:,i) = conv2(input_image(:,:,i), mask.','same'); % vertical
end
edge_mag = sqrt((s1.^2) + (s2.^2));

edge_dir = atan2(-s1,-s2);  
end















