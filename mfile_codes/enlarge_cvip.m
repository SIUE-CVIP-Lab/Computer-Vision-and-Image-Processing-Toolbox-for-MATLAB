function [ outImage ] = enlarge_cvip( inImage, row, col)
% ENLARGE_CVIP - Enlarge image to a user-specified size.
% Enlarge allows the user to specify the number of rows and columns in the
% resultant image, corresponding to the height and width of the new image. 
% The integers specified for row and column sizes must be equal to 
% or greater than the input image sizes or an error results.
% Because the user may enter different values for height and width,
% enlarge may be used to geometrically distort the image in a rubber-sheet
% fashion. 
%
% Syntax :
% ------
% outImage = enlarge_cvip( inImage,row,col); 
%    
% Input Parameters include :
% ------------------------
%
%   'inImage'        1-band input image of MxN size or 3-band input image of   
%                    MxNx3 size.The input image can be of uint8 or uint16 
%                    or double class. 
%
%   'row'            Row has to be greater than original image.
%
%   'col'            Col has to be larger than original image.
%
% Output Parameter include :  
% ------------------------
%
%  'outImage'        enlarged image.
%                                         
%
% Example 1 :
% ---------
%                   I = imread('cam.bmp');    %original image
%                   O1 = enlarge_cvip(I,300,300);           
%                   figure;imshow(O1,[]);    
%
% Example 2 :
% ---------
%                   I = imread('car.bmp');    %original image
%                   O1 = enlarge_cvip(I,400,400);           
%                   figure;imshow(remap_cvip(O1,[]));
% 
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications 
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    4/14/2017
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     04/03/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.3  09/05/2018  17:27:56  jucuell
 % start adding revision history and deleting old commented code
% 
 % Revision 1.2  04/03/2018  17:00:03  jucuell
 % code for enlarge image was modified outImage(1:rind(1), 1:cind(1), :)
 % 
%
 % Revision 1.1  03/31/2018  23:14:22  jucuell
 % Initial revision: Error detected when trying to enlarge some images from
 % 256x256 to 512x512
 % 
%

%check number of input arguments
if nargin ~=1 && nargin ~= 2 && nargin ~= 3 && nargin ~= 4
    error('Too many or too few input arguments!');
end

%check number of output arguments
if nargout ~= 1 && nargout ~= 0
    error('Too many output arguments!');
end

%size of the input image
[nrow, ncol, nband] = size(inImage);

%create the outputImage
outImage = zeros(row,col, nband);

%compute width and height ratios
ratio_height = row/nrow;
ratio_width = col/ncol;

%check if new image is smaller than original image
if (ratio_height < 1 || ratio_width < 1)
    error('The new image must be larger than original image!')
end

%row index and col index to divide image into blocks
r1= floor(ratio_height * (1:nrow));
c1= floor (ratio_width*(1:ncol));
rind = cumsum(r1 - [0 r1(1:end-1)]);
cind = cumsum(c1 - [0 c1(1:end-1)]);



%enlarging the input image
outImage(1:rind(1), 1:cind(1), :) = inImage(1:rind(1),1:cind(1),:); 

for b = 1: nband
for r = 1: nrow
    for c = 1:ncol
        if r > 1 && c > 1
            outImage(rind(r-1)+1:rind(r), cind(c-1)+1:cind(c), b) = inImage(r,c,b);
        elseif r == 1 && c > 1
            outImage(rind(r), cind(c-1)+1:cind(c), b) = inImage(r,c,b);
        elseif r > 1 && c == 1
            outImage(rind(r-1)+1:rind(r), cind(c), b) = inImage(r,c,b);
        end
    end
end
end

end % end of function
