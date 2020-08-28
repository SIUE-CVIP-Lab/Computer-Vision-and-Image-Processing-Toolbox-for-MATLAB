function [outImage] = split_merge_cvip( inImage, N, testType, testArgs)
% SPLIT_MERGE_CVIP -Perform Split-Merge Segmentation of an image.
% The function performs Split & Merge Segmentation on a grayscale image.
% If input image is 3-band image,it performs PCT transform and then
% segments only the principal component.To perform either split or merge
% operation,homogeneity test is required.A  homogeneity test is used to
% determine if the Region of Interest is homogeneous,if it is then all
% the pixels in that region are replaced with their average (in the
% segmented image).The level to begin the split and merge is related to the size of
% the beginning region,specifically,the smaller the number the larger
% the beginning region.The chosen homogeneity test is the test that is
% to be used throughout the split and merge segmentation process.
%
%
% Syntax :
% ------
% [outputImage] = split_merge_cvip( inputImage, entryLevel, choice, testArgs)
%   
% 
% Input Parameters include :
% ------------------------
%   'inImage'       2-D or 3-D Image array. The image can be of uint8,
%                   int16, int32, single or double class. 
%   'N'             Initial level of split in each direction (horizontal &
%                   vertical). After initial splitting, (N+1)^2 subregions
%                   are formed. 
%                   (default| 7)
%   'testType'      Type of the homogeneity test              (default| 2)
%   'testArgs'      Parameter of homogeneity test. Only Variance test has
%                   the input parameter (i.e. threshold value). For more 
%                   details, refer to Homogeneity Test section.
%
%
% Output Parameter include :  
% ------------------------
%   'outImage'      Segmented image using Split and Merge method
%   
%                                         
%
% Example :
% -------
%                   I = imread('cam.bmp');               %original image
%                   O1 = split_merge_cvip(I);            %default parameters  
%                   %segemented image with non-default input parameters 
%                   %N=7, testType = 3 (variance test), testArgs = 20 (threshold)
%                   O2 = split_merge_cvip(I,7,3,15);                              
%                   figure;imshow(remap_cvip(O1,[]));
%                   figure;imshow(remap_cvip(O2,[]));
%
%   Homogeneity Test:
%   ------------------
%   1. Local Mean vs. Global Mean       
%      Region  is  considered homogeneous  if  the  local  mean is greater
%      than the global mean. To select this test, pass testType value as 1,
%      i.e. testType = 1. 
%      (No test arguments are needed)
%
%   2. Local Standard Deviation vs. Global Mean       
%      Region is considered homogeneous if the local standard deviation is
%      less than 10% of the global mean. To select this test, pass testType
%      value as 2, i.e. testType = 2. 
%      (No test arguments are needed)
%
%   3. Variance      
%      Region is considered homogeneous if the local standard deviation is
%      less than threshold. (It is recommended to use threshold value in
%      the range of 10 - 50). To select this test, pass testType value
%      as 3, i.e. testType = 3. 
%      (Threshold value as test argument is needed)
%
% 
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.
  
%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    4/20/2017
%           Latest update date:     5/10/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================


if nargin ~= 0 && nargin ~= 1 && nargin ~= 2 && nargin ~= 3 && nargin ~= 4 
    error('Too many or too few arguments!')
end

if nargout ~=0 && nargout ~= 1
    error('Too many or too few arguments!')
end

%setup default parameters
if nargin ==1
    testType = 2;
    N = 7;
    testArgs = [];
elseif nargin == 2
    testType = 2;
    testArgs = [];
elseif nargin == 3
    if testType ~= 3
        testArgs = [];
    else
        testArgs = 30;
    end
elseif nargin == 4
    if isempty(testArgs)
        testArgs = 30;
    end
end


N = N + 1;   %N lines create N+1 regions
image_in = double(inImage);
[nrow, ncol, nband] = size(image_in); 
%check if input image is RGB image, perform PCT transform 
if nband == 3 
    [pctimg,ee] = pct_cvip(inImage);  
    image_in = pctimg(:,:,1); %principal component only
    nband = 1;
end
 
