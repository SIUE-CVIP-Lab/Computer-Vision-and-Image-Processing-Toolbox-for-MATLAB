function out_s = ideal_low_cvip( spectrum, block_size, transform_type, keep_DC, fc)
% IDEAL_LOW_CVIP - perform ideal low pass filter.
%
% Syntax :
% -------
% out_s = ideal_low_cvip( spectrum, block_size, transform_type, fc )
%
% Description :  
% -------------
% ideal_low_cvip performs a lowpass filtering on the input spectrum. The
% low pass cutoff frequency _fc_ is given as an input argument.The input
% spectrum my be obtained using various available transform in CVIP Matlab
% toolbox,such as fft_cvip or dct_cvip.These functions accept an input 
% _block_size_ which is also used here as input argument._transform_type_
% should be chosen according to the transform used to obtain the
% _spectrum_.FFT has the origin at the center while the other transforms 
% have their origin located at upper left corner of the image. 
% transform_type is a string.If given spectrum is FFT, then set 
% transform_type = 'fft' or 'center'.Else, the origin would be located at 
% the upper left corner.
%
%  Example :
%  ---------
% 
%        spectrum = ones(128,256,3); 
%        out_s = ideal_low_cvip( spectrum, [], 'fft', 32 );
%        figure; imshow(out_s,[]);
%        out_s = ideal_low_cvip( spectrum, [64 128], 'non-fft', 32 );
%        figure; imshow(out_s,[]); 
%        out_s = ideal_low_cvip( spectrum, [64 128], 'center', 16 );
%        figure; imshow(out_s,[]);
% 
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
%% Check the input block_size to see if it agrees with the input convention.
%   it should either be 1x1, 1x2, or empty matrix.
%   if it is 1x1 --> square window
%   if it is 1x2 or 2x1 --> rectangular window.
%   if it is 2x2, The last two elements are ignored --> back to case 1x2.
%   if either of dimensions have size greater than 3 --> error.
%   if only one of the elemtns is zero then it is ignored--> back to square
%   window.
%   if both are zero or empty --> block_size = size(spectrum);
if length(block_size) == 2
    block_size_x = block_size(2);
    block_size_y = block_size(1);
    if block_size_x == 0 && block_size_y ~= 0
        block_size_x = block_size_y;
    elseif block_size_y == 0 && block_size_x ~= 0
        block_size_y = block_size_x;
    end
    block_size = [block_size_y block_size_x];
elseif length(block_size) == 1
    block_size_x = block_size(1);
    block_size_y = block_size(1);
    block_size = [block_size_y block_size_x];
elseif length(block_size) > 2
    error('block_size should be either 1x1, 1x2 or empty.');
end

% display(block_size)

%% CHECK THE BLOCK SIZE AND SIZE OF THE SPECTRUM
[m,n,d] = size(spectrum);
if ~isempty(block_size) && block_size_x ~= 0
    if mod(m, block_size_y) ~= 0 || mod(n, block_size_x) ~= 0
        error('You cannot cover the spectrum with the given block_size.');
    end
else
    block_size = [m n];
    block_size_y = m;
    block_size_x = n;
    siz = 2.^nextpow2([m n]);
    M = siz(1);
    N = siz(2);
    
    if M~=m || N~= n
        % this should never happen
        warning('The spectrums created by CVIP toolbox have heights and width that are power of 2. The given spectrum does not match this criteria.');
    end
end


%% check the transform type to decide where to put the origin of the spectrum.
if strcmp(transform_type,'fft') || strcmp(transform_type,'center')
    origin = 'center';
else
    origin = 'uppleft';
end

%% Create the desired filter response and apply it to the spectrum

H = ideal_h_cvip( 'low', block_size, origin, keep_DC, fc);

qr = m/block_size_y;
qc = n/block_size_x;
mask = repmat(H,qr,qc);

out_s = zeros(m,n,d);
for i=1:d
    out_s(:,:,i) = mask.*spectrum(:,:,i);
end


end

























