function [ outImage] = igs_cvip( inImage, graylevel)
% IGS_CVIP - IGS gray level quantization of an image.
% The function performs the gray level quantization of an image using
% improved gray scale (IGS) method. The number of gray-level must be a
% power of 2.IGS minimizes false contouring that can occur in areas that
% appear to be uniform, but also adds a dithered effect to the image 
% which may not be desired for segmentation.It is recommended that 
% morphological filtering is performed, for example erosion, before using
% the segmented image for feature extraction. 
%
% Syntax :
% -------
% outImage = igs_cvip(inImage, graylevel)
%   
% Input Parameters include :
% -------------------------
%   'inImage'       1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. The input image can be of uint8 or double
%                   class. If double class, the function assumes
%                   the data range of image is from 0 to 1.
%   'graylevel'     Number of gray levels. It must be a power of 2, but not
%                   greater than 256.
%
%
% Output Parameter include :  
% ------------------------
%   'outImage'      Quantized image having same size and same class of
%                   input image. 
%                                         
%
% Example :
% ------- 
%                   I = imread('butterfly.tif');     %original image
%                   O1 = igs_cvip(I);                %default graylevel = 4          
%                   graylevel = 16;                  %new graylevel
%                   O2 = igs_cvip(I,graylevel);      %user specified graylevel
%                   figure;imshow(O2,[]);
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


if nargin ~= 1 && nargin ~= 2 
    error('Too many or too few input arguments!')
end
if nargout ~= 0 && nargout ~= 1
    error('Too many or too few output arguments!')
end

%set up default parameters
if nargin == 1
    graylevel = 4;
else      
    %check if the gray level is power of 2
    if mod(log2(graylevel),1)
        warning('The number of gray levels must be power of 2! Default option for number of gray levels is selected!');
        graylevel = 4;
    elseif graylevel>256
        warning('The number of gray levels must be less than 256! Default option for number of gray levels is selected!');
        graylevel = 4;
    end
end

%check image data is of 8-bits unsigned integer type
if ~isa(inImage,'uint8')
    inImage = uint8(inImage);
end

%compute improved gray-scale(igs) quantized images
outImage = inImage;
[n_rows, n_cols, n_bands] = size(inImage);
initial = 128;
sum=zeros(n_rows,1,n_bands);
mask = initial;

i=graylevel/2;
while i>1
    initial =initial/2; mask = bitor(mask,initial); i=i/2;
end
complement = 255-mask;
randbits_check=(bitand(inImage,mask)~=mask);

for c=1:n_cols
    sum=double(inImage(:,c,:))+randbits_check(:,c,:).*double(bitand(uint8(sum),complement));
    outImage(:,c,:)=bitand(uint8(sum),mask);
end

end

%end of function grayquantCVIP
