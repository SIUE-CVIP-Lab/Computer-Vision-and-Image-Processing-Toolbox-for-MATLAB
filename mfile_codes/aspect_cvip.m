function asp = aspect_cvip(labeledImage, objLabel)
% ASPECT_CVIP - finds the aspect ratio of a binary object of interest on the
% labeled image.Aspect ratio is equal to difference between maximum coioumn
% value and minimum column value of the object divided by difference between
% maximum row value and minimum row value of the object.
%
% Syntax:
% -------
% asp = aspect_cvip(labeledImage, [r,c])
%   
% Input Parameters include :
% ------------------------
%   'labelImage'    Label image of MxN size with single object or multiple objects.  
%                   Each object has unique gray value.
%   'r'             The row number of a pixel on the object.
%                   positive integer.
%   'c'             The column number of a pixel on the object.
%                   positive integer.
%                 
% Output Parameter Include :  
% ------------------------
%   'asp'           The aspect ratio of the object.
%                    
% Example :
% -------
%                 input_img = imread('Shapes.bmp');
%                 lab_image = label_cvip(input_img);
%                 figure; imshow(input_img,[]);
%                 asp = aspect_cvip(lab_image, [33,27])
%          
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    12/27/2016
%           Latest update date:     5/9/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================
[x, objdim] = size(objLabel);
if x ~= 1
    error('objLabel is the information on one object, so the size of objLabel should be either 1x2 or 1x1');
end
if objdim== 2
    gray_level = labeledImage(objLabel(1,1),objLabel(1,2)); 
else
    gray_level = objLabel;
end


    s = (labeledImage == gray_level);
    [r,c] = find (s == 1);
    
    asp = (max(c) - min(c)) / (max(r) - min(r));
end