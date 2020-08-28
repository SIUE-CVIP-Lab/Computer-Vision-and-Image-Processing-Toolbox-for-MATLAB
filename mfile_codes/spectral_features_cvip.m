function out_feat = spectral_features_cvip( input_img,mask_img, objLabel, spec_feat )
% SPECTRAL_FEATURES_CVIP -extracts spectral features based on Fourier transform and ring and sector power.
%
% Syntax :
% -------
% out_feat = spectral_features_cvip( input_img,mask_img, objLabel, spec_feat )
%   
% Input Parameters include :
% ------------------------
%
%  'input_img'     The orignial image which can be grayscale or RGB.
%
%  'mask_img'      Label image of MxN size with single object or multiple objects.  
%                  Each object has unique gray value.
%  'objLabel'      Labels of the objects.Column vector (Yx1) or Yx2 matrix.
%                  If row vector,objLabel must be unique gray value
%                  corresponding to each object.If Yx2 matrix, objLabel
%                  must have row index in first column and col index in
%                  second column for each object.
%  'spec_feat'     a Row vector of size 1x2 with which its first element
%                  determines the number of rings and the 2nd element
%                  determines the number of sectors.If empty, the default
%                  values are [3 3].
%
%
% Output Parameters include :  
% -------------------------
%  'out_feat'      Cell array containing object name,object label,and feature 
%                  values for selected features.
%                   
%
%
% Example :
% -------
%             input_img = imread('Stripey.jpg');
%             mask_img = zeros(size(input_img));
%             mask_img = mask_img(:,:,1);
%             mask_img(50:200,25:95) = 1;
%             mask_img(100:300,255:400) = 2; 
%             objLabel = [1 ;2];
%             spec_feat  = [3 4];
%             out_feat = spectral_features_cvip( input_img,mask_img, objLabel, spec_feat )
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

o = size(input_img,3);
feats_name = {'Rings' 'Sectors'};
total_feats = 2;

% If feat_list is empty matrix, all 20 features are selected
% Also check if no feature is selected
if isempty(spec_feat)|| ~isnumeric(spec_feat)          
    spec_feat = 3*ones(1,total_feats);      %% default is [3 3]
elseif ~sum(spec_feat),         warning('No feature is selected!!!'); 
    out_feat = {};          return ;    
elseif size(spec_feat,2) < total_feats
    spec_feat = [spec_feat zeros(1, total_feats - size(spec_feat,2))];
end

feat_length = o*sum(spec_feat) + o;


%% Create the column Obj_id in the output
[num_obj, objdim] = size(objLabel);
objList=zeros(num_obj,1);
if objdim== 2
    for i=1:size(objLabel,1)
        objList(i) = mask_img(objLabel(i,1),objLabel(i,2)); 
    end 
    obj_id = {'row_obj' 'col_obj'};
else
    objList = objLabel;
    obj_id = {'obj_id'};
end


%% Create the list of selected features (feats_title) which sits in the first row of the output cell array 
k=1;
feats_title = cell(1,feat_length);

for j=1:o
    
    feats_title(1,k) =  cellstr(['Spectral_DC_band_' num2str(j)]);
    k=k+1;
    
    for i=1:spec_feat(1)
        feats_title(1,k) =  cellstr([char(feats_name(1))  num2str(i) '_band_' num2str(j)]);
        k=k+1;
    end

    for i=1:spec_feat(2)
        feats_title(1,k) =  cellstr([char(feats_name(2))  num2str(i) '_band_' num2str(j)]);
        k=k+1;
    end
end

feature_val = zeros(num_obj,feat_length);

for count=1:num_obj
    %% extract each object into -> obj
    %   take fft -> obj
    [r,c] = find(mask_img == objList(count));
    r0 = min(r);
    r1 = max(r);
    c0 = min(c);
    c1 = max(c);
    obj = input_img(r0:r1, c0:c1, :);
    
    
    
    feature_val(count,:) = extract_spec(obj, spec_feat);
