function [ outImage ] = zoom_cvip( inImage, quadrant, factor, method, startPoint, sizeSR)
% ZOOM_CVIP - Zoom an entire image or a part of the image by a given factor. 
% The maximum zoom factor allowed is 10.Two zoom methods are
% available: zero-order and first order zooming algorithms. 
%
% Syntax :
% -------
% outImage = zoom_cvip( inImage, quadrant, factor, method, startPoint, sizeSR)
%   
% Input Parameters include :
% ------------------------
%
% 'inImage'       Input image of MxN or MxNxB size. The input image can
%                 be of uint8 or uint16 or double class. 
% 'quadrant'      Specify a region of the image. It is of string class.
%                      'ul' ---->  upper left quadrant
%                      'ur' ---->  upper right quadrant
%                      'll' ---->  lower left quadrant
%                      'lr' ---->  lower right quadrant
%                      'all' ----> entire image
%                      'def'---->  specify the subregion( use the input
%                                  arguments #5 and #6 to define subregion) 
%                                                          ('ul' | default)
% 'factor'       Zoom factor (1.0 - 10.0)   
%                                                             (2 | default)
% 'method'       Zoom methods.   
%                       0 -----> zero-order hold
%                       1 -----> first-order hold (linear interpolation)
%                                                             (0 | default)
% 'startPoint'    Upper-left pixel location of a subregion. Only needed 
%                 if 'def' option is selected for quadrant parameter.   
%                       startPoint(1) ---> row co-ordinate
%                       startPoint(2) ---> column co-ordinate
% 'sizeSR'        Size of the sub-region. Only needed if 'def' option is 
%                 selected for quadrant parameter.   
%                       sizeSR(1) ---> height
%                       sizeSR(2) ---> width
%
%
% Output Parameter include :  
% ------------------------
% 'outImage'      Output  subimage
%                                         
%
% Examples :
% --------
%        I = imread('cam.bmp');      %original image
%        O1 = zoom_cvip(I);                %default parameters  
%        figure; imshow(O1/255);
%        O2 = zoom_cvip(I,'ur', 2.0, 0);   %user defined parameters
%        figure; imshow(O2/255);
%        O3 = zoom_cvip(I,'def',3.0, 0, [100  100], [156 120]);  
%        figure; imshow(O3/255);
%                                                                      
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    4/14/2017
%           Latest update date:     4/14/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

%check number of input arguments
if nargin ~=1 && nargin ~= 2 && nargin ~= 3 && nargin ~= 4 && nargin ~= 5 && nargin ~= 6
    error('Too many or too few input arguments!');
end

%check number of output arguments
if nargout ~= 1 && nargout ~= 0
    error('Too many output arguments!');
end

%set up default parameters
default_quadrant = 'ul';    %upper-left subregion as default subimage
default_factor = 2.0;       %default zoom factor
default_zoomMethod = 0;     %default method as Zero order hold

%check if input arguments exist or is not empty
if ~exist('quadrant','var') || isempty(quadrant)
    quadrant = default_quadrant;
elseif strcmp(quadrant, 'def')
    if ~exist('startPoint', 'var') || ~exist('sizeSR','var')
        error('Please specify the sub-regions!\n');
    end
end
if ~exist('factor','var') || isempty(factor)
    factor = default_factor;
elseif factor > 10
    factor = 10;
    warning('Zoom factor must be upto 10!');
else
    factor = ceil(factor);  %rounded to the nearest high integer value
end
if ~exist('method', 'var') || isempty(method)
    method = default_zoomMethod;
end


%find size of image
[R, C, ~] = size(inImage);

%find the region of image to be zoomed
center = ceil([R/2 C/2]);
switch quadrant
    case 'ul'  %Upper-Left quadrant
        tempImage = inImage(1:center(1), 1:center(2),:);
    case 'ur'  %Upper-right quadrant
        tempImage = inImage(1:center(1), center(2)+1:C, :);
    case 'll'  %Lower-Left quadrant
        tempImage = inImage(center(1):R, 1:center(2), :);
    case 'lr'  %Lower-right quadrant
        tempImage = inImage(center(1):R, center(2):C, :);
    case 'all'  %All quadrants (whole image)
        tempImage = inImage;
    case 'def'  %specify the sub-region
        if ~exist('startPoint','var') || isempty(startPoint)
            startPoint = default_startPoint;
        end
        if ~exist('sizeSR', 'var') || isempty(sizeSR)
            endPoint = [R  C];
        else
            endPoint = sizeSR + startPoint;
        end        
        if endPoint(1) > R || endPoint(2) > C
            error('The size of sub-image exceeds the maximum height or width of image');
        end
        tempImage = double(inImage(startPoint(1):endPoint(1)-1, startPoint(2):endPoint(2)-1, :));
end
    
  
%start the zoom operation
[R1, C1, B] = size(tempImage);


switch method
    
    case 0 %zero-order hold method
        outImage = zeros(R1*factor, C1*factor, B);
        temp = zeros(R1*factor, C1, B);
        
         for r=1:factor %repeat each row
            temp(r:factor:end,:,:) = tempImage;
        end
        for c=1:factor %repeat each column
            outImage(:,c:factor:end,:) = temp;
        end
        
    case 1  %linear-interpolation method
        outImage = zeros((R1-1)*factor+1, (C1-1)*factor+1, B);
        temp = zeros((R1-1)*factor+1, C1, B);
        
        %first, linearly interpolate along the rows
        diff = tempImage(1:end-1,:,:) - tempImage(2:end,:,:);
        diff_new = double(diff/factor);
        temp(1:factor:end,:,:) = tempImage;
        for k=2:factor
            if k==2
                temp(k:factor:end,:,:) = temp(k-1:factor:end-1,:,:) - ...
                    diff_new;
            else
                temp(k:factor:end,:,:) = temp(k-1:factor:end,:,:) - ...
                    diff_new;
            end
        end
        
        %second, linearly interpolate along the columns
        diff = temp(:,1:end-1,:) - temp(:,2:end,:);
        diff_new = diff/factor;
        outImage(:,1:factor:end,:) = temp;
        for k=2:factor
            if k == 2
                outImage(:,k:factor:end,:) = outImage(:,k-1:factor:end-1,:)...
                    - diff_new;
            else
                outImage(:,k:factor:end,:) = outImage(:,k-1:factor:end,:) ...
                    - diff_new;
            end
        end
        
    otherwise
        error('No such zoom method available!');
end

    
end % end of function