%zero pad the image if the root node cannot be evenly splitted
row_mod = mod(nrow, N);
col_mod = mod(ncol, N);
rowpad = 0;
colpad = 0;
if row_mod ~= 0 &&  col_mod ~= 0
    rowpad = N - row_mod;
    colpad = N - col_mod;
    image_in = [zeros(floor(rowpad/2),ncol + colpad,nband); ...
        zeros(nrow, floor(colpad/2), nband), image_in,...
        zeros(nrow, colpad - floor(colpad/2), nband); ...
        zeros(rowpad - floor(rowpad/2),ncol + colpad,nband)];
elseif row_mod ~= 0
    rowpad = N - row_mod;
    image_in = [zeros(floor(rowpad/2),ncol,nband); image_in; ...
        zeros(rowpad - floor(rowpad/2),ncol,nband)];
elseif col_mod ~= 0
    colpad = N - col_mod;
    image_in = [zeros(nrow, floor(colpad/2), nband), image_in,...
        zeros(nrow, colpad - floor(colpad/2), nband)];
end

nrow = nrow + rowpad;
ncol = ncol + colpad;

%create outputImage with zero pixel values 
outImage = zeros(nrow,ncol);

for b=1:nband
    tempImage = image_in(:,:,b);     
           
    %process root node
    %split the root node into (entryLevel + 1)^2 nodes
    rowwidth = nrow/N;
    colwidth = ncol/N;
    
    %create adjacency matrix with unique id for each block/node   
    rows_val = 1:N;
    tt1 = rows_val(ones(1,colwidth),:);
    tt1=tt1(:).';    
    tt2 = rows_val(ones(1,rowwidth),:);
    tt2 = tt2(:);    
    adjmat = ones(nrow,1)*tt1 + ((tt2-1)*N)*ones(1,ncol);
    
    %put all nodes/blocks into process list
    id = N*N+1;
    processlist = 1:id-1;  
    
    %process the new nodes
    while ~isempty(processlist)        
        currentNode = processlist(1);
        [test_result, localmean] = homogeneity_test(currentNode, testType, testArgs, adjmat, tempImage);
        if test_result == false
            %split the node
            [split,adjmat] = split_quadNode(currentNode, id, adjmat);
            
            if length(split) == 1 %split was done
                %put new nodes in the processlist
                t_nodes = length(processlist);
                processlist(t_nodes+1: t_nodes + 4) = [id id+1 id+2 id+3];
                %update id 
                id = id + 4;  
            else  %split not possible                
                outImage(adjmat == currentNode) = mean(mean(tempImage(split(1):split(2),split(3):split(4))));
            end        
        
        else %merge the nodes                               
            
            outImage(adjmat == currentNode) = localmean;
            
            %find neighbors of current node 
            neighbor = neighbors_of_node(currentNode, adjmat);
            
            newNode = id;          %currentNode and id have not same value            
            flag = false;             %flag to check successful merge operation
            for i = 2: length(neighbor)
                temp_adj = adjmat;                              
                temp_adj(temp_adj == currentNode | temp_adj == neighbor(i)) = newNode; %update newly merged node's id in temporarily stored adjmat 
                %if new merged nodes pass the test
                [test_result, localmean]= homogeneity_test(newNode, testType, testArgs, temp_adj, tempImage);
                if test_result
                    currentNode = newNode;
                    flag = true;                    
                    adjmat = temp_adj;                   
                    updated_mean = localmean; 
                    
                    %from processlist, remove the neighbor nodes that has 
                    %been successfuly merged 
                    processlist = processlist(processlist ~= neighbor(i));                    
                end                
            end
            %%if successfully merged, keep the merged node as new node
            if flag    
                outImage(adjmat == newNode) = updated_mean; 
                id = id+1;  
            end           
        end
        
        %update the processlist
        %remove the processed node from the processlist
        if length(processlist) > 1
            processlist = processlist(2:end);
        else
            processlist = [];
        end
        
    end    
end
outImage = outImage(floor(rowpad/2)+1:nrow-rowpad + floor(rowpad/2), floor(colpad/2)+1:ncol-colpad + floor(colpad/2));
end%end of function



