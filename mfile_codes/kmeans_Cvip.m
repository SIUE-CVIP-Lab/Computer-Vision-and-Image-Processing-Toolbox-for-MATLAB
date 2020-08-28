function [OutIma,ratio,err,size1,size2,time,fData] =kmeans_Cvip(InIma,K,max_iters)
% kmeans_plus_CVIP - Encodes an input image using kmeans++ algorithm
%                with the given cluster and iteration numbers.
%  
% Syntax :
% ------
% [X_recovered] = kmeans_plus_cvip(InIma,K,max_iters)
%
% Description :
% -----------
% 
%
%                   
%
% After computing block parameters the file stream of data (fData) is 
% conformed, if the block size (Blk) is not a power of two the block
% information is zero padded to complete the closest 8 bit.
%
% Input parameters include :
% ------------------------       
%   'InIma'      Binary, Grayscale or RGB Image
%   'K'          Cluster number
%   'max_iters'  maximum iterations
% 
% Output parameters include :
% ------------------------       
%  
%   'OutIma'     Output image after k_means++ clustering
% Example 1:
% -------
% Read a RGB image, computes its BTC data and show the compressed image:
%
%               
%
%  
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications 
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Hridoy Biswas
%           Initial coding date:    05/20/2020
%           Updated by:             Hridoy Biswas
%           Latest update date:     06/06/2020
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================
% Each RGB value ranges from 0-255 (8'cameraman.tif'resentation).
% So, all values are in range 0-1
InIma = double(InIma);
A = InIma/255;
tic;

img_size = size(A);


[~,~,b] = size(A);

if b==1
    
   X = reshape(A, img_size(1)*img_size(2), 1);
else
    X = reshape(A, img_size(1)*img_size(2), 3);
end



initial_centroids = kMeansInitCentroids(X,K);
% Run K-Means algo
[centroids, ~] = kMeans(X, initial_centroids, max_iters);

idx = ClosestCentroids(X, centroids);
fData = centroids(idx, :);
% Image represented by 3D matrix
if b==3
   OutIma = reshape(fData, img_size(1), img_size(2), 3);
else
   OutIma = reshape(fData, img_size(1), img_size(2), 1);
   
end
% OutIma = uint8(OutIma);
imwrite(OutIma,'C.png')
iminfo1 = imfinfo('C.png');
size1 = iminfo1.FileSize ;
imwrite(A,'Input_Image.png')
iminfo = imfinfo('Input_Image.png');
size2 = iminfo.FileSize;
ratio = size2 /size1;
inimage1 = imread('C.png');
inimage2 = imread('Input_Image.png');
err = rms_error_cvip(inimage1,inimage2);
% OutIma1 = uint8(OutIma);
% vipmwrite2_cvip(A,'Input_image.vipm');
% [inimage2, Info1] = vipmread_cvip('Input_image.vipm');
% vipmwrite2_cvip(OutIma1,'Output_Image.vipm')
% [inimage1, Info] = vipmread_cvip('Output_Image.vipm');

% size1 = Info.file_size;
% size2 = Info1.file_size;
% ratio = Info1.file_size/Info.file_size;
% 
% err = rms_error_cvip(inimage2,inimage1);

time=toc;
function [centroids, idx] = kMeans(X, initial_centroids, max_iters)
[m,~] = size(X);
K = size(initial_centroids, 1);
centroids = initial_centroids;
%previous_centroids = centroids;
idx = zeros(m, 1);

 for i = 1:max_iters
    
    idx = ClosestCentroids(X, centroids);
    centroids = computeCentroids(X, idx, K);
 end
end

function centroids = kMeansInitCentroids(X, K)
%centroids = zeros(K, size(X, 2));

randidx = randperm(size(X, 1));
centroids = X(randidx(1:K), :);
end
function idx = ClosestCentroids(X, centroids)
    K = size(centroids, 1);
    idx = zeros(size(X, 1), 1);

    for i = 1:size(X, 1)
        index = zeros(1, K);
        for j = 1:K
               index(1, j) = sqrt(sum(power((X(i, :) - centroids(j, :)), 2)));
           
        end
        [~, id] = min(index);
        idx(i, 1) = id;
    end
end
%%New Centroid by getting the mean of the K clusters
function centroids = computeCentroids(X, idx, K)
    [~, n] = size(X);
    centroids = zeros(K, n);
    for i = 1:K
        ci = idx==i;
        ni = sum(ci);
        matrix = repmat(ci, 1, n);
        centroids(i, :) = sum(X .* matrix) ./ ni;
    end
end



end

