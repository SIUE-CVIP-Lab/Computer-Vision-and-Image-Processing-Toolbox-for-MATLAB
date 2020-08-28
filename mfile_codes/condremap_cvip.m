function [ outImage ] = condremap_cvip( inImage, rangeIn, datatype)
% CONDREMAP_CVIP - perfom conditional remapping,user specified range and data type.
% The function linearly remaps the data range of input image into new 
% range.The user has choice to either specify the new range or let the 
% function choose the default parameter.For the remapped image, the user 
% can explicitly define the new datatype or let the function to select 
% same class of input image.First, it remaps the image into the user 
% defined range.Second, the function checks whether the new range is 
% within the maximum range of user specfied datatype.If not, the 
% function remaps the output image into the maximum range of user 
% specified datatype.
%
% Syntax :
% -------
% outImage = condremap_cvip(inImage, rangeIn,datatype)
%    
% Input Parameters include :
% ------------------------
%   'inImage'        1-band input image of MxN size or 3-band input image of   
%                    MxNx3 size.The input image can be of uint8 or uint16
%                    or double class.If double class, the function assumes
%                    the data range of image is from 0 to 1.
%  'rangeIn'         New data range of image.A row vector or column
%                    vector of length two.First element should be low end
%                    and second element should be high end.
%  'datatype'        Class of the remapped image.It can be uint8 or uint16 
%                    or double.
%
%
% Output Parameter include :  
% ------------------------
%   'outImage'        Remapped image having same size of input image. But, 
%                     the class can be either user specified class type or
%                     or same class as of input image.  
%                                         
% Example :
% -------
%                   I = imread('butterfly.tif');     %original image
%                   O1 = condremap_cvip(I);          %default range & class          
%                   rangeIN = [0 4e+4];              %new range
%                   O2 = condremap_cvip(I,rangeIN,'uint16');      %user specified range and class
%                   figure;imshow(O2,[]);
%
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    3/20/2017
%           Latest update date:     3/23/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

if nargin ~= 1 && nargin ~= 2 && nargin ~= 3
    error('Too many or too few input arguments!')
end
if nargout ~= 0 && nargout ~= 1
    error('Too many or too few output arguments!')
end

%set up default parameters
if nargin == 1
    datatype = class(inImage);
    rangeIn = [];
else      
    if nargin == 2
        datatype = class(inImage);        
    end      
    if length(rangeIn) == 1
        rangeIn(2) = rangeIn;
        rangeIn(1) = 0; 
    elseif length(rangeIn)>2
        rangeIn = [min(rangeIn) max(rangIn)];
    end
end

%find the maximum range of data type
if strcmp(datatype,'uint8')
    max_range = [0 2^8-1];
elseif strcmp(datatype,'uint16')
    max_range = [0 2^16-1];
else  %otherwise, assume datatype as double 
    max_range = [0.0 1.0];
end
inImage = double(inImage);
[nrow,ncol,nband] = size(inImage);

if ~isempty(rangeIn)
    %First, convert the image into user's input range
    ymin=rangeIn(1);
    ymax=rangeIn(2);
    xmax=max(max(inImage));
    xmin=min(min(inImage));   
    outImage = repmat(ymax-ymin,[nrow ncol nband])...
        ./repmat(xmax-xmin,[nrow ncol 1]).*(inImage - repmat(xmin,[nrow ncol 1]))...
        +repmat(ymin,[nrow ncol nband]);  
    
    %Second, check if user's new range is within the range of user's new
    %datatype
    % if the user's input range is not within the range of user's datatype, 
    %it will be remapped into maximum range of the datatype
    if rangeIn(1) < max_range(1) || rangeIn(2) > max_range(2)
        xmax=max(max(outImage));
        xmin=min(min(outImage));
        outImage = repmat(max_range(2)-max_range(1),[nrow ncol nband])...
                ./repmat(xmax-xmin,[nrow ncol 1]).*(outImage - repmat(xmin,[nrow ncol 1]))...
                +repmat(max_range(1),[nrow ncol nband]); 
    end
else %if rangeIN is empty, then the image is remapped into the maximum 
    % range of new datatype
    outImage = remap_cvip(inImage, max_range);  
end

%Final, type conversion
if strcmp(datatype,'uint8')   
    outImage = uint8(outImage);
elseif strcmp(datatype,'uint16')     
    outImage = uint16(outImage);
end

end

