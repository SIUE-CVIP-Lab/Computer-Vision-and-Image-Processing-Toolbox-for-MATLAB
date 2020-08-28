function histfeats = hist_feature_cvip(originalImage, labeledImage, objLabel,featSelect)
% HIST_FEATURE_CVIP - calculates the 5 first order histogram features for an object
%
% Syntax:
% -------
% h = hist_feature_cvip(originalImage, labeledImage, objLabel,featSelect)
%   
% Input Parameters include :
% -------------------------
%
%   'originalImage' The orignial image which can be grayscale or RGB.
%
%   'labelImage'    Label image of MxN size with single object or multiple objects.  
%                   Each object has unique gray value.
%   'objLabel'      Labels of the objects. Column vector (Yx1) or Yx2 matrix.
%                   If row vector, objLabel must be unique gray value
%                   corresponding to each object. If Yx2 matrix, objLabel
%                   must have row index in first column and col index in
%                   second column for each object.
%   'featSelect'    Empty matrix '[]' or Row vector of size 1x5 with 
%                   values 1 or 0 (1->Select or 0->No Select). If [], then
%                   all 5 features are selected. The elements of featSelect
%                   correspond respectively to Mean, STD, Skew, Energy, and
%                   Entropy.
%
%
% Output Parameters include :  
% --------------------------
%   'histfeats'     Cell array containing object name, object label, and feature 
%                   data for selected features.
%                   
%
%
% Example :
% -------
%                     originalImage = imread('Stripey.jpg');
%                     labeledImage = zeros(size(originalImage));
%                     labeledImage = labeledImage(:,:,1);
%                     labeledImage(50:200,25:95) = 1;
%                     labeledImage(100:300,255:400) = 2;
%                     featSelect = [1 0 1 0 1];
%                     objLabel = [1 ;2];
%                     output = hist_feature_cvip(originalImage, labeledImage,objLabel,featSelect)
%                  
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    3/13/2017
%           Latest update date:     3/19/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

o = size(originalImage,3);
feats_name = {'Mean' 'STD' 'Skew' 'Energy' 'Entropy'};
total_feats = 5;

% If feat_list is empty matrix, all 20 features are selected
% Also check if no feature is selected
if isempty(featSelect)|| ~isnumeric(featSelect)          
    featSelect = ones(1,total_feats);  
elseif ~sum(featSelect),         warning('No feature is selected!!!'); 
    histfeats = {};          return ;    
elseif size(featSelect,2) < total_feats
    featSelect = [featSelect zeros(1, total_feats - size(featSelect,2))];
end

feat_length = nnz(featSelect);


%% Create the column Obj_id in the output
[num_obj, objdim] = size(objLabel);
objList=zeros(num_obj,1);
if objdim== 2
    for i=1:size(objLabel,1)
        objList(i) = labeledImage(objLabel(i,1),objLabel(i,2)); 
    end 
    obj_id = {'row_obj' 'col_obj'};
else
    objList = objLabel;
    obj_id = {'obj_id'};
end


%% Create the list of selected features (feats_title) which sits in the first row of the output cell array 
k=1;
feats_title = cell(1,feat_length);
for i=1:total_feats
    for j=1:o
        if featSelect(i)
            feats_title(1,k) =  cellstr([char(feats_name(i)) '_' num2str(j)]);
            k=k+1;
        end
    end
end

%%  
% The number of feature values calculated are determined by #of features
% selected and #of bands of the original image.
feature_val = zeros(num_obj,o*feat_length); 
obj_name=cell(num_obj,1);

labeledImage = labeledImage(:,:,1); % We ignore other bands on the labeled image.
for count=1:num_obj
    obj_label = labeledImage;

    MAX_GRAY_LEVEL = intmax(class(originalImage));
    MIN_GRAY_LEVEL = intmin(class(originalImage));

    gray_level = objList(count);
    obj_label(obj_label ~= gray_level) = 0;
    mask = (obj_label == gray_level);
    M = sum(sum(mask));
%     mask3d = repmat(labeledImage,1,1,o);
    obj_img = double(originalImage) .* repmat(obj_label,[1 1 o]);
    
    %% compute p(g) for each band
    gbar = zeros(o,1);
    sigmag = gbar;
    skew = gbar;
    energy = gbar;
    entropy = gbar;
    for d=1:o
        originalImage_one_band = obj_img(:,:,d);
        MAX_GRAY_LEVEL = max(max(originalImage_one_band(mask)));
        MIN_GRAY_LEVEL = min(min(originalImage_one_band(mask)));

        
        g = double(MIN_GRAY_LEVEL:MAX_GRAY_LEVEL);
        pg = g;
        for i = MIN_GRAY_LEVEL:MAX_GRAY_LEVEL
            m = (originalImage_one_band(mask) == i);
            
            pg(g == i) = sum(sum(m))/M;
        end
        %% compute the features 
        gbar(d) = sum(g.*pg);
        sigmag(d) = sqrt(sum( ( (g- gbar(d)).^2 ).*pg ));
        if sigmag(d) == 0 && sum((g- gbar(d)).^3) == 0
            skew = 256;
        else
        	skew(d) = (1/sigmag(d)^3).* sum(((g- gbar(d)).^3).*pg );
        end
        energy(d) = sum(pg.^2);
        entropy(d) = -1* sum(log2(pg.^pg));
    end
    
    h = [gbar/count ,sigmag/count, skew, energy, entropy];
    
    %% put the feature values calculated in the correct position in feature_val
    k=1;
    for i=1:total_feats
        for j=1:o
            if featSelect(i)
                feature_val(count,k) =  h(j,i);
                k=k+1;
            end
        end
    end

%     obj_name(count) = cellstr(['Object' num2str(count)]);   % The first column of the output cell array.
end

%% Create the output cell array
histfeats = [  obj_id feats_title ;  num2cell(objLabel) num2cell(feature_val) ];

end
