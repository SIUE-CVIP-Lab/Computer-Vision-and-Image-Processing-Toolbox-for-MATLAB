function varargout = centroid_cvip(labeledImage, objLabel)
% CENTROID_CVIP - finds the centroid of a binary object.
%
% Syntax :
% -------
%  Com = centroid_cvip(labeledImage,  [r,  c])
%  [Rc, Cc] = centroid_cvip(labeledImage,  [r,  c])
%   
% Input Parameters include :
% ------------------------  
%
%  'labelImage'     Label image of MxN size with single object or multiple objects.  
%                   Each object has unique gray value.
%
%   'r'             The row number of a pixel on the object.
%                   positive integer.
%
%   'c'             The column number of a pixel on the object.
%                   positive integer.
%                
% Output Parameter include :
% ------------------------  
%
%  Com              A 1x2 array which contains the centroid coordinates.
%                   Com = [r,c].
%                    
% Example :
% -------
%                    input_img = imread('Shapes.bmp');
%                    lab_image = label_cvip(input_img);
%                    figure; imshow(input_img,[]);  	
%                    Com = centroid_cvip(lab_image, [115,359])
%                    [r,c] = centroid_cvip(lab_image,  [115,359])
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

%% Find the coordinates of all the pixels on the object
    s = (labeledImage == gray_level);
    [r,c] = find (s == 1);
%% Calculate centroid   
    rc  = round(mean(r));
    cc = round(mean(c));
%% create the appropriate output
    if nargout ==1  % one output --> [r , c] array
        varargout{1} = [rc , cc];
    elseif nargout ==2 % two outputs --> r c seperate 
        varargout{1} = rc;
        varargout{2} = cc;
    else
        error('number of output argumetns is not correct');
    end
end
