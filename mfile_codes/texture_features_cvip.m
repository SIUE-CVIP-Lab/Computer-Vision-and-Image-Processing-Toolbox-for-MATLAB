function texfeats = texture_features_cvip(inImage, labelImage, texDist, featSelect, objLabel, quantLvl, statsType, className)
% TEXTURE_FEATURES_CVIP - Gray level co-occurence matrix (GLCM) based texture features of an image.
%
% Syntax :
% ------
% texfeats = texture_features_cvip(inImage, labelImage, texDist, featSelect, objLabel, quantLvl, statsType, className)
%   
% Input Parameters include :
% ------------------------
%   'inImage'       1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. If 3-band image, it is converted into 
%                   1-band using luminance method.
%   'labelImage'    Label image of MxN size with single object or multiple 
%                   objects. Each object has unique gray level.   
%                   If empty matrix '[]', whole region of image is
%                   selected for feature computations.
%   'texDist'       Texture distance. The td is a positive integer
%                   (1,2,... and so on).
%   'featSelect'    Selection of features. A row vector of length 20 or
%                   Empty matrix '[]'. If row vector, featSelect contains 
%                   sequences of 1s or 0s or combination of both. 1->Select 
%                   or 0->No Select. 
%                   If [], then all 20 features are selected. 
%                   Look *List of Features in next section for the indices  
%                   of features.
%                   Default: -1|no quantization for co-occurence matrices.
%   'objLabel'      Labels of the objects. objLabel is either column vector
%                   (Yx1) or Yx2 matrix. Y = total number of objects i.e.
%                   each row represents each unique object. 
%                   If column vector, objLabel contains unique gray values
%                   corresponding to each object. 
%                   If Yx2 matrix, each row contains any pixel location of
%                   an unique object. First column is row-index second 
%                   column is column index.                
%   'quantLvl'      Number of quantization levels in co-occurence matrices.
%                   Quantization reduces the dimension of GLCM. For
%                   example, if quantLvl = 10, 10*10 GLCM is created to
%                   compute the features.
%                   (default: -1 | No quantization)
%   'statsType'     Statistics type([Average Range Variance]) of the feature
%                   values. A row vector of 1x3 size with each element either 0 or
%                   1 or combination of both. If particular element is '1', 
%                   then corresponding statistics is selected.
%                   The four sets of texture feature values are computed
%                   corresponding to 4 co-occurence matrices for four
%                   directions. The user has the option to select different
%                   statistics of four sets.                     
%   'className'     Class name of each labeled object. Class name can be of 
%                   string or cell class.
%
%
% Output Parameter includes :  
% --------------------------
%   'texfeats'      Cell array containing object name in first column, 
%                   object label in second and third columns, and feature data 
%                   for selected features in remaining columns except the 
%                   last column. The last column contains the class name. 
%                   The first row contains the title of each column.
%                 
%
%
% List of Features 
% ----------------
%
%   SN   Name                                     Abbreviated Name    Index in featSelect
%   
%    1.  Angular Second Moment                    ASM                  1
%    2.  Contrast                                 Contr                2
%    3.  Correlation                              Corr                 3
%    4.  Variance                                 Var                  4
%    5.  Inverse Difference Moment                IDM                  5
%    6.  Sum Average                              SumAvg               6
%    7.  Sum Entropy                              SumEnt               7
%    8.  Sum Variance                             SumVar               8
%    9.  Entropy                                  Entr                 9
%   10.  Difference Variance                      DiffVar             10
%   11.  Difference Entropy                       DiffEnt             11
%   12.  Auto Correlation                         AuCorr              12
%   13.  Dissimilarity                            Dismlr              13
%   14.  Cluster Shade                            CShad               14
%   15.  Cluster Prominence                       CProm               15
%   16.  Maximum Probability                      MaxPr               16
%   17.  Inverse Difference Normalized            IDNorm              17
%   18.  Inverse Difference Moment Normalized     IDMNorm             18
%   19.  Information Measure of Correlation 1     InfoMC1             19
%   20.  Information Measure of Correlation 2     InfoMC2             20
%
%
% Example :
% -------
%                   I = imread('acl.tif');        %original image
%                   M = imread('acl_mask.tif');   %mask image           
%                   td = 3;                       %texture distance
%                   featsel = [1 1 1 0 1];        %selects 4 features among the first five in the list
%                   qL = 100;                     %number of quantization levels
%                   olevel = 255;                 %object label, only one object
%                   stats = [1 0 1];              %statistics type
%                   cN = 'abnormal';              %class of the single object
%                   featurevalue = texture_features_cvip(I,M,td,featsel,olevel,qL,stats,cN)
%
%
% Reference 
% ---------
%   1. Haralick RM, Shanmugam K, Dinstein I. Textural features for image classification. 
%      IEEE Trans Syst Man Cybern. 1973 Transactions;3:610–621.
%   2. Soh LK, Tsatsoulis C. Texture analysis of SAR sea ice imagery using gray level
%      co-occurrence matrices. IEEE Trans Geosci Remote Sensing. 1999;37:780–795.
%   3. Clausi DA. An analysis of co-occurrence texture statistics as a function of
%      grey level quantization. Can J Remote Sensing. 2002;28:45–62

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    07/29/2016
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     03/03/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.2  03/03/2019  12:07:51  jucuell
 % equation to calculate the correlation was modified by using the
 % equations in this reference: Scott E Umbaugh. DIGITAL IMAGE PROCESSING
 % AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.In the
 % equation of the entropy the log function was changed to log2. The
 % variance and inverse difference normalized stills under revision.
