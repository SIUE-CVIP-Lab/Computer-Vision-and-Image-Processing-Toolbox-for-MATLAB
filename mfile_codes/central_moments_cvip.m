function mu = central_moments_cvip(labeledImage, objLabel,p,q)
% CENTRAL_MOMENTS_CVIP - computes the central moment of order (p+q) of a binary object.
%
% Syntax :
% -------
%  mu = central_moments_cvip(labeledImage,[r,c],p,q)
%   
% Input Parameters include :
% -------------------------
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
%   'p'              The exponent of the moment in the vertical direction.
%                   
%   'q'              The exponent of the moment in the horizontal direction.
%                   
% Output Parameter include :
% -------------------------  
%
%   'mu'              The central moment of order (p+q)
%                    
% Example :
% -------
%                    input_img = imread('Shapes.bmp');
%                    lab_image = label_cvip(input_img);
%                    figure; imshow(input_img,[]);
%                    r= 247; 
%                    c=224;
%                    p=1; 
%                    q=2;
%           % (247,224) is a location on the ellipse with a hole.
%           % The central moment for p=1 and q=2 should turn out
%           % to be 0 because of the symmetry of the object.
%                   mu = central_moments_cvip(lab_image, [r,c],p,q)     
%
% Reference
% ---------
% 1.Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

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

% This function is called by rst_invariant_cvip()


[x, objdim] = size(objLabel);
if x ~= 1
    error('objLabel is the information on one object, so the size of objLabel should be either 1x2 or 1x1');
end
if objdim== 2
    gray_level = labeledImage(objLabel(1,1),objLabel(1,2)); 
else
    gray_level = objLabel;
end



    [rr,cc] = centroid_cvip(labeledImage,objLabel);
    

    s = (labeledImage == gray_level);
    [m,n] = size(s);
    r = (1:m)';
    c = 1:n;
    [c,r] = meshgrid(c,r);
    
    r = r - rr;
    c = c - cc;
   
    mu = sum(sum( (r.^p).*(c.^q).*s ));

end