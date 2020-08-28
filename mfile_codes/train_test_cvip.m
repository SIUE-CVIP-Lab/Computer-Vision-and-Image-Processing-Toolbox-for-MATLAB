function [Result, Dist] = train_test_cvip(file_tt, file_tr, file_out, ...
                option_normalize, option_distance, opt_classification, count)
% TRAIN_TEST_CVIP - reads test and training files of feature vectors and 
% creates output file for classification using Train/Test Sets as algorithm
% testing method.
%
% Syntax :
% -------
% train_test_cvip(file_tt, file_tr, file_out, option_normalize, ...
%       option_distance, opt_classification, count)
% leave_one_out_cvip(file_tt, file_tr, file_out, [option_normalize ...
%       s_min/r_softmax s_max], [option_distance r_minkowski], [opt_classification k])
%   
% Input Parameters include :
% ------------------------ 
%   'file_tt'       Name of the test set file.  
%                   A CSV file with a predefined structure.
%   'file_tr'       Name of the training set file. 
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
%   'count'         An integer value with the number of Train/Test set to be
%                   tested for Leave One Out algorithm, for single Train/Test
%                   set it must be equal to 1. Default value 1
%   
%   If option_normalize(1) is either 4 or 5, or option_distance(1) is 4, then their
%   corresponding parameters should be given as input arguments seperated
%   by comma after option_distance(1). Look at the below examples:
%                                
%
% Example 1 :   Classify Test vectors using Min-max normalization(s_min = 0; 
% ---------     s_max = 1), Tanimoto metric, and Nearest Neighbor.
%
%               file_tt = 'myTestVectors.CSV';
%               file_tr = 'myTrainingVectors.CSV';
%               file_out = 'ClassifiedTestVectors.CSV';
%               option_normalize = [4 0 1];
%               option_distance = 6;
%               option_classification = 1;
%               TestVector = readtable(file_tt)
%               ClassVector = train_test_cvip(file_tt, file_tr, file_out, ...
%               option_normalize, option_distance, option_classification, [])
%                  
%
% Example 2 :   Classify Test vectors using Min-max normalization(s_min = 0; 
% ---------     s_max = 1), Minkowski distance(r_minkowski = 3), and Nearest Centroid.
%
%               file_tt = 'myTestVectors.CSV';
%               file_tr = 'myTrainingVectors.CSV';
%               file_out = 'ClassifiedTestVectors.CSV';
%               option_normalize = [4 0 1];
%               option_distance = [4 3];
%               option_classification = 3;
%               TestVector = readtable(file_tt)
%               ClassVector = train_test_cvip(file_tt, file_tr, file_out, ...
%               option_normalize, option_distance, option_classification, [])
%
%
% Example 3 :   Classify Test vectors using Softmax scaling(r_softmax = 5), 
%               Maximum value metric, and k-Nearest Neighbor(k = 5).
%
%               file_tt = 'myTestVectors.CSV';
%               file_tr = 'myTrainingVectors.CSV';
%               file_out = 'ClassifiedTestVectors.CSV';
%               option_normalize = [5 5];
%               option_distance = 3;
%               option_classification = [2 5];
%               TestVector = readtable(file_tt)
%               ClassVector = train_test_cvip(file_tt, file_tr, file_out, ...
%               option_normalize, option_distance, option_classification, [])
%
%   See also leave_one_out_cvip, nearest_neighbor_cvip.
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
%           Latest update date:     07/13/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
 % Revision 1.3  07/13/2019  00:48:39  jucuell
 % Save intermediate train andtest files if the test feature vector ontins
 % more than 1 feature vector.
%
 % Revision 1.2  01/16/2019  15:39:04  jucuell
 % include variables file_out to save all the normalized vectors and count
 % to be used in leave one out algorithm.
%
 % Revision 1.1  02/09/2019  18:33:22  jucuell
 % Initial coding:
 % using nearest_neighbor_cvip.m created by Mehrdad Alvandipour as 
 % squeleton for this function, tested with GUI
%            

if isempty(count)               %single Train/Test sets
    count = 1;
end

% check tr and tt
test_set = readtable(file_tt);
if strcmp(test_set.obj_id{end},'Images:')%new feature vector
    n_feat = test_set{end,2};
    test_set = test_set(1:n_feat,:);%get features