%
 % Revision 1.1  07/29/2016  15:23:31  norlama
 % Initial coding and testing. 
%

if nargin ~=1 && nargin ~= 2 && nargin ~= 3 && nargin ~=4 && nargin ~=5 ...
        && nargin ~= 6 && nargin ~=7 && nargin ~=8
    error('Too many or too few input arguments!');
end
if nargout ~=0 && nargout ~=1
    error('Too many or too few output arguments!');
end

num_dir = 4;           % number of directions
total_feats = 20;      % total number of features

% check if input image is gray or rgb image. If rgb, then it is converted
% to gray image using luminance method
if size(inImage,3)==3   
    inImage = 0.3*inImage(:,:,1)+0.6*inImage(:,:,2)+0.1*inImage(:,:,3);
end

%check if texture distance is positive integer i.e. td=1,2,3,...so on
if ~exist('texDist','var') || isempty(texDist)
    texDist = 2;
elseif  texDist<1   
    error('Texture distance must be +ve integer (1,2,3,...)!!!');       
end

% Find the selected feature
% If feat_list is empty matrix, all 20 features are selected
if ~exist('featSelect','var') || isempty(featSelect)|| ~isnumeric(featSelect)          
    feat_length =total_feats;     featSelect = ones(1,feat_length);  
else
    if ~sum(featSelect),         warning('No feature is selected!!!');
    texfeats = {};          return ;    
    end
    if size(featSelect,2) <= total_feats
        featSelect = [featSelect zeros(1, total_feats - size(featSelect,2))];
        feat_length = nnz(featSelect);
    end
end

% create the list of the objects in labeled image
% if ~exist('objLabel','var') || isempty(objLabel)
%     objLabel = unique(labelImage);
%     if objLabel(1) == 0
%         objLabel = (objLabel(2:end))';
%     else
%         objLabel = objLabel';
%     end
% else
%     [num_obj, objdim] = size(objLabel);
%     objList=zeros(num_obj,1);
%     if objdim== 2
%         for i=1:size(objLabel,1)
%             objList(i) = labelImage(objLabel(i,1),objLabel(i,2)); 
%         end         
%     else
%         objList = objLabel;
%     end
% end
[num_obj, objdim] = size(objLabel);
objList=zeros(num_obj,1);
if objdim== 2
    for i=1:size(objLabel,1)
        objList(i) = labelImage(objLabel(i,1),objLabel(i,2)); 
    end 
    obj_id = {'row_obj' 'col_obj'};
else
    objList = objLabel;
    obj_id = {'obj_id'};
