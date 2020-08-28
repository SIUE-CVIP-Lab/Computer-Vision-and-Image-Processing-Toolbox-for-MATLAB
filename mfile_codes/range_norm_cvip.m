function [a, range] = range_norm_cvip(vector)
% RANGE_NORM_CVIP - normalizes a set of feature vector values in a matrix
% based on the range of each feature 
%
% Syntax :
% ------
%  a = range_norm_cvip(vector)
%   
% Input Parameters include :
% ------------------------
%   'vector'        An m by n numerical matrix where m is the number of vectors and n 
%                   is the length of each row vector. 
%
% Output Parameter include :
% -------------------------  
%
%   'a'             A matrix with the same size as the input 'vector' , 
%                   where each column(feature vector) is normalized using
%                   range normalization method.
%   'range'         A matrix with the same size as the input 'vector', 
%                   where each column(feature vector) has the vector's data range.
%                 
%
% Example :
% -------
%                   vectors = randn(13,6);
%                   a = range_norm_cvip(vectors)
%
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
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
 % provide the data range of train set as output to be used in
 % pattern_range_norm_cvip to normalize the test set
%
 % Revision 1.1  07/29/2016  16:29:05  norlama
 % Initial coding:
 % function creation and initial testing
%

    m = size(vector,1);
    range = max(vector) - min(vector);
    range = repmat(range,[m 1]);
    a = vector./range;
    
end