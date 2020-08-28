function d = pattern_vector_inner_product_cvip(file_tt, file_tr)
% PATTERN_VECTOR_INNER_PRODUCT_CVIP – takes two csv files as input, test
% and training set, then calculates the normalized vector inner product
% metric by comparing each vector in the test set to each in the training set
%
% Syntax :
% ------
% d = pattern_vector_inner_product_cvip(file_tt, file_tr)
% 
% Description :
% -----------
%  Using normalized vector inner product we calculate the similarity between the vectors 
%  in training set and the test set. The distances are returned in a matrix
%  which its rows represetns the test vectors and its columns, the training
%  vectors.
% 
% Input Parameters include :
% ------------------------
%   'file_tt'       Name of the test set file.  
%                   A CSV file with a predefined structure.
%   'file_tr'       Name of the training set file. 
%                   A CSV file with a predefined structure.
%
%
% Output Parameters include :
% -------------------------
%
%   'd'             A matrix containing the inner product between each vector
%                   in the test set to each vector in the training set.
%                   Each column represents a vector in training set.
%                   Each row represents a vector in test set.
%
%
% Example :
% -------
%                   file_tt = 'myTestVectors.CSV';
%                   file_tr = 'myTrainingVectors.CSV';
%                   d = pattern_vector_inner_product_cvip(file_tt, file_tr)
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
 % Revision 1.3  02/18/2019  14:06:59  
 % replace for loop calling of vector_inner_product_cvip to matrixial
 % representation by using matrix tensors
%
 % Revision 1.2  06/08/2018  15:39:04  jucuell
 % extraction of feature vector values according to the type of feature
 % data by using obj_id, Image name, or obj_id and Image name
%
 % Revision 1.1  03/13/2017  16:29:05  mealvan
 % Initial coding:
 % function creation and initial testing
%

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
        tt = test_set{:,2:(end-1)};
        tr = training_set{:,2:(end-1)};
    case 'row_obj'
        tt = test_set{:,3:(end-1)};
        tr = training_set{:,3:(end-1)};
    otherwise %case 'Name'
        tt = test_set{:,4:(end-1)};
        tr = training_set{:,4:(end-1)};
end
%% Do the math
m = size(tr,1); %number of Training objects
n = size(tt,1); %number of Test objects
w = size(tt,2); % number of features. The same number for tt and tr


%   change to tensor
T = reshape(tt',1,w,n);
T = repmat(T,[m 1 1]);
R = repmat(tr,[1 1 n]);

%   calculate the distance
d = sum(T.*R,2)./(sqrt(sum(T.*T,2)).*sqrt(sum(R.*R,2)));
d = d';

% for i = 1:n
%     for j=1:m
%         d(i,j) = vector_inner_product_cvip( tt(i,:), tr(j,:) ,2);
%     end
% end

%%  The structure of d
%   each column represents a vector in training set
%   each row represents a vector in test set
%   The entry at (i,j) is the distance from test vector i to the training
%   vector j.
%   So to find the nearest neighbor we need min(d,[],2); the smallest
%   distance along side the 2nd dimension.
%
%   At this point, d should be saved to a file "CVIPtemp.mat" for further analysis by
%   other functions.

end