end

%check if the option to reduce the dimension of GLCM is selected
%Dimension of GLCM is reduced by quantizing the gray levels of input image
if ~exist('quantLvl','var') || isempty(quantLvl)  %no quantization
    %quantLvl is equal to all the unique levels inside ROI
    quantLvl= -1;
end

%find the statistic types the user wants for selected features
default_statsType = [1 0 0];
if ~exist('statsType','var') || isempty(statsType) || ~isnumeric(statsType) 
    statsType = default_statsType;
else
    if length(statsType) < 3
        statsType = [statsType default_statsType(length(statsType)+1:end)];  
    end
end

%Check if the class names of leveled objects are provided
if ~exist('className','var') || isempty(className) 
    classFlag = false;
else  
    classFlag = true;
    % Formatting output cell array
    if ~iscell(className)
        className = cellstr(className);
        if length(className) ~= num_obj
            classFlag = false;
        end
    end       
end


% Features name
feats_name = {'ASM' 'Contr' 'Corr' 'Var' 'IDM' 'SumAvg' 'SumEnt' 'SumVar'...
    'Entr' 'DiffVar' 'DifEnt' 'AuCorr' 'Dismlr' 'CShad' 'CProm' 'MaxPr'...
    'IDNorm' 'IDMNorm' 'InfoMC1' 'InfoMC2'};
feat_val = zeros(num_dir,feat_length);
feature_val = zeros(num_obj,nnz(statsType)*feat_length);

% Create gray level co-occurence matrix (GLCM) and Compute texture feature values
%glcm is Ng*Ng*4 matrix with four GLCM corresponding to 4 directions 
%glcm(:,:,1) -> vertical (90° ,-90° ), glcm(:,:,2) -> horizontal(0°,180°) 
%glcm(:,:,3) -> Diagonal1(45° , 225°), glcm(:,:,4) -> Diagonal2(135°, 315°)


for j=1:num_obj    %compute texture features for each object in the input image
    maskImage = labelImage;
    maskImage(maskImage~=objList(j,1))=0;
    maskImage = maskImage*255/j;
    glcm = create_glcm(inImage,uint8(maskImage),texDist,quantLvl);
    Ng = size(glcm,1);

    % Calculate the features using each glcm 
    for i=1:num_dir
        feat_val(i,:) = calc_stats(glcm(:,:,i), featSelect, Ng);
    end

    % Average, range, and variance of each feature values from four directions(Ver, Hor, Diag 1, Diag 2)
    row_vec = ones(1,num_dir);    
    k=1; 
    for i=1:nnz(statsType):feat_length*nnz(statsType)
        l=i;
        if statsType(1) == 1 
           feature_val(j,l) = (row_vec*feat_val(:,k))/num_dir;       %average   
           l=l+1;
        end
        if statsType(2) == 1 
             feature_val(j,l) = max(feat_val(:,k))-min(feat_val(:,k));    %range
             l=l+1;
        end
        if statsType(3) == 1 
            feature_val(j,l) = var(feat_val(:,k));               %variance    
        end   
        k=k+1;
    end  
end

%set up texture features as cell array
k=1;
feats_title = cell(1,feat_length*nnz(statsType));
for i=1:total_feats
    if featSelect(i)
        if statsType(1) == 1 
            feats_title(1,k) =  cellstr([char(feats_name(i)) '_Avg']);
            k=k+1;
        end
        if statsType(2) == 1 
            feats_title(1,k) =  cellstr([char(feats_name(i)) '_Range']);
            k=k+1;
        end
        if statsType(3) == 1 
            feats_title(1,k) =  cellstr([char(feats_name(i)) '_Var']);
            k=k+1;   
        end   
    end
end

%check if class of each object is provided
if classFlag  
    texfeats = [ obj_id feats_title {'ClassName'}; num2cell(objLabel) num2cell(feature_val) className];
else          %if class of each object is not provided
    texfeats = [ obj_id feats_title; num2cell(objLabel) num2cell(feature_val)];
end

end
% End of texture_features function


