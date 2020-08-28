function [ edge_mag, edge_dir ] = kirsch_ed_cvip( input_image )
% KIRSCH_ED_CVIP - perform kirsch edge detection.
%
% Syntax :
% ------ 
% [ edge_mag, edge_dir ] = kirsch_ed_cvip( input_image )
%   
% Input Parameter include :
% -----------------------
%   'input_image'     Input image can be gray image or rgb image of MxN size.                
%                       
% Output Parameter include :  
% ------------------------
%
%   'edge_mag'     The magnitude of the edges.
%                  An image with the same size as the input image.
%   'edge_dir'     The direction of the edges.
%                  An image with the same size as the input image.
%
% Example :
% -------
%                   input_image = imread('butterfly.tif');
%                   [edge_mag, edge_dir] = kirsch_ed_cvip(input_image);
%                   figure; imshow(hist_stretch_cvip(edge_mag,0,1,0,0),[]);
%                   figure; imshow(hist_stretch_cvip(edge_dir,0,1,0,0),[]);
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
k0 = [-3 -3 5; -3 0 5; -3 -3 5];
k1 = [-3 5 5; -3 0 5; -3 -3 -3];
k2 = [5 5 5; -3 0 -3; -3 -3 -3];
k3 = [5 5 -3; 5 0 -3; -3 -3 -3];

k4 = [5 -3 -3; 5 0 -3; 5 -3 -3];
k5 = [-3 -3 -3; 5 0 -3; 5 5 -3];
k6 = [-3 -3 -3; -3 0 -3; 5 5 5];
k7 = [-3 -3 -3; -3 0 5; -4 5 5];

input_image = double(input_image);

kbands = zeros([m n 8]);
edge_mag = zeros([m n o]);
edge_dir = zeros([m n o]);

for i=1:o
    kbands(:,:,1) = conv2(input_image(:,:,i), k0,'same');
    kbands(:,:,2) = conv2(input_image(:,:,i), k1,'same');
    kbands(:,:,3) = conv2(input_image(:,:,i), k2,'same');
    kbands(:,:,4) = conv2(input_image(:,:,i), k3,'same');
    kbands(:,:,5) = conv2(input_image(:,:,i), k4,'same');
    kbands(:,:,6) = conv2(input_image(:,:,i), k5,'same');
    kbands(:,:,7) = conv2(input_image(:,:,i), k6,'same');
    kbands(:,:,8) = conv2(input_image(:,:,i), k7,'same');
    
    [edge_mag(:,:,i), edge_dir(:,:,i)] = max(kbands,[],3);
end

edge_dir(edge_dir > 4) = edge_dir(edge_dir > 4) - 8;

edge_dir = (mod(edge_dir + 6,8))*pi/4;

end