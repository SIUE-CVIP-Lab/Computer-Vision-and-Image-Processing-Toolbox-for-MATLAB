function [ outImage ] = otsu_cvip( inImage )
% OTSU_CVIP -Otsu thresholding segmentation of an image. 
% Otsu method performs the thresholding of an image by finding the 
% threshold  value that minimizes the weighted within-class variance.
% Otsu method works best with bimodal histogram, a histogram with two 
% major peaks. No parameters to enter. 
%
% Syntax :  
% ------
% outImage = otsu_cvip(inImage)
%   
% Input Parameter include :
% -----------------------
%   'inImage'       1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. If 3-band image, it is converted into 
%                   1-band using luminance method.
%                   string or cell class.
%
%
% Output Parameter include :  
% ------------------------
%   'outImage'      Otsu thresholded image 
%                         
%
% Example :
% -------
%                   I = imread('cam.bmp');        %original image
%                   O = otsu_cvip(I);             %otsu thresholded image
%                   figure;imshow(remap_cvip(O,[]));
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    2/10/2017
%           Latest update date:     3/27/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

[nrow, ncol, no_of_bands] = size(inImage);
% inImage = uint8(remap_cvip(inImage,[0 255]));
total_pixels = nrow*ncol;
sigma = zeros(256,1);
outImage = inImage;
for bands = 1: no_of_bands
    tmp = 0.0;
    %find histogram of image
    hist_img=hist_create_cvip(inImage(:,:,bands));
    hist_prob = hist_img/total_pixels; 
    
    %find the otsu threshold for each band and perform thresholding
    for t=1:256
        w0t = sum(hist_prob(1:t));
        w1t = sum(hist_prob(t+1:end));
        a=1:t;
        b=t+1:256;
        mean0t = (a*hist_prob(1:t))/w0t;
        mean1t = (b*hist_prob(t+1:end))/w1t;
        sigma(t) = w0t*w1t*(mean0t-mean1t)^2;    
        %update the otsu_threshold, until the maximum variance is not
        %achieved
        if (sigma(t)>tmp)
            otsu_threshval = t-1;
            tmp = sigma(t);
        end
    end
    tempImage = outImage(:,:,bands);
    tempImage(tempImage>=otsu_threshval)=255;
    tempImage(tempImage<otsu_threshval)=0;
    outImage(:,:,bands) = tempImage;
end  

end% end of otsu_segment function

