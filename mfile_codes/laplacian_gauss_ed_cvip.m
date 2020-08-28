function [ I ] = laplacian_gauss_ed_cvip( input_image, std, method )
% LAPLACIAN_GAUSS_ED_CVIP - laplacian_gauss is an edge detector.
%
% Syntax  :
% ------
% [ I ] = laplacian_gauss_ed_cvip( input_image, std, method )
%
% InputParameters include :
% ------------------------- 
%
%       'input_image'    A multibad input image.
%       
%       'std'            The Standard Deviation of the Gaussian blur kernel.
%                        the size of the gaussian is related to std by:
%                          size = 4*std
%                        Thus we have 2 standard deviation of the gaussian
%                        inside the kernel.
%
%       'method'          integer values of 1-4. Representing different laplacian
%                          masks. 
%                  1) Laplace  =  [0 -1 0;
%                               -1 4 -1;
%                               0 -1 0];
%             
%                   2) Laplace  = [-2 1 -2;
%                                1 4 1;
%                               -2 1 -2];
%         
%                   3) Laplace  =  [-1 -1 -1;
%                                -1 8 -1;
%                               -1 -1 -1];
%                   4) LoG equation --> Mexican hat
%
%
% Example :
% -------
%                 input_image = imread('butterfly.tif');
%                 std = 1;
%                 [ I ] = laplacian_gauss_ed_cvip( input_image, std , 4);
%                 figure; imshow(hist_stretch_cvip(I,0,1,0,0),[]);
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

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
    

switch method        
    case 1
        Laplace = [0 -1 0;
            -1 4 -1;
            0 -1 0];
        
        [~,~,d] = size(input_image);
        I = double(input_image);
        I = blur_gauss(I,std);
        for band=1:d
            I(:,:,band) = conv2(I(:,:,band), Laplace,'same');
        end
        
    case 2
        Laplace = [-2 1 -2;
            1 4 1;
            -2 1 -2];
        
        [~,~,d] = size(input_image);
        I = double(input_image);
        I = blur_gauss(I,std);
        for band=1:d
            I(:,:,band) = conv2(I(:,:,band), Laplace,'same');
        end
    case 3
        Laplace = [-1 -1 -1;
            -1 8 -1;
            -1 -1 -1];
        
        [~,~,d] = size(input_image);
        I = double(input_image);
        I = blur_gauss(I,std);
        for band=1:d
            I(:,:,band) = conv2(I(:,:,band), Laplace,'same');
        end
    case 4  % LoG as in Moravec
        n = 4*std;
        std2 = (std)^2;
        x = 0:n-1;
        y = 0:n-1;
        x = x - floor(n/2);
        y = y - floor(n/2);
        [X,Y] = meshgrid(x,-y);
        
        arg   = -(X.*X + Y.*Y)/(2*std2);
        
        h     = exp(arg);
        h(h<eps*max(h(:))) = 0;
        
        sumh = sum(h(:));
        if sumh ~= 0,
            h  = h/sumh;
        end;
        % now calculate Laplacian
        h1 = h.*(X.*X + Y.*Y - 2*std2)/(std2^2);
        h     = h1 - sum(h1(:))/(n^2); % make the filter sum to zero
        input_image = double(input_image);
        [m,n,o] = size(input_image);
        I = zeros(m,n,o);
        for i=1:o
            I(:,:,i) = conv2(input_image(:,:,i), h,'same');
        end
end


end

function I_blured = blur_gauss(I,std)
I = double(I);
I_blured = zeros(size(I));
    height = floor(4*std);
    width = height;
    %std = min([width,height])/4;
    h = h_image_cvip( 3,height, width,std);
    for i=1:size(I,3)
        I_blured(:,:,i) = conv2(I(:,:,i),h,'same');
    end
end