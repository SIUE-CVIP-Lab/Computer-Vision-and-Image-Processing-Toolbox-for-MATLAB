function [ after_hysteresis, edge_mag_suppressed,  before_suppression] = shen_castan_ed_cvip( input_image, a00 , low_thresh, high_thresh)
% SHEN_CASTAN_ED_CVIP- performs edge detection.
%
% Syntax :
% ------
% [ after_hysteresis, edge_mag_suppressed,  before_suppression] = shen_castan_ed_cvip( input_image, a00 , low_thresh, high_thresh)
% 
%
% Input Parameters include :
% -------------------------
%   'input_image'   Input image can be gray image or rgb image of MxN size. 
%  
%   'a00'           Smoothing factor. A value in the interval (0,1).
%
%   'low_thresh'    The low threshold value for hystersis thresholding.  
%                   A number in the range 0-10. 
%
%   'high_thresh'   The high threshold value for hystersis thresholding.  
%                   A number in the range 0-10. 
%
%
%
%
% Example :
% -------      
%                 input = imread('butterfly.tif');
%                 a00 = .9;
%                 low_thresh = 1;
%                 high_thresh = 4;
%                 [ after_hysteresis, edge_mag_suppressed,  before_suppression] = shen_castan_ed_cvip( input, a00  , low_thresh, high_thresh); 
%                 figure; imshow(hist_stretch_cvip(before_suppression,0,1,0,0));
%                 figure; imshow(hist_stretch_cvip(edge_mag_suppressed,0,1,0,0));
%                 figure; imshow(after_hysteresis,[]);
%
% Reference
% ---------
% 1.S.Castan,J.Zhao and J.Shen,"New edge detection methods based on exponential filter," 
%   [1990] Proceedings. 10th International Conference on Pattern Recognition, 
%   Atlantic City, NJ, 1990, pp. 709-711 vol.1.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    7/11/2017
%           Latest update date:     7/14/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================


global a0;

a0 = a00;
edge_mag_suppressed = double(input_image);
before_suppression = double(input_image);
for band=1:size(input_image,3)
    
    [Ix,Iy,~,~] = shen_alg_single_band(input_image(:,:,band));  
    % This is the first method from the paper to extract the edges. it is
    % on the 2nd page of the paper, number 1. Edges from the maxima of
    % gradient.
    %
    %   The 2nd method may be developed in the future employing the current
    %   shen_alg_single_band() function. In the current developed method we
    %   do not use Ixx, and Iyy although they are calculated in
    %   shen_alg_single_band.
    edge_mag = sqrt( (Iy.^2) + (Ix.^2));
    edge_dir = atan2(-Ix,-Iy);
    
    before_suppression(:,:,band) = edge_mag;
    
    edge_mag_suppressed(:,:,band) = non_maxima_suppression(edge_mag,edge_dir);
    
end

after_hysteresis = hysteresis_thresholding(edge_mag_suppressed, low_thresh, high_thresh);


end



function [new_edge_mag] = non_maxima_suppression(edge_mag,edge_dir)
%% nonmaxima suppression
[m,n,~] = size(edge_mag);
new_edge_mag = edge_mag;
directions = [0 pi/4 pi/2 3*pi/4 pi -pi -3*pi/4 -pi/2 -pi/4];
% for k=1:1
k=1;
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
% end

end


function Iout = hysteresis_thresholding(edge_mag, low_thresh, high_thresh)
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
Iout = edge_mag;

% figure; imshow(Iout,[]);

end


function [Ix,Iy,Ixx,Iyy] = shen_alg_single_band(I)
I = double(I);
first = conv_f1(I,'y');
sec = conv_f2(first,'y');
L = conv_f2(sec,'x');
R = conv_f1(sec,'x');

Ix = L- R;
Ixx = L + R - (2*sec);



first = conv_f1(I,'x');
sec = conv_f2(first,'x');
L = conv_f2(sec,'y');
R = conv_f1(sec,'y');

Iy = L- R;
Iyy = L + R - (2*sec);
end

function I1 = conv_f1(I, dir)
global a0;

I = double(I);
[m,n] = size(I);
I1 = zeros(m,n);
switch dir
    case 'x'
        I1(:,1) = a0*I(:,1);
        for i = 2:n
            I1(:,i) = I1(:,i-1) + a0*(I(:,i) - I1(:,i-1));
        end
    case 'y'
        I1(1,:) = a0*I(1,:);
        for i = 2:m
            I1(i,:) = I1(i-1,:) + a0*(I(i,:) - I1(i-1,:));
        end
end

end

function I2 = conv_f2(I, dir)
global a0;

I = double(I);
[m,n] = size(I);
I2 = zeros(m,n);
switch dir
    case 'x'
        I2(:,n) = a0*I(:,n);
        for i = n-1:-1:1
            I2(:,i) = I2(:,i+1) + a0*(I(:,i) - I2(:,i+1));
        end
    case 'y'
        I2(m,:) = a0*I(m,:);
        for i = m-1:-1:1
            I2(i,:) = I2(i+1,:) + a0*(I(i,:) - I2(i+1,:));
        end
end

end