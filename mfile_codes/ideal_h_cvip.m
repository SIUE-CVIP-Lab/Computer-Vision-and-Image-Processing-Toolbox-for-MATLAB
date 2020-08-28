function H = ideal_h_cvip( type, block_size, origin, keep_DC, varargin )
% IDEAL_H_CVIP -  returns the frequency response of filters
%  
% SYNTAX :
% ------
% H = ideal_h_cvip( type, block_size, origin,  varargin )
%
% DESCRIPTION :
% -----------
% All frequency components that are inside the circle (or 1/4 circle if dc component  is  on  the  
% upper-left-hand corner of its transform plane) of radius "cutoff" are filtered, 
% while all frequencies  outside the circle (or 1/4 circle) are left completely
% intact.If dc equals 1, the dc component will  be  retained,if it equals 0, it will be dropped.
%
%  Input Parameters include:
%  -------------------------
%    'block_size'              block_size is usualy 1x1 for a square window. 
%
%  
%   But you can also specify a 1x2 matrix to create a rectangular window.   
%   First element is the number of rows, and the 2nd elements is the number of columns.
%
%
%  Example :
%  --------- 
%
%   H = ideal_h_cvip( 'low', 64, 'center',  16 );
%   figure; imshow(H,[])
%   H = ideal_h_cvip( 'high', 64, '',  32 );
%   figure; imshow(H,[])
%   H = ideal_h_cvip( 'br', 128, 'center', 16,32 );
%   figure; imshow(H,[])
%   H = ideal_h_cvip( 'bp', 128, [], 16,32 );
%   figure; imshow(H,[])
%
% block_size does not necessarily specify a square window
% we let the block_size to be a 1x2 matrix, to specify block_size
% in y direction and x direction. This case is needed for spectrums that
% are not a square after zero-padding. This functionality is different
% with cviptools.In cviptools all images are zero padded in both
% dimension so that the image is square with size equal to a power of 2.
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
% 
%           Author:                Mehrdad Alvandipour
%           Initial coding date:    06/27/2017
%           Latest update date:     06/27/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%==========================================================================

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
H = ones(size(R));
H(r,c) = 0;
type = lower(type);
switch (type)
    case 'low'  % low pass filter
        fc = varargin{1};
        H(R > fc) = 0;        % low_pass
    case 'high' % high pass filter
        fc = varargin{1};
        H(R < fc) = 0;        % low_pass
    case 'br'   % band reject filter
        fc_low = varargin{1};
        fc_high = varargin{2};
        if fc_high < fc_low
            error('High cut off should be greater than low cut off frequency.');
        end
        H( and((R > fc_low) , (R < fc_high))) = 0;
         
    case 'bp'   % band pass filter
        fc_low = varargin{1};
        fc_high = varargin{2};
        if fc_high < fc_low
            error('High cut off should be greater than low cut off frequency.');
        end
        H(R > fc_high) =  0;
        H(R < fc_low) =  0;
end

%deciding to keep DC or not
if strcmp('y',keep_DC) || strcmp('Y',keep_DC) || any(keep_DC)
    H(r,c) = 1;
end

end

