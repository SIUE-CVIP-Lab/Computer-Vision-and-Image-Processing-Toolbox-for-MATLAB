function  edge_mag = roberts_ed_cvip(input_image,Type)
% ROBERTS_ED_CVIP - performs a Roberts edge detection.
% 
% Syntax :
% -------
% edge_mag = roberts_ed_cvip( input_image, Type )
%  
% Input Parameters include :
% ------------------------
%
%  'input_image'   Input image can be gray image or rgb image of MxN size. 
%                   
%  'Type'          The operator type.It can be either 1 or 2.  
%                   Type 1- Regular gradient
%                   G[I(r,c)] =  ( (I(r,c) - I(r+1,c+1)).^2 + (I(r+1,c) - I(r,c+1)).^2 )^1/2
%
%                   Type 2- Roberts gradient
%                   G[I(r,c)] = |I(r,c) - I(r+1,c+1)| + | I(r+1,c) - I(r,c+1)|
%                   
%                      
% Output Parameters include :  
% -------------------------
%
%  'edge_mag'     The magnitude of the edges.
%                  An image with the same size as the input image.
%  'edge_dir'     The direction of the edges.
%                  An image with the same size as the input image.
%
% Example :
% -------
%                   input_image = imread('butterfly.tif');
%                   Type = 2;
%                   edge_mag = roberts_ed_cvip(input_image, Type);
%                   figure; imshow(hist_stretch_cvip(edge_mag,0,1,0,0),[]);
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

if (~isscalar(Type))
    error('Type should be a scalar. Possible values are 1 and 2');
end

[m,n,o] = size(input_image);


input_image = double(input_image);
edge_mag = zeros(m,n,o);

switch Type
    case 1 % Type 1- Regular gradient
        for i= 1: (m-1)
            for j=1:(n-1) 
                edge_mag(i,j,:) = sqrt ( (input_image(i,j,:) - input_image(i+1,j+1,:)).^2 + ( input_image(i+1,j,:) - input_image(i,j+1,:)).^2 );    %Type 1                
            end
        end
        
    case 2  % Type 2- Roberts gradient
        for i= 1: (m-1)
            for j=1:(n-1) 
                edge_mag(i,j,:) = abs(input_image(i,j,:) - input_image(i+1,j+1,:)) + abs( input_image(i+1,j,:) - input_image(i,j+1,:));    %Type 2                
            end
        end
    otherwise
        error('Type should be either 1 or 2.');
end



 end



















