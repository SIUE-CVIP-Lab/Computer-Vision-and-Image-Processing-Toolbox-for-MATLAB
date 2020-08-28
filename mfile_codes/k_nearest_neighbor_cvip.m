function [Test, dista] = k_nearest_neighbor_cvip(file_tt, file_tr, ...
    file_out, k, option_normalize, option_distance, count, varargin)
% K_NEAREST_NEIGHBOR_CVIP - reads test and training files of feature vectors
% and creates output file for classification using k-nearest neighbor 
% classification method
% 
% Syntax :
% ------
% k_nearest_neighbor_cvip(file_tt, file_tr, file_out, k, option_normalize, option_distance,  varargin)
% k_nearest_neighbor_cvip(file_tt, file_tr, file_out, k, option_normalize, option_distance, [s_min], [s_max], [r_softmax], [r_minkowski])
%   
% Input Parameters include :
% ------------------------
%   'file_tt'       Name of the test set file.  
%                   A CSV file with a predefined structure.
%   'file_tr'       Name of the training set file. 
%                   A CSV file with a predefined structure.
%   'file_out'      Name of the output file.  
%                   A CSV file as the inputs with the test vectors 
%                   classified based on their KNN in training set..
%   'k'             The number K in KNN.
%                   Number of nearest neighbors considered in KNN.
%
%   'option_normalize':
% 
%     0 – No Normalization
%     1 – Range-normalize
%     2 – Unit Vector normalization
%     3 – Standard Normal Density normalization
%     4 – Min-max normalization     ----> s_min, s_max
%     5 – Softmax scaling           ----> r_softmax
% 
%    'option_distance':
% 
%     1 – Euclidean Distance
%     2 – City block or Absolute value metric
%     3 – Maximum value metric
%     4 – Minkowski distance        ----> r_minkowski
%     5 – Vector inner product
%     6 – Tanimoto metric
%
%   'count'         An integer value with the number of Train/Test set to be
%                   tested for Leave One Out algorithm, for single Train/Test
%                   set it must be equal to 1. Default value 1
%
%   If option_normalize is either 4 or 5, or option_distance is 4, then their
%   corresponding parameters should be given as input arguments seperated
%   by comma after option_distance. Look at the below examples:
%                                
%
% Example 1 :
% ---------
%                   file_tt = 'myTestVectors.CSV';
%                   file_tr = 'myTrainingVectors.CSV';
%                   file_out = 'ClassifiedTestVectors.CSV';
%                   k = 3;
%                   option_normalize = 4;
%                   option_distance = 6;
%                   s_min = 0; s_max = 1;
%                   k_nearest_neighbor_cvip(file_tt, file_tr, file_out, k, ...
%                       option_normalize, option_distance, s_min, s_max)
%                  
%
% Example 2 :
% ---------
%                   file_tt = 'myTestVectors.CSV';
%                   file_tr = 'myTrainingVectors.CSV';
%                   file_out = 'ClassifiedTestVectors.CSV';
%                   k = 3;
%                   option_normalize = 4;
%                   option_distance = 4;
%                   s_min = 0; s_max = 1;
%                   r_minkowski = 3;
%                   k_nearest_neighbor_cvip(file_tt, file_tr, file_out, k, ...
%                       option_normalize, option_distance, s_min, s_max, r_minkowski)
%
%
%
% Example 3 :
% ---------
%                   file_tt = 'myTestVectors.CSV';
%                   file_tr = 'myTrainingVectors.CSV';
%                   file_out = 'ClassifiedTestVectors.CSV';
%                   k = 3;
%                   option_normalize = 5;
%                   option_distance = 4;
%                   r_softmax = 5;
%                   r_minkowski = 3;
%                   k_nearest_neighbor_cvip(file_tt, file_tr, file_out, k, ...
%                       option_normalize, option_distance, r_softmax, r_minkowski)
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
%           Initial coding date:    03/13/2017
%           Latest update date:     02/18/2019
%           Updated by:             Julian Rene Cuellar Buritica
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
 % Revision 1.3  02/18/2019  14:10:34  
 % update function class_names to really look and found the number of
 % elements for each class within the k neighbors and get the class
%
 % Revision 1.2  01/16/2019  15:39:04  jucuell
 % include variables file_out to save all the normalized vectors and count
 % to be used in leave one out algorithm
%
 % Revision 1.1  03/13/2017  16:29:05  mealvan
 % Initial coding:
 % function creation and initial testing
