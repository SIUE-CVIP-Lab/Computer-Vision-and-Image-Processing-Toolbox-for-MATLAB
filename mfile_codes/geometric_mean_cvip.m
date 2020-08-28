function new_image = geometric_mean_cvip( imageP,  mask_size, varargin)
% GEOMETRIC_MEAN_CVIP - performs a geometric mean filter
% geometric filter is a non-linear mean filter which is  better
% at removing gaussian type noise and preserving edge features
% than the mean filter.
%
% Syntax :
% -------
% new_image = geometric_mean_cvip( imageP,  mask_size, varargin)
%
% Input Parameters include :
% ------------------------
%
%   'imageP'        Input image can be gray image or rgb image of MxN size. 
%                                  
%   'mask_size'     Block size of the filter.An odd integer between 3-11.
%              
%   'ignore_zeros'  [Optional] if 0(default value) then the zero pixels in the window are
%                   replaced by one before calculating the geometric mean.
%                   Any value other than 0, results in calculating the GM
%                   without changing the pixel values in any window.
%                   
%
% Output Parameter include :  
% ------------------------
%
%   'new_image'     The output image after filtering
% 
%
% Example :
% -------
%                   imageP = imread('Cam.bmp');
%                   mask_size = 7;
%                   new_image = geometric_mean_cvip( imageP,mask_size);
%                   figure; imshow(new_image,[]);
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

if option ~= 0
    % CVIPtools style
    for i= c: (m+1 -c)
        for j=c:(n+1 - c) 
        block = double(imageP(i - (c-1): i+ (c-1) , j - (c-1): j+ (c-1), 1:o)) ; % W-block of the image with as many bands as the originial
        block(block == 0) = 1;
        %for k = 1:o
            %one_band = block(:,:,k);
            % perform the algorithm on one_band
            % and store the result in new_image(i,j,o);
    %         display(size(block))
            new_image(i,j,:) = geomean_cvip(reshape(block,[mask_size^2 1 o]));
        %end
        end
    end
else 
    % True formula
    for i= c: (m+1 -c)
        for j=c:(n+1 - c) 
        block = double(imageP(i - (c-1): i+ (c-1) , j - (c-1): j+ (c-1), 1:o)) ; % W-block of the image with as many bands as the originial
        %block(block == 0) = 1;
        %for k = 1:o
            %one_band = block(:,:,k);
            % perform the algorithm on one_band
            % and store the result in new_image(i,j,o);
    %         display(size(block))
            new_image(i,j,:) = geomean_cvip(reshape(block,[mask_size^2 1 o]));
        %end
        end
    end
end

new_image = uint8(new_image);
end

function gm = geomean_cvip(A)
    n = size(A,1);
%     for count=1:z
%        plane = A(:,:,count);
%        plane = plane(:);
%        
%        
%     end
    gm = prod(A).^(1/n);
end
% figure; imshow(new_image/255,[])