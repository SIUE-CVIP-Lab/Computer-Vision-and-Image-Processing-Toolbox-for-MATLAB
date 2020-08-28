function [a, mu, s] = softmax_cvip( vector,r_softmax)
% SOFTMAX_CVIP - applies softmax normalization to set of feature vectors in a matrix
%
% Syntax :
% ------
% a = softmax_cvip( vector,  r_softmax)
%   
% Input Parameters include :
% ------------------------
%   'vector'        An m by n numerical matrix where m is the number of vectors and n 
%                   is the length of each row vector. 
%
%   'r_softmax'     The parameter for softmax scaling.  
% 
%
%
% Output Parameter include :
% ------------------------
%
%   'a'             A matrix with the same size as the input 'vector' , 
%                   where each column(feature vector) is normalized using softmax scaling method.
%                 
%
% Example :
% -------
%                   vectors = randn(13,6);
%                   a = softmax_cvip(vectors, 3)
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
%           Latest update date:     02/23/2019
%           Updated by:             Julian Rene Cuellar Buritica
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
 % Revision 1.3  02/23/2019  14:45:53  jucuell
 % use of the std function that includes de use of the square root of the
 % deviation for calculations
%
 % Revision 1.2  01/11/2019  13:01:04  akarlap
 % provide the mean and std deviation of train set as output to be used in
 % pattern_softmax_norm_cvip to normalize the test set
%
 % Revision 1.1  07/29/2016  16:29:05  norlama
 % Initial coding:
 % function creation and initial testing
%
    m = size(vector,1);


    mu = mean(vector);
    mu = repmat(mu,[m 1]);
    s = std(vector,1);          %perform std using the square root of the 
    s = repmat(s,[m 1]);        %second moment of the sample about its mean
    
    y = (vector - mu)./(r_softmax*s);
    a = 1./(1 + exp(-y));
end