end
cpath = mfilename( 'fullpath' );
cpath = [cpath(1:end-22) 'GUI\'];
file_tt = [cpath 'Temp\file_test.csv'];
writetable(test_set, file_tt);
        
training_set = readtable(file_tr);
if strcmp(training_set.obj_id{end},'Images:')%new feature vector
    n_feat = training_set{end,2};
    training_set = training_set(1:n_feat,:);%get features
end
file_tr = [cpath 'Temp\file_train.csv'];
writetable(test_set, file_tr);%%%%%%%%%%%%%%%%%%%%

%  If these two sets are to be compared, they should have the same 
%  features, thus the same VariableNames on their tables. So, 
if size(test_set,2) ~= size(training_set,2)
    error('The size of the feature vectors in the Test and Training sets do not match.');
end

var_names = strcmp(test_set.Properties.VariableNames(1:end-1),...
    training_set.Properties.VariableNames(1:end-1));
if min(var_names) ~= 1
   error('Feature vectors do not match.'); 
end

% options
if opt_classification(1)==1            %perform Nearest Neighbor Classification
    if (option_normalize(1) == 4) && (option_distance(1) ~= 4)   %min-max Norm
        [Result, Dist] = nearest_neighbor_cvip(file_tt, file_tr, file_out,...
            option_normalize(1), option_distance(1), count, option_normalize(2),...
            option_normalize(3));
    elseif (option_normalize(1) == 5) && (option_distance(1) ~= 4) %soft-max norm
        [Result, Dist] = nearest_neighbor_cvip(file_tt, file_tr, file_out,...
            option_normalize(1), option_distance(1), count, option_normalize(2));
    elseif (option_normalize(1) == 4) && (option_distance(1) == 4) %min-max Norm & minkowski dist
        [Result, Dist] = nearest_neighbor_cvip(file_tt, file_tr, file_out,...
            option_normalize(1), option_distance(1), count, option_normalize(2),...
            option_normalize(3), option_distance(2));
    elseif (option_normalize(1) == 5) && (option_distance(1) == 4) %soft-max norm & minkowski dist
        [Result, Dist] = nearest_neighbor_cvip(file_tt, file_tr, file_out,...
            option_normalize(1), option_distance(1), count, option_normalize(2),...
            option_distance(2));
    elseif (option_distance(1) == 4)          %single normalization & minkowski dist
        [Result, Dist] = nearest_neighbor_cvip(file_tt, file_tr, file_out,...
            option_normalize(1), option_distance(1), count, option_distance(2));
    else
        [Result, Dist] = nearest_neighbor_cvip(file_tt, file_tr, file_out,...
            option_normalize(1), option_distance(1), count);
    end

elseif opt_classification(1)==2      %perform k-Nearest Neighbor Classification
    k = opt_classification(2);
    if (option_normalize(1) == 4) && (option_distance(1) ~= 4)
        [Result, Dist] = k_nearest_neighbor_cvip(file_tt, file_tr, file_out,k, ...
            option_normalize(1), option_distance(1), count, option_normalize(2),...
            option_normalize(3));
    elseif (option_normalize(1) == 5) && (option_distance(1) ~= 4)
        [Result, Dist] = k_nearest_neighbor_cvip(file_tt, file_tr, file_out,k, ...
            option_normalize(1), option_distance(1), count, option_normalize(2));
    elseif (option_normalize(1) == 4) && (option_distance(1) == 4)
        [Result, Dist] = k_nearest_neighbor_cvip(file_tt, file_tr, file_out,k, ...
            option_normalize(1), option_distance(1), count, option_normalize(2),...
            option_normalize(3), option_distance(2));
    elseif (option_normalize(1) == 5) && (option_distance(1) == 4)
        [Result, Dist] = k_nearest_neighbor_cvip(file_tt, file_tr, file_out,k, ...
            option_normalize(1), option_distance(1), count, option_normalize(2),...
            option_distance(2));
    elseif (option_distance(1) == 4)          %single normalization & minkowski dist
        [Result, Dist] = k_nearest_neighbor_cvip(file_tt, file_tr, file_out,k,...
            option_normalize(1), option_distance(1), count, option_distance(2));            
    else
        [Result, Dist] = k_nearest_neighbor_cvip(file_tt, file_tr, file_out, k,...
            option_normalize(1), option_distance(1), count);
    end

elseif opt_classification(1)==3     %perform Centroid Classification
    if (option_normalize(1) == 4) && (option_distance(1) ~= 4)
        [Result, Dist] = nearest_centroid_cvip(file_tt, file_tr, file_out,...
            option_normalize(1), option_distance(1), count, ...
            option_normalize(2), option_normalize(3));
    elseif (option_normalize(1) == 5) && (option_distance(1) ~= 4)
        [Result, Dist] = nearest_centroid_cvip(file_tt, file_tr, file_out,...
            option_normalize(1), option_distance(1), count, option_normalize(2));
    elseif (option_normalize(1) == 4) && (option_distance(1) == 4)
        [Result, Dist] = nearest_centroid_cvip(file_tt, file_tr, file_out,...
            option_normalize(1), option_distance(1), count, ...
            option_normalize(2),option_normalize(3), option_distance(2));
    elseif (option_normalize(1) == 5) && (option_distance(1) == 4)
        [Result, Dist] = nearest_centroid_cvip(file_tt, file_tr, file_out,...
            option_normalize(1), option_distance(1), count, ...
            option_normalize(2), option_distance(2));
    elseif (option_distance(1) == 4)%single normalization & minkowski dist
        [Result, Dist] = nearest_centroid_cvip(file_tt, file_tr, file_out,...
            option_normalize(1), option_distance(1), count, option_distance(2));              
    else
        [Result, Dist] = nearest_centroid_cvip(file_tt, file_tr, file_out,...
            option_normalize(1), option_distance(1), count);
    end
end
end