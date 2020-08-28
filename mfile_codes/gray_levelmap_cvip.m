function OutIma = gray_levelmap_cvip(InIma, MapFun, Llim, Hlim)
% GRAY_LEVELMAP_CVIP - histogram gray linear level mapping by five (5)
% predefined functions according to the specified Low and High gray level limits.
%
%
% Syntax :
% ------
% OutIma = gray_levelmap_cvip(InIma, MapFun);
%    
% Input Parameters include :
% ------------------------
%
%   'InIma'       Input image can be gray image or rgb image of MxN size.
%   'MapFun'      Selected mapping function. Default '1'
%                 1 - Trapezoid function, gray level limits [0 Llim Hlim 255]
%                 2 - Positive Step, gray level limits [0 Llim Hlim 255]
%                 3 - Negative Step, gray level limits [0 Llim Hlim 255]
%                 4 - Positive Slope, gray level limits [Llim Hlim]
%                 5 - Negative Slope, gray level limits [Llim Hlim]
%
% Output Parameter include :  
% ------------------------
%
%  'OutIma'       Output image with the same size of input image and with
%                 the modified histogram.
%                                         
%
% Example :
% ---------
%                   I = imread('cam.bmp');  %Input image
%                   Fun = 1;                %Select mapping function
%                   OutIma = gray_levelmap_cvip( I, Fun, 96, 128 );
%                   % display images and histograms
%                   figure, subplot(2,1,1), imshow(I), title('Input Image')
%                   subplot(2,1,2), get_hist_image_cvip(I); title('Input Histogram')
%                   figure, subplot(2,1,1), imshow(OutIma), title('Output Image')
%                   subplot(2,1,2), get_hist_image_cvip(OutIma); title('Output Histogram')
% 
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications 
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Julian Rene Cuellar Buritica
%           Initial coding date:    06/01/2019
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     06/01/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.2  06/11/2019  10:55:43  jucuell
 % adding Llim and Hlim input parameters.
%
 % Revision 1.1  06/01/2019  15:10:28  jucuell
 % Initial revision: Coding and initial testing.
%

%change data type to byte
if (max(InIma(:))) > 1
    InIma = uint8(InIma);
else
    InIma = uint8(255*InIma);
end
[row, col] = size(InIma);
OutIma = zeros(row, col);

switch MapFun
    case 1      %trapezoid
        %apply histogram modification to each segment
        p1 = gray_linear_cvip(InIma, 0, Llim-1, 0, 3.9844, 1, 1);
        p2 = gray_linear_cvip(InIma, Llim, Hlim-1, 255, 0, 1, 1);
        p3 = gray_linear_cvip(InIma, Hlim, 255, 255, -3.9844, 1, 1);
        
        OutIma = p1 + p2 + p3;
        
    case 2      %pos step 
        %apply histogram modification to each segment
        p1 = gray_linear_cvip(InIma, 0, Llim-1, 0, 0, 1, 1);
        p2 = gray_linear_cvip(InIma,  Llim, Hlim-1, 0, 3.9844, 1, 1);
        p3 = gray_linear_cvip(InIma, Hlim, 254, 255, 0, 1, 1);
        
        OutIma = p1 + p2 + p3;
    case 3      %neg step
        %apply histogram modification to each segment
        p1 = gray_linear_cvip(InIma, 0, Llim-1, 255, 0, 1, 1);
        p2 = gray_linear_cvip(InIma, Llim, Hlim-1, 255, -3.9844, 1, 1);
        p3 = gray_linear_cvip(InIma, Hlim+1, 255, 0, 0, 1, 1);
        
        OutIma = p1 + p2 + p3;
    case 4      %pos slope
        %apply histogram modification to each segment
        OutIma = gray_linear_cvip(InIma, 0, 255, 0, 1, 1, 1);

    case 5      %neg slope
        %apply histogram modification to each segment
        OutIma = gray_linear_cvip(InIma, 0, 255, 255, -1, 1, 1);
        
end

OutIma = uint8(OutIma);