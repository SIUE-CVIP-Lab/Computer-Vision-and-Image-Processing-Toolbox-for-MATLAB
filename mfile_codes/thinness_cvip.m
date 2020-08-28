function t = thinness_cvip(labeledImage, objLabel)
% THINNESS_CVIP - calculate the thinness ratio of a binary object.
% Syntax :
% ------
% t = thinness_cvip(labeledImage, [r, c])
%   
% Input Parameters include :
% -------------------------
%   'labelImage'    Label image of MxN size with single object or multiple objects.  
%                   Each object has unique gray value.
%   'r'             The row number of a pixel on the object.
%                   positive integer.
%   'c'             The column number of a pixel on the object.
%                   positive integer.
%                 
%
% Output Parameter include :  
% ------------------------
%   't'             The thinness ratio of the binary object.
%                                       
%
%
% Example :
% -------
%           input_img = imread('shapes.bmp');
%           lab_image = label_cvip(input_img);
%           ir = thinness_cvip(lab_image, [33  27])   % a point on the ellipse in the top left corner 
%                   
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    12/27/2016
%           Latest update date:     3/19/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================


    t = 4* pi * area_cvip(labeledImage, objLabel)/(perimeter_cvip(labeledImage,objLabel)^2);
end