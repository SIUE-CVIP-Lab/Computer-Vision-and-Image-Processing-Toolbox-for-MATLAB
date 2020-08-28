function x = xor_cvip(a,b)
% XOR_CVIP - Performs logical XOR operation between two images.
%
% Syntax :
% ------
% Z = xor_cvip(X,Y)
%
% performs bitwise XOR between each element in array X  
% and corresponding element in array Y and returns the result of bitwise 
% XOR operation in the corresponding element of the output array Z.
%
%   X   -   First input image. 
%   Y   -   Second input image.
%   Z   -   Output image.
%
% Z is an array of type depending upon the input X and Y.
%
% If X and Y are numeric arrays of the different size,smaller size 
% arrays are zero padded before performing bitwise XOR operation.
%                  
% Example :
% -------
%   Performs bitwise XOR operation between two images:
%
%                   X = imread('Cam.bmp');
%                   Y = imread('Car.bmp');
%                   S = xor_cvip(X,Y);
%                   figure;imshow(S,[]);
%
%   See also, or_cvip, and_cvip, not_cvip
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
  
%------------------------------------------------------------------------
% Checking number of input arguments
%     narginchk(2,2); % using if else is faster
    if nargin<2,
        error('Too few arguements for xor_cvip');
    elseif nargin>2,
        error('Too many arguements for xor_cvip');
    end;
%----------------------------------------------------------------
% Checking data type of input image and converting to type uint8 if
% necessary
%     if isa(a,'double')
%         a=uint8(a);
%     end
%     
%     if isa(b,'double')
%         b=uint8(b);
%     end
%-------------------------------------------------------------------
%----------Logic to support different input image type
    if isa(a,'uint8') && isa(b,'uint16')
        b= uint8(b);
    elseif isa(a,'uint16') && isa(b,'uint8')
        a=uint8(a);
    elseif isa(a,'uint8') && isa(b,'double')
        b=uint8(b);
    elseif isa(a,'double') && isa(b,'uint8')
        a=uint8(a);
    elseif isa(a,'double') && isa(b,'uint16')
        a=uint16(a);
    elseif isa(a,'uint16') && isa(b,'double')
        b=uint16(b);  
    end;

% Checking the size of images and making same size by zero padding if
% necessary    
    if size(a,3)>size(b,3)
        b=cat(3,b,b,b);
       %b=repmat(b,[1 1 3]);
    elseif size(b,3)>size(a,3)
        a=cat(3,a,a,a);
    else
    end
    if size(a,2)>size(b,2)
        if size(a,1)>size(b,1)
            %c = zeros(size(a));
            b(end+size(a,1)-size(b,1),end+size(a,2)-size(b,2),1)=0;
        else
            a(end+size(b,1)-size(a,1),end,1)=0;
            b(end,end+size(a,2)-size(b,2),1)=0;
        end
    else
        if size(a,1)<size(b,1)
            a(end+size(b,1)-size(a,1),end+size(b,2)-size(a,2),1)=0;
        else
            a(end+size(a,1)-size(b,1),end,1)=0;
            b(end,end+size(b,2)-size(a,2),1)=0;
        end
    end
%-------------------------------------------------------------------
% Performing XOR operation on images    
    x = bitxor(a,b);
end
