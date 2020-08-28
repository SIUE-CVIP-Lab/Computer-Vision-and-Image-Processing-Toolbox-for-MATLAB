function H = butterworth_h_cvip( type, block_size, origin, keep_DC,n, varargin )
% BUTTERWORTH_H_CVIP - returns the frequency response for butterworth filters.
% 
% Syntax:
% -------
% H = butterworth_H_CVIP( type, block_size, origin, n, varargin )
%
% Input Parameters include :
% ------------------------
%   'type'          choose either high,low,br,bp.   
%   'block_size'      block_size is usualy 1x1 for a square window. 
%   But you can also specify a 1x2 matrix to create a rectangular window.   
%   First element is the number of rows, and the 2nd elements is the number of columns.
%   
% Example :
% -------
%   H = butterworth_h_cvip( 'low', 64, 'center', 5, 16 );
%   figure; imshow(H,[]);
%   H = butterworth_h_cvip( 'high', 64, '', 5, 32 );
%   figure; imshow(H,[]);
%   H = butterworth_h_cvip( 'br', 128, 'center', 5, 16,32 );
%   figure; imshow(H,[]);
%   H = butterworth_h_cvip( 'bp', 128, [], 5, 16,32 );
%   figure; imshow(H,[]);
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    7/13/2017
%           Latest update date:     7/19/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%=========================================================================
%%  block_size doen not necessarily specify a square window
%   we let the block_size to be a 1x2 matrix, to specify block_size
%   in y direction and x direction. This case is needed for spectrums that
%   are not a square after zero-padding. This functionality is different
%   with cviptools. In cviptools all images are zero padded in both
%   dimension so that the image is square with size equal to a power of 2.
%
if length(block_size) == 2
    block_size_x = block_size(2);
    block_size_y = block_size(1);
elseif length(block_size) == 1
    block_size_x = block_size(1);
    block_size_y = block_size(1);
else
    error('block_size is either 1x1 or 1x2.');
end
%% Create the grid
x = 0:block_size_x-1;
y = 0:block_size_y-1;
if strcmp(origin,'center')
    x = x - (block_size_x/2);
    y = y - (block_size_y/2);
end
[X,Y] = meshgrid(x,-y);
R = sqrt(X.^2 + Y.^2);  % The f-plane.
[r,c] = find(R == 0);

%% Create the desired frequency response
%   The variable R is the frequency.
type = lower(type);
switch (type)
    case 'low'  % low pass filter
        fc = varargin{1};
        den = sqrt( 1 + (R/fc).^(2*n) );
        H = 1./den;         % low_pass
    case 'high' % high pass filter
        fc = varargin{1};
        den = sqrt( 1 + (R/fc).^(2*n) );
        H = ( (R/fc).^(n) )./ den;
    case 'br'   % band reject filter
        fc_low = varargin{1};
        fc_high = varargin{2};
        if fc_high < fc_low
            error('High cut off should be greater than low cut off frequency.');
        end
        w = fc_high - fc_low;
        f0 = (fc_high + fc_low)/2;
        k = R*w./((R.^2) - (f0^2));
        H = 1./(1 + (k.^(2*n)));
    case 'bp'   % band pass filter
        fc_low = varargin{1};
        fc_high = varargin{2};
        if fc_high < fc_low
            error('High cut off should be greater than low cut off frequency.');
        end
        w = fc_high - fc_low;
        f0 = (fc_high + fc_low)/2;
        k = R*w./((R.^2) - (f0^2));
        H_BR = 1./(1 + (k.^(2*n)));
        H = 1 - H_BR;
end

%deciding to keep DC or not
if strcmp('y',keep_DC) || strcmp('Y',keep_DC) || any(keep_DC)
    H(r,c) = 1;
end

end

