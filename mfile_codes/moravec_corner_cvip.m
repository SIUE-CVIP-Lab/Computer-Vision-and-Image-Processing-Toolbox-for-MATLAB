function [ I_MD ] = moravec_corner_cvip( I , e)
% MORAVEC_CORNER_CVIP -a spatial corner detecting filter.
%
% Syntax :
% ------
%  I_MD  = moravec_corner_cvip( I , e)
%
% Description :
% ------------
% Moravec Filter is the simplest corner detector.This is used 
% to find the points of maximum contrast,which corresponds to potential
% corners and sharp edges.It finds the average difference between a pixel 
% and its neighbors in all directions.Then the threshold operation is applied on the image.
%
% Input Parameters include:
% -------------------------
%  'I'    Input Image.
%  
%  'e'    Threshold range from 0.0 - 1.0.
%
% Output Parameter Include :
% ------------------------
%  'I_MD'   moravec corner detected image.
% 
% Example :
% -------                
%                               I = imread('shapes.bmp');  % Input Image
%                               e = 0.5;   % threshold range from 0.0 - 1.0. 
%                               I_MD = moravec_corner_cvip(I,e);  %  Moravec corner detected Image. 
%                               figure;imshow(I);title('Input Image');                               
%                               figure;imshow(I_MD);title('Output Moravec corner detected Image');
%                               
%                                                            
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

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

% I = double(I);

 I  = condremap_cvip(I,[0 1],'double');
                     
[m,n,d] = size(I);

I_MD = zeros(m,n,d);

%% Compute the inner product
for band = 1:d
                 
I_NW = I([1,1:m-1],[1,1:n-1],band);
I_W = I(:,[1,1:n-1],band);
I_SW = I([2:m,m],[1,1:n-1],band);
I_S = I([2:m,m],:,band);
I_SE = I([2:m,m],[2:n,n], band);
I_E = I(:,[2:n,n], band);
I_NE = I([1,1:m-1],[2:n,n], band);
I_N = I([1,1:m-1],:, band);

I_MD(:,:,band) = abs(I(:,:,band) - I_NW) + abs(I(:,:,band)-I_W) + abs(I(:,:,band)-I_SW) + ...
    abs(I(:,:,band)-I_S) + abs(I(:,:,band)-I_SE) + abs(I(:,:,band)- I_E) + ...
    abs(I(:,:,band) - I_NE) + abs(I(:,:,band) - I_N) ;

end
I_MD = I_MD./8;

% I_MD = condremap_cvip(I_MD,[0 255],'uint8');

%% threshold
x = e*max(I_MD(:));

%display(x)

I_MD(I_MD < x) = 0;
I_MD(I_MD >= x) = 255;

end

