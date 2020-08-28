function outImage = copy_paste_cvip( srcImage, destImage, startLocs, sizeSubimg, destLocs, transparent)
% COPY_PASTE_CVIP- Copy a subimage from one image and paste to the same or another image.
% The function copies a subimage from the srcImage and paste it to the
% destImage.It is designed for the cross-image copy-paste, but it also
% works for copy-paste within the samge image, which is indicated by
% making srcImage == destImage). 
% If the subimage is too large, the size will be adjusted automatically
% so the subimage can be successfully copied from the srcImage and pasted
% to the destImage.
% If srcImage is 1-band image and destImage is 3-band image, then
% srcImage is made as 3-band image by copying same band information to
% other bands before pasting to destImage. In other case, if srcImage is
% 3-band image and destImage is 1-band image, only first band of scrImage
% is pasted to destImage.
%
% Syntax :
% -------
% outImage = copy_paste_cvip( srcImage, destImage, startLocs, sizeSubimg, destLocs, transparent)
%   
% 
% Input Parameters include :
% ------------------------
%     'srcImage'      Source image to copy the subimage. 1-band input image
%                     of MxN size or 3-band input image of MxNx3 size. 
%    'destImage'      Destination image for pasting
%    'startLocs'      Starting point of upper-left corner of the subimage on
%                     srcImage. A vector of length 2 (Eg. [1 1]).
%                     startLocs(1): Row value                   
%                     startLocs(2): Column value  
%   ' sizeSubImg'     Size of desired subimage. A vector of length 2. 
%                     (Eg. [1 1]). 
%                     sizeSubImg(1): height                   
%                     sizeSubImg(2): width 
%    'destLocs'       Starting point of upper-left corner of the destImage
%                     area to paste the subimage. A vector of length 2 (Eg.
%                     [1 1]). 
%                     destLocs(1): Row value                   
%                     destLocs(2): Column value  
%    'transparent'    Whether the paste is transparent or not (1 or 0).
%
%
% Output Parameter include :  
% ------------------------
%    'outImage'        Output image after copy-paste operation.
%                                         
%
% Example :
% -------
%                   I1 = imread('cam.bmp');          %source image
%                   I2 = imread('butterfly.tif');   %destination image         
%                   O = copy_paste_cvip( I1, I2, [10 5], [150 200], [64 64], 1);
%                   figure; subplot(1,2,1); imshow(I1) ;
%                   subplot(1,2,2); imshow(I2);
%                   figure; imshow(O);                                        
%
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications 
%    with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    4/14/2017
%           Modified by:            Julian Rene Cuellar Buritica
%           Latest update date:     08/29/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
 % Revision 1.3  08/29/2018  11:00:35  jucuell
 % start adding revision history and deleting old commented code
%
 % Revision 1.2  04/03/2018  23:01:47  jucuell
 % adding new elseif case to crop big source images before paste (> R2, > C2)
%
 % Revision 1.1  03/27/2018  20:04:06  jucuell
 % Initial revision:
 % initiate variable datatypeFlag =0; does not copy a bigger image inside a
 % small one
%

%check number of input arguments
if nargin ~=1 && nargin ~= 2 && nargin ~= 3 && nargin ~= 4 && ...
        nargin ~= 5 && nargin ~= 6    
    error('Too many or too few input arguments!');
end

%check number of output arguments
if nargout ~= 1 && nargout ~= 0
    error('Too many output arguments!');
end

datatypeFlag =0;
%check if srcImage and destImage is uint8 image
if isa(srcImage, 'uint8') && isa(destImage, 'uint8')
    datatypeFlag =1;
end

%size of the input image
[R1, C1, B1] = size(srcImage);
[R2, C2, B2] = size(destImage);

%find the subimage that needs to be pasted
start_r = startLocs(1);
start_c = startLocs(2);
height = sizeSubimg(1);
width = sizeSubimg(2);

if (start_r + height-1) <= R1 && (start_c + width-1) <= C1
    subImage = srcImage(start_r : start_r + height-1, start_c : start_c ...
        + width-1,:);
else
    error('The sub-image exceeds the dimension of source image!');
end

%check the number of bands in destination image and copied image (sub-image)
%if destination image is single band, and source image is multi-band image
%then, only first band is copied
if B1 > B2 && B2 == 1  
    subImage = subImage(:,:,1); 
%if source image is 1-band & destination image is 3-band
elseif B1 < B2 && B2 == 3  
    subImage(:,:,B1:B2) = repmat(subImage,[1 1 3]);
end

%check if transparent argument is either 1 or 0
if transparent ~=1 && transparent ~= 0
    transparent = 0;
    warning('Transparent arg must be 1 or 0! Transparent pasting is set OFF!\n');
end

%paste the copied image to destination image
dest_r = destLocs(1);
dest_c = destLocs(2);
destImage = double(destImage);
subImage = double(subImage);

if (dest_r + height -1) <= R2 && (dest_c + width-1) <= C2
    destImage(dest_r: dest_r+height-1, dest_c: dest_c +width-1, :) = ...
       destImage(dest_r: dest_r+height-1, dest_c: dest_c +width-1, :)*...
       transparent + subImage;
elseif (dest_r + height -1) <= R2 && (dest_c + width-1) > C2
    destImage(dest_r: dest_r+height-1, dest_c:end, :) = ...
       destImage(dest_r: dest_r+height-1, dest_c: end, :)*transparent + ...
       subImage(:,1:C2-dest_c+1,:);
elseif (dest_r + height -1) > R2 && (dest_c + width-1) <= C2
    destImage(dest_r: end, dest_c : dest_c +width-1, :) = ...
       destImage(dest_r: end, dest_c: dest_c +width-1, :)*transparent +...
       subImage(1:R2-dest_r+1,:,:);
elseif (dest_r + height -1) > R2 && (dest_c + width-1) > C2
    destImage(dest_r: R2, dest_c : C2, :) = ...
       destImage(dest_r: end, dest_c: end, :)*transparent +...
       subImage(1:R2-dest_r+1,1:C2-dest_c+1,:);   
else
    destImage(dest_r: end, dest_c : end, :) = destImage(dest_r: end, end,:)...
        *transparent + subImage(1:R2-dest_r+1,1:C2-dest_c+1,:);
end

%remap the image if transparent options was enabled
if transparent
    outImage = remap_cvip(destImage,[0 255]);
else
    outImage = destImage;
end

if datatypeFlag
    outImage = uint8(outImage);
end

end % end of function