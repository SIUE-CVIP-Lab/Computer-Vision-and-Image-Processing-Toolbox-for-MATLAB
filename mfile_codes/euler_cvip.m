function e = euler_cvip( labeledImage, objLabel)
% EULER_CVIP - finds the Euler number of a binary object.
%
% Syntax :
% ------
% e = euler_cvip(labeledImage,[r,c])
%   
% Input Parameters include :
% ------------------------
%
%  'labelImage'      Label image of MxN size with single object or multiple objects.  
%                    Each object has unique gray value.
%
%   'r'              The row number of a pixel on the object.
%                    positive integer.
%
%   'c'              The column number of a pixel on the object.
%                    positive integer.
%                 
% Output Parameter include :
% ------------------------  
%
%    'e'             The Euler number of the object.
%                    
%
%
% Example :
% -------
%                 input_img = imread('Shapes.bmp');
%                 lab_image = label_cvip(input_img);
%                 figure; imshow(input_img,[]);  
%                 e = euler_cvip(lab_image, [115,359])   
%                 e = euler_cvip(lab_image, [422,418])
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
    obj = s(min(r):max(r),min(c):max(c));
    [m,n] = size(obj);
    new_obj = zeros(m+2,n+2);
    new_obj(2:(end-1),2:(end-1)) = obj;
    e = 0;
    for i=2:m
        for j=2:n
            if new_obj(i,j) == 1 && new_obj(i-1,j-1) == 0
                if new_obj(i-1,j) == 0 && new_obj(i,j-1) == 0
                    %it is a convexity
                    e = e+1;
                elseif new_obj(i-1,j) == 1 && new_obj(i,j-1) == 1
                    %it is a concavity
                    e = e-1;
                end
            end
        end
    end
end