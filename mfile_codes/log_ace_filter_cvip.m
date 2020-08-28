function new_image = log_ace_filter_cvip( imageP,W, k1,k2)
% LOG_ACE_FILTER_CVIP - performs a log ACE filter operation.
%
% Syntax :
% -------
% new_image = log_ace_filter_cvip( imageP,W, k1,k2)
%   
% Input Parameters include:
% -------------------------
%
%   'imageP'        Input image can be gray image or rgb image of MxN size. 
%                   
%   'W'             Filter block size.  
%                   
%   'k1'            Local gain factor constant, between 0 and 1.
%                    
%   'k2'            Local mean factor, between 0 and 1.
%                   
%                      
% Output Parameter include :
% -------------------------  
%
%   'new_image'     The output image after filtering.
%                 
%
%
% Example :
% -------
%                   imageP = imread('kuw.png');
%                   W = 11;
%                   k1 = .8;
%                   k2 = 1;
%                   new_image = log_ace_filter_cvip( imageP,W, k1,k2);
%                   figure;imshow(new_image,[]);
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

image_data_type = class(imageP);
int_types = {'int8';
'int16';
'int32';
'int64';
'uint8';
'uint16';
'uint32';
'uint64';
};
is_int = sum( strcmp(image_data_type,int_types) );

if is_int >=1
    M = double(intmax(image_data_type));
else
    % data type is not one of the integers above
    M = ceil(max(imageP(:)));
end

new_image = double(imageP);
for i= c: (m+1-c)
  for j=c:(n+1-c) 
    for k = 1:o
        block = double( imageP( i - (c-1): i+ (c-1) , j - (c-1): j+ (c-1), k ) ) ; % W-block of the image. Only one band.
        ml = mean(block(:));
        mlc = 1 - (ml/M);
        Ic = 1 - (new_image(i,j,k)/M);
        new_image(i,j,k) =(k1*(log(Ic) - log(mlc)) + k2*mlc);
        
    end
  end
end
 new_image = 1- new_image;
end