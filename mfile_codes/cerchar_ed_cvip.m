function edge_mag = cerchar_ed_cvip( input_image )
% CERCHAR_ED_CVIP - a spatial- multi spectral image edge detection filter.It
% takes color image as the input.It determines the edges in the color
% image.The output image is a gray scale image.
%
% Syntax :
% -------
% edge_mag = cerchar_ed_cvip( input_image )
%   
% Input Parameter include :
% -----------------------
%
% 'input_image'     Input image can be gray image or rgb image of MxN size.                
%  
% Output Parameter include :
% ------------------------ 
%
%  'edge_mag'       The magnitude of the edges.
%                   An image with the same size as the input image.
%
% Example :
% -------
%                   input_image = imread('butterfly.tif');
%                   edge_mag = cerchar_ed_cvip(input_image);
%                   figure; imshow(hist_stretch_cvip(edge_mag,0,1,0,0));
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
[m,n,~] = size(input_image);

input_image = double(input_image);

mean_bands = mean(input_image,3);
edge_mag = zeros([m n 1]);
for i= 1: (m-1)
  for j=1:(n-1) 
	v1 = sum((input_image(i,j,:) - mean_bands(i,j)).*(input_image(i+1,j+1,:) - mean_bands(i+1,j+1))) / sqrt( sum((input_image(i,j,:) - mean_bands(i,j)).^2) * sum((input_image(i+1,j+1,:) - mean_bands(i+1,j+1)).^2) );
    v2 = sum((input_image(i+1,j,:) - mean_bands(i+1,j)).*(input_image(i,j+1,:) - mean_bands(i,j+1))) / sqrt( sum((input_image(i+1,j,:) - mean_bands(i+1,j)).^2) * sum((input_image(i,j+1,:) - mean_bands(i,j+1)).^2) );
    edge_mag(i,j) = min(v1,v2);
    
  end
end

end