end

out_feat = [  obj_id feats_title ;  num2cell(objLabel) num2cell(feature_val) ];



end





function feat_values = extract_spec(n_band_image, rings_sectors)
%% use utility 
    rings = rings_sectors(1);
    sects = rings_sectors(2);
    siza = 2.^nextpow2(max(size(n_band_image)));
    obj = fft_cvip(n_band_image, siza); %min(2.^nextpow2(size(n_band_image))));
    [m,n,d] = size(obj);
    feat_values = zeros(1, d + d*sum(rings_sectors));
    mc = 1 + floor(m/2);    %% center row
    nc = 1 + floor(n/2);    %% center col
    
    index=1;
    for band=1:d
        feat_values(index) = obj(mc,nc,band);   % DC= obj(mc,nc,band);
        index = index + 1;
        
        r11 = [];
        r22 = [];
        theta11 = [];
        theta22 = [];
        
        if rings >0
            if mc < nc
                r1 = 0:floor(mc/rings):mc;
            else
                r1 = 0:floor(nc/rings):nc;
            end
            r1(end) = [];
            r2 = [r1(2:end) inf];
            k = length(r1);

            [U,V] = dftuv(m,n);
            D = sqrt(U.^2 + V.^2);
            D = fftshift(D);

            D = repmat(D,[1 1 k]);

            r11(1,1,:) = r1;
            r11 = repmat(r11,[m n 1]);

            r22(1,1,:) = r2;
            r22 = repmat(r22,[m n 1]);

            ring_mask =  (r11 <= D) .* (D<= r22);
            ring_mask(mc:end,:,:) = 0;
            
            
            extracted_rings = repmat(obj(:,:,band),[1 1 k]).* ring_mask;
            extracted_rings = extracted_rings/feat_values(1);
            extracted_rings = abs(extracted_rings.^2);
            extracted_rings = sum(sum(extracted_rings));
            feat_values(index:index+k-1) = extracted_rings(:);

        end
        index = index+k;
        if sects > 0

            x = 0:n-1;
            y = 0:m/2;

            x = x - (n/2);
            y = y - (m/2);

            [X,Y] = meshgrid(x,-y);

            %R = sqrt(X.^2 + Y.^2);

            theta = atan2(Y,X);
            theta = repmat(theta,[1,1, sects]);
            
            theta1 = (0:sects-1)* (pi/sects);
            theta2 = (1:sects)* (pi/sects);
            
            theta11(1,1,:) = theta1;
            theta11 = repmat(theta11,[1 + m/2 ,n ,1]);
            
            theta22(1,1,:) = theta2;
            theta22 = repmat(theta22,[1+ m/2 ,n ,1]);
            
            sect_mask = (theta >= theta11) .* (theta <= theta22);
            extracted_sects = repmat(obj(1:(1+ m/2),:,band),[1 1 sects]).* sect_mask/feat_values(1);
            extracted_sects = abs(extracted_sects).^2;
            extracted_sects = sum(sum(extracted_sects));
            feat_values(index:index+sects-1) = extracted_sects(:);
            feat_values(1)=power(feat_values(1),2)/power(siza,4);
        end
        index = index+sects;
        
    end
function [U, V] = dftuv(M, N)

% Set up range of variables.
u = 0:(M-1);
v = 0:(N-1);

% Compute the indices for use in meshgrid
idx = find(u > M/2);
u(idx) = u(idx) - M;
idy = find(v > N/2);
v(idy) = v(idy) - N;

% Compute the meshgrid arrays
[V, U] = meshgrid(v, u);

end
end


function [U, V] = dftuv(M, N)

% Set up range of variables.
u = 0:(M-1);
v = 0:(N-1);

% Compute the indices for use in meshgrid
idx = find(u > M/2);
u(idx) = u(idx) - M;
idy = find(v > N/2);
v(idy) = v(idy) - N;

% Compute the meshgrid arrays
[V, U] = meshgrid(v, u);

end





