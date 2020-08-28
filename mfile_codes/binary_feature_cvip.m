function binfeats = binary_feature_cvip(labeledImage, objLabel,featSelect, varargin)
% BINARY_FEATURE_CVIP  - calculates the 5 first order binary features for an object.
%
% Syntax :
% --------
% binfeats = binary_feature_cvip(labeledImage, objLabel,featSelect, varargin)
%   
% Input Parameters include:
% ------------------------
%
%  'originalImage' The orignial image which can be grayscale or RGB.
%
%  'labelImage'    Label image of MxN size with single object or multiple objects.  
%                   Each object has unique gray value.
%  'objLabel'      Labels of the objects. Column vector (Yx1) or Yx2 matrix.
%                   If row vector, objLabel must be unique gray value
%                   corresponding to each object. If Yx2 matrix, objLabel
%                   must have row index in first column and col index in
%                   second column for each object.
%  'featSelect'    Empty matrix '[]' or Row vector of size 1x5 with 
%                   values 1 or 0 (1->Select or 0->No Select). If [], then
%                   all 5 features are selected. The elements of featSelect
%                   correspond respectively to Area' 'Aspect' 'Centroid' 'Euler' 'Orientation'
%                  'Perimeter' 'Projections' 'Thinness
%
%
% Output Parameter include :  
% -------------------------
%
%   'binfeats'     Cell array containing object name, object label, and feature 
%                   data for selected features.
%                   
% Example 1 :
% ---------
%                   I = imread('Shapes.bmp');
%                   lab_image = label_cvip(I);
%                   objLabel = [1 ;2];
%                   featSelect = [1 0 0 0 1];
%                   binfeats = binary_feature_cvip(lab_image, objLabel,featSelect)
% 
%
% Example 2 :
% ---------
%                   I = imread('Shapes.bmp');
%                   lab_image = label_cvip(I);
%                   objLabel = [1 ;2];
%                   featSelect = [1 0 0 0 0 0 1 0];
%                   binfeats = binary_feature_cvip(lab_image, objLabel,featSelect, 'normWidth',8 , 'normHeight',8)
%                    
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

nVarargs = length(varargin);
if mod(nVarargs,2) % odd number of varargins means something wrong
    error('the variable input areguments should be in pairs')
end

feats_name = {'Area' 'Centroid' 'Orientation' ...
    'Perimeter' 'Euler' 'Projections' 'Thinness' 'Aspect'};
total_feats = 8;
global normWidth normHeight; normWidth=10; normHeight=10;

for k = 1:(nVarargs/2)  % override default if given other values by user
      opt = varargin{2*k -1};
      val = varargin{2*k};
      process_input(opt, val)
end


% If feat_list is empty matrix, all 8 features are selected
% Also check if none feature is selected
if isempty(featSelect)|| ~isnumeric(featSelect)          
    featSelect = ones(1,total_feats);  
elseif ~sum(featSelect),         warning('No feature is selected!!!'); 
    binfeats = {};          return ;    
elseif size(featSelect,2) < total_feats
    featSelect = [featSelect zeros(1, total_feats - size(featSelect,2))];
end



feat_length = nnz(featSelect);
if featSelect(2)
    feat_length = feat_length + 1;
end

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
    if featSelect(i)
        if i~=2 && i~= 6
            feats_title(1,k) =  cellstr(char(feats_name(i)));
            k=k+1;
        elseif i == 2       %centroid Row and column
            feats_title(1,k) =  cellstr([char(feats_name(i)) '_r']);
            feats_title(1,k+1) =  cellstr([char(feats_name(i)) '_c']);
            k=k+2;
        elseif i==6         %projections
            for j=1:normHeight
                feats_title(1,k) =  cellstr(['Proj_H_' num2str(j)]);
                k = k+1;
            end
            for j=1:normWidth
                feats_title(1,k) =  cellstr(['Proj_W_' num2str(j)]);
                k = k+1;
            end   
        end
    end
end

%%  
% The number of feature values calculated are determined by #of features
% selected
feature_val = zeros(num_obj,feat_length); 
obj_name=cell(num_obj,1);

labeledImage = labeledImage(:,:,1); % We ignore other bands on the labeled image.
for count=1:num_obj
%     obj_label = labeledImage;


    gray_level = objList(count);
%     obj_label(obj_label ~= gray_level) = 0;
%     mask = (obj_label == gray_level);

    %% put the feature values calculated in the correct position in feature_val
    k=1;
    for i=1:total_feats
        if featSelect(i)
            switch i
                case 1	% Area
                    feature_val(count,k) =  area_cvip(labeledImage,gray_level );
                    k = k+1;
                case 8  % Aspect
                    feature_val(count,k) =  aspect_cvip(labeledImage, gray_level);
                    k = k+1;
                case 2	% Centroid
                    [feature_val(count,k) ,feature_val(count,k+1)] =  centroid_cvip(labeledImage, gray_level);
                    k = k+2;
                case 5  % Euler
                    feature_val(count,k) =  euler_cvip(labeledImage, gray_level);
                    k = k+1;
                case 3	% Orientation
                    feature_val(count,k) =  orientation_cvip(labeledImage, gray_level);
                    k = k+1;
                case 4  % Perimeter
                    feature_val(count,k) =  perimeter_cvip(labeledImage, gray_level);
                    k = k+1;
                case 6	% Projections
                     [ B_h, B_w ] = projection_cvip(labeledImage, gray_level, normWidth, normHeight);
                     lh = normHeight;   % length(B_h);
                     lw = normWidth ;  % length(B_w);
                    feature_val(count,k:k+lh-1) = B_h;
                    k = k+lh;
                    feature_val(count,k:k+lw-1) = B_w;
                    k = k+lw;
                case 7  % Thinness
                    feature_val(count,k) =  thinness_cvip(labeledImage, gray_level);
                    k = k+1;
            end   
        end
    end

    obj_name(count) = cellstr(['Object' num2str(count)]);   % The first column of the output cell array.
end

%% Create the output cell array
binfeats = [  obj_id feats_title ;  num2cell(objLabel) num2cell(feature_val) ];

end


function process_input(option, value) % Reads optional inputs
 global normWidth normHeight % for projection
 
 option = lower(option);
 switch option
     case 'normwidth'
         normWidth = value;
     case 'normheight'
         normHeight = value;
 end

end
