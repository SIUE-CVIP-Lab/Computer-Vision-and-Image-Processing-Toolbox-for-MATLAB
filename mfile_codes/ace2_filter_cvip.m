function new_image = ace2_filter_cvip( imageP,W, k1,k2)
% ACE2_FILTER_CVIP - adaptive contrast and enhancement filter.
% This is a simplified variation of ACE filter and is less
% computationally intensive than original ACE filter.
% It is a spatial-domain method for contrast and dynamic range
% modifications with less limitation on linear contrast stretching.
% This filter adapts to local image statistics contrast is improved in both
% bright and dark areas of the image.
%
% Syntax :
% -------
% new_image = ace2_filter_cvip( imageP,W, k1,k2)
%   
% Input Parameters include :
% ------------------------
%
% 'imageP'        Input image can be gray image or rgb image of MxN size. 
%                   
% 'W'             Filter block size.  
%                   
% 'k1'            Local gain factor constant, between 0 and 1.
%                    
% 'k2'            Local mean factor, between 0 and 1.
%                   
%                      
% Output Parameter include :  
% ------------------------
% 'new_image'     The output image after filtering.
%                 
% Example :
% -------
%                   imageP = imread('kuw.png');
%                   W = 11;
%                   k1 = .8;
%                   k2 = 0.5;
%                   new_image = ace2_filter_cvip( imageP,W, k1,k2);
%                   figure;imshow(hist_stretch_cvip(new_image,0,1,0,0),[]);
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    3/13/2017
%           Latest update date:     3/19/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

if (rem(W,2) < 1) || (W > 11 && W <3)
    error('mask_size should be an odd number between 3 and 11');
end
[m,n,o] = size(imageP);


c = (W+1)/2;    % coordinate of the center pixel of the window
new_image = double(imageP);
for i= c: (m+1-c)
  for j=c:(n+1-c) 
    for k = 1:o
        block = double( imageP( i - (c-1): i+ (c-1) , j - (c-1): j+ (c-1), k ) ) ; % W-block of the image. Only one band.
        ml = mean(block(:));
        new_image(i,j,k) = k1*(new_image(i,j,k) - ml) + k2*ml;
    end
  end
end

end