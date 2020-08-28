function [outImage] = rotate_cvip(inImage, theta)
% ROTATE_CVIP - Rotate the image by an angle (Range 1~360,degree)specified by the user .
% The function rotates the image by the degree specified.The
% transformation equation used are X=xcos(rads)+ysin(rads);
% Y=-xsin(rads)+ycos(rads);Where, X=shifted x co-ordinate,Y = shifted
% y co-ordinate, and rads=number of radians to be rotated.For the 4
% corners of the image,the shifted co-ordinates are  found out and from
% that the new image size can be calculated. For each co-ordinate in the
% new image the corresponding co-ordinate in the old image is calculated,
% if it falls with in the range of the old image size,the corresponding
% pixel value is copied,otherwise the pixel value is set to zero.
%
%
% Syntax :
% ------
% outImage = rotate_cvip(inImage)
% outImage = rotate_cvip(inImage, theta)
%    
% Input Parameters include :
% ------------------------
%   'inImage'       Input image of MxN or MxNxB size. 
%   'theta'         Angle in degree (-360 < theta < +360).
%                                                            (90 | default)
%                                                               
%
% Output Parameter include :  
% ------------------------
%   'outImage'      Rotated image
%
%
% Example 1
% -------
%     %Perform rotation using default parameters
%       I = imread('cam.bmp');         
%       O1 = rotate_cvip(I); 
%       figure; imshow(O1/255);
%
% Example 2
% ---------
%     %Perform rotation using user-specified parameters    
%       O2 = rotate_cvip(I,-60); 
%       figure; imshow(O2/255);
%               
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications 
%    with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    06/02/2017
%           Modified by:            Julian Rene Cuellar Buritica
%           Latest update date:     04/03/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.3  08/28/2018  20:08:07  jucuell
 % start adding revision history and deleting old commented code
%
 % Revision 1.2  03/31/2018  11:17:34  jucuell
 % error when rotate non-square images to 90,180,-90,180 degrees 
 % adding variable Nsize = size(inImage); to determine rows to add
%
 % Revision 1.1  01/21/2018  10:20:55  jucuell
 % Initial revision
 % image is not showing when is applied to color images and is not
 % performed in non-square size images
%

%check number of input and output arguments
if nargin ~= 1 && nargin ~= 2 
    error('Too many or too few input arguments!')
end
if nargout ~= 0 && nargout ~= 1 
    error('Too many or too few output arguments!')
end

%setting up the default parameters
default_theta = 90;
if ~exist('theta', 'var') || isempty(theta)
    theta = default_theta;
end

%find the numbers of rows, columns, and bands
[nRow, nCol, nBand] = size(inImage);

%angle in rad
rads = theta/180*pi;

%old border pixel locations
old_bord = [1 1; 1 nCol; nRow 1; nRow nCol];

%rotate the border pixel locations
rot_bordpix = [old_bord(:,1)*cos(rads) + old_bord(:,2)*sin(rads)...
            -old_bord(:,1)*sin(rads) + old_bord(:,2)*cos(rads)];
min_bordpix = min(rot_bordpix);
max_bordpix = max(rot_bordpix);

%find new border pixels
rc_min = min([1 1], min_bordpix);
rc_max = max([1 1], max_bordpix);

%new width and height of pixels
hw = uint16(ceil(rc_max - rc_min));    

%create row index and col index
[rind, cind] = ndgrid(1:double(hw(1)),1:double(hw(2)));

%map new indices to old indices
rind_old = (rind + rc_min(1))*cos(-rads) + (cind + rc_min(2))*sin(-rads);
cind_old = -(rind + rc_min(1))*sin(-rads) + (cind + rc_min(2))*cos(-rads);

rind_old = ceil(rind_old);
cind_old = ceil(cind_old);

inImage = [inImage zeros(nRow,hw(2)-nCol+1, nBand)];    %add columns
Nsize = size(inImage);
inImage = [inImage; zeros(hw(1)-nRow +1,Nsize(2), nBand)];

rind_old (rind_old < 1 | rind_old > nRow) = nRow + 1;
cind_old (cind_old < 1 | cind_old > nCol) = nCol + 1;

%copy the pixel value from old image to new image
%x,y,z must be of same size,
outImage = zeros(size(inImage));
rind_old = [[rind_old (nRow+1)*ones(hw(1), size(inImage,2)-hw(2))]; ...
    (nRow+1)*ones(size(inImage,1)-hw(1),size(inImage,2))];
cind_old = [[cind_old (nCol+1)*ones(hw(1), size(inImage,2)-hw(2))]; ...
    (nCol+1)*ones(size(inImage,1)-hw(1),size(inImage,2))];

for b =1:nBand
    outImage(:,:,b) = arrayfun(@(x,y,z) inImage(y,z,b), inImage(:,:,b), ...
        rind_old, cind_old);
end

outImage = outImage(1:hw(1),1:hw(2),:);

end % end of function