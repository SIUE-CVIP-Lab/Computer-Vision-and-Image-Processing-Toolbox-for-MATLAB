function [ out_table ] = feature_images_cvip( folder , out_file_name, bin_feat,his_feat, rst_feat, tex_feat, spec_feat,varargin)
% FEATURE_IMAGES_CVIP - extracts features from a group of images, where each image contains one object of interest, 
%                       and uses corresponding mask images, output is a csv file
%
% Syntax :
% ------
% [out_table] = feature_images_cvip( folder,out_file_name,bin_feat,his_feat,rst_feat,tex_feat,spec_feat,varargin)
%   
% Input Parameters include :
% ------------------------
%
%  'folder'        Address relative to the current directory, or absolute
%                  address to a folder containing the images and their mask folder.
%                  So the folder should contain a number of images and
%                  another subfolder. The subfolder is assumed to contain
%                  the mask images. The names of the images and their
%                  masks should match. Also the number of images should be
%                  the same in both folders.
%                    
% 'out_file_name'  Name of the output file.it can be empty.
%                  The output is a CSV file 
%
% 'bin_feat'       A row vector of 8 elemets at most, that selects the desired
%                  binary features to be extracted.For more details look
%                  at binary_feature_cvip.
%
%  'his_feat'      A row vector of 5 elemets at most, that selects the desired
%                  histogram features to be extracted.For more details
%                  look at hist_feature_cvip.
%
% 'rst_feat'       A row vector of 7 elemets at most, that selects the desired
%                  rst invariant features to be extracted.For more
%                  details look at rst_invariant_cvip.
%
%  'tex_feat'      A row vector of 20 elemets at most, that selects the desired
%                  texture features to be extracted. For more details look
%                  at texture_features_cvip.
%
% 'spec_feat'      A row vector of 2 elemets at most, that determines the
%                  number of rings and sectors to be used.
%
%'[optional]'      The default values for texDist, quantLvl,
%                  statsType, normWidth, normHeight can be overwritten by
%                  specifying the new values as optional input arguments.
%                  For each of these, first, the name should be given as a
%                  string, and then the value, i.e. (..., 'par_name', value)
%                  For example: feature_objects_cvip( ... , 'quantLvl', 2)
%
%   
% Example 1 :
% ---------
%
%             folder = 'C:\Users\lgorant\Desktop\Anjana\Anjana\CVIP_Toolbox\images\ACL\ACL\Lateral\Abnormal';
%             bin_feat = [1 0 1 1 1];
%             his_feat = [0 1 1];
%             rst_feat = [1  1 1];
%             tex_feat = [1 0 0 0];
%             spec_feat = [0 0]; 
%             texDist  = 4;
%             quantLvl = 2;
%             statsType = [0 0 1]; 
%             out_file_name=  'the_output_of_feat_imgs';
%             [ out_table ] = feature_images_cvip( folder, out_file_name , bin_feat,his_feat, rst_feat, tex_feat, spec_feat,'statstype', [1 0 1])
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

%   folder:     'address relative to the current directory, or absolute address'


list = dir(folder);

%   list is the folder of images.
%   mask_list is the folder for masks.
%   They should contain the same number of images with the same names.
% list contains:        . , .. , A_folder, images
% mask_list contains:   . , .. , images
%   Thus the the third elements of list is the name of the mask folder that
%   we need to look into.

mask_folder = [folder '\MASKS'];% list(3).name];
mask_list = dir(mask_folder);

if length(list)-3 ~= length(mask_list) -2
    error('The mask folder should contain the same number of images as the main folder');
else
    num_of_images = length(list)-3;
end

n=2;    %figure image index in directory
m=2;    %figure image index in masks directory
for i=1:num_of_images
    if list(i+n).isdir
        n=n+1;      %increase index if detect an intermediate directory
    end
    if mask_list(i+m).isdir
        m=m+1;      %increase index if detect an intermediate directory
    end
    if strcmp(list(i+n).name, mask_list(i+m).name)~=1
        warning('The names do not match')
    end
    
    img_add = [folder '\' list(i+n).name];
    mask_add = [mask_folder '\' mask_list(i+m).name];
    I = imread(img_add);
    mask = imread(mask_add);
    
    mask = mask>0;          % Threshold to make sure there is only one object for each image.
    objLabel = 1;           % There's only one object in each image, and it is labeled 1.
    if size(mask,3)~=1
        mask=mask(:,:,1);   %if we have a 3 band mask... strangr but happens
    end
    out_file_name_0 = [];   % we don't want feature_objects_cvip to save anything
    final_table = feature_objects_cvip( I, mask,objLabel, out_file_name_0 ,bin_feat,his_feat, rst_feat, tex_feat, spec_feat,varargin);
    final_table(2,1)={list(i+n).name};  %change obj_id to image name
    if i~=1
        out_table(i+1,:) = final_table(2,:);
    else
        out_table = cell(num_of_images,size(final_table,2));
        out_table(1:2,:) = final_table;
    end
end
%out_table(2:end,1) = num2cell(1:num_of_images); % id correction --> first column of final table

    




    % We just return the cell array final_table, unless the user specifies an
    % output file name in out_file_name. out_file_name is a string.
    if ~isempty(out_file_name)
        if ~strcmp(out_file_name(end-3:end), '.csv')    % the extension should be .csv
            out_file_name = [pwd '\Features\' out_file_name '.csv'];     % so we append it to out_file_name if it does not end with '.csv'.
        end
        fid = fopen(out_file_name, 'w') ;
        fprintf(fid, '%s,', out_table{1,1:end-1}) ;
        fprintf(fid, '%s\n', out_table{1,end}) ;
        [rows, cols] = size(out_table);
        for i = 1:rows
            for j = 1:cols
                if j==1
                    fprintf(fid, '%s,', out_table{i,j});
                elseif j==cols
                    fprintf(fid, '%6.6f\n', out_table{i,j});
                else
                    fprintf(fid, '%6.6f,', out_table{i,j});
                end
            end
        end
        fclose(fid) ;
        %dlmwrite(out_file_name, out_table(2:end,:), '-append') ;
    end
end

