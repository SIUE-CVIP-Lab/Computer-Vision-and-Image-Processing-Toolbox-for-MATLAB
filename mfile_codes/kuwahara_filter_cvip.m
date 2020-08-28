function new_image = kuwahara_filter_cvip( imageP,W)
% KUWAHARA_FILTER_CVIP - an edge preserving,smoothing filter.
%
% Syntax :
% -------
% new_image = kuwahara_filter_cvip( imageP,W)
%   
% Input Parameters include:
% -------------------------
%
%   'imageP'        Input image can be gray image or rgb image of MxN size. 
%                   
%   'W'             Filter block size.  
%                   
%
% Output Parameters include :  
% --------------------------- 
%   'new_image'     The output image after filtering
% 
%
% Example :
% -------
%                   imageP = imread('kuw.png');
%                   new_image = kuwahara_filter_cvip( imageP,7);
%                   figure; imshow(new_image/255);
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    3/13/2017
%           Latest update date:     3/19/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

if (rem(W,2) < 1) || (W > 11 && W <3)
    error('mask_size should be an odd number between 3 and 11');
end
[m,n,o] = size(imageP);


c = (W+1)/2;    % coordinate of the center pixel of the window
new_image = double(imageP);

for i= c: (m+1-c)
  for j=c:(n+1-c) 
    for k = 1:o
            block = double( imageP( i - (c-1): i+ (c-1) , j - (c-1): j+ (c-1), k ) ) ; % W-block of the image. Only one band.
            
            region1 = block(1:c,c:end);
            region2 = block(1:c,1:c);
            region3 = block(c:end,1:c);
            region4 = block(c:end,c:end);
            
            std_vec = [std(region1(:)) std(region2(:)) std(region3(:)) std(region4(:))];
            [~,p] = min(std_vec);
            switch p
                case 1
                    new_image(i,j,k) = mean(region1(:));
                case 2
                    new_image(i,j,k) = mean(region2(:));
                case 3
                    new_image(i,j,k) = mean(region3(:));
                case 4
                    new_image(i,j,k) = mean(region4(:));
                otherwise
                    error('not possile');
            end 
    end
  end
end

end

