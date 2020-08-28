function  edge_mag  = laplacian_ed_cvip( input_image, mask_type )
% LAPLACIAN_ED_CVIP - performs a Laplacian edge detection.
%
% Syntax :
% ------
%  edge_mag  = laplacian_ed_cvip( input_image, mask_type )
%   
% Input Parameters include :
% -------------------------
%   'input_image'   Input image can be gray image or rgb image of MxN size. 
%                   
%   'mask_type'     Laplacian mask to be used.                   
%                   Type 1 = [0  -1  0; 
%                             -1  4 -1; 
%                             0  -1  0];
%
%                   Type 2 = [-2  1  -2; 
%                              1  4   1; 
%                             -2  1  -2];
%
%                   Type 3 = [-1  -1  -1; 
%                             -1  8   -1; 
%                             -1  -1  -1];
%                   
%                   
%                      
% Output Parameter include :  
% ------------------------
%   'edge_mag'     The output after Laplacian operator is applied.
%                  An image with the same size as the input image.
%
% Example :
% -------
%                   input_image = imread('butterfly.tif');
%                   mask_type = 2;
%                   edge_mag = laplacian_ed_cvip( input_image, mask_type );
%                   figure; imshow(hist_stretch_cvip(edge_mag,0,1,0,0),[]);
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

if (~isscalar(mask_type))
    error('mask_type should be a scalar. Possible values are 1,2, or 3');
end

[m,n,o] = size(input_image);
Mask1 = [0 -1 0; -1 4 -1; 0 -1 0];
Mask2 = [-2  1 -2; 1 4 1; -2  1 -2];
Mask3 = [-1 -1 -1; -1 8 -1; -1 -1 -1];

switch mask_type
    case 1
        mask = Mask1;
    case 2
        mask = Mask2;
    case 3
        mask = Mask3;
    otherwise
        error('mask_type should be 1,2, or 3.');
end
input_image = double(input_image);
edge_mag = zeros(m,n,o);

for i=1:o
    edge_mag(:,:,i) = conv2(input_image(:,:,i), mask,'same');
end

end
