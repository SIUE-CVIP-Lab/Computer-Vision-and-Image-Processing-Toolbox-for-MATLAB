function div = divide_cvip(a,b)
% DIVIDE_CVIP - Divide two images or divide constant to image.
%
% Syntax :
% ------
%  Z = divide_cvip(X,Y) 
%  divide each element in array X by the corresponding 
%  element in array Y and returns the result of division in the corresponding 
%  element of the output array Z.
%
%   'X'      First input image or constant image
%   'Y'      Second input image.
%   'Z'      Output image.
%
%  Z is an array of type depending upon the input X and Y.
%
%  If X and Y are numeric arrays of the different size, smaller size 
%  arrays are zero padded and division is performed.
% 
%  In order to handle the division by 0, a very small number is added to
%  the denominator.
%   
%  To view the 8-bit image of type double, divide by 255.
%  To view the 16-bit image of type double, divide by 65535.
%                 
% Example 1 :
% ---------
%   Divide two images together:
%
%                   X = imread('Cam.bmp');
%                   Y = imread('Car.bmp');
%                   S = divide_cvip(X,Y);
%                   figure;imshow(S,[]);
%
% Example 2 :
% ---------
%   Divide image by a constant:
%
%                   X = imread('Cam.bmp');
%                   Y = 50;
%                   S = divide_cvip(X,Y);
%                   figure;imshow(S,[]);
%
%
%   See also, add_cvip, subtract_cvip, multiply_cvip
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
    if nargin<2,
        error('Too few arguements for divide_cvip');
    elseif nargin>2,
        error('Too many arguements for divide_cvip');
    end;
%----------------------------------------------------------------
% Checking data type of input image and converting to type double if
% necessary    

    if ~isa(a,'double')
        a=double(a);
    end
    
    if ~isa(b,'double')
        b=double(b);
    end
%-------------------------------------------------------------------

%     index=a==0;a(index)=1;
%     index=b==0;b(index)=1;
%----------Logic to support different input image type
%     if isa(a,'uint8') && isa(b,'uint16')
%         a= uint16(a);
%     elseif isa(a,'uint16') && isa(b,'uint8')
%         b=uint16(b);
%     elseif isa(a,'uint8') && isa(b,'double')
%         a=double(a);
%     elseif isa(a,'double') && isa(b,'uint8')
%         b=double(b);
%     elseif isa(a,'double') && isa(b,'uint16')
%         a=uint16(a);
%     elseif isa(a,'uint16') && isa(b,'double')
%         b=uint16(b);  
%     end;
    
    if numel(a)==1 || numel(b)==1,
        div = a./(b+10e-8);
%         index=div==Inf;
%         div(index) = 0;
    else
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
% Performing division operation on images    
        div = a ./ (b+10e-8);
%     div=div/255;
    end
end