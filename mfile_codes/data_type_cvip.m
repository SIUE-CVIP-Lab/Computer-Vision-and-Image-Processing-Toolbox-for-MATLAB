function OutIma = data_type_cvip( InIma, Type )
% DATA_TYPE_CVIP - Convert the dta type according to the selected Type.
%
% Syntax :
% ------
% OutIma = data_type_cvip( InIma, Type );
%    
% Input Parameters include :
% ------------------------
%
%   'InIma'       Input image can be gray image or rgb image of MxN size.
%   'Type'        Desired Output image data type according to the most
%                 common data types used in image processing. Default '1'
%
% Output Parameter include :  
% ------------------------
%
%  'OutIma'       Output image with the same size of input image and with
%                 the desired data type.
%                                         
%
% Example :
% ---------
%                   I = imread('cam.bmp');  %Input image
%                   Type = 5                %Select Double data type
%                   OutIma = data_type_cvip( I, Type );
%                   % display message with data types conversion
%                   disp(['Image input data type = ' class(I) ' and' ...
%                       ' the image output data type = ' class(OutIma)]);
%
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
 % Revision 1.1  06/01/2019  15:10:28  jucuell
 % Initial revision: Coding and initial testing.
%
if isempty(Type) || Type > 5 || Type < 1
    Type = 1;               % default conversion data type = Byte (uint8)
end
% switch according to type
switch Type
    case 1                  % to Byte 
        OutIma = uint8(InIma);
    case 2                  % to Short
        OutIma = uint16(InIma);
    case 3                  % to Integer
        OutIma = int64(InIma);
    case 4                  % to Float
        OutIma = single(InIma);
    case 5                  % to Double
        OutIma = double(InIma);
end

