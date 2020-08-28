function [ outImage ] = remap_cvip( inImage, rangeIn )
% REMAP_CVIP - Remaps the data range of input image.
% The function linearly remaps the data range of input image into new 
% range.The user has choice to either specify the new range or let the 
% function choose the default parameter.If the user doesn't pass the 
% rangeIn input parameter, the program selects the maximun range of the
% datatype of input image as the new range.And in case of multiband 
% image,the function performs the remapping in each band irrespective 
% of the range of other bands. 
%
%
% Syntax:
% ------
% outImage = remap_cvip(inImage, rangeIn)
%    
% Input Parameters include :
% ------------------------
%   'inImage'       1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. The input image can be of uint8 or uint16
%                   or double class. If double class, the function assumes
%                   the data range of image is from 0 to 1.
%   'rangeIn'       New data range of image. A row vector or column
%                   vector of length two. First element should be low end
%                   and second element should be high end.
%
%
% Output Parameter include :  
% ------------------------
%   'outImage'      Remapped image having same size and same class as that
%                   of input image.  
%                                         
%
% Example :
% -------
%                   I = imread('butterfly.tif');      %original image
%                   O1 = remap_cvip(I);               %default range          
%                   rangeIN = [0 240];                %new range
%                   O2 = remap_cvip(I,rangeIN);       %user specified range
%                   figure;imshow(O1,[]);
%                   figure;imshow(O2,[]);
%
% Reference :
% ---------
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    7/29/2016
%           Latest update date:     3/22/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

%check number of input and output arguments
if nargin ~= 1 && nargin ~= 2 
    error('Too many or too few input arguments!')
end
if nargout ~= 0 && nargout ~= 1
    error('Too many or too few output arguments!')
end

%check input image data type
if isa(inImage,'uint8')
    datatype = 'uint8';
    max_range = [0 2^8-1];
elseif isa(inImage,'double')
    datatype = 'double';
    max_range = [0.0 1.0];
elseif isa(inImage,'uint16')
    datatype = 'uint16';
    max_range = [0 2^16-1];
end
%set up default input parameters
if nargin == 1    
    rangeIn = max_range;   
elseif nargin == 2   
    if isempty(rangeIn)
        rangeIn = max_range; 
    end        
end 

%remapping in each band independently
inImage = double(inImage);
ymin=rangeIn(1);
ymax=rangeIn(2);
[~,~,nbands] = size(inImage);
outImage = inImage;
xmax=max(max(inImage));
xmin=min(min(inImage));
for b = 1:nbands
    outImage(:,:,b)= ((ymax-ymin)/(xmax(1,1,b)-xmin(1,1,b)))*...
        (inImage(:,:,b)-xmax(1,1,b))+ymax;
end

%Final, type conversion
if strcmp(datatype,'uint8')   
    outImage = uint8(outImage);
elseif strcmp(datatype,'uint16')     
    outImage = uint16(outImage);
end  %else output will be of double class

end

