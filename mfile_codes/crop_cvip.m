function [ outImage ] = crop_cvip( inImage, sizeSI, startPoint)
% CROP_CVIP - Cropping a subimage from an input image.
% The function crops the subimage from the input image.This function
% allows the user to specify a  subimage to be cropped from an input
% image.The user specifies the row and column coordinates of the
% upper-left corner of the desired area,along with the subimage's
% width and height.The passed image is deleted.  
%
% Syntax :
% -------
% outImage = crop_cvip( inImage, sizeSI, startPoint)
%   
% Input Parameters include:
% -------------------------
%   'inImage'         1-band input image of MxN size or 3-band input image of   
%                     MxNx3 size.The input image can be of uint8 or uint16 
%                     or double class. 
%   'sizeSI'          Size of the subimage, i.e. width and height of
%                     subimage.Row or column vector of length 2.
%                      sizeSI(1): height                     
%                      sizeSI(2): width 
%   'startPoint'      Starting point of subimage, i.e. row and column  
%                     coordinates of upper left corner.A vector of length 2. 
%                      startPoint(1): row                  
%                      startPoint(2): column               
%                                                         ([1 1] | default)                     
%
% Output Parameter include:  
% --------------------------
%  'outImage'        Cropped subimage
%                                         
%
% Example :
% -------
%        %Crop subimage with default parameter
%                   I = imread('cam.bmp');      %original image
%                   O1 = crop_cvip(I, [200 180]); 
%                  figure;imshow(O1,[]);
%        %Crop subimage with user defined parameter
%                   O2 = crop_cvip(I,[120 150], [50 50]);              
%                    figure;imshow(O2,[]);
%
% Reference
% ---------
%  1.Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition. 

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    4/14/2017
%           Latest update date:     4/14/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

%check number of input arguments
if nargin ~=1 && nargin ~= 2 && nargin ~= 3  
    error('Too many or too few input arguments!');
end

%check number of output arguments
if nargout ~= 1 && nargout ~= 0
    error('Too many output arguments!');
end


default_startPoint = [1 1]; %default row and column

%set up the default parameters
if ~exist('startPoint', 'var') || isempty(startPoint)
    startPoint = default_startPoint;
end  
if ~exist('sizeSI', 'var') || isempty(sizeSI)
    error('Specify the size of a subimage!');
end  



%crop the image
%check if sub-image's size,i.e. width and height, are within limit of
%original input image
[nrow, ncol,~] = size(inImage);
if sizeSI(1)+ startPoint(1)-1 > nrow
    sizeSI(1) = nrow - startPoint(1);
end
if sizeSI(2)+ startPoint(2)-1 > ncol
    sizeSI(2) = ncol - startPoint(2);
end

outImage = inImage(startPoint(1):startPoint(1)+sizeSI(1)-1,...
    startPoint(2):startPoint(2)+sizeSI(2)-1,:);

end % end of function
