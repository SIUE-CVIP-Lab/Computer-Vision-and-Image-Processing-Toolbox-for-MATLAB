function [OutIma,RC_cell] = hough_transform_cvip(InIma,theta,rho)
% HOUGH_TRANSFORM_CVIP - returns the hough image based on the input parameters
%
% Syntax :
% --------
% [OutIma,RC_cell] = hough_transform_cvip(InIma,theta,rho)
%   
% Input Parameters include :
% --------------------------
%
%  'InIma'          This should be a binary edge detected image
%                  
%  'theta'          A single value or range of values in degrees,
%                   indicating the size of the theta dimension
%
%  'rho'         	A single value indicating the size of the rho dimension
%
% Output Parameter include :  
% --------------------------
%
%   'OutIma'        The outputted Hough Image with dimensions based on
%                   theta and rho
%
%   'RC_cell'       A cell containing the RC coordinates for each pixel in 
%                   a specific rho-theta box
%
% Example :
% -------
%                   InIma = imread('cameraman.tif');
%                   theta = [0 1 45];
%                   rho = 1;
%                   [OutIma,RC_cell] =
%                   hough_transform_cvip(InIma,theta,rho);
%                   figure;imshow(remap_cvip(out_img));
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Joey Olden
%           Initial coding date:    03/13/2020
%           Latest update date:     06/08/2020
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

% THIS FUNCTION PRODUCES THE HOUGH IMAGE
%taking the size of the input image
[xI,yI,zI] = size(InIma);
Diagonal = sqrt(xI^2 + yI^2);

%checking to make sure the input is a binary image
if size(unique(InIma(:)),1) ~= 2
    error('Please use a binary image as the input');
end

%formatting the theta range based on the user input
if size(theta,2) == 1
    theta_range = theta;
elseif size(theta,2) == 2
    theta_range = theta(1):1:theta(2);
elseif size(theta,2) == 3
    theta_range = theta(1):theta(2):theta(3);
end

%checking to see how the image was thresholded
%also changing the image to a 0 1 double image
if zI == 3 && isequal(InIma(:,:,1),InIma(:,:,2),InIma(:,:,3))
    zMax = 1;
    InIma = double(InIma(:,:,1) > min(min(InIma(:,:,1))));
    InIma = InIma(:,:,1);
    count_max = sum(InIma(:));
elseif zI == 3 && ~isequal(InIma(:,:,1),InIma(:,:,2),InIma(:,:,3))
    zMax = 3;
    InIma(:,:,1) = double(InIma(:,:,1) > min(min(InIma(:,:,1))));
    InIma(:,:,2) = double(InIma(:,:,2) > min(min(InIma(:,:,2))));
    InIma(:,:,3) = double(InIma(:,:,3) > min(min(InIma(:,:,3))));
    InIma = double(InIma);
    count_max = [sum(sum(InIma(:,:,1))) sum(sum(InIma(:,:,2))) sum(sum(InIma(:,:,3)))];
else
    zMax = 1;
    InIma = double(InIma > min(InIma(:)));
    count_max = sum(InIma(:));
end

%converting to radians
theta_range = theta_range.*(pi/180);

%taking the size of theta_range
[~,yT,~] = size(theta_range);

%making sure the delta rho is not larger than the max of the image
if rho > Diagonal
    error('Please select a delta row that is less than the image diagonal');
else
    rho_range = 0:rho:ceil(Diagonal);
end

%taking the size of rho_range
[~,yR,~] = size(rho_range);

%creating a lower and higher shifted range of rho for thresholding
low_rho = rho_range;
high_rho = cat(2,rho_range(2:end),ceil(Diagonal));

%preallocating
OutIma = zeros(yR,yT,zMax);
RC_cell = cell(yR+1,yT,zMax);
RC_cell{1,1,1} = theta_range;
RC_cell{2,1,1} = [xI yI];

%Alternative way to calculate rho per hit in image
R_OG = repmat(rot90(1:xI,3),[1 yI]);
R_OG = R_OG(:);
C_OG = repmat(1:yI,[xI 1]);
C_OG = C_OG(:);

for zz = 1:zMax
    %Removing non hits from the Image
    InLine = InIma(:,:,zz);
    InLine = InLine(:);
    R = InLine.*R_OG;
    C = InLine.*C_OG;
    R(R == 0) = [];
    C(C == 0) = [];
    
    %threshold size based on the array
    L = repmat(reshape(low_rho,[1 1 yR]),[count_max(zz),yT,1]);
    H = repmat(reshape(high_rho,[1 1 yR]),[count_max(zz),yT,1]);

    %Thresholding all rho distances based on user input threshold 
    Distance = repmat(R.*cos(theta_range) + C.*sin(theta_range),[1 1 yR]);      
    D = double(Distance.*(Distance >= L));
    D = double(logical(D.*(D < H)));

    for rr = 1:yR
        for tt = 1:yT
            
            %selecting the current column of rho calculations
            Current_Rho = D(:,tt,rr);
            rt_R = Current_Rho.*R;
            rt_R(rt_R == 0) = [];
            rt_C = Current_Rho.*C;
            rt_C(rt_C == 0) = [];
            
            %summing the hits for each rho/theta box
            %creating the cells with coordinates for each hit
            OutIma(rr,tt,zz) = sum(Current_Rho);
            RC_cell{rr+2,tt,zz} = cat(2,rt_R,rt_C);

        end
    end
end

%flipping the output image to be oriented correctly
OutIma = fliplr(OutIma);
       
end