% A function to compute 20 different statistics of GLCM
function feat_value = calc_stats(glcm_array,feat_list, Ng)

total_feats = 20;

% Calculate parameters (px, py, p_xplusy, p_xminusy, meanx, meany, sigmx, sigmy) for feature calcuation
[px, py, p_xplusy, p_xminusy, meanx, meany, sigmx, sigmy] = calcstats_setup(glcm_array,Ng);

%Initialization of feature sets and constant

%Initialization of Ep as an arbitrary small positive constant
%as probabilities may become zero so log(0) is indefinite
%log(p+Ep) becomes nonzero
Ep = 0.0001;
feat_length=nnz(feat_list);
feat_value = zeros(1,feat_length);

% ________________________Feature Calculation____________________________  
 
col_vec = ones(Ng,1); col_vec22 = ones(2*Ng-1,1);
row_index = double(repmat((0:Ng-1)',[1 Ng]));   col_index = row_index';
col_index22 = 2:2*Ng;   col_index33 = 0:Ng-1;

feat_index = 1;
for n=1:total_feats
    if feat_list(n)
        switch feat_list(n)*n
            case 1      % 1. Angular Second Moment    
                feat_value(feat_index) = ((glcm_array.^2)*col_vec)'*col_vec;
            case 2      % 2. Contrast
                temp = zeros(1,Ng);
                for i=1:Ng
                    for j=1:Ng
                        temp(1,abs(i-j)+1)= temp(1,abs(i-j)+1)+glcm_array(i,j);                         
                    end
                end
                feat_value(feat_index) = ((col_index33.^2).*temp)*col_vec;
            case 3      % 3. Correlation                
%                 feat_value(feat_index) = ((((glcm_array.*row_index.*col_index)*col_vec)'...
%                     *col_vec)-meanx*meany)/(sigmx*sigmy);
                feat_value(feat_index) = (((glcm_array.*(row_index-meanx).*(col_index-meany)*col_vec)'...
                    *col_vec))/sqrt(sigmx*sigmy);
            case 4      % 4. Sum of Squares: Variance
%                 feat_value(feat_index) = ((((row_index-meanx).^2).*glcm_array)*col_vec)'...
%                     *col_vec;   
                temp = 0;
                for i=1:255
                    for j=1:255
                            temp = temp + glcm_array(i+1,j+1)*(i-j)^2;
                    end
                end
                feat_value(feat_index) = temp;  
                
%                 feat_value(feat_index) = sum(sum(((row_index-col_index).^2).*glcm_array)); 
                %sum of squares (variance) will be same if(col_index-meany) is used.  
            case 5      % 5. Inverse Difference Moment
                feat_value(feat_index) = ((glcm_array./(1+(row_index-col_index).^2))*col_vec)'...
                    *col_vec;               
            case 6       % 6. Sum Average
                feat_value(feat_index) = (p_xplusy.*col_index22)*col_vec22;
                
            case {7,8}      % 7. Sum Entropy  % 8. Sum Variance
                if feat_list(n)*n == 7    %computes Sum Entropy if true
                    feat_value(feat_index) = -((p_xplusy.*log10(p_xplusy+Ep))*col_vec22);
                else            %computes Sum variance if false
                    feat_value(feat_index) = (((col_index22-feat_value(n-1)).^2).*p_xplusy)...
                        *col_vec22;
                end            
            case 9       % 9. Entropy
                feat_value(feat_index)= -(((glcm_array.*log2(glcm_array+Ep))*col_vec)'...
                    *col_vec);                       % before it uses log10
            case 10     % 10. Difference Variance
                feat_value(feat_index) = ((col_index33.^2).*p_xminusy)*col_vec;                
            case 11     % 11. Difference Entropy
                feat_value(feat_index) = -((p_xminusy.*log10(p_xminusy+Ep))*col_vec);                  
            case 12     % 12. Autocorrelation
                feat_value(feat_index)=(((glcm_array.*row_index.*col_index)*col_vec)'...
                    *col_vec);
            case 13     % 13. Dissimilarity
                feat_value(feat_index)=((abs(row_index-col_index).*glcm_array)*col_vec)'...
                    *col_vec;               
            case 14     % 14. Cluster Shade
                feat_value(feat_index)=((((row_index+col_index-meanx-meany).^3).*glcm_array)...
                    *col_vec)'*col_vec;
            case 15     % 15. Cluster Prominence
                feat_value(feat_index)=((((row_index+col_index-meanx-meany).^4).*glcm_array)...
                    *col_vec)'*col_vec;
            case 16     % 16. Maximum Probability
                feat_value(feat_index) = max(max(glcm_array));
            case 17     % 17. Inverse Difference Normalized
%                 feat_value(feat_index) = ((glcm_array./(1+abs(row_index-col_index)/Ng^2))...
%                     *col_vec)'*col_vec;                
                temp = 0;
                for i=1:255
                    for j=1:255
                        if ~isequal(i,j)
                            temp = temp + glcm_array(i+1,j+1)/abs(i-j);
                        end
                    end
                end
                feat_value(feat_index) = temp*4;  
            case 18     % 18. Inverse Difference Moment Normalized
                feat_value(feat_index) = ((glcm_array./(1+((row_index-col_index).^2)/Ng^2))...
                    *col_vec)'*col_vec;         
            case {19,20}     % 19. Information Measure of Correlation 1
                             % 20. Information Measure of Correlation 2
                hxy = -(((glcm_array.*log10(glcm_array+Ep))*col_vec)'*col_vec);
                hxy1 = -(((log10(repmat(px,[1 Ng]).*repmat(py,[Ng 1])+Ep).*glcm_array)...
                    *col_vec)'*col_vec);
                hxy2 = -(((log10(repmat(px,[1 Ng]).*repmat(py,[Ng 1])+Ep).*(repmat(px,[1 Ng]).*repmat(py,[Ng 1])))...
                    *col_vec)'*col_vec);
                if feat_list(n)*n == 19    
                    feat_value(feat_index) = (hxy-hxy1)/max(hxy,hxy1);
                else            
                    feat_value(feat_index) = sqrt(1-exp(-2*(hxy2-hxy)));
                end  
            otherwise
                warning('Only 20 features available!!!');
        end 
        feat_index = feat_index + 1;
    end
end      
%__________________ End of Feature Calcualtion ____________________________

feat_value = feat_value';
end
% end of cal_stats function


% A function to calculate parameters to measure different statistics of GLCM
function [px, py, p_xplusy, p_xminusy, meanx, meany, sigmx, sigmy] = calcstats_setup(glcm_array, Ng)
%CALCSTATS_SETUP The function computes the values of different parameters
%required to calculate statistics of GLCM matrix.
%    Input:
%       glcm_array = gray level co-occurence matrix of Ng*Ng size
%       Ng = width or height of GLCM
%    Output:
%       px = col vector of Ng x 1
%       py = row vector of 1 x Ng
%       p_xplusy = row vector of 1 x 2Ng-1 but actual runs from 2 to 2Ng
%       p_xminusy = row vector of 1 x 2Ng but actual runs from 0 ot Ng-1
%       meanx, meany, sigmx, sigmy = constant value


col_vec = ones(Ng,1);

% _________________________________________________________________________
%   1. Calculating Px and Py
px=(glcm_array*col_vec);
py=(glcm_array'*col_vec)';

% _________________________________________________________________________
%   2. Calculating pxySUM and pxyDIF

% Initialization of Parameters
p_xplusy = zeros(1, 2*Ng-1); 
p_xminusy = zeros(1, Ng); 
for i=1:Ng
    for j=1:Ng
        p_xplusy(i+j-1)= p_xplusy(i+j-1)+ glcm_array(i,j);
    end
end

for i=1:Ng
    for j=1:Ng
        p_xminusy(abs(i-j)+1) = p_xminusy(abs(i-j)+1) + glcm_array(i,j);
    end
end

% _________________________________________________________________________
%   3. Calculating meanx and meany 
row_index = double(repmat((0:Ng-1)',[1 Ng]));     col_index = row_index';

meanx = ((glcm_array.*row_index)*col_vec)'*col_vec;
meany = ((glcm_array.*(col_index))*col_vec)'*col_vec;

% _________________________________________________________________________
%   4. Calculating sigma of x and sigma of y
sigmx = ((((row_index-meanx).^2).*glcm_array)*col_vec)'*col_vec;
sigmy = ((((col_index-meany).^2).*glcm_array)*col_vec)'*col_vec;

end
% End of calcstats_setup function


% A function to create GLCM Matrix
function  glcm = create_glcm(inputImage, maskImage, td, quantLevel)
%create_glcm Function creates a gray level co-occurence matrix 
%   The function computes co-occurence matrix from the 2D input array.  
%   The input image is remapped or scaled so that it will have Ng levels
%   ranging from 0 to Ng-1. And, it creates a four Ng*Ng normalized GLCM 
%   matrix corresponding to  four directions (vertical,horizontal, right 
%   diagonal, left diagonal).
%
%   Input:  inputImage - 2D input array or image of MxN size
%           maskImage - mask image containing region of interest
%           td - texture distance (integer value 1,2,...)
%           quantLevel - total number of quantized gray levels
%   Output: glcm - Cooccurence matrix of size Ng*Ng*4 corresponding to four
%                   directions,where Ng is number of quantization levels
%           (vertical->1,horizontal->2,right diagonal->3,left diagonal->4)

persistent countobj;
if isempty(countobj)
    countobj = 0;
end
countobj = countobj + 1;
%   Size of Image/Mask
[nrow,ncol] = size(inputImage);

%   If mask image is empty, create a mask image defining whole region as 
%   ROI and create a masked image

if ~isempty(maskImage) || nnz(maskImage) > 0                          %Mask Image Defined
    roi_flag = 1;
    MAX = max(maskImage(:));                     %Mask is binary image
    maskedimg = double(bitand(inputImage,maskImage)); 
    % Find the ROI's starting row and col, and ending row and col
    [row,col]=find(maskImage==MAX);
    min_row = min(row); max_row = max(row);
    min_col = min(col); max_col = max(col);
    % Clip off zeros outside ROI in GLCM creation
    maskedimg(maskImage ~= MAX)=nan;
    maskedimg(isnan(maskedimg))=min(min(maskedimg));    
    
else                  %Mask Image Not Defined or ROI as whole image region
    roi_flag = 0;
    maskedimg = double(inputImage);
    % Find the ROI's starting row and col, and ending row and col
    min_row = 1; max_row = nrow;
    min_col = 1; max_col =ncol;
end

%If no quantization, find the total gray levels in ROI
if quantLevel == -1
    quantLevel = length(unique(maskedimg));
end

% Scale (remap) the ROI values in the range of 0 to Ng-1
xmin = min(min(maskedimg));
xmax = max(max(maskedimg));
ymax = quantLevel-1;
ymin = 0;
maskedimg= fix(((ymax-ymin)/(xmax-xmin))*(maskedimg-xmax)+ymax);

% Creating Gray level Co-occurence Matrix with size Ng*Ng*4 
% Ng = Total number of gray levels, Ng*Ng = total pairs in GLCM
num_dir = 4; % each matrix for four directions
glcm = zeros(quantLevel, quantLevel, num_dir);


% To avoid (r,c)indexes of ROI exceed the image dimension
r_start = min_row;         % r_end = max_row;
c_start = min_col;          c_end = max_col;
if ~(min_row > td),         r_start = min_row+td;        end
%if (max_row+td > nrow),     r_end=max_row-td;            end
if ~(min_col > td),         c_start = min_col+td;        end
if (max_col+td > ncol),     c_end=max_col-td;            end


% Compute GLCM
switch roi_flag
    %======================================================================
    case 0     %Mask image not defined or ROI as whole region of input image
        %__________________________________________________________________
        
        % Vertical 90°  
        dir = 1;
        for r=r_start:max_row
            for c=min_col:max_col
              glcm(maskedimg(r,c)+1,maskedimg(r-td,c)+1,dir)=glcm(maskedimg...
                  (r,c)+1,maskedimg(r-td,c)+1,dir)+1;                
            end
        end
        %__________________________________________________________________
        
        % Horizontal 0° 
        dir=2;
        for r=min_row:max_row
            for c=min_col:c_end
                glcm(maskedimg(r,c)+1,maskedimg(r,c+td)+1,dir)=glcm(maskedimg...
                        (r,c)+1,maskedimg(r,c+td)+1,dir)+1; 
            end
        end
        %__________________________________________________________________
        
        % Diagonal Top Right 45°
        dir=3;
        for r= r_start:max_row
            for c=min_col:c_end
                glcm(maskedimg(r,c)+1,maskedimg(r-td,c+td)+1,dir)=glcm(maskedimg...
                        (r,c)+1,maskedimg(r-td,c+td)+1,dir)+1;  
            end              
        end
        %__________________________________________________________________
        
        %   Diagonal Top Left (135°)  
        dir =4;
        for r= r_start:max_row
            for c= c_start:max_col
                glcm(maskedimg(r,c)+1,maskedimg(r-td,c-td)+1,dir)=glcm(maskedimg...
                        (r,c)+1,maskedimg(r-td,c-td)+1,dir)+1;
            end
        end
        
    %======================================================================    
    case 1     %ROI defined in Mask image 
        %__________________________________________________________________
        
        % Vertical 90°  
        dir = 1;
        for r=r_start:max_row
            for c=min_col:max_col
                % To operate only in region of interest(ROI)        
                if maskImage(r,c) == MAX && maskImage(r-td,c) == MAX
                    glcm(maskedimg(r,c)+1,maskedimg(r-td,c)+1,dir)=glcm(maskedimg...
                        (r,c)+1,maskedimg(r-td,c)+1,dir)+1;
                end
             end

        end
        %__________________________________________________________________
        
        % Horizontal 0° 
        dir=2;
        for r=min_row:max_row
            for c=min_col:c_end
                % To operate only in region of interest(ROI)
                if maskImage(r,c) == MAX && maskImage(r,c+td) == MAX
                    glcm(maskedimg(r,c)+1,maskedimg(r,c+td)+1,dir)=glcm(maskedimg...
                        (r,c)+1,maskedimg(r,c+td)+1,dir)+1; 
                end 
            end
        end
        %__________________________________________________________________
        
        % Diagonal Top Right 45°
        dir=3;
        for r= r_start:max_row
            for c=min_col:c_end
                % To operate only in region of interest(ROI)
                if maskImage(r,c) == MAX && maskImage(r-td,c+td) == MAX
                    glcm(maskedimg(r,c)+1,maskedimg(r-td,c+td)+1,dir)=glcm(maskedimg...
                        (r,c)+1,maskedimg(r-td,c+td)+1,dir)+1; 
                end
            end              
        end
        %__________________________________________________________________
        
        %   Diagonal Top Left (135°)  
        dir =4;
        for r= r_start:max_row
            for c= c_start:max_col
                % To operate only in region of interest(ROI)
                if maskImage(r,c) == MAX && maskImage(r-td,c-td) == MAX
                    glcm(maskedimg(r,c)+1,maskedimg(r-td,c-td)+1,dir)=glcm(maskedimg...
                        (r,c)+1,maskedimg(r-td,c-td)+1,dir)+1;
                end
            end
        end
end

% GLCM is a symmetric matrix, i.e. transpose of GLCMs for 0°, 45°, 90° and 
% 135° are GLCMs for 180°, 225°, 270° and 315° respectively.
% Add corresponding symmetric pair to get final GLCM matrix
for i=1:dir
    glcm(:,:,i)=glcm(:,:,i)+(glcm(:,:,i))';
end

% Normalize glcm by total gray-level pairs 
col_vec = ones(quantLevel,1);
for i=1:dir
    total_pairs = (glcm(:,:,i)*col_vec)'*col_vec;  %sum of GLCM
    glcm(:,:,i)=glcm(:,:,i)/total_pairs;
end
   
end
%end of cooccurence_matrix function

