function theta = orientation_cvip(labeledImage, objLabel)
% ORIENTATION_CVIP - calculates the axis of least second moment for a binary object
%
% Syntax :  
% ------
% theta = orientation_cvip(labeledImage, [r, c])
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
%
%   'theta'         The orientation of the binary object.
%                                       
%
%
% Example :
% -------
%                     input_img = imread('Shapes.bmp');
%                     lab_image = label_cvip(input_img);
%                     theta_hor = orientation_cvip(lab_image,  [33,  35])     % The horizontal ellipse
%                     theta_ver = orientation_cvip(lab_image,  [377,  134])
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    12/27/2017
%           Latest update date:     04/06/2018
%           Updated by:             Julian Rene Cuellar Buritica
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.2  12/17/2018  10:14:51  jucuell
 % fixing the computing of the angle theta (equation was wrong).
%
 % Revision 1.1  12/27/2017  15:23:31  mealvan
 % Initial coding and testing.
 % 
%

[x, objdim] = size(objLabel);
if x ~= 1
    error('objLabel is the information on one object, so the size of objLabel should be either 1x2 or 1x1');
end
if objdim== 2
    gray_level = labeledImage(objLabel(1,1),objLabel(1,2)); 
else
    gray_level = objLabel;
end


    [rc, cc] = centroid_cvip(labeledImage,  objLabel);

    s = (labeledImage == gray_level);
    [r,c] = find (s == 1);

    r = r - rc;
    c = c - cc;
    A = sum(r.*c);
    B = sum(r.^2);
    C = sum(c.^2);    
    
    if A == 0   % The shape is symmetric along x and y axis
        
        if B < C
            theta = 90;
        elseif B > C
            theta = 0;
        else
            theta = 0; % in case that the shape is rotationaly symmetric, let theta = 0
        end
    else
        theta = atan2(2*A,B-C)/2;
        theta = theta*180/pi;
    end
        
end
