function [ outputImage ] = median_cut_cvip( inputImage, numColors, option )
% MEDIAN_CUT_CVIP -Image segmentation using median-cut method.
% The function performs the segmentation using median-cut method,
% originally developed to map 24-bit color images to 8-bit color.It 
% works by finding the maximum spread along the red, green or blue axes,
% and then dividing the color space with the median value along that 
% axis.This division of the color space continues until the number of
% desired colors is reached.At this point,all the color vectors in a
% given subdivision of the color space are used to find an average color
% for that subdivision.After all the average colors are found, we
% implemented two methods to assign one of the average colors to each
% pixel.In method 1,we directly assign the average color of a cube 
% to the pixels that have same colors of the color cube. In method 2,
% the algorithm goes back and maps each of the original color
% vectors to the closest one.Euclidean distance method is implemented to
% find the closeness.
%
% Syntax :
% -------
% outImage = median_cut_cvip(inImage, numColors, option)
%   
% Input Parameters include:
% -------------------------
%   'inImage'       1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. The input image can be of uint8 or double
%                   class. If double class, the function assumes
%                   the data range of image is from 0 to 1.
%   'numColors'     Number of colors. 
%                   NumColors = 2(default)
%   'option'        Option for mapping of color vectors method. 
%                   If Option = 1, it directly assigns the average color of 
%                   a cube to all pixels associated to that cube.
%                   If Option = 2, it map each of the original color 
%                   vectors to the closest average color(Euclidean distance 
%                   method)
%                   Option = 1(default)
%
%
% Output Parameter includes:  
% --------------------------
%   'outImage'      Segmented image having same size and same class of
%                   input image
%                                         
%
% Example :
% -------
%                   I = imread('butterfly.tif');   %original image
%                   O1 = median_cut_cvip(I);       %default numColors = 2, Option = 1         
%                   N = 8;                         %number of colors
%                   O2 = median_cut_cvip(I,N);     %numColors = 8, but option = 1 as default
%                   O3 = median_cut_cvip(I,N,2);   %numColors = 8 and Euclidean distance method is selected 
%                   figure;imshow(O1,[]);
%                   figure;imshow(O2,[]);
%                   figure;imshow(O3,[]);
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    2/25/2017
%           Latest update date:     3/27/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================


global id;

if nargin ~=1 && nargin ~=2 && nargin ~= 3 
    error('Too many or too few input arguments!');
end

if nargin == 3
    if option ~= 1 && option ~= 2
        option = 1; %Euclidean distance method 
        warning('Default option, i.e. euclidean distance method, is selected!')
    end
    if ~isnumeric(numColors)|| numColors < 2
        numColors = 2;
        warning('numColors is not numeric or not greater than 1!');
    end
elseif nargin == 2 
    option = 1;      %Euclidean distance method   
    if ~isnumeric(numColors)|| numColors < 2
        numColors = 2;
        warning('numColors is not numeric or not greater than 1!');
    end
elseif nargin == 1
    option = 1;
    numColors = 2;
end

if nargout ~= 1 && nargout ~=0
    error('Too many output arguments!');
end

[nrow,ncol,bands] = size(inputImage);

%check number of bands in image, if 1 then copy the image data of band 1 to
%band 2 and band 3 to make 3-band image
if bands ==1 
    inputImage(:,:,2)= inputImage(:,:,1);
    inputImage(:,:,3)= inputImage(:,:,1);
    bands = 3;
end
red_band = inputImage(:,:,1);
green_band = inputImage(:,:,2);
blue_band = inputImage(:,:,3);
rgbdata = fix(double([red_band(:) green_band(:) blue_band(:)])); 

id =1;
cube = create_cube();
root_cube = create_cube();
root_cube.id = 0;
iter_count = 0;
k = 0;
centroid=zeros(numColors,1,bands);
while iter_count <= numColors
    if id==1        
        root_cube.data = rgbdata;
        root_cube=findmaxrange_cube(root_cube);
        [cube(id), cube(id+1)] = medcut(root_cube);
        root_cube.child = [id id+1];
        root_cube.data = [];
    else
        max_id = 0;
        for j=1:id-1
            if cube(j).child == false
                if max_id == 0
                    max_id = cube(j).id;
                end
                if (cube(j).range)> (cube(max_id).range)
                    max_id = j;
                end  
            end
        end         
        [cube(id), cube(id+1)] = medcut(cube(max_id));  
        cube(max_id).child = true;
        cube(max_id).data = [];  
        k=k+1;
    end
    id = id+2;
    iter_count = id-k; 
end

if option == 1
    %Assign centroid value to all pixels of corresponding color cube
    resultimg = zeros(nrow*ncol,bands);
    sum1 = 0;
    for i=1:id-1
        if cube(i).child == false
            temp = cube(i).data;
            [r,~] = find(~isnan(temp(:,1)));
            aa = repmat(cube(i).centroid,[length(r) 1]);
            temp(isnan(temp))=0;
            temp(r,:) = aa;       
            resultimg = resultimg + temp;
            sum1 = sum1 + sum(~isnan(temp));
        end

    end
    outputImage(:,:,1) = reshape(resultimg(:,1),[nrow ncol]);
    outputImage(:,:,2) = reshape(resultimg(:,2),[nrow ncol]);
    outputImage(:,:,3) = reshape(resultimg(:,3),[nrow ncol]);

