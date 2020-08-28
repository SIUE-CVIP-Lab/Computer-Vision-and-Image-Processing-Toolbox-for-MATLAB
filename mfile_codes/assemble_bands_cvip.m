function RGB = assemble_bands_cvip(a,b,c)
% ASSEMBLE_BANDS_CVIP - Assemble the red band, green band and blue band of
% RGB image.Adds monochrome image planes to create a multispectral image.
% 
% Syntax :
% ------
%  RGB = ASSEMBLE_BANDS_CVIP(X,Y,Z) 
%  assemble elements in array X, array Y and array Z forming a 3-d array RGB.
%  Input image array must be of same size.
%
%   X   -   Band 1 image 
%   Y   -   Band 2 image
%   Z   -   Band 3 image
%   RGB -   Output 3-band image
%
%                 
% Example :
% -------
%   Assemble bands together:
%
%                   X = imread('Car.bmp');
%                   R = extract_band_cvip(X,1);
%                   G = extract_band_cvip(X,2);
%                   B = extract_band_cvip(X,3);
%                   RGB = assemble_bands_cvip(R,G,B);
%                   figure;imshow(RGB,[]);
%
%
%
%   See also, extract_band_cvip
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Deependra Mishra
%           Initial coding date:    03/17/2017
%           Latest update date:     03/17/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

% Checking number of input arguments---------------------------------------    
    if nargin<3
        error('Too few arguements for assemble_bands_cvip');
    elseif nargin>3
        error('Too many arguements for assemble_bands_cvip');
    end
% Checking the size of image-----------------------------------------------    
    if size(a)==size(b)
        if size(a) == size(c)
            RGB = cat(3,a,b,c);
        else
            error('Image Size Unequal: Please pass same size image as input parameters');
        end
    else
        error('Image Size Unequal: Please pass same size image as input parameters');
    end
end

    