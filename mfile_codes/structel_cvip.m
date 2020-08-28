function [struct_el] = structel_cvip(kType, kSize, kArgs)
% STRUCTEL_CVIP - Create structuring element or kernel.
% The function creates the structuring element or kernel,which is
% typically used in morphological operationsto probe or interact with a
% given image.The available shapes are disk,square,rectangle and cross.
%
% Syntax :
% -------
% struct_el = structel_cvip(kType, kSize, kArgs)
%   
% Input Parameters include :
% -------------------------
%   'kType'         Kernel or Structure Elements type.
%                   kType = 1 ----> disk 
%                   kType = 2 ----> square 
%                   kType = 3 ----> rectangle 
%                   kType = 4 ----> cross
%                                                              (default: 2)
%
%   'kSize'         Size of Kernel or Structure Elements. Kernel will
%                   a square matrix of K*K, where K = kSize. kSize must be
%                   positive odd integer (1,3,5, and so on). 
%                                                              (default: 3)
%
%   'kArgs'         Kernel arguments. The number of arguments vary with the
%                   kernel type. Any argument must be positive odd integer 
%                   (1,3,5, and so on)    
%                     'disk' kernel, no arguments, i.e. kArgs = []
%                     'square' kernel, one argument (width) 
%                           i.e. kArgs = width
%                                                          (default: kSize)
%                     'rectangle' kernel, two arguments (width & height) 
%                           i.e. kArgs(1) = width
%                                kArgs(2) = height       
%                                                (default: [kSize kSize-2])
%                     'cross' kernel, two arguments (thickness & cross size) 
%                           i.e. kArgs(1) = thickness
%                                kArgs(2) = cross size
%                                                    (default: [1 kSize-2])
%
%
% Output Parameter include :  
% ------------------------       
%   'struct_el'     Kernel or Structuring elements matrix of K*K size. 
%         
%
% Example :
% -------
%     %Create 5*5 rectangle kernel structuring element with rectangle width 
%      %5 and rectangle height 3   
%       kernel = structel_cvip(3,5,[5 3])  
%               
%
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    5/27/2017
%           Latest update date:     6/1/2017
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
if ~exist('kType','var') || isempty(kType)
    kType = 1;
end

if ~exist('kSize','var')  || isempty(kSize)
    kSize = 3;
end

if ~exist('kArgs','var')  || isempty(kArgs)
    switch kType
        case 1
            kArgs = [];
        case 2
            kArgs = kSize;
        case 3
            kArgs = [kSize kSize-2];
        case 4
            kArgs = [1 kSize-2];
        otherwise
            error('No such kernel available! See help page for details!');
    end
end

%define kernel type
%k_type = 1 ----> disk 
%k_type = 2 ----> square 
%k_type = 3 ----> rectangle 
%k_type = 4 ----> cross

%configure the kernel
if mod(kSize,2) ~= 1
    kSize = kSize + 1;
end
%center of kernel
centr_loc = ceil(kSize/2);
%create kernels 
struct_el = zeros(kSize,kSize); 

switch kType
    case 1 %disk
        [R, C]= ndgrid(1:kSize, 1:kSize);
        dist2 = (R-centr_loc).^2 + (C-centr_loc).^2;
        rad2 = (kSize/2)^2;
        struct_el(dist2 <= rad2)= 1;
    case 2 %square 
        k_width = floor(kArgs/2);
        struct_el(centr_loc - k_width :centr_loc + k_width,...
            centr_loc - k_width : centr_loc + k_width )= 1;
    case 3 %rectangle
        rec_width = floor(kArgs(1)/2);
        rec_height = floor(kArgs(2)/2);        
        struct_el(centr_loc - rec_height : centr_loc + rec_height,...
            centr_loc - rec_width : centr_loc + rec_width)= 1;
    case 4 %cross
        cros_thick = floor(kArgs(1)/2);
        cros_size = floor(kArgs(2)/2);
        struct_el(centr_loc-cros_thick:centr_loc+cros_thick,...
            centr_loc-cros_size: centr_loc + cros_size)= 1;
        struct_el(centr_loc - cros_size :centr_loc + cros_size,...
            centr_loc - cros_thick : centr_loc + cros_thick)= 1;    
end


end %end of function

