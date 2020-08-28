function new_image = harmonic_mean_cvip( imageP,  mask_size, varargin)
% HARMONIC_MEAN_CVIP - performs a harmonic mean filter
%
% Syntax :
% -------
% new_image = harmonic_mean_cvip( imageP,  mask_size)
% new_image = harmonic_mean_cvip( imageP,  mask_size, ignore_zeros)        
%   
% Input Parameters include :
% ------------------------
%
%   'imageP'        Input image can be gray image or rgb image of MxN size. 
%                                  
%   'mask_size'     Block size of the filter. An odd integer between 3-11.
%              
%   'ignore_zeros'  [Optional] if 0(default value) then the zero pixels in the window are
%                   ignored when calculating the geometric mean.
%                   Any value other than 0, results in calculating the
%                   harmonic mean without changing the pixel values in any window.
%                   
%
% Output parameters include :  
% -------------------------
%   'new_image'     The output image after filtering
% 
%
% Example :
% -------
%                   imageP = imread('Cam.bmp');
%                   mask_size = 7;
%                   new_image = harmonic_mean_cvip( imageP, mask_size);
%                   figure; imshow(new_image,[]);
%
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


nVararg = length(varargin);
option = 0;
if nVararg > 1
    error('too many arguments');
elseif nVararg == 1
    option = varargin{1};
end

if (rem(mask_size,2) < 1) || (mask_size > 11 && mask_size <3)
    error('mask_size should be an odd number between 3 and 11');
end


[m,n,o] = size(imageP);
c = (mask_size+1)/2; % coordinate of the center pixel of the window
new_image = double(imageP);


if option >= 1
    % CVIPtools style
    for i= c: (m+1 -c)
      for j=c:(n+1 - c) 
        block = double(imageP(i - (c-1): i+ (c-1) , j - (c-1): j+ (c-1), 1:o)) ; % W-block of the image with as many bands as the originial
        
        for k = 1:o
            %one_band = block(:,:,k);
            % perform the algorithm on one_band
            % and store the result in new_image(i,j,o);
    %         display(size(block))
            zero_less = block(:,:,k);
            zero_less = zero_less(zero_less ~= 0);
            new_image(i,j,k) = harmean_cvip(zero_less(:));
        end
      end
    end
else 
    % True formula
    for i= c: (m+1 -c)
      for j=c:(n+1 - c) 
        block = double(imageP(i - (c-1): i+ (c-1) , j - (c-1): j+ (c-1), 1:o)) ; % W-block of the image with as many bands as the originial
        %block(block == 0) = 220;
        %for k = 1:o
            %one_band = block(:,:,k);
            % perform the algorithm on one_band
            % and store the result in new_image(i,j,o);
    %         display(size(block))
            new_image(i,j,:) = harmean_cvip(reshape(block,[mask_size^2 1 o]));
        %end
      end
    end
end




new_image = uint8(new_image);
end


function hm = harmean_cvip(A)
    n = size(A,1);
    hm = n ./ sum(1./A);
end
