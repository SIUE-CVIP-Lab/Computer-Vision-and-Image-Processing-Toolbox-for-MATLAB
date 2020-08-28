function [outImage] = morph_hitmiss_cvip(inImage, hitmissFilt)
% MORPH_HITMISS_CVIP - perfom morphological hit-miss transform of a binary image.
% The function performs morphological hit-miss transform on a binary
% image.If input image color or gray-scale image, binary thresholding is
% performed before the hit-miss operation.The hit-miss filter is a
% structuring element containing 0's, 1's and NaN's or "don't care".
% Don't care element is represented by NaN value in this case.And,don't
% care elements in the structuring element match with either 0s or 1s.
%
% Syntax :
% ------
% [outImage, struct_el] = morph_hitmiss_cvip(inImage,hitmissFilt )
%   
% Input Parameters include :
% ------------------------
%   'inImage'       Binary image of MxN size. If not binary image, binary  
%                   thresholding is performed on input image before 
%                   hit-miss transform.    
%
%   'hitmissFilt'   hit-miss filter or Structure Element of K*K size. And k
%                   must be a positive odd integer. (use structel_cvip
%                   function to create structuring elements) 
%                   (Default: hitmissFilt = [nan 0 0; 1 1 0; nan 1 nan];)
%                                                               
%
% Output Parameter include :  
% ------------------------
%   'outImage'      Output image of Morphological hit-miss transform. It is 
%                   of logical class. It will be a binary image even if
%                   input image is color or grayscale image.
%
%
% Example 1 :
% ---------
%     %Perform hit-miss tranform using default hit-miss filter
%       I = imread('shapes.bmp');         %original image
%       O1 = morph_hitmiss_cvip(I);             
%       figure;imshow(O1,[]);
%   Example 2
%   ---------
%     %Perform hit-miss transform using user specified hit-miss filter
%       I = imread('shapes.bmp');          %original image
%       kernel = [0 0 0; nan 1 nan; 1 nan 1];
%       O2 = morph_hitmiss_cvip(I,kernel); 
%       figure;imshow(O2,[]);        
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    6/2/2017
%           Latest update date:     6/6/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

%check number of input and output arguments
if nargin ~= 1 && nargin ~= 2 
    error('Too many or too few input arguments!')
end
if nargout ~= 0 && nargout ~= 1 
    error('Too many or too few output arguments!')
end

%check if hit-miss filter arguments are existed
% default values are set-up inside structel_cvip function
if ~exist('hitmissFilt','var') || isempty(hitmissFilt) 
    hitmissFilt = [nan   0   0;  ...
                   1     1   0;  ...
                   nan   1   nan];
end

%check if hit-miss filter is a square matrix 
%Also, the length of side must be positive odd integer.
[num_rows, num_cols] = size(hitmissFilt);

if (num_rows ~= num_cols) && mod(num_rows, 2) ~= 1
    error('Hitt-miss filter is not K*K matrix or K is not odd & positive integer!');
end

%centers of structuring element or hit-miss filter
centr_loc = ceil(num_rows/2);

%Perform Morphological hit-miss
[nrow, ncol, nband] = size(inImage);

%output image
outImage = true(nrow, ncol, nband);
logic0_mat = false(nrow, ncol, nband);
logic1_mat = outImage;

for r = -(centr_loc-1) : centr_loc -1
    for c = -(centr_loc - 1) : centr_loc - 1  
        %fprintf('\n\tr = %d c = %d', r + centr_r,c + centr_c)
        
        %if hit-miss filter element is 1, update the result image with new max value
        %if hit-miss filter element is 0, no change     
        if ~isnan(hitmissFilt(r + centr_loc, c + centr_loc))
            if hitmissFilt(r + centr_loc, c + centr_loc) == true
               kernel_matrix = logic1_mat;
            else
                kernel_matrix = logic0_mat;
            end
            if r < 0
                temp2 = [false(-r, ncol, nband); inImage(1:end+r,:,:)];
            elseif r > 0
                temp2 = [inImage(1+r:end,:, :); false(r,ncol, nband)];
            else
                temp2 = inImage;
            end

            if c < 0
                temp2 = [false(nrow,-c, nband) temp2(:, 1:end+c, :)]; 
            elseif c > 0
                temp2 = [temp2(:, 1+c:end, :) false(nrow,c,nband)];
            end
            
            %find hit or miss with each element of structuring element
            outImage = outImage & (~xor(temp2, kernel_matrix)); 
            
        end             
    end
end

end

