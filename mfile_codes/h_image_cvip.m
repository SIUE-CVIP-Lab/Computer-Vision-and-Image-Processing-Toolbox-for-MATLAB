function out_img =  h_image_cvip( type,   height, width)
% H_IMAGE_CVIP - create a mask image according to the size and type.
%
% Syntax :
% --------
% out_img =  h_image_cvip( type,   height, width)
%   
% Input Parameters include :
% --------------------------
%
%  'type'          three types are there
%                  type = 1   Constant mask.
%                  type = 2   center weighted mask.
%                  type = 3   Gaussian
%  'height'        height of the image.
%
%  'width'         width of the image.
%
% Output Parameter include :  
% --------------------------
%
%   'out_img'      Mask image corresponding to type,height and width.
%
% Example :
% -------
%                   type = 2;
%                 height = 40;
%                 width = 50;
%           out_img = h_image_cvip(type,height,width);
%           figure;imshow(out_img);
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
if type == 1        % Constant mask
    out_img = ones(height, width);
elseif type == 2    % Center weighted
    out_img = ones(height, width);
    r = floor(height/2) + 1;
    c = floor(width/2) + 1;
    out_img(r,c) = height*width;
elseif type == 3    % Gaussian
    std = min([width,height])/4;
    std2 = (std)^2;
%     r = floor(height/2) + 1;
%     c = floor(width/2) + 1;
    
    x = 0:width-1;
    y = 0:height-1;

    x = x - floor(width/2);
    y = y - floor(height/2);

    [X,Y] = meshgrid(x,-y);

    arg   = -(X.*X + Y.*Y)/(2*std2);
    
     h     = exp(arg);
     h(h<eps*max(h(:))) = 0;
     
     % make it summ to 1
     sumh = sum(h(:));
     if sumh ~= 0,  
       out_img  = h/sumh;
     end;
     
%      out_img = out_img*height*width;
%    out_img = out_img*height*width/ max(out_img(:));
else
    error('Wrong type. It should be 1,2, or 3.');
end

% %% Use formula in page 151 to calculate the window size of the LoG filter based on the input sigma
% n = 2*floor(3.35*sigma + 0.33) + 1;
%  siz   = (n-1)/2;
%  std2   = sigma^2;
% 
%  [x,y] = meshgrid(-siz:siz,-siz:siz);
%  arg   = -(x.*x + y.*y)/(2*std2);
% 
%  h     = exp(arg);
%  h(h<eps*max(h(:))) = 0;
% 
%  sumh = sum(h(:));
%  if sumh ~= 0,
%    h  = h/sumh;
%  end;
%  % now calculate Laplacian     
%  h1 = h.*(x.*x + y.*y - 2*std2)/(std2^2);
%  h     = h1 - sum(h1(:))/(n^2); % make the filter sum to zero



end