else
    %compute euclidean distance from each pixel to each centroid, find
    %minimum distance, and assign centroid value which has minimum distance
    %to the pixel
    j=1;
    for i=1:id-1
        if cube(i).child == false
            centroid(j,:) = cube(i).centroid;        
            j=j+1;
        end    
    end
    dist = zeros(nrow*ncol,numColors);
    for b=1:bands
        dist = dist + (rgbdata(:,b)*ones(1,numColors)-ones(nrow*ncol,1)*(centroid(:,b))').^2;
    end
    dist = dist.^1/2;
    for r=1: nrow*ncol
        minmum = dist(r,1);
        index = 1;
        for c =2: size(centroid,1)
            if dist(r,c) < minmum
                minmum = dist(r,c);
                index = c;
            end
        end
        rgbdata(r,:)=centroid(index,:);
    end
    outputImage(:,:,1) = reshape(rgbdata(:,1),[nrow ncol]);
    outputImage(:,:,2) = reshape(rgbdata(:,2),[nrow ncol]);
    outputImage(:,:,3) = reshape(rgbdata(:,3),[nrow ncol]);
end
if isa(inputImage,'uint8')
    outputImage = uint8(outputImage);
elseif isa(inputImage,'uint16')
    outputImage = uint16(outputImage);
elseif   isa(inputImage,'int8')
    outputImage = int8(outputImage);
elseif isa(inputImage, 'int16')
    outputImage = int16(outputImage);
elseif isa(inputImage, 'double')
    outputImage = double(outputImage);
else
    warning('Output data format is converted to double!!!')
end
end


function [cubeA, cubeB]= medcut(cubeIn)
%MEDCUT Split/cut the color cube using median value

    global id;
    cubeA = create_cube();
    cubeB = create_cube();
    rgb = cubeIn.data;
    total_color = sum(~isnan(rgb(:,1)));    
    cubeA.id = id;    cubeB.id = id+1;       
    switch (cubeIn.band)
        case 'r'
            tempdata = rgb(:,1);
        case 'g'
            tempdata = rgb(:,2);
        case 'b'
            tempdata = rgb(:,3);
    end
    %find the histogram of the band having largest range
    tt = tempdata;
    tt(isnan(tt))=0;                
    [hist, edges] = histcounts(tt,'Binwidth',1);
    hist(1)= hist(1)-cubeIn.totalnan;   
    
    %find the median value using the histogram
    med_val = edges(median_histogram(hist));
     
    %all colors that has values equal or less than median in CubeA
    [r, ~] = find(tempdata > med_val);
    rgb(r ,:) = nan;    
    cubeA.totalnan = sum(isnan(rgb(:,1)));
    cubeA.data = rgb;  
    rgb(isnan(rgb))=0;
    cubeA.centroid = fix(sum(rgb)/(total_color-length(r)));
    cubeA=findmaxrange_cube(cubeA);
    cubeA.parent = cubeIn.id;
        
    %all colors that has values greater than median in CubeA
    rgb = cubeIn.data;
    [r, ~] = find(tempdata <= med_val);    
    rgb(r,:) = nan;   
    cubeB.totalnan = sum(isnan(rgb(:,1)));
    cubeB.data = rgb;
    rgb(isnan(rgb))=0;
    cubeB.centroid = fix(sum(rgb)/(total_color-length(r)));
    cubeB = findmaxrange_cube(cubeB);
    cubeB.parent = cubeIn.id;      
end

function cubetemp = findmaxrange_cube(cubetemp)
%FINDMAXRANGE_CUBE finds the maximum range and band having maximum range 
    high_range = max(cubetemp.data);  
    low_range = min(cubetemp.data);
    rgb_range = high_range - low_range;
    max_range = max(rgb_range);
    if max_range == rgb_range(1)
        cubetemp.band = 'r';
        cubetemp.range = rgb_range(1);
    elseif max_range == rgb_range(2)
        cubetemp.band = 'g';
        cubetemp.range = rgb_range(2);
    else
        cubetemp.band = 'b';
        cubetemp.range = rgb_range(3);
    end   
end

function medianval = median_histogram(hist)
%MEDIAN_HISTOGRAM find the median value of histogram
   
    low_bin = 1;
    high_bin = size(hist,2);    
    mid_old=0;
    
    total_pixels = sum(hist);
    while 1
        mid_bin = fix((low_bin+high_bin)/2);
        if mid_old == mid_bin
            break;
        end
        mid_old = mid_bin;
        temp_sum = sum(hist(1:mid_bin));
        if temp_sum < total_pixels/2
            low_bin =  mid_bin;
        elseif temp_sum > total_pixels/2
            high_bin = mid_bin;
        else            
            break;
        end             
    end
    medianval = high_bin;
end


function cube = create_cube()
%CREATE_CUBE Creates the color cube structure
    cube = struct();
    cube.band = '';
    cube.id = [];
    cube.centroid = [];
    cube.data = [];
    cube.range =[];   
    cube.centroid = [];    
    cube.child = false;   
    cube.totalnan = 0;
    cube.parent = [];
end

