function [norm_file_tt,  norm_file_tr] = pattern_softmax_norm_cvip(file_tt, file_tr, file_out, r, count)
% PATTERN_SOFTMAX_NORM_CVIP - two csv files are input, training and test
% sets, and returns new csv files with the feature vectors normalized with
% softmax scaling normalization  
%
% Syntax :
% -------
% [norm_file_tt,  norm_file_tr] = pattern_softmax_norm_cvip(file_tt, file_tr, r)
% 
% Description :
% -----------  
% This function gets the training set and the test set as input arguments
% and normalizes them using softmax normalization method.Then the results are
% saved to two new CSV files and their names are returned as output.The
% softmax method need and extra parameter that should also be given as
% input _r_.
%
% Input Parameters include :
% ------------------------
%   'file_tt'       Name of the test set file.  
%                   A CSV file with a predefined structure.
%   'file_tr'       Name of the training set file. 
%                   A CSV file with a predefined structure.
%   'file_out'      Name of the output file. (Optional - Used in Leave One Out.
%                   A CSV file as the inputs with the train and test vectors 
%                   normalized by using Soft Max Normalization.
%   'r'             The parameter for softmax scaling. 
%   'count'         An integer value with the number of Train/Test set to be
%                   tested for Leave One Out algorithm, for single Train/Test
%                   set it must be equal to 1. Default value 1
%                   
%
%
% Output Parameters include :
% -------------------------  
%  
%  'norm_file_tt'     A string containing the name of the
%                     normalized test file.It is the same name as 
%                     file_tt with the prefix softmax_.
%
%
%  
%  'norm_file_tr'      A string containing the name of the
%                      normalized training file.It is the same name as 
%                      file_tr with the prefix softmax_.
%
%
% Example : 
% -------
%                   file_tt = 'myTestVectors.CSV';
%                   file_tr = 'myTrainingVectors.CSV';
%                   [norm_file_tt,  norm_file_tr] = pattern_softmax_norm_cvip(file_tt, file_tr, [], 3)
%
%   See also pattern_min_max_norm_cvip, pattern_range_norm_cvip, pattern_snd_norm_cvip,
%            pattern_unit_vector_norm_cvip, pattern_euclidean_cvip, min_max_norm_cvip.
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.
%

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    03/13/2017
%           Latest update date:     06/08/2018
%           Updated by:             Julian Rene Cuellar Buritica
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.4  07/13/2019  00:51:39  akarlap
 % Equation to normalize test vector with parameters from train vector was
 % adjusted when working for more than 1 feature vector in test file
%
 % Revision 1.3  01/11/2019  13:03:53  akarlap
 % use mean and std deviation from train set to normalize the test set
 % use count to save all required normalized vectors
%
 % Revision 1.2  06/08/2018  15:39:04  jucuell
 % extraction of feature vector values according to the type of feature
 % data by using obj_id, Image name, or obj_id and Image name
%
 % Revision 1.1  03/13/2017  16:29:05  mealvan
 % Initial coding:
 % function creation and initil testing
%

if isempty(count)               %single Train/Test sets
    count = 1;
end

%%  check the files to make sure they are of the format csv,
%   and also they have the presumed structure. The structure is as follows:
%   Image name | r | c | . . . features names . . . | class
%       .      | . | . |           .                |   .
%       .      | . | . |           .                |   .
%       .      | . | . |           .                |   .
%       .      | . | . |           .                |   .
%   
%   features are stored from 4th column to the one before the last column
%   so they are extracted as follows
test_set = readtable(file_tt);
training_set = readtable(file_tr);

%%  If these two sets are to be compared, they should have the same 
%   features, thus the same VariableNames on their tables. So, 
if size(test_set,2) ~= size(training_set,2)
    error('The size of the feature vectors in the Test and Training sets do not match.');
end

var_names = strcmp(test_set.Properties.VariableNames,training_set.Properties.VariableNames);
if min(var_names) ~= 1
   error('Feature vectors do not match.'); 
end

%% Extract the vectors
switch test_set.Properties.VariableNames{1,1}
    case 'obj_id'
        ini = 2;
    case 'row_obj'
        ini = 3;
    otherwise %case 'Name'
        ini = 4;
end
tt = test_set{:,ini:(end-1)};
tr = training_set{:,ini:(end-1)};

%% Do the math
%normalize train set and extract mean and std
[tr, m, s] = softmax_cvip(tr,r);
%normalize test set with train parameters
tt = (tt - m(1,:))./(r*s(1,:));
tt = 1./(1 + exp(-tt));

test_set{:,ini:(end-1)} = tt;
training_set{:,ini:(end-1)} = tr;

%set file name save file in the same directory of the train vector
norm_file_tr = [file_tr(1,1:size(file_tr,2)-4) '_SoftMax.csv'];
norm_file_tt = [file_tt(1,1:size(file_tt,2)-4) '_SoftMax.csv'];

writetable(test_set,norm_file_tt);
writetable(training_set,norm_file_tr);

if ~isempty(file_out)
    cpath = mfilename( 'fullpath' );
    cpath = [cpath(1:end-32) 'GUI\'];
    file_norm_tr = [cpath 'Pattern\Normalization\' file_out '_Train_SoftMax'];
    if ~strcmp(file_out(end-3:end), '.xls')% the extension should be .xls
        file_norm_tr = [file_norm_tr '.xls'];%append '.xls' to out_file_name 
    end

    file_norm_tt = [cpath 'Pattern\Normalization\' file_out '_Test_SoftMax'];
    if ~strcmp(file_out(end-3:end), '.xls')% the extension should be .xls
        file_norm_tt = [file_norm_tt '.xls'];%append '.xls' to out_file_name 
    end
    if ~isempty(count) && count > 1

        warning ('off','all');      %supress new sheet warning
        writetable(training_set, file_norm_tr, 'Sheet', count);
        writetable(test_set, file_norm_tt, 'Sheet', count);

    else
        writetable(training_set, file_norm_tr, 'Sheet', count);
        writetable(test_set, file_norm_tt, 'Sheet', count);
    end
end

end