function [test_file, Dist] = leave_one_out_cvip(file_ft, file_out, ...
    option_normalize, option_distance, opt_classification)
% LEAVE_ONE_OUT_CVIP - reads feature file of feature vectors and creates
% output files file_train and file_test for classification using leave one
% out algorithm testing method.
%
% Syntax :
% -------
% leave_one_out_cvip(file_ft, file_out, option_normalize, option_distance,...
% opt_classification)
% leave_one_out_cvip(file_ft, file_out, [option_normalize s_min/r_softmax...
%       s_max], [option_distance r_minkowski], [opt_classification k])
%   
% Input Parameters include :
% ------------------------ 
%   'file_ft'       Name of the feature file. 
%                   A CSV file with a predefined structure.
%   'file_out'      Name of the output file.  
%                   A CSV file as the inputs with the feature vectors 
%                   classified based on classification parameters.
%
%   'option_normalize(1)':
% 
%     0 – No Normalization
%     1 – Range-normalize
%     2 – Unit Vector normalization
%     3 – Standard Normal Density normalization
%     4 – Min-max normalization     ----> s_min, s_max
%     5 – Softmax scaling           ----> r_softmax
% 
%    'option_distance(1)':
% 
%     1 – Euclidean Distance
%     2 – City block or Absolute value metric
%     3 – Maximum value metric
%     4 – Minkowski distance        ----> r_minkowski
%     5 – Vector inner product
%     6 – Tanimoto metric
%
%    'option_classification':
% 
%     1 – Nearest Neighbor
%     2 – k-Nearest Neighbor        ----> k
%     3 – Nearest Centroid
%   
%   If option_normalize(1) is either 4 or 5, or option_distance(1) is 4, then their
%   corresponding parameters should be given as input arguments seperated
%   by comma after option_distance(1). Look at the below examples:
%                                
%
% Example 1 :   Classify Feature vectors using SND normalization, 
% ---------     Tanimoto metric, and Nearest Centroid.
%
%               file_ft = 'myFeatureVectors.CSV';
%               file_out = 'ClassifiedVectors';
%               option_normalize = [3 0 0];
%               option_distance = 6;
%               option_classification = 3;
%               %Calling function
%               TestVector = readtable(file_tt)
%               ClassVector = leave_one_out_cvip(file_ft, file_out, ...
%               option_normalize, option_distance, option_classification)
%                  
%
% Example 2 :   Classify Test vectors using Min-max normalization(s_min = 0; 
% ---------     s_max = 1), Minkowski distance(r_minkowski = 3), and Nearest Neighbor.
%
%               file_ft = 'myFeatureVectors.CSV';
%               file_out = 'ClassifiedVectors';
%               option_normalize = [4 0 1];
%               option_distance = [4 3];
%               option_classification = 1;
%               %Calling function
%               TestVector = readtable(file_tt)
%               ClassVector = leave_one_out_cvip(file_ft, file_out, ...
%               option_normalize, option_distance, option_classification)
%
%
% Example 3 :   Classify Test vectors using Softmax scaling(r_softmax = 5), 
%               Maximum value metric, and k-Nearest Neighbor(k = 5).
%
%               file_ft = 'myFeatureVectors.CSV';
%               file_out = 'ClassifiedVectors';
%               option_normalize = [5 5];
%               option_distance = 3;
%               option_classification = [2 5];
%               %Calling function
%               TestVector = readtable(file_tt)
%               ClassVector = leave_one_out_cvip(file_ft, file_out, ...
%               option_normalize, option_distance, option_classification)
%
%   See also train_test_cvip, nearest_neighbor_cvip.
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.
%

%==========================================================================
%
%           Author:                 Julian Rene Cuellar Buritica
%           Initial coding date:    02/09/2019
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     02/10/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
 % Revision 1.3  12/17/2018  10:29:53  jucuell
 % 
 % 
%
 % Revision 1.2  02/10/2019  15:39:04  jucuell
 % using a new feature file format that includes a sumary of used features
 % with its parameters and using the writetable function
%
 % Revision 1.1  02/09/2019  16:29:05  jucuell
 % Initial coding:
 % using nearest_neighbor_cvip.m created by Mehrdad Alvandipour as 
 % squeleton for this function
%

% read features file
features = readtable(file_ft);
if strcmp(features.obj_id{end},'Images:')%new feature vector
    n_feat = features{end,2};
    tbl = features(n_feat+1:end,:); %get foot table
    features = features(1:n_feat,:);%get features
end
n_feat = size(features, 1);         %number of feature vectors in file
Dist = zeros(n_feat, 1);            %distances vector
test_file = features;
for i=1:n_feat                      %classify each vector
    test_set = features(i,:);       %extract current features for test
    if i==1                         %extract features 2 to n_feat for train
        train_set = features(2:end,:);
    elseif i==n_feat                %extract features 1 to n_feat - 1 for train
        train_set = features(1:end-1,:);
    else
        %extract all features less features on index i for train
        train_set = [features(1:i-1,:); features(i+1:end,:)];
    end
    %Save each Train feature vectors
    if ~isempty(file_out)   
        cpath = mfilename( 'fullpath' );
        cpath = [cpath(1:end-25) 'GUI\'];
        file_train0 = [cpath 'Temp\file_train_tmp.csv'];
        writetable(train_set, file_train0);
        %add pattern directory
        file_train = [cpath 'Features\' file_out '_Train'];
        if ~strcmp(file_out(end-3:end), '.xls')% the extension should be .csv
            file_train = [file_train '.xls'];%append '.csv' to out_file_name 
        end
        tbl(end,2) = {n_feat-1};    %update number of images
        train_set = [train_set; tbl];%append table with feat info
        warning ('off','all');      %supress new sheet warning
        writetable(train_set, file_train, 'Sheet', i);
        clc;
        file_test = [cpath 'Temp\file_test_tmp.csv'];
        writetable(test_set, file_test);
    end
    [Result, Dis] = train_test_cvip(file_test, file_train0, file_out, ...
                    option_normalize, option_distance, opt_classification, i);
    if isa(Result{1,1},'double')
        Result.obj_id = {num2str(Result.obj_id)};
    end
    test_file(i,:) = Result;
    Dist(i,:) = Dis;
end

%Save Test feature vectors
if ~isempty(file_out)      
    %add pattern directory
    cpath = mfilename( 'fullpath' );
    cpath = [cpath(1:end-25) 'GUI\'];
    file_test = [cpath 'Features\' file_out '_Test'];
    if ~strcmp(file_out(end-3:end), '.xls')% the extension should be .csv
        file_test = [file_test '.xls'];	%append '.csv' to out_file_name 
    end
    tbl(end,2) = {n_feat};           %update number of images
    test_file = [test_file; tbl];%append table with feat info
    writetable(test_file, file_test, 'Sheet', 1);
end

end