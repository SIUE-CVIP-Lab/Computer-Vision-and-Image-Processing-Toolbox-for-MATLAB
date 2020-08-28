function [ out_img ] = raster_deblur_mean_cvip( img )
% RASTER_DEBLUR_MEAN_CVIP - raster deblurring filter.
%
% Syntax :
% ------
% [ out_img ] = raster_deblur_mean_cvip( img )
%   
% Input Parameter include :
% -----------------------
%   'img'        Input image can be gray image or rgb image of MxN size. 
%                                  
%                    
% Output Parameter include :  
% --------------------------
%  'out_img'    The output image after raster deblur filter.
% 
%
% Example :
% -------
%                   I = imread('car.bmp');
%                   [ out_img ] = raster_deblur_mean_cvip( I );
%                   figure; imshow(hist_stretch_cvip(out_img,0,1,0,0),[]);
%
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    8/9/2017
%           Latest update date:     8/9/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================


img = double(img);
[m,n,d] = size(img);
if mod(m,2) ~= 1
    img = [img; zeros(1,n,d)];
end
if mod(n,2) ~= 1
    img = [img, zeros(size(img,1),1,d)];
end
img(:, 2:2:end,:) = (img(:,1:2:end-1,:) + img(:,3:2:end,:))/2;
img( 2:2:end,:,:) = (img(1:2:end-1,:,:) + img(3:2:end,:,:))/2;
out_img = img;
end

