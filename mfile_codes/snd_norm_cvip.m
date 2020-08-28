function [a, mu, s] = snd_norm_cvip(vector)
% SND_NORM_CVIP - applies standard normal density normalization to a set of
% feature vectors in a matrix. 
%
% Syntax :
% ------
% a = snd_norm_cvip(vector)
%   
% Input Parameter include :
% -----------------------
%
%   'vector'        An m by n numerical matrix where m is the number of vectors and n 
%                   is the length of each row vector. 
% 
% Output Parameter include :
% ------------------------
%
%   'a'             A matrix with the same size as the input 'vector', 
%                   where each column(feature vector) is normalized by SND method.
%   'mu'            A matrix with the same size as the input 'vector', 
%                   where each column(feature vector) has the vector's mean.
%   's'             A matrix with the same size as the input 'vector', 
%                   where each column(feature vector) has the vector's std.
%                 
%
% Example :
% -------
%                   vectors = [1 3 6];
%                   a = snd_norm_cvip(vectors)
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
%
 % Revision 1.2  01/11/2019  13:01:04  akarlap
 % provide the mean and std deviation of train set as output to be used in
 % pattern_snd_norm_cvip to normalize the test set
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
    
    a = (vector - mu)./s;
end