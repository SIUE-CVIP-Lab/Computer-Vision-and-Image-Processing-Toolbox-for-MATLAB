function ir = irregular_cvip(labeledImage, r, c)
% IRREGULAR_CVIP  - calculates the irregularity ratio of a binary object.
%
% Syntax :
% ------
% ir = irregular_cvip(labeledImage, r, c)
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
%
% Output Parameter include :  
% ------------------------
%   'ir'            The irregularity ratio of the binary object.
%                                       
%
% Example :
% -------
%                  
%                   lab_image = label_cvip(imread('Shapes.bmp'));
%                   ir = irregular_cvip(lab_image, 33 , 27)
%                   
%                  
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



  ir = (perimeter_cvip(labeledImage,[r, c])^2)/ (4* pi * area_cvip(labeledImage, [r ,c]));
end