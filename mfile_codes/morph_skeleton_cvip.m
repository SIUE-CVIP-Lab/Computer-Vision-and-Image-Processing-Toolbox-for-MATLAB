function [outImage] = morph_skeleton_cvip(inImage, filtSkel, numIter, masksType, method)
% MORPH_SKELETON_CVIP- perform morphological skeletonization of a binary image.
% The function performs morphological skeletonization on a binary image.
% If input image is color or gray-scale image, first, binary thresholding 
% is performed on the input image. Then, morphological skeletonization 
% is performed on binary image. The skeletonization filter or mask is 
% square matrix containing 0's, 1's and x's or "don't care".Here,don't 
% care element is represented by NaN value.And,don't care elements can
% match with either 0s or 1s.
%
% Syntax :
% -------
% [outImage] = morph_skeleton_cvip(inImage, filtSkel, numIter, masksType, method)
%   
% 
% Input Parameters include :
% ------------------------
%   'inImage'       Binary image of MxN size. If not binary image, binary  
%                   thresholding is performed on input image before 
%                   thinning operation.    
%
%                                                               
%   'filtSkel'      Skeletonization filter or mask of K*K size. And K
%                   must be a positive odd integer. Use thinskel_mask_cvip
%                   function to create an initial mask. The function can
%                   create diagonal or non-diagonal mask. 
%                       if maskType = 0, filtSkel must be diagonal mask
%                       if maskType = 1, filtSkel must be non-diagonal mask
%                       if maskType = 2, filtSkel must either diagonal or 
%                                        non-diagonal mask
%                          (Default: filtSkel = [0 0 0; nan 1 nan; 1 1 1];)
%
%   'numIter'       Number of iterations (usually 2-20). 
%                                                             (Default: 10)
%
%   'masksType'     Type of masks based on connectivity.
%                       masksType = 0 for four diagonal masks.
%                       masksType = 1 for four horizontal/vertical masks.
%                       masksType = 2 for eight directional masks.
%                   
%                                                              (Default: 1)
%
%   'method'        Method to combine thinning results from all directions.
%                       method = 0, AND method
%                       method = 1, Sequential method
%                                                              (Default: 0)
%
%
% Output Parameter include :  
% ------------------------
%   'outImage'      Output image of skeletonization operation. 
%
%
% Example 1 :
% ---------
%             inimage = imread('Shapes.bmp');
%             filtSkel  = [0   0   0;nan     1   nan;1   1   1]; 
%             numIter = 10;
%             masksType = 1;
%             method = 0;
%             [outImage] = morph_skeleton_cvip(inimage, filtSkel, numIter, masksType, method); 
%             figure;imshow(inimage);title('Input Image');
%             figure; imshow(outImage,[]); title('Morphological skeleton with default parameters');
%             %Perform morphological skeleton using user specified parameters 
%             inimage = imread('Shapes.bmp');          %original image 
%             filtSkel = [0 0 0; nan 1 nan; 1 nan 1]; 
%             numIter = 15; 
%             masksType = 2; 
%             method = 1;
%             [outImage] = morph_skeleton_cvip(inimage, filtSkel, numIter, masksType, method);  
%             figure; imshow(outImage,[]); title('Morphological skeleton with user specified parameters');
%             
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
if nargin ~= 1 && nargin ~= 2 && nargin ~= 3 && nargin ~= 4 && nargin ~= 5
    error('Too many or too few input arguments!')
end
if nargout ~= 0 && nargout ~= 1 
    error('Too many or too few output arguments!')
end

%--------------------------------------------------------------------------
%set-up default parameters

%skeleton filter
if ~exist('filtSkel','var') || isempty(filtSkel) 
    if masksType ~= 0   %four diagonal masks case
        filtSkel = [0     0   0;  ...
                    nan   1   nan;  ...
                    1     1   1];   %default case
    else               %four non-diagonal or eight directional mask case
        filtSkel = [1     1   nan;  ...
                    1     1   0;  ...
                    nan   0   0];   %default case
    end
end

%number of iterations
if ~exist('numIter','var') || isempty(numIter) 
   numIter = 10;
end

%masks' type
if ~exist('masksType','var') || isempty(masksType) 
   masksType = 1;
end

%method
if ~exist('method','var') || isempty(method) 
   method = 0;
end

%-------------------------------------------------------------------------

%check if initial filter or mask is a square matrix 
%Also, the length of side must be positive odd integer.
[num_rows, num_cols] = size(filtSkel);

if (num_rows ~= num_cols) && mod(num_rows, 2) ~= 1
    error('Skeletonization filter must be K*K matrix! K must be odd & positive integer!');
end

%convert input image type to logical array
inImage = logical(inImage);


%create skeletonization filter based on initial mask
maskSkel = createmask_skeletonization(filtSkel, masksType);

%--------------------------------------------------------------------------
%Perform skeletonizatin operation
if method == 0 %AND method
    N = size(maskSkel,3);     %N = 4 or 8, based on 4-connectivity  
                                           %or 8-connectivity
    while numIter > 0
        outImage = morph_thinning_cvip(inImage, maskSkel(:,:,1));
        for j=2:N    %repeat for each direction
            outImage = outImage & morph_thinning_cvip(inImage,...
                maskSkel(:,:,j));
        end
        numIter = numIter -1;
        inImage = outImage;
    end
elseif method == 1 %Sequential method
    N = size(maskSkel,3);     %N = 4 or 8, based on 4-connectivity  
                                           %or 8-connectivity
    outImage = inImage;
    while numIter > 0
        for j=1:N    %repeat for each direction
            outImage = morph_thinning_cvip(outImage,maskSkel(:,:,j));
        end
        numIter = numIter -1;
    end
else
    error('No such method available!');
end
    
%--------------------------------------------------------------------------
end %end of morph_skeleton_cvip function



%--------------------------------------------------------------------------
%Function to create the masks for skeletonization operation
function [maskSkel] = createmask_skeletonization(initialMask, connectivity)
%Create the mask for skeletonization operation
if nargin ~= 1 && nargin ~= 2 
    error('Too many or too few input arguments!')
end
if nargout ~= 0 && nargout ~= 1 
    error('Too many or too few output arguments!')
end


%find size of initialMask
[nrow, ncol] = size(initialMask);

%create output mask based on connectivity
switch connectivity
    case 0   %4-diag mask
        maskSkel = zeros(nrow,ncol,4);
        maskSkel(:,:,1)= initialMask;
        j=2;
        %assuming initialMask as diagonal mask
        for angle=90:90:270
            maskSkel(:,:,j) = rotmask_cvip(initialMask,angle);
            j=j+1;
        end
            
    case 1   %4-hor/ver mask
        maskSkel = zeros(nrow,ncol,4);
        maskSkel(:,:,1)= initialMask;
        j=2;
        %assuming initialMask as not diagonal mask or side mask
        for angle=90:90:270
            maskSkel(:,:,j) = rotmask_cvip(initialMask,angle);
            j=j+1;
        end
        
    case 2   %8-directional mask
        maskSkel = zeros(nrow,ncol,8);
        maskSkel(:,:,1)= initialMask;
        j=2;
        %assuming initialMask as not diagonal mask or side mask
        for angle=45:45:315
            maskSkel(:,:,j) = rotmask_cvip(initialMask,angle);
            j=j+1;
        end
end


end