%

if isempty(count)               %single Train/Test sets
    count = 1;
end

%% check tr and tt
test_set = readtable(file_tt);
training_set = readtable(file_tr);

%  If these two sets are to be compared, they should have the same 
%  features, thus the same VariableNames on their tables. So, 
if size(test_set,2) ~= size(training_set,2)
    error('The size of the feature vectors in the Test and Training sets do not match.');
end

var_names = strcmp(test_set.Properties.VariableNames(1:end-1),training_set.Properties.VariableNames(1:end-1));
if min(var_names) ~= 1
   error('Feature vectors do not match.'); 
end

clear test_set training_set;
%% options
switch option_normalize
    case 0  % No normalization
        switch option_distance
            case 1  % Euclidean Distance
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                        
                        ' and option_distance= ' num2str(option_distance)])
                end

                distances = pattern_euclidean_cvip(file_tt,file_tr);
                [dista,id] = sort(distances,2,'ascend');
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %%writetable(Test,file_out);
                
            case 2 % City block 
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                
                distances = pattern_city_block_cvip(file_tt,file_tr,file_out,count);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 3 % Maximum 
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                
                distances = pattern_maximum_cvip(file_tt,file_tr,file_out,count);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 4 % Minkowski 
                if nargin ~= 8
                    error(['You should have 8 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                r_minkowski = varargin{1};
                display(r_minkowski)
                
                distances = pattern_minkowski_cvip(file_tt,file_tr,r_minkowski);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 5 % Vector inner product
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                
                distances = pattern_vector_inner_product_cvip(file_tt,file_tr,file_out,count);
                [dista,id] = sort(distances,2,'descend');                
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 6 % Tanimoto metric
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                distances = pattern_tanimoto_cvip(file_tt,file_tr,file_out,count);
                [dista,id] = sort(distances,2,'descend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            otherwise
                error('option_distance should be a number btween 1-6');
        end
    case 1  % Range normalize
        switch option_distance
            case 1  % Euclidean Distance
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                [normal_file_tt,normal_file_tr] = pattern_range_norm_cvip(file_tt,file_tr,file_out,count);
                
                distances = pattern_euclidean_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 2 % City block 
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                [normal_file_tt,normal_file_tr] = pattern_range_norm_cvip(file_tt,file_tr,file_out,count);
                
                distances = pattern_city_block_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 3 % Maximum 
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                [normal_file_tt,normal_file_tr] = pattern_range_norm_cvip(file_tt,file_tr,file_out,count);
                
                distances = pattern_maximum_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 4 % Minkowski 
                if nargin ~= 8
                    error(['You should have 8 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                r_minkowski = varargin{1};
                
                [normal_file_tt,normal_file_tr] = pattern_range_norm_cvip(file_tt,file_tr,file_out,count);
                
                distances = pattern_minkowski_cvip(normal_file_tt,normal_file_tr,r_minkowski);
                [dista,id] = sort(distances,2,'ascend');                
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 5 % Vector inner product
                if nargin ~= 8
                    error(['You should have 8 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                [normal_file_tt,normal_file_tr] = pattern_range_norm_cvip(file_tt,file_tr,file_out,count);
                
                distances = pattern_vector_inner_product_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'descend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 6 % Tanimoto metric
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                [normal_file_tt,normal_file_tr] = pattern_range_norm_cvip(file_tt,file_tr,file_out,count);
                
                distances = pattern_tanimoto_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'descend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            otherwise
                error('option_distance should be a number btween 1-6');
        end
    case 2  % Unit vector normalization
        switch option_distance
            case 1  % Euclidean Distance
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                
                [normal_file_tt,normal_file_tr] = pattern_unit_vector_norm_cvip(file_tt,file_tr,file_out,count);
                
                distances = pattern_euclidean_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'ascend');                
                id = id(:,1:k);
                Tr = readtable(file_tr); 
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 2 % City block 
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                [normal_file_tt,normal_file_tr] = pattern_unit_vector_norm_cvip(file_tt,file_tr,file_out,count);
                
                distances = pattern_city_block_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 3 % Maximum 
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                [normal_file_tt,normal_file_tr] = pattern_unit_vector_norm_cvip(file_tt,file_tr,file_out,count);
                
                distances = pattern_maximum_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'ascend');                
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 4 % Minkowski 
                if nargin ~= 8
                    error(['You should have 8 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                r_minkowski = varargin{1};
                [normal_file_tt,normal_file_tr] = pattern_unit_vector_norm_cvip(file_tt,file_tr,file_out,count);
                
                distances = pattern_minkowski_cvip(normal_file_tt,normal_file_tr,r_minkowski);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 5 % Vector inner product
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                [normal_file_tt,normal_file_tr] = pattern_unit_vector_norm_cvip(file_tt,file_tr,file_out,count);
                
                distances = pattern_vector_inner_product_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'descend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 6 % Tanimoto metric
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                [normal_file_tt,normal_file_tr] = pattern_unit_vector_norm_cvip(file_tt,file_tr,file_out,count);
                
                distances = pattern_tanimoto_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'descend');                
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            otherwise
                error('option_distance should be a number btween 1-6');
        end
    case 3  % SND normalization
        switch option_distance
            case 1  % Euclidean Distance
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                [normal_file_tt,normal_file_tr] = pattern_snd_norm_cvip(file_tt,file_tr,file_out,count);
                
                distances = pattern_euclidean_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 2 % City block 
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                [normal_file_tt,normal_file_tr] = pattern_snd__norm_cvip(file_tt,file_tr,file_out,count);
                
                distances = pattern_city_block_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 3 % Maximum 
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                [normal_file_tt,normal_file_tr] = pattern_snd_norm_cvip(file_tt,file_tr,file_out,count);
                
                distances = pattern_maximum_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 4 % Minkowski 
                if nargin ~= 8
                    error(['You should have 8 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                r_minkowski = varargin{1};
                
                [normal_file_tt,normal_file_tr] = pattern_snd_norm_cvip(file_tt,file_tr,file_out,count);
                
                distances = pattern_minkowski_cvip(normal_file_tt,normal_file_tr,r_minkowski);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 5 % Vector inner product
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                [normal_file_tt,normal_file_tr] = pattern_snd_norm_cvip(file_tt,file_tr,file_out,count);
                
                distances = pattern_vector_inner_product_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'descend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 6 % Tanimoto metric
                if nargin ~= 7
                    error(['You should have 7 input arguments when ' ...
                        'option_normalize=' num2str(option_normalize) ...
                        ' and option_distance= ' num2str(option_distance)])
                end
                
                [normal_file_tt,normal_file_tr] = pattern_snd_norm_cvip(file_tt,file_tr,file_out,count);
                
                distances = pattern_tanimoto_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'descend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            otherwise
                error('option_distance should be a number btween 1-6');
        end
    case 4  % Min-Max normalization
        switch option_distance
            case 1  % Euclidean Distance
                if nargin ~= 9
                    error(['You should have 9 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                s_min = varargin{1};
                s_max = varargin{2};
                
                [normal_file_tt,normal_file_tr] = pattern_min_max_norm_cvip(file_tt,...                     
                    file_tr,file_out,s_min,s_max,count);
                
                distances = pattern_euclidean_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 2 % City block 
                if nargin ~= 9
                    error(['You should have 9 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                s_min = varargin{1};
                s_max = varargin{2};
                
                [normal_file_tt,normal_file_tr] = pattern_min_max_norm_cvip(file_tt,...                     
                    file_tr,file_out,s_min,s_max,count);
                
                distances = pattern_city_block_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 3 % Maximum 
                if nargin ~= 9
                    error(['You should have 9 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                s_min = varargin{1};
                s_max = varargin{2};
                
                [normal_file_tt,normal_file_tr] = pattern_min_max_norm_cvip(file_tt,...                     
                    file_tr,file_out,s_min,s_max,count);
                
                distances = pattern_maximum_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 4 % Minkowski 
                if nargin ~= 9
                    error(['You should have 9 input arguments when ' ...
                        'option_normalize=' num2str(option_normalize) ...
                        ' and option_distance= ' num2str(option_distance)])
                end
                s_min = varargin{1};
                s_max = varargin{2};
                r_minkowski = varargin{3};
                
                [normal_file_tt,normal_file_tr] = pattern_min_max_norm_cvip(file_tt,...                     
                    file_tr,file_out,s_min,s_max,count);
                
                distances = pattern_minkowski_cvip(normal_file_tt,normal_file_tr,r_minkowski);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 5 % Vector inner product
                if nargin ~= 9
                    error(['You should have 9 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                s_min = varargin{1};
                s_max = varargin{2};
                
                [normal_file_tt,normal_file_tr] = pattern_min_max_norm_cvip(file_tt,...                     
                    file_tr,file_out,s_min,s_max,count);
                
                distances = pattern_vector_inner_product_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'descend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 6 % Tanimoto metric
                if nargin ~= 9
                    error(['You should have 9 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                s_min = varargin{1};
                s_max = varargin{2};
                
                [normal_file_tt,normal_file_tr] = pattern_min_max_norm_cvip(file_tt,...                     
                    file_tr,file_out,s_min,s_max,count);
                
                distances = pattern_tanimoto_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'descend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            otherwise
                error('option_distance should be a number btween 1-6');
        end
    case 5  % Softmax normalization
        switch option_distance
            case 1  % Euclidean Distance
                if nargin ~= 8
                    error(['You should have 8 input arguments when ' ...
                        'option_normalize=' num2str(option_normalize) ...
                        ' and option_distance= ' num2str(option_distance)])
                end
                r_softmax = varargin{1};
                
                [normal_file_tt,normal_file_tr] = pattern_softmax_norm_cvip(file_tt,...                     
                    file_tr, file_out,r_softmax, count);
                
                distances = pattern_euclidean_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 2 % City block 
                if nargin ~= 8
                    error(['You should have 8 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                r_softmax = varargin{1};
                
                [normal_file_tt,normal_file_tr] = pattern_softmax_norm_cvip(file_tt,...                     
                    file_tr, file_out,r_softmax, count);
                
                distances = pattern_city_block_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 3 % Maximum 
                if nargin ~= 8
                    error(['You should have 8 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                r_softmax = varargin{1};
                
                [normal_file_tt,normal_file_tr] = pattern_softmax_norm_cvip(file_tt,...                     
                    file_tr, file_out,r_softmax, count);
                
                distances = pattern_maximum_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
               %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 4 % Minkowski 
                if nargin ~= 9
                    error(['You should have 9 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...
                        ' and option_distance= ' num2str(option_distance)])
                end
                r_softmax = varargin{1};
                r_minkowski = varargin{2};
                
                [normal_file_tt,normal_file_tr] = pattern_softmax_norm_cvip(file_tt,...                     
                    file_tr, file_out,r_softmax, count);
                
                distances = pattern_minkowski_cvip(normal_file_tt,normal_file_tr,r_minkowski);
                [dista,id] = sort(distances,2,'ascend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 5 % Vector inner product
                if nargin ~= 8
                    error(['You should have 8 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                r_softmax = varargin{1};
                
                [normal_file_tt,normal_file_tr] = pattern_softmax_norm_cvip(file_tt,...                     
                    file_tr, file_out,r_softmax, count);
                
                distances = pattern_vector_inner_product_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'descend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            case 6 % Tanimoto metric
                if nargin ~= 8
                    error(['You should have 8 input arguments when ' ...                         
                        'option_normalize=' num2str(option_normalize) ...                         
                        ' and option_distance= ' num2str(option_distance)])
                end
                r_softmax = varargin{1};
                
                [normal_file_tt,normal_file_tr] = pattern_softmax_norm_cvip(file_tt,...                     
                    file_tr, file_out,r_softmax, count);
                
                distances = pattern_tanimoto_cvip(normal_file_tt,normal_file_tr);
                [dista,id] = sort(distances,2,'descend');                 
                id = id(:,1:k);
                Tr = readtable(file_tr);
                Test = readtable(file_tt);
                %extract class names                 
                class_names = class_fun(Test, Tr, id);
                
                Test = Test(:,1:end-1);
                Test.class = class_names;
                %writetable(Test,file_out);
            otherwise
                error('option_distance should be a number btween 1-6');
        end
    otherwise
        error('option_normalize should be a number btween 0-5');
end
%get the related distance measure
if option_distance > 4
    dista = max(dista);
else
    dista = min(dista);
end

end

function class_names = class_fun(Test, Tr, id)
    class_names = cell(size(Test,1),1);%number of clases to give
    for j=1:size(Test,1)
        class = unique(Tr{id,end});
        Nclass = zeros(size(class,1) ,1);
        for i=1:size(class,1) 
            Nclass(i) = sum(strcmp(Tr{id,end},class{i})); 
        end 
        Ind = find(Nclass==max(Nclass));
        %check for tie in the classification, if the k neighbors are equal
        %the nearest neighbor is selected
        if size(Ind,1)>1
            class_names(j) = Tr{id(1),end};
        else
            class_names(j) = class(Ind); 
        end
    end
end
