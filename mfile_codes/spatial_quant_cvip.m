function [ outImage ] = spatial_quant_cvip( inImage, row, col, method)
% SPATIAL_QUANT_CVIP - Reduce the image size using spatial quantization method. 
% The function performs spatial quantization using five reduction methods.
% spatial_quant allows the user to specify the number of rows and columns
% in the resultant image,corresponding to the height and width of the new
% image.The integers specified for row and column sizes must be equal to
% or less than the input image sizes or an error results.  
% Five methods are available for image reduction:
%     1) AVERAGE - each pixel in the new image represents an average of the
%        original image pixels it replaces 
%     2) MEDIAN - each pixel  in  the  new  image  represents  the median 
%        value of the original image pixels it replaces
%     3) DECIMATION - each pixel in the new  image  has  the  same value as
%        a corresponding pixel in the original image; other original-image
%        pixels are discarded
%     4) MAXIMUM - each pixel  in  the  new  image  represents  the maximum 
%        value of the original image pixels it replaces
%     5) MINIMUM - each pixel  in  the  new  image  represents  the minimum 
%        value of the original image pixels it replaces
% 
% Because the user may enter different values for  height  and  width,
% spatial_quant may  be used to geometrically distort the image in a
% rubber-sheet fashion.  
%
%
% Syntax :
% ------
% outImage = spatial_quant_cvip( inImage, row, col, method)
%   
% 
% Input Parameters include :
% ------------------------
%   'inImage'       Input image of MxN or MxNxB size. The input image can
%                   be of uint8 or uint16 or double class.  
%   'row'           Number of rows or height (1 < row <= M).
%                                                             (M | default)
%   'col'            Number of columns or width (1 < col <= N).
%                                                             (N | default)
%   'method'        Reduction method.
%                     method = 1 ---> average      
%                     method = 2 ---> median  
%                     method = 3 ---> decimation    
%                     method = 4 ---> maximum    
%                     method = 5 ---> minimum    
%                                                             (1 | default)
%
%
% Output Parameter include  :  
% ------------------------
%   'outImage'      Cropped subimage
%                                         
%
% Examples :
% --------
%       I = imread('cam.bmp');    %original image
%       O1 = spatial_quant_cvip(I, 200, 200);       %default method
%       figure; imshow(O1/255);
%       O2 = spatial_quant_cvip(I, 180, 200, 3);   %user defined parameters
%       figure; imshow(O2/255);             
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

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
if nargin ~=1 && nargin ~= 2 && nargin ~= 3 && nargin ~= 4
    error('Too many or too few input arguments!');
end

%check number of output arguments
if nargout ~= 1 && nargout ~= 0
    error('Too many output arguments!');
end

%size of the input image
[M, N, B] = size(inImage);

%setting up default parameters
if ~exist('row','var') || isempty(row)
    row = M;
end
if ~exist('col','var') || isempty(col)
    col = N;
end
if ~exist('method','var') || isempty(method)
    method = 1;
end

%create the outputImage
outImage = zeros(row,col, B);

%compute width and height ratios
ratio_height = M/row;
ratio_width = N/col;

%check if new image is smaller than original image
if (ratio_height < 1 || ratio_width < 1)
    error('The new image must be smaller than original image!')
end

%row index and col index to divide image into blocks
r1= floor(ratio_height * (1:row));
c1= floor (ratio_width*(1:col));
r_ind = r1 - [0 r1(1:end-1)];
c_ind = c1 - [0 c1(1:end-1)];

for b=1:B
    tempImage = inImage(:,:,b);
    %create a cell array of sub-blocks
    cell_of_subBlocks = mat2cell(tempImage,r_ind,c_ind);

    %convert contents of each cell element to vector
    cell_of_vectorElement=cellfun(@(x) x(:), cell_of_subBlocks, 'UniformOutput',false);

    %Perform spatial quantization
    switch method
        case 1 % Mean
            resultImage=cellfun(@mean, cell_of_vectorElement, 'UniformOutput',true);
        case 2 % Median
            resultImage=cellfun(@median, cell_of_vectorElement, 'UniformOutput',true);
        case 3 % Decimation
            resultImage=cellfun(@(x) x(end), cell_of_vectorElement, 'UniformOutput',true);
        case 4 % Maximum
            resultImage=cellfun(@max, cell_of_vectorElement, 'UniformOutput',true);
        case 5 % Minimum
            resultImage=cellfun(@min, cell_of_vectorElement, 'UniformOutput',true);
        otherwise
            warning('\n\tNo such method available!');
            resultImage = [];
    end
    
    %combine each band to create outputImage
    outImage(:,:,b) = resultImage;
end
end % end of function
