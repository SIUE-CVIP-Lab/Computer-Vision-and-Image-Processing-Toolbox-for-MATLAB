function p = perimeter_cvip(labeledImage, objLabel)
% PERIMETER_CVIP - calculates perimeter of a binary object.
%
% Syntax :
% --------
%  p = perimeter_cvip(labeledImage, r, c)
%   
% Input Parameters include :
% -----------------------
%
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
%   'p'             The perimeter of the binary object.
%                                       
%
%
% Example :
% -------
%                   labeledImage = label_cvip(imread('Shapes.bmp'));
%                   theta = perimeter_cvip(labeledImage,  [391 , 139])
%                   
%                  
%
% Reference
% ---------
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

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
    clear obj;
    i = 2;
    j =  find(new_obj(2,:) == 1, 1); fj = j;
    
%   figure; imshow(new_obj,[])
    
    shift = 0;
    flag = 1;
    obj = zeros(size(new_obj));
    obj(i,j) = 1;
    while(flag)
        box = new_obj(i-1:i+1,j-1:j+1);
        [ii,jj] = scan_box(box,shift);
        obj(i+ii,j+jj) = 1;
        if ([ii jj] == [0 1]) 
            shift = 1;
        elseif ([ii jj] == [1 1])
            shift = 1;
        elseif ([ii jj] == [1 0]) 
            shift = 7;
        elseif ([ii jj] == [1 -1]) 
            shift = 7;
        elseif ([ii jj] == [0 -1]) 
            shift = 5;
        elseif ([ii jj] == [-1 -1]) 
            shift = 5;
        elseif ([ii jj] == [-1 0]) 
            shift = 3;
        elseif ([ii jj] == [-1 1])
            shift = 3;
        end
        i = i + ii;
        j = j + jj;
        
        if (i == 2) && (j == fj)
            flag = 0;
        end
    end
    
    p = sum(sum(obj));
%     figure; imshow(obj+new_obj,[])
end

function [ii,jj] = scan_box(box,shift)
seq = [0 1;
       1 1;
       1 0;
       1 -1;
       0 -1;
       -1 -1;
       -1 0;
       -1 1];
   seq = circshift(seq,shift);
   for i=1:8
      if box(2+seq(i,1),2+seq(i,2)) == 1
          ii = seq(i,1);
          jj = seq(i,2);
          break;
      end
   end
end