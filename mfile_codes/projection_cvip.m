function [ B_h, B_w ] = projection_cvip( lab_image, gray_level, normWidth, normHeight )
% PROJECTION_CVIP - extracts horizontal and vertical projections of a binary object.
%
% SYNTAX :
% ------  
% [ B_h, B_w ] = projection_cvip( lab_image, gray_level, normWidth, normHeight )
%
% Input Parameters include :
% ------------------------
%   'lab_image'     Label image of MxN size with single object or multiple objects.  
%                   Each object has unique gray value.
%                    
%   'gray_level'    The gray level of the object of interest on the labeled image.
%                   
%   'normWidth'     The width of the bounding box that surronds the scaled
%                   image for projection.
%
%   'normHeight'    The width of the bounding box that surronds the scaled
%                   image for projection.
%
%
%   
% Outputs Parameters include :
% --------------------------
%
%   'B_h'           The projected values on the y-axis or the height of the
%                   bounding box.
%
%   'B_w'           The projected values on the x-axis or the width of the
%                   bounding box.
%                                
%
% Example :
% -------
%             I = imread('Shapes.bmp');
%             lab_image = label_cvip(I);
%             normWidth = 13;
%             normHeight = 26;
%             [ B_h, B_w ] = projection_cvip( lab_image, 6, normWidth, normHeight)
%
% Reference
% ---------
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    10/13/2016
%           Latest update date:     05/19/2018
%           Updated by:             Julian Rene Cuellar Buritica
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.2  05/19/2018  10:14:51  jucuell
 % padarray function is not used, floor function changed to ceil, output
 % image indexes improved by computing the size of the image
%
 % Revision 1.1  10/13/2016  15:23:31  mealvan
 % Initial coding and testing.
 % 
%

[r,c] = find(lab_image == gray_level);

ri = min(r);
rf = max(r);
ci = min(c);
cf = max(c);

A = lab_image(ri:rf,ci:cf);
A = A>0;

[Ho, Wo] = size(A);
W_ratio = normWidth/Wo;
H_ratio = normHeight/Ho;
if W_ratio <= H_ratio
    if W_ratio > 1
        warning('Current ratio is bigger than expected');
    else
        [ outImage ] = spatial_quant_cvip( A, ceil(W_ratio*Ho) , normWidth, 3);
        m = size(outImage,1);
%         index = ceil((normHeight - m) / 2);
%         index = index +1;
        B = zeros(normHeight,normWidth);
        B(1:m,:) = outImage;
    end
else
    if H_ratio > 1
        warning('qer');
    else
        [ outImage ] = spatial_quant_cvip( A, normHeight , ceil(H_ratio*Wo), 3);
        n = size(outImage,2);
%         index = ceil((normWidth - n) / 2);
%         index = index +1;
        B = zeros(normHeight,normWidth);
        B(:,1:n) = outImage;
    end
end
 
 B_h = sum(B,2).';    % projection to the y (height) axis
 B_w = sum(B,1);    % projection to the x (width) axis
end