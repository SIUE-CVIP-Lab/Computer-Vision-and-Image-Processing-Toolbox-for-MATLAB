function [out_img, new_edge_mag, edge_dir] = canny_ed_cvip( input_image, sigma, low_thresh, high_thresh )
% CANNY_ED_CVIP -  perform a Canny edge detection on the image.
%
% Syntax:
% -------
% out_img = canny_ed_cvip( input_image, sigma, low_thresh, high_thresh )
%   
% Input Parameters include :
% -------------------------
%
%  'input_image'   Input image can be gray image or rgb image of MxN size. 
%                   
%  'sigma'         The Gaussian variance.  
%     
% 'low_thresh'     The low threshold value for hystersis thresholding.  
%                  A number in the range 0-10. 
% 'high_thresh'    The high threshold value for hystersis thresholding.  
%                  A number in the range 0-10. 
%   
%                                        
% Output Parameter include :
% ------------------------
%
%   'out_img'      The output image after edge detection.
%                  An image with the same size as the input image.
%
%
% Example :
% -------
%              input_image = imread('butterfly.tif');
%              sigma = 3;
%              low_thresh = 1;
%              high_thresh = 3;
%              out = canny_ed_cvip( input_image, sigma, low_thresh,high_thresh );
%              figure; imshow(hist_stretch_cvip(out,0,1,0,0),[]);
%
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    05/03/2017
%           Modified by:            Julian Rene Cuellar Buritica
%           Latest update date:     08/29/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.2  08/29/2018  23:01:47  jucuell
 % allowing the function to provideintermediate images as outputs.
%
 % Revision 1.1  05/03/2017  20:04:06  jucuell
 % Initial coding and testing.
%
                  
n = 2*floor(3.35*sigma + 0.33) + 1;
siz   = (n-1)/2;
std2   = sigma^2;

[x,y] = meshgrid(-siz:siz,-siz:siz);
arg   = -(x.*x + y.*y)/(2*std2);

h     = exp(arg);
h(h<eps*max(h(:))) = 0;

sumh = sum(h(:));
if sumh ~= 0
    h  = h/sumh;
end
 
input_image = double(input_image);
[m,n,o] = size(input_image);
I = zeros(m,n,o);
for i=1:o
    I(:,:,i) = conv2(input_image(:,:,i), h,'same');
end

hor = 1/2*[-1 1;-1 1];
ver = 1/2*[-1 -1;1 1];

s1 = zeros(m,n,o);
s2 = zeros(m,n,o);
for i=1:o
    s1(:,:,i) = conv2(I(:,:,i), hor,'same');
    s2(:,:,i) = conv2(I(:,:,i), ver,'same');
end

edge_mag = sqrt((s1.^2) + (s2.^2));     % high range output. needs hist stretch to 0-1
edge_dir = atan2(-s1,-s2);

%% nonmaxima suppression
new_edge_mag = edge_mag;
directions = [0 pi/4 pi/2 3*pi/4 pi -pi -3*pi/4 -pi/2 -pi/4];
for k=1:o
    for i=2:(m-1)
        for j=2:(n-1)
            [~,dir] = min(abs(edge_dir(i,j,k) -  directions));
            if dir ==5 || dir == 6 || dir ==1
                if edge_mag(i,j,k) < edge_mag(i+1,j,k) || edge_mag(i,j,k) < edge_mag(i-1,j,k)
                        new_edge_mag(i,j,k) = 0;
                end
            elseif dir == 3 || dir == 8
                if edge_mag(i,j,k) < edge_mag(i,j+1,k) || edge_mag(i,j,k) < edge_mag(i,j-1,k)
                        new_edge_mag(i,j,k) = 0;
                end
            elseif dir == 4 || dir ==9
                if edge_mag(i,j,k) < edge_mag(i-1,j+1,k) || edge_mag(i,j,k) < edge_mag(i+1,j-1,k)
                        new_edge_mag(i,j,k) = 0;
                end
            elseif dir == 2 || dir == 7
                if edge_mag(i,j,k) < edge_mag(i+1,j+1,k) || edge_mag(i,j,k) < edge_mag(i-1,j-1,k)
                        new_edge_mag(i,j,k) = 0;
                end
            end
        end
    end
end

edge_mag = new_edge_mag;

%% hystersis thresholding
if (high_thresh ~= -1)
    edge_mag(1,:,:) = 0;
    edge_mag(end,:,:) = 0;
    edge_mag(:,1,:) = 0;
    edge_mag(:,end,:) = 0;
%     figure; imshow(edge_mag,[]);    % before hystersis

    high_thresh = (high_thresh/10)*max(edge_mag(:));    % high_thresh is now converted to a value in the range of the image
    low_thresh = (low_thresh/10)*high_thresh;           % low_thresh is also converted as above.
    [x,y,z] = ind2sub(size(edge_mag),find(edge_mag> high_thresh));
    for i=1:length(x(:))
        block = edge_mag(x(i)-1:x(i)+1,y(i)-1:y(i)+1, z(i));
        block(block <= low_thresh) = 0;
        block(block > low_thresh) = high_thresh + 1;
        edge_mag(x(i)-1:x(i)+1,y(i)-1:y(i)+1, z(i)) = block;
    end
    
    edge_mag(edge_mag > high_thresh) = 255;
    edge_mag(edge_mag <= high_thresh) = 0;
end
out_img = edge_mag;

% figure; imshow(out_img,[]); % after hystersis


end
