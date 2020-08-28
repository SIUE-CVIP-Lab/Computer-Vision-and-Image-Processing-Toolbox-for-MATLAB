function [ outImage ] = relative_remap_cvip( inImage, rangeIn )
% RELATIVE_REMAP_CVIP  - Relative remapping of an image data.
% The function linearly remaps the data range of input image into new  
% range.The user has choice to either specify the new range or let the 
% function choose the default range.If the user doesn't pass the 
% rangeIn input parameter,the default range is maximun possible range of 
% the datatype of input image.And in case of multiband image, the 
% function performs the relative remapping, and to perform it, first, it 
% finds the band having highest range.Second, it finds the mapping
% parameters corresponding to that band and maps all bands using same 
% parameters. 
%
% Syntax :
% ------
% outImage = relative_remap_cvip(inImage, rangeIn)
% 
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
%                   I = imread('butterfly.tif');          %original image
%                   O1 = relative_remap_cvip(I);          %default range          
%                   rangeIN = [0 240];                    %new range
%                   O2 = relative_remap_cvip(I,rangeIN);  %user specified range
%                   figure;imshow(O1,[]);
%                   figure;imshow(O2,[]);
%
% Reference :
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    3/15/2017
%           Latest update date:     3/23/2017
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

inImage = double(inImage);
[nrow,ncol,nband] = size(inImage);

%First, convert the image into user's input range
 xmax=max(max(inImage));
 xmin=min(min(inImage));
 ymax = rangeIn(2);
 ymin = rangeIn(1);

%relative linear remapping for multiband case, first find the band that has
%largest range, and remap according to that band's information
if nband > 1 %multiband image case
    maxmrange_band = max(max(inImage))-min(min(inImage));
    maxval = maxmrange_band(1);
    bandid = 1;
    for i=2:nband
        if maxmrange_band(i) > maxval
            maxval = maxmrange_band(i);
            bandid = i;
        end
    end
    outImage = (ymax-ymin)/(xmax(bandid)-xmin(bandid))*(inImage- xmin(bandid))...
        + ymin;
else  %single band image case   
    outImage = repmat(ymax-ymin,[nrow ncol])...
        ./repmat(xmax-xmin,[nrow ncol]).*(inImage - repmat(xmin,[nrow ncol]))...
        +repmat(ymin,[nrow ncol]);    
end     

%Final, type conversion
if strcmp(datatype,'uint8')   
    outImage = uint8(outImage);
elseif strcmp(datatype,'uint16')     
    outImage = uint16(outImage);
end

end



