function a =  area_cvip(labeledImage, objLabel)
% AREA_CVIP - calculates the area in pixels of a binary object.Gets the sum of
% pixels whose gray level values equal to a specific label.This label is the
% gray level value of the point of coordinates on the labeled image.
%
% Syntax:
% -------
% a =  area_cvip(labeledImage,[ r,c])
%   
% Input Parameters include :
% --------------------------
% 'labelImage'      Label image of MxN size with single object or multiple objects.  
%                   Each object has unique gray value.
%
% 'r'               The row number of a pixel on the object.
%                   positive integer.
%
% 'c'               The column number of a pixel on the object.
%                   positive integer.
%                 
% Output Parameters Include :  
% -------------------------
%   'a'             The area of the object in pixels.
%                    
%
%
% Example :
% -------
%             input_img = imread('Shapes.bmp');
%             lab_image = label_cvip(input_img);
%             figure; imshow(input_img,[]);
%             area = area_cvip(lab_image, [125,125])      
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
    a = sum(sum(s));

end