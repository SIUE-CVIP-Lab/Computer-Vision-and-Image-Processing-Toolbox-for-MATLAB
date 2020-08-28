function [outMask] = thinskel_mask_cvip(N, dir)
% THINSKEL_MASK_CVIP - Creates N*N size Thinning filter or mask.
% The function creates a thinning filter or thinning mask.It is used in
% the thinning operation.In skeletonization operation, it can be used as
% an initial mask, but the user must be aware of diagonal or non-diagonal
% type of it.The diagonal masks are for directions NE, NW, SE and SW, 
% while remaining fours are non-diagonal masks.
%
% Syntax :
% -------
% [outMask] = thinskel_mask_cvip(N, dir)
%   
% Input Parameters include :
% ------------------------
%   'N'             width/height of mask. N must be a positive and odd
%                   integer (1,3,5, and so on). 
%                                                              (default: 3)
%
%   'dir'           Mask direction. Eight mask directions as follows:
%                       1. 'E' -> east
%                       2. 'W' -> west
%                       3. 'N' -> north
%                       4. 'S' -> south
%                       5. 'NE' -> north east
%                       6. 'NW' -> north west 
%                       7. 'SE' -> south east
%                       8. 'SW' -> south west                   
%                   Masks for directions 1-4 are non-diagonal masks and 
%                   masks for directions 5-8 are diagonal masks. 
%                                                            (default: 'W')
%
%                   For example, 3*3 non-diagonal mask for west direction 
%                   is
%                       [ 1  x  0;
%                         1  1  0;
%                         1  x  0 ]
%
%                   Here, 'x' is don't care. For simplicity, it is
%                   represented by NaN. Thus, 3*3 mask for west direction
%                   is
%                       [ 1  nan   0;
%                         1   1    0;
%                         1  nan   0 ]
%
% Output Parameter include  :  
% ------------------------       
%   'outMask'       Thinning mask of N*N size. 
%         
%
% Example :
% -------
%     %Create 5*5 diagonal Thinning filter or mask for north-west direction
%     M = thinskel_mask_cvip(5,'NW')
%
%
% Reference 
% ---------
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    6/2/2017
%           Latest update date:     6/12/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

%check number of input and output arguments
if nargin ~= 1 && nargin ~= 2 && nargin ~= 3   
    error('Too many or too few input arguments!')
end
if nargout ~= 0 && nargout ~= 1 
    error('Too many or too few output arguments!')
end

%set up the default parameters
if ~exist('N','var') || isempty(N)
    N = 3;
end


if ~exist('dir','var')  || isempty(dir)
   dir = 'W';
end


%configure the kernel
if mod(N,2) ~= 1
    N = N + 1;
end

%center of kernel
centr = (N+1)/2;


%create initial mask with West direction
initialMask = [ones(N,N-centr) nan(N,1) zeros(N,N-centr)];
initialMask(centr, centr) = 1;

switch dir
    case 'W'
        outMask = initialMask;
    case 'E' 
        outMask = rot90(initialMask, -2);
    case 'N' 
        outMask = rotmask_cvip(initialMask, -1);
    case 'S' 
        outMask = rotmask_cvip(initialMask);
    case 'NE' 
        outMask = rotmask_cvip(initialMask, 135);
    case 'NW' 
        outMask = rotmask_cvip(initialMask, 45);
    case 'SE' 
        outMask = rotmask_cvip(initialMask, 225);
    case 'SW' 
        outMask = rotmask_cvip(initialMask, 315);
        
    otherwise
        error('No such direction available!');
end


end %end of function

