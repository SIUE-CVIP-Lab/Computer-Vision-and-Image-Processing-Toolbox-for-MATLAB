function [ outImage ] = local_histeq_cvip( inImage, blockSize, band)
% LOCAL_HISTEQ_CVIP - Histogram equalization on block-by-block basis.
% The function performs the histogram equalization on local areas of an
% image rather than on the image as a whole.The user may specify the size
% of blocks to use.By performing local rather than global histeq,detail
% can often be enhanced in large uniform areas of an image. 
%
% Syntax:
% -------
% outImage = local_histeq_cvip( inImage, blockSize, band)
%    
% Input Parameters include:
% -------------------------
%   'inImage'       Input image of MxN or MxNxB size. Input image is
%                   considered as 8-bit image.
%   'blockSize'     Desired block size.
%                                                             (9 | default)
%   'band'          RGB band on which to calculate histogram (1,2,3)
%                                                             (1 | default)
%
%
% Output Parameter include :  
% ------------------------
%   'outImage'      Locally hisotgram equalized image.
%                                         
%
% Example :
% -------
%         I = imread('cam.bmp');    %original image
%         O1 = local_histeq_cvip(I);           %default parameters
%         figure; imshow(O1/255);
%         O2 = local_histeq_cvip(I,32);    %user defined parameters   
%         figure; imshow(O2/255);
%         X = imread('car.bmp');
%         O3 = local_histeq_cvip(X,56,3);
%         figure;imshow(remap_cvip(O3,[]));
%
% Reference
% ---------
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.
    
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

%select the band to modify it
[R, C, B] = size(inImage);

%setting up the default parameters
if ~exist('blockSize', 'var') || isempty(blockSize)
    blockSize = 9;
end

if ~exist('band', 'var') || isempty(band)
    band = 1;
end

%find the border pixels that needs to be neglected
if mod(blockSize,2)~= 0
    padL = (blockSize-1)/2;
    odd_ = true;
else
    padL = blockSize/2;
    odd_ = false;
end

%change input Image to double type
inImage = double(inImage);

%create output image
outImage = zeros(R,C,B);

%perform histogram equalization in each block
L = 255;

for r = padL+1:R-padL
    for c = padL+1:C-padL

        %find the local block and its center element
        if odd_
            tempImage = inImage(r-padL:r+padL, c-padL:c+padL, band);
            xc = tempImage(padL+1,padL+1);
        else
            tempImage = inImage(r-padL:r+padL-1, c-padL:c+padL-1, band);
            xc = tempImage(padL, padL);
        end
        %compute the prob of histogram (pdf)
        hist_ = histcounts(tempImage, -0.5:255.5)/(blockSize^2);
%         hist_ = histcounts(tempImage, 'BinLimits', [0,255],'BinMethod',...
%                 'integers', 'Normalization', 'probability');          
        %compute cdf upto pixel value of center element
        %replace the center pixel with newly computed value
        outImage(r,c,band) = sum(hist_(1:xc+1)) * L;
        
    end
end

%for multi-band image, relatively remap other bandsin

if B>1
    %avoid divide-by-zero by replacing 0 with nan
    tempImage = inImage(:,:,band);
    tempImage(tempImage == 0) = nan;


    for b=1:B
        if b ~= band
            outImage(:,:, b) = (outImage(:,:,band)./tempImage).*inImage(:,:,b);
        end
    end

    %now replace all nan values with 0
    outImage(isnan(outImage)) = 0;
end

end