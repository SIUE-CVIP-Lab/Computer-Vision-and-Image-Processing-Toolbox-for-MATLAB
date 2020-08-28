function outMask = rotmask_cvip(inMask, angleD)
% ROTMASK_CVIP - Rotate an 2-D mask or filter by given angle( in degree).
% The function rotates an 2-D array by given angle (in degree).This
% function is useful to rotate the mask used in the thinning operation.
%
% Syntax:
% ------
% outMask = rotmask_cvip(inMask, angleD)
%   
% 
% Input Parameters include:
% -------------------------
%   'inMask'        A mask or filter of NxN size.  
%
%   'angle'         An angle in degree.
%                                                               
%
% Output Parameter includes:  
% --------------------------
%   'outMask'      Rotated mask or filter.
%
%
% Example :
% -------
%       M = [0 0 0; nan 1 nan; 1 1 1]
%       O = rotmask_cvip(M, 45)             
%               
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    6/2/2017
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     01/25/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.3  01/25/2019  12:54:56  jucuell
 % change of ceil function to round to preserve matrix data values
%
 % Revision 1.2  06/06/2017  16:09:55  nslama
 % last file modification 
%
 % Revision 1.1  06/02/2017  15:23:31  nslama
 % Initial coding date
%

%check number of input and output arguments
if nargin ~= 1 && nargin ~= 2 
    error('Too many or too few input arguments!')
end
if nargout ~= 0 && nargout ~= 1 
    error('Too many or too few output arguments!')
end



%check if thinning filter is a square matrix 
%Also, the length of side must be positive odd integer.
[n_row, n_col] = size(inMask);

if (n_row ~= n_col) && mod(n_row, 2) ~= 1
    error('Array must be N*N matrix! N must be odd & positive integer!');
else
    N = n_row;
end

%angle in rad
theta = angleD/360*2*pi;


%center of mask or array
if mod(N,2) ~= 0
    centr = (N+1)/2;
else
    centr = N/2;
end


%create row index and col index
[rind, cind] = ndgrid(1:N,1:N);

%shift and rotate the indices
rind = rind - centr;
cind = cind - centr;

rind_temp = centr + rind*cos(theta)-cind*sin(theta);
cind_temp = centr + rind*sin(theta)+cind*cos(theta);

rind_new = round(rind_temp);
cind_new = round(cind_temp);

rind_new(rind_new < 1) = 1;
rind_new(rind_new > N) = N;
cind_new(cind_new < 1) = 1;
cind_new(cind_new > N) = N;

%create rotated array
outMask = arrayfun(@(x,y,z) inMask(y,z), inMask, rind_new, cind_new);

end

