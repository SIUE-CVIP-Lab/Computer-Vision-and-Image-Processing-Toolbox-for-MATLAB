function  final_table = feature_objects_cvip( input_img, mask_img,objLabel, out_file_name,bin_feat,his_feat, rst_feat, tex_feat, spec_feat,varargin)
% FEATURE_OBJECTS_CVIP - extracts features from a group of objects in a single image and a single image mask for the objects, 
%                        output is a csv file
%
% Syntax :
% ------
% final_table = feature_objects_cvip( input_img, mask_img,objLabel, out_file_name,bin_feat,his_feat, rst_feat, tex_feat, spec_feat,varargin)
%   
% Input Parameters include:
% ------------------------
%
%  'input_img'       The input image for feature extraction.  
%                    A gray scale or color image.
%
%  'mask_img'        A 2d mask that has integers assigned to objects and 0 to other areas in the image.
%                    It hould have the same number of row and columns as the
%                    input_img.
%
% 'out_file_name'    Name of the output file. it can be empty.
%                    The output is a CSV file 
%
% 'bin_feat'         A row vector of 8 elemets at most, that selects the desired
%                    binary features to be extracted.For more details look
%                    at binary_feature_cvip.
%
%  'his_feat'        A row vector of 5 elemets at most, that selects the desired
%                    histogram features to be extracted.For more details
%                    look at hist_feature_cvip.
%
%  'rst_feat'        A row vector of 7 elemets at most, that selects the desired
%                    rst invariant features to be extracted.For more
%                    details look at rst_invariant_cvip.
%
% 'tex_feat'         A row vector of 20 elemets at most, that selects the desired
%                    texture features to be extracted.For more details look
%                    at texture_features_cvip.
%
%  'spec_feat'       A row vector of 2 elemets at most, that determines the
%                    number of rings and sectors to be used.
%
%  '[optional]'      The default values for texDist, quantLvl,
%                    statsType, normWidth, normHeight can be overwritten by
%                    specifying the new values as optional input arguments.
%                    For each of these, first, the name should be given as a
%                    string, and then the value, i.e. (..., 'par_name', value)
%                    For example: feature_objects_cvip( ... , 'quantLvl', 2)
%
%   
%                                
%
%  Example :
%  --------
%
%             input_img = imread('Stripey.jpg');
%             mask_img = zeros(size(input_img));
%             mask_img = mask_img(:,:,1);
%             mask_img(50:200,25:95) = 1;
%             mask_img(100:300,255:400) = 2;
%             objLabel = [1 ;2];
%             out_file_name =( 'sdfsdf');
%             bin_feat = [1 0 1];
%             his_feat = [0 1 1];
%             rst_feat = [1 0 0 1];
%             tex_feat = [1 0 0 0];
%             spec_feat = [0 0];
%             texDist  = 4;
%             quantLvl = 2;
%             statsType = [0 0 1];
%             normWidth = 12;
%             normHeight = 15;
%             b = feature_objects_cvip( input_img, mask_img,objLabel, out_file_name,bin_feat,his_feat, rst_feat, tex_feat, spec_feat, 'statstype', [1 0 1])
%
%
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.

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
global suppress_info
suppress_info = 0;

nVarargs = length(varargin);            %
if iscell(varargin) && nVarargs==1      % This is to allow varargin to be
    varargin = varargin{1};             % passed in the format of a cell array.
    nVarargs = length(varargin);        % This is specially useful when this function is called within feature_images_cvip()
    suppress_info = 1;
end

if mod(nVarargs,2) % odd number of varargins means something wrong
    error('the variable input areguments should be in pairs')
end

global texDist quantLvl statsType; % texture feature parameters
global normWidth normHeight; % for projection feature

% The default values
texDist = 2;
quantLvl = -1;
statsType = [1 0 0];
normWidth = 10;
normHeight = 10;
% override the defaults if given other values by user
% optional arguments at the end of input arguments of the function can
% contain any combination of the above 5 parameters. The parameters and
% their desired values are given in pair by their names, and values in
% varargin. For example a call to our fucntion could be like:
%
%                                    ( neccessary input args  ,        optional args           )
%                                    (              |         ,               |                )
%                                    (              |         ,               |                )
%                                    (              |         ,               |                )
%                                    (______________|________ , ______________|_______________ )
%  final_table = feature_objects_cvip(             ...        ,  'texDist', 3 , 'normWidth', 15)
%
for k = 1:(nVarargs/2)  
      opt = varargin{2*k -1};
      val = varargin{2*k};
      process_input(opt, val)
