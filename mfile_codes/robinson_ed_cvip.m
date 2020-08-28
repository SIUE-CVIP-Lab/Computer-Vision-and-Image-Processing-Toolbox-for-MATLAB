function [ edge_mag, edge_dir ] = robinson_ed_cvip( input_image )
% ROBINSON_ED_CVIP - perform a Robinson edge detection.
% applies Robinson operator to the image and returns two images containging 
% information about the edge magnitude and  edge direction as outputs.
% 
% SYNTAX :
% ------   
% [ edge_mag, edge_dir ] = robinson_ed_cvip( input_image )
%   
% Input Parameter include :
% ------------------------
%
% 'input_image'   Input image can be gray image or rgb image of MxN size.                
%                        
% Output Parameters include :
% ------------------------  
%
%   'edge_mag'     The magnitude of the edges.
%                  An image with the same size as the input image.
%   'edge_dir'     The direction of the edges.
%                  An image with the same size as the input image.
%
% Example :
% -------
%                  input_image = imread('butterfly.tif');
%                  [edge_mag, edge_dir] = robinson_ed_cvip(input_image);
%                  figure; imshow(hist_stretch_cvip(edge_mag,0,1,0,0),[]);
%                  figure; imshow(hist_stretch_cvip(edge_dir,0,1,0,0),[]);
% 
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
r0 = [-1 0 1; -2 0 2; -1 0 1];
r1 = [0 1 2; -1 0 1; -2 -1 0];
r2 = [1 2 1; 0 0 0; -1 -2 -1];
r3 = [2 1 0; 1 0 -1; 0 -1 -2];

% r4 = [5 -3 -3; 5 0 -3; 5 -3 -3];
% r5 = [-3 -3 -3; 5 0 -3; 5 5 -3];
% r6 = [-3 -3 -3; -3 0 -3; 5 5 5];
% r7 = [-3 -3 -3; -3 0 5; -4 5 5];

input_image = double(input_image);

kbands = zeros([m n 8]);
edge_mag = zeros([m n o]);
edge_dir = zeros([m n o]);

for i=1:o
    kbands(:,:,1) = conv2(input_image(:,:,i), r0,'same');
    kbands(:,:,2) = conv2(input_image(:,:,i), r1,'same');
    kbands(:,:,3) = conv2(input_image(:,:,i), r2,'same');
    kbands(:,:,4) = conv2(input_image(:,:,i), r3,'same');
    kbands(:,:,5) = -1*kbands(:,:,1); %conv2(new_image(:,:,i), r4,'same');
    kbands(:,:,6) = -1*kbands(:,:,2); %conv2(new_image(:,:,i), r5,'same');
    kbands(:,:,7) = -1*kbands(:,:,3); %conv2(new_image(:,:,i), r6,'same');
    kbands(:,:,8) = -1*kbands(:,:,4); %conv2(new_image(:,:,i), r7,'same');
    
    [edge_mag(:,:,i), edge_dir(:,:,i)] = max(kbands,[],3);
end

edge_dir(edge_dir > 4) = edge_dir(edge_dir > 4) - 8;

edge_dir = (mod(edge_dir + 6,8))*pi/4;

end