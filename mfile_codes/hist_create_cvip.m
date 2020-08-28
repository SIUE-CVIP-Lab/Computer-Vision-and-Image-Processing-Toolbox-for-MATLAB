function [ hist_count] = hist_create_cvip( inImage )
% HIST_CREATE_CVIP -Histogram of an image.
% The function computes the histogram of an image. The input image can be
% either 1-band or 3-band image. For each band, it finds the frequencies 
% of each unique gray level. 
%
% Syntax :
% -------
% hist_count = HIST_CREATE_CVIP(inImage)
%   
% Input Parameter include :
% -----------------------
%   'inImage'       1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. It is of uint8 or uint16 or double class.
%
%
% Output Parameter include :  
% ----------------------
%   'hist_count'    Histogram of an image. GxB array with histogram of each 
%                   band in each column. B is equal to number of bands.                       
%
% Example :
% -------
%                 I = imread('cam.bmp');
%                 % histogram of an image
%                 hist = hist_create_cvip(I);
%                 figure;imshow(I);title('Input Image');
%                 figure;bar(hist);
% 
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    2/15/2016
%           Latest update date:     3/22/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================


%size of the image
nbands= size(inImage,3);

%find the number of levels
if isa(inImage,'double')
    if nbands == 3
        %find number of unique gray levels in the image
        grayImg = 0.3*inImage(:,:,1)+0.6*inImage(:,:,2)+0.1*inImage(:,:,3);
        if length(unique(grayImg))>256
            inImage = uint16(inImage*(2^16-1));
            total_levels = 2^16;
        else
            inImage = uint8(inImage*(2^8-1));
            total_levels = 2^8;
        end
    end
else
    total_levels = 2^8;
end
hist_count=zeros(total_levels,nbands);  

for bands=1:nbands
    %find all unique gray levels in an image       
    graylevel_set = double(unique(inImage(:,:,bands)));
    for i=1:size(graylevel_set,1)
        tempImage = inImage(:,:,bands);
        num_grayval = find(tempImage == graylevel_set(i));                 
        hist_count(graylevel_set(i)+1,bands)= length(num_grayval);         
    end
end

end%end of the function