end




%%
[num_obj, objdim] = size(objLabel);
objList=zeros(num_obj,1);
if objdim== 2
    for i=1:size(objLabel,1)
        objList(i) = mask_img(objLabel(i,1),objLabel(i,2)); 
    end 
    obj_id = {'row_obj' 'col_obj'};
    first_cols = 3;
else
    objList = objLabel;
    obj_id = {'obj_id'};
    first_cols = 2;
end


%% input_img, mask_img bin_feat,his_feat, rst_feat, tex_feat, spec_feat

% Tell the user about the values used for optional arguments
%	info on projection feature--normWidth,normHeight -- are handled
%   inside binary_feature_cvip() which is called later in this code if
%   necessary.
final_table = {};
if sum(bin_feat)        %% Binary features
    if ~suppress_info &&  length(bin_feat) > 6
        if bin_feat(7)    % Tell the user what settings is being used
            display('The settings for projection feature is as follows:');
            display(['Normalizing width = ' num2str(normWidth) ]);
            display(['Normalizing height = ' num2str(normHeight) ]);
        end
    end
    bin_cell = binary_feature_cvip(mask_img, objLabel,bin_feat, 'normWidth', normWidth, 'normHeight', normHeight );
    if isempty(final_table)
        final_table = bin_cell;
    else
        final_table = [final_table bin_cell(:,first_cols:end)];
    end
end

if sum(rst_feat)        %% RST Invariant features
    rst_cell = rst_invariant_cvip(mask_img, objLabel, rst_feat);
    if isempty(final_table)
        final_table = rst_cell;
    else
        final_table = [final_table rst_cell(:,first_cols:end)];
    end
end

if sum(his_feat)        %% Histogram features
    hist_cell = hist_feature_cvip(input_img, mask_img, objLabel,his_feat);
    if isempty(final_table)
        final_table = hist_cell;
    else
        final_table = [final_table hist_cell(:,first_cols:end)];
    end
end

if sum(tex_feat)
    if ~suppress_info
        display('The settings for texture features are as follows: ');
        display(['Texture distance = ' num2str(texDist) ]);
        display(['Quantization level = ' num2str(quantLvl) ]);
        display(['Statistics type = ' num2str(statsType) ]);
    end
    % texture_features_cvip(inImage, labelImage, texDist, featSelect, objLabel, quantLvl, statsType, className)
    tex_cell = texture_features_cvip(input_img, mask_img, texDist, tex_feat, objLabel, quantLvl,  statsType);
    if isempty(final_table)
        final_table = tex_cell;
    else
        final_table = [final_table tex_cell(:,first_cols:end)];
    end
end

if sum(spec_feat)       %% Spectral features
    spec_cell = spectral_features_cvip(input_img,mask_img, objLabel, spec_feat);
    if isempty(final_table)
        final_table = spec_cell;
    else
        final_table = [final_table spec_cell(:,first_cols:end)];
    end
end

% We just return the cell array final_table, unless the user specifies an
% output file name in out_file_name. out_file_name is a string.
if ~isempty(out_file_name)      
    if ~strcmp(out_file_name(end-3:end), '.csv')    % the extension should be .csv
        out_file_name = [out_file_name '.csv'];     % so we append it to out_file_name if it does not end with '.csv'.
    end
%      fid = fopen(out_file_name, 'a') ;
%      fprintf(fid, '%s,', final_table{1,1:end-1}) ;
%      fprintf(fid, '%s\n', final_table{1,end}) ;
%      fclose(fid) ;
%      dlmwrite(out_file_name, final_table(2:end,:), '-append') ;
end

end

function process_input(option, value) % Reads optional inputs
 global texDist quantLvl statsType % texture featur parameters
 global normWidth normHeight %  projection parameters
 global suppress_info

 option = lower(option);
 switch option
     case 'texdist'
         texDist = value;
     case 'quantlvl'
         quantLvl = value;
     case 'statstype'
         statsType = value;
     case 'normwidth'
         normWidth = value;
     case 'normheight'
         normHeight = value;
 end

end
