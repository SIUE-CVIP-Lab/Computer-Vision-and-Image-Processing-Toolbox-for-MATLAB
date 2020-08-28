function [a, norms] = unit_vector_norm_cvip(vector)
% UNIT_VECTOR_NORM_CVIP - applies unit vector normalization to set of feature vectors in a matrix.
% 
% Syntax :
% ------
%  a = unit_vector_norm_cvip(vector)
%   
% Input Parameter include :
% -----------------------
%  'vector'        An m by n numerical matrix where m is the number of vectors and n 
%                  is the length of each row vector. 
% 
% Output Parameter include :  
% ------------------------ 
%  'a'             A matrix with the same size as the input 'vector', 
%                  where each column(feature vector) is normalized by unit
%                  vector normalization method.
%  'norms'         A matrix with the same size as the input 'vector', 
%                  where each column(feature vector) has the vector's 
%                  unit normalization values.
%                 
%
% Example :
% -------
%                   vectors = randn(13,6);
%                   a = unit_vector_norm_cvip(vectors)
%
%
% Reference 
% ---------
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    07/29/2016
%           Latest update date:     01/11/2019
%           Updated by:             Akhila Karlapalem
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
 % Revision 1.2  01/11/2019  13:01:04  akarlap
 % provide the normalization matrix of train set as output to be used in
 % pattern_range_norm_cvip to normalize the test set
%
 % Revision 1.1  07/29/2016  16:29:05  norlama
 % Initial coding:
 % function creation and initial testing
%

    m = size(vector,1);
    norms = diag(sqrt(vector'*vector));
    norms = repmat(norms',[m 1]);
    
    a = vector./norms;
end