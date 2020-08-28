function R = extract_band_cvip(a,bands)
% EXTRACT_BAND_CVIP - Extract the red band or green band or blue band depending upon the bands value from the input image.
%
% Syntax :
% ------
% Z = extract_band_cvip(X,Band) extract the elements from input image 
% (3-d array) and forms a 2-d array representing a single band image.Input image array must be of 3 band.
%
% Input Parameter include :
% -----------------------
%
%   'X'      Input RGB image (3-band image) 
%
% Output Parameter include :
% ------------------------
%   'Z'      Extracted band image 
%           (Band=1, Red band image)
%           (Band=2, Green band image)
%           (Band=3, Blue band image)
%
%
% Example 1 :
% ---------
%   Assemble bands together:
%
%                   X = imread('Car.bmp');
%                   R = extract_band_cvip(X,1);
%                   G = extract_band_cvip(X,2);
%                   B = extract_band_cvip(X,3);
%                   figure;imshow(R,[]);
%                   figure;imshow(G,[]);
%                   figure;imshow(B,[]);
%
%
%
%   See also, assemble_bands_cvip
%
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

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
    if nargin<2,
        error('Too few arguements for extract_bands_cvip');
    elseif nargin>2,
        error('Too many arguements for extract_bands_cvip');
    end;
% Checking for the single or 3-band image----------------------------------    
    if size(a,3)==1
        error('Invalid Image Parameter: Pass RGB (color) image as parameter');
    
    else    
        if bands==1
            R = a(:,:,1);
        elseif bands==2
            R = a(:,:,2);
        elseif bands==3;
            R = a(:,:,3);
        else
            error('Invalid band parameter: Enter correct band value [1-3]');
        end
    end
end

    