%==========================================================================
%           sub-function to compute homogeneity test
%==========================================================================
function [test_result, localmean] = homogeneity_test(node, choice, param, temp_adj, tempImage)       
    
    
    switch choice        
            
        case 1          %global mean vs local mean test             
            global_mean = mean(tempImage(:));          
            
            %find the local mean of node region
            tempImage(temp_adj ~= node) = nan;      
            temp = tempImage(:);
            localmean = mean(temp(~isnan(temp)));
            test_result = (localmean > global_mean);             
            
        case 2          % local standard deviation vs global mean test
            
            global_mean = mean(tempImage(:));             
            
            %find the local std deviation of node region             
            tempImage(temp_adj ~= node) = nan;   
            temp = tempImage(:);
            localmean = mean(temp(~isnan(temp)));            
            local_stddev = sqrt(var(temp(~isnan(temp))));
            test_result = (local_stddev < 0.1 * global_mean);
                        
        case 3          % variance test 
            %(modified from CVIPtools C function because original test did not work properly)
            threshold = param;
            
            %find the local std deviation of node region             
            tempImage(temp_adj ~= node) = nan;   
            temp = tempImage(:);
            localmean = mean(temp(~isnan(temp)));            
            local_stddev = sqrt(var(temp(~isnan(temp))));           
            test_result = (local_stddev < threshold);    
            
         %Other tests of CVIPtools C function are not implemented here due to its slow process          
            
    end  
   
end


%==========================================================================
%               sub-function to perform split operation
%==========================================================================
function [split, out_adjmat] = split_quadNode(nodeID, id, adjmat)      
    
    out_adjmat = adjmat;
    %find the indices of pixels of current node 
    %find upper and lower limits of indices
    [r,c] = find(out_adjmat == nodeID);
    rmin = min(r);    rmax = max(r);
    cmin = min(c);    cmax = max(c);      
   
    
    %update new nodes' values in adjmat (adjacency matrix)  
    if rmax - rmin  >= 1 && cmax-cmin >= 1         %atleast 2x2 size sub-region to split into 4 nodes         
        %create four child of node
        ul = id;     %upper-left
        ur = id + 1;     %upper-right
        ll = id + 2;     %lower-left
        lr = id + 3;     %lower-right
        
        t1 = floor((rmax-rmin)/2);  t2 = floor((cmax-cmin)/2);
        out_adjmat(rmin : rmin + t1 , cmin : cmin + t2) = ul;
        out_adjmat(rmin : rmin + t1, cmin + t2 + 1 : cmax) = ur;
        out_adjmat(rmin + t1 + 1 : rmax, cmin : cmin + t2) = ll;
        out_adjmat(rmin + t1 + 1 : rmax, cmin + t2 + 1 : cmax) = lr;        
        split = 1;
       
    else %no split is possible
        split = [rmin rmax cmin cmax]; %return locations of current node to compute its mean        
    end          
       
end


%==========================================================================
%               sub-function to find the neighbors of node
%==========================================================================
function [neighbor] = neighbors_of_node(currentNode, adjmat)      
    

     [nrow, ncol] = size(adjmat);
     %find the neighbors of current node
     temp = zeros(nrow, ncol);
     [r_inds,c_inds] = find(adjmat == currentNode);
     
     
     c = c_inds-1;            %go one pixel position left
     c(c < 1) = 1;            %c must be between 1 and ncol    
     r = r_inds-1;            %go one pixel position top
     r(r < 1) = 1;            %r must be between 1 and nrow
     
     %left neighbor
     temp(r_inds,c) = 1;    
     
     %add top neighbor
     temp(r,c_inds) = 1;     
     
     %add top-left neighbor
     temp(r,c) = 1;           
          
     c = c_inds+1;            %go one pixel position right     
     c(c > ncol) = ncol;      %c must be between 1 and ncol
     
     %add top-right neighbor
     temp(r,c) = 1;           
     
     %add right neighbor
     temp(r_inds,c) =1;       
     
     r = r_inds+1;            %go one pixel position below
     r(r > nrow) = nrow;      %r must be between 1 and nrow
     
     %add bottom-right neighbor
     temp(r,c) = 1;           
     
     %add bottom neighbor
     temp(r, c_inds) =1;      
     
     c = c_inds-1;            %go one pixel position left
     c(c < 1) = 1;            %c must be between 1 and ncol           
     
     %add bottom-left neighbor
     temp(r,c) = 1;    
     
     %final neighbor
     neighbor = temp.*adjmat;
     neighbor(neighbor == currentNode) = 0;     
     neighbor = unique(neighbor);    
     neighbor = neighbor(2:end);
end



