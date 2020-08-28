function [OutIma,ratio, err,size1,size2,time,fData] =kmeans_plus_cvip(InIma,K,max_iters)
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
%  See also, btcdeco_cvip, btcenco2_cvip, btcdecol_cvip, btcencol_cvip,
%  btcdvec_cvip, btcevec_cvip, vipmwrite_cvip, vipmread_cvip, vipmwrite2_cvip, 
%  vipmread2_cvip
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
   
% end
% % a1=reshape(A,r*c*b,1);
len=length(X);
% % msize = numel(A);
% % init_cent(1)=A(randperm(msize, 1));%% Grtting the 1st centroid
% % randidx = randperm(size(X, 1));
% init_cent = X(1, :);

% d=3;
randidx = randperm(size(X, 1));
X1= X(randidx,:);
init_cent = X1(1, :);

initial_centroids = kMeansInitCentroids(X,b, K,init_cent,len);
% Run K-Means algo
[centroids, ~] = runkMeans(X, initial_centroids, max_iters);

idx = ClosestCentroids(X, centroids);
OutIma = centroids(idx, :);
fData = centroids(idx, :);
% Image represented by 3D matrix
if b==3
   OutIma = reshape(OutIma, img_size(1), img_size(2), 3);
else
   OutIma = reshape(OutIma, img_size(1), img_size(2), 1);
end


imwrite(OutIma,'Output_Image.png')
iminfo1 = imfinfo('Output_Image.png');
size1 = iminfo1.FileSize ;
imwrite(A,'Input_image.png');
iminfo = imfinfo('Input_image.png');
size2 = iminfo.FileSize;


ratio = size2/size1;
inimage1 = imread('Output_Image.png');
inimage2 = imread( 'Input_image.png');
err = rms_error_cvip(inimage2,inimage1);


time=toc;

function [centroids, idx] = runkMeans(X, initial_centroids, max_iters)
[m,~] = size(X);
K = size(initial_centroids, 1);
centroids = initial_centroids;
%previous_centroids = centroids;
idx = zeros(m, 1);

 for i = 1:max_iters
    
    idx = ClosestCentroids(X, centroids);
    centroids = Centroids(X, idx, K);
 end
end


function init_cent1=kMeansInitCentroids(X,b, K,init_cent,len)
for d=1:b
    m=1;
for k=1:K
  
 
    %%distance calculation
   
    for i=1:len
     
        for j=1:m
            
         
         
            new(j,1) = sqrt(sum(power((X(i, d) - init_cent(j,d)), 2)));
            
              
        end
      
           min1(i,1)=min(new(:));
           new=0;
           
        
    end
 


 [~,y]=max(min1(:));
 new1 = X(y,d);

         
  
 
 if k==1 && d==1 || k==1 && d==2 || k==1 && d==3
     init_cent1(k,d)=init_cent(k,d);
 else
     
 init_cent1(k,d)=new1;
%  if init_cent1(k,d)==0 || init_cent1(k,d)==1
%      switch d
%      case 1
%       init_cent1(k,d) =mod(1,1);
%      case 2
%         init_cent1(k,d) =mod(1,2);
%      case 3
%          init_cent1(k,d) =mod(1,3);
%      end
%  end
 init_cent(m+1,d)=new1;
 m=m+1;
 end

 
 
 
 
end

end

end

%%Find the distance for getting the index valuefor the pixel which
%%clusters...it belongs to
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

%%Find the distance for getting the index valuefor the pixel which
%%clusters...it belongs to


%%New Centroid by getting the mean of the K clusters
function centroids = Centroids(X, idx, K)
    [~, n] = size(X);
    centroids = zeros(K, n);
    for i = 1:K
        ci = idx==i;
        ni = sum(ci);
        matrix = repmat(ci, 1, n);
        if ni==0
            centroids(i,:)= mode(X);
        else
        centroids(i, :) = sum(X .* matrix) ./ ni;
        end
    end
end


end