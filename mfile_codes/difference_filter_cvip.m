function difference = difference_filter_cvip(input_image , mask_type)
% DIFFERENCE_FILTER_CVIP - Performs a difference/emboss filtering operation.
%  
% Syntax :
% ------
% difference = difference_filter_cvip(input_image , mask_type)
%
% Input parameters include:
% --------------------------
%  'input_image'   image of M*N size.
%
%  'Mask_type'     can choose any mask from 1 to 8.
%   
%   
% Output parameter include:
% --------------------------
% 'difference'    output image enhanced in particular direction depending on
%                 the type of mask.
%
% Example :
% -------
%     input_image = imread('cam.bmp');
%     mask_type = 3;
%     difference = difference_filter_cvip(input_image,3);
%     figure;imshow(difference,[]);
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
% 
%           Author:                 Lakshmi Gorantla
%           Initial coding date:    06/27/2017
%           Latest update date:     06/27/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%==========================================================================
%
if (~isscalar(mask_type))
    error('mask_type should be a scalar. Possible values are 1,2,3,4,5,6,7 or 8');
end
[m,n,o] = size(input_image);
Mask1 = [0 1 0; 0 1 0; 0 -1 0];
Mask2 = [0 0 0; 1 1 -1; 0 0 0];
Mask3 = [1 0 0; 0 1 0; 0 0 -1];
Mask4 = [0 0 1; 0 1 0; -1 0 0];
Mask5 = [0 -1 0; 0 1 0; 0 1 0];
Mask6 = [0 0 0; -1 1 1; 0 0 0];
Mask7 = [-1 0 0; 0 1 0; 0 0 1];
Mask8 = [0 0 -1; 0 1 0; 1 0 0];


switch mask_type
    case 1
        mask = Mask1;
    case 2
        mask = Mask2;
    case 3
        mask = Mask3;
    case 4 
        mask = Mask4;
    case 5
        mask = Mask5;
    case 6
        mask = Mask6;
    case 7 
        mask = Mask7;
    case 8
        mask = Mask8;
    otherwise
        error('mask_type should be 1,2,3,4,5,6,7, or 8');
end
input_image = double(input_image);
difference = zeros(m,n,o);

for i=1:o
    difference(:,:,i) = conv2(input_image(:,:,i), mask,'same');
end

end
