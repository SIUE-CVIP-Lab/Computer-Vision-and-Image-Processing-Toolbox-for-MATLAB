function phi = rst_invariant_cvip(labeledImage, objLabel, featSelect)
% RST_INVARIANT_CVIP - calculates the 7 RST-invariant features defined in Table 6.1 of reference 1.
%
% Syntax :
% ------
% phi = rst_invariant_cvip(labeledImage, r, c)
%   
% Input Parameters include :
% -------------------------
%   'labelImage'    Label image of MxN size with single object or multiple objects.  
%                   Each object has unique gray value.
%   'r'             The row number of a pixel on the object.
%                   positive integer.
%   'c'             The column number of a pixel on the object.
%                   positive integer.
%                 
%
% Output Parameter include :  
% ------------------------
%   'phi'           The 7 RST-invariant features in a row vector.
%                                       
%
%
% Example :
% -------
%                   labeledImage = label_cvip(imread('Shapes.bmp'));
%                   phi = rst_invariant_cvip(labeledImage,  [391,  139], [1 0 1])
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


%% this function calls central_moments_cvip()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================
%
%			 MATLAB CVIPtoolbox - Dr. Scott Umbaugh SIUE
% 
% =========================================================================
%
%             File Name: centroid_cvip.m 
%		  Expanded Name: Centroid
%                Inputs: The labeled image, coordinates of a pixel on an object.
%				Outputs: A vector of the coordinates of the centroid, or
%				two seperate vectors for r and c.
%           Description: It contains the function to calculate the
%           centroid of an object on the labeled image.
%   Initial Coding Date: Dec 27, 2016
%Last Modification Made: Jan 3, 2017
%             Credit(s): Mehrdad Alvandipour
%                        Southern Illinois University at Edwardsville
%
%		  Copyright (c): 1995-2005 SIUE - Scott Umbaugh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%/
% RST_INVARIANT_CVIP  Add two values together.
%   C = RST_INVARIANT_CVIP(A) adds A to itself.
%   C = RST_INVARIANT_CVIP(A,B) adds A and B together.
%
%   See also SUM, PLUS.

feats_name = {'rst1' 'rst2' 'rst3' 'rst4' 'rst5' ...
    'rst6' 'rst7'};
total_feats = 7;

% If feat_list is empty matrix, all 8 features are selected
% Also check if none feature is selected
if isempty(featSelect)|| ~isnumeric(featSelect)          
    featSelect = ones(1,total_feats);  
elseif ~sum(featSelect),         warning('No feature is selected!!!'); 
    phi = {};          return ;    
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
    if featSelect(i)
        feats_title(1,k) =  cellstr(char(feats_name(i)));
        k=k+1;
    end
end

%%  
% The number of feature values calculated are determined by #of features
% selected
feature_val = zeros(num_obj,feat_length); 
obj_name=cell(num_obj,1);

labeledImage = labeledImage(:,:,1); % We ignore other bands on the labeled image.



for count=1:num_obj
    gray_level = objList(count);

    mu00 = area_cvip(labeledImage,gray_level);
    
    eta20 = central_moments_cvip(labeledImage,gray_level,2,0)/(mu00^2);
    eta02 = central_moments_cvip(labeledImage,gray_level,0,2)/(mu00^2);
    eta11 = central_moments_cvip(labeledImage,gray_level,1,1)/(mu00^2);
    
    eta30 = central_moments_cvip(labeledImage,gray_level,3,0)/(mu00^2.5);
    eta03 = central_moments_cvip(labeledImage,gray_level,0,3)/(mu00^2.5);
    eta21 = central_moments_cvip(labeledImage,gray_level,2,1)/(mu00^2.5);
    eta12 = central_moments_cvip(labeledImage,gray_level,1,2)/(mu00^2.5);
    
    
    phi1 = eta20 + eta02;
    phi2 = ((eta20 - eta02)^2) + (4*(eta11^2));
    phi3 = (eta30 - 3*eta12)^2 + (3*eta21 - eta03)^2;
    phi4 = (eta30 + eta12)^2 + (eta21 + eta03)^2;
    
    phi5 = (eta30 - 3*eta12)*(eta30 + eta12)* ( (eta30 + eta12)^2 - (3*((eta21 + eta03)^2)) ) + ...
        (3*eta21 - eta03)*(eta21 + eta03)*(  3*((eta30 + eta12)^2) - (eta21 + eta03)^2 );
    
    phi6 = (eta20 - eta02)*( (eta30 + eta12)^2 - (eta21 + eta03)^2 ) + ( 4 * eta11* (eta30 + eta12)*(eta21 + eta03) );
    
    phi7 = (3*eta21 - eta03)*(eta30 + eta12)*( (eta30 + eta12)^2 - (3*((eta21 + eta03)^2)) ) - ...
        (eta30 - 3*eta12)*(eta21 + eta03)*( 3*((eta30 + eta12)^2) -  (eta21 + eta03)^2 );
    
    all_phi = [phi1; phi2; phi3; phi4; phi5; phi6; phi7];
    
    k=1;
    for i=1:total_feats
        if featSelect(i)
            feature_val(count,k) = all_phi(i);
            k = k+1;
        end
    end
    
    
    obj_name(count) = cellstr(['Object' num2str(count)]);
end

%% Create the output cell array
phi = [  obj_id feats_title ;  num2cell(objLabel) num2cell(feature_val) ];


    
end