function  out_img  = marr_hildreth_ed_cvip( input_image, sigma, threshold )
% MARR_HILDRETH_ED_CVIP - performs a Marr Hildreth edge detection on the image.
%
% Syntax :
% ------
% out = marr_hildreth_ed_cvip( input_image, sigma, threshold )
%   
% Input Parameters include :
% ------------------------
%  'input_image'   Input image can be gray image or rgb image of MxN size. 
%                   
%  'sigma'         The Gaussian variance.  
%     
%  'threshold'     The threshold tested against the absolute value of the difference  
%                   between the two pixels that have the sign changes. 
%   
%                              
% Output Parameter include :
% -------------------------
%
%  'out_img'      The output image after edge detection.
%                  An image with the same size as the input image.
%
% Example :
% -------
%                  input_image = imread('cam.bmp');
%                  sigma = 5; 
%                  threshold =.2;
%                  out = marr_hildreth_ed_cvip( input_image, sigma, threshold ); 
%                  figure;imshow(input_image);title('Input Image'); 
%                  figure; imshow(remap_cvip(out));
% 
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    4/28/2017
%           Latest update date:     5/3/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

%% Use formula in page 151 to calculate the window size of the LoG filter based on the input sigma
n = 2*floor(3.35*sigma + 0.33) + 1;
 siz   = (n-1)/2;
 std2   = sigma^2;

 [x,y] = meshgrid(-siz:siz,-siz:siz);
 arg   = -(x.*x + y.*y)/(2*std2);

 h     = exp(arg);
 h(h<eps*max(h(:))) = 0;

 sumh = sum(h(:));
 if sumh ~= 0,
   h  = h/sumh;
 end;
 % now calculate Laplacian     
 h1 = h.*(x.*x + y.*y - 2*std2)/(std2^2);
 h     = h1 - sum(h1(:))/(n^2); % make the filter sum to zero

%% Convolve with LoG
input_image = double(input_image);
[m,n,o] = size(input_image);
I = zeros(m,n,o);
for i=1:o
    I(:,:,i) = conv2(input_image(:,:,i), h,'same');
end


%% Find the zero crossing
out_img = zeros(m,n,o);
for k=1:o
    for i=2:(m-1)
        for j=2:(n-1)
            if (I(i-1,j-1,k)*I(i+1,j+1,k) < 0) && (abs(I(i-1,j-1,k) - I(i+1,j+1,k)) > threshold )% NW / SE
                out_img(i,j,k) = 255;
            elseif (I(i-1,j,k)*I(i+1,j,k) < 0) && (abs(I(i-1,j,k) - I(i+1,j,k)) > threshold )% N / S
                out_img(i,j,k) = 255;
            elseif (I(i-1,j+1,k)*I(i+1,j-1,k) < 0) && (abs(I(i-1,j+1,k) - I(i+1,j-1,k)) > threshold)     % NE / SW
                out_img(i,j,k) = 255;
            elseif (I(i,j-1,k)*I(i,j+1,k) < 0) && (abs(I(i,j-1,k) - I(i,j+1,k)) > threshold)     % W / E
                out_img(i,j,k) = 255;
            end
        end
    end
end



end

