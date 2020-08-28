function [ outImage] = fuzzyc_cvip( inImage, N, parameters )
% FUZZYC_CVIP - Fuzzy c-means clustering based image segmentation.
% The function performs the image segmenation using fuzzy c-means method.
% Fuzzy c-means is a clustering technique that partitions the image data
% into a number of clusters such that each datapoint may have different 
% degree of association with each cluster.A datapoint belongs to a 
% cluster that has the highest degree.For each cluster, the center is 
% computed, and the original datapoints are mapped to these centers 
% vectors.
%
% Syntax:
% -------
%  outImage = fuzzyc_cvip(inImage, N, parameters)
%    
% Input Parameters include:
% -------------------------
%  'inImage'        1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size.The input image can be of uint8 or double
%                   class.If double class, the function assumes
%                   the data range of image is from 0 to 1.
%  'N'              Number of clusters in each band. 
%                   N = 2 (default)
%  'parameters'     Parameters for objective function computation and 
%                   termination condition of FCM. A row or column vector 
%                   containing m, maximum iteration, and minimum error.
%                   parameters(1): m, fuzzy partition matrix exponent greater than 1
%                                  2.0 (default)
%                   parameters(2): max_iter, maximum iteration
%                                  20 (default)
%                   parameters(3): error_min, minimum error to stop maximum
%                                  iteration
%                                  1e-3 (default)
%
%
% Output Parameter include :  
% ------------------------
%  'outImage'      Segmented image having same size and same class of
%                   input image. 
%                                         
%
% Example :
% -------
%                   I = imread('raphael.jpg');       %original image
%                   O1 = fuzzyc_cvip(I);             %default N and FCM parameters       
%                   figure;imshow(O1,[]);
%                   N = 4;                           %Number of clusters
%                   O2 = fuzzyc_cvip(I,N);           %user specified N and default fcm parameters
%                   figure;imshow(O2,[]);
%                   O3 = fuzzyc_cvip(I,N,[2.5 15 0.01]);  %user specified N and FCM parameters                  
%                   figure;imshow(O3,[]);
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    2/07/2017
%           Latest update date:     3/27/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================
    
    if nargin ~=1 && nargin ~=2 && nargin ~= 3 
        error('Too many or too few input arguments!');
    end
    if nargout ~=0 && nargout ~=1
        error('Too many or too few output arguments!');
    end
    
    %convert the image data type into double
    inputImg = double(inImage);
       
    %set up the default parameters    
    m = 2.0;            %fuzzy partition matrix exponent
    max_iter = 20;      %maxium iteration     
    error_min = 1e-3;   %minimum error     
    if nargin == 3
        if size(parameters,2) == 1
            m = parameters;
        else
            if size(parameters,2) == 2
                m = parameters(1);
                max_iter = parameters(2);
            else
                m = parameters(1);
                max_iter = parameters(2);
                error_min = parameters(3);
            end
            % check if fuzzy partition matrix exponent, m > 1
            if m<=1
                warning('The fuzzy partition matrix exponent must be > 1');
                m = 2.0;
            end
        end
    elseif nargin == 1
        N=2;
    end 
     
    [nrow, ncol, nband] = size(inputImg);   
    outImage = zeros(nrow,ncol,nband);
    
    for b=1:nband
        Jm = ones(max_iter+1,1);
        tempImg = inputImg(:,:,b);
        tempImg = tempImg(:);
        %randomly initialize the cluster membership values
        mue=rand(N,nrow*ncol);
        sum1 = sum(mue);
        mue=mue./repmat(sum1,[N 1]);   
        j=1;     
        while 1
            %calculate the center of clusters
            center = ((mue.^m)*tempImg)./((mue.^m)*ones(nrow*ncol,1));  

            %compute the cluster membership values
            distance = abs((ones(N,1)*tempImg')-(center*ones(1,nrow*ncol)));
            temp_distance = distance.^(-2/(m-1));
            mue=temp_distance./(ones(N,1)*sum(temp_distance));
                                  
            %compute the objective function Jm
            t2=(mue.^m).* ((ones(N,1)*tempImg'-center*ones(1,nrow*ncol)).^2);            
            j=j+1;  Jm(j)=sum(t2(:));                
            
            if (j-1) >= max_iter
                break;
            elseif  abs(Jm(j+1)-Jm(j)) <= error_min
                break;
            end             
        end    
        %find maximum degree of membership to clusters
        max_degree = max(mue);
        max_degree = repmat(max_degree,[N 1]);
        tempmue=mue-max_degree;
        tempmue(tempmue==0)=1;
        tempmue(tempmue<0)=0;
        %assign each pixel to cluster which has the highest membership
        %degree
        img_band = center'*tempmue;
        outImage(:,:,b)=reshape(img_band',[nrow, ncol]);        
    end    
    if isa(inImage,'uint8')
        outImage = uint8(outImage);
    elseif isa(inImage,'uint16')
        outImage = uint16(outImage);
    end    
    
end    
 


