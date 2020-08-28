function [a, fmin, range] = min_max_norm_cvip(vector,s_min,s_max)
% MIN_MAX_NORM_CVIP - applies min-max normalization to set of feature vectors in a matrix.
% 
% Syntax :
% -------
%   a = min_max_norm_cvip(vector,  s_min,  s_max)
%   
% Input Parameters include :
% ------------------------ 
%   'vector'        An m by n numerical matrix where m is the number of vectors and n 
%                   is the length of each row vector. 
%
%   's_min'         The min parameter in Min-Max normalization.  
%                    
%   's_max'         The max parameter in Min-Max normalization.  
%                   
%
% Output Parameter include :  
% ------------------------ 
%   'a'             A matrix with the same size as the input 'vector' , 
%                   where each column(feature vector) is normalized using Min-Max.
%   'fmin'          A matrix with the same size as the input 'vector', 
%                   where each column(feature vector) has the vector's min value.
%   'range'         A matrix with the same size as the input 'vector', 
%                   where each column(feature vector) has the vector's data range.
%                 
%
% Example :
% -------
%                   vectors = randn(13,6);
%                   a = min_max_norm_cvip(vectors,0,1)
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
%           Latest update date:     16:17:27
%           Updated by:             Julian Rene Cuellar Buritica
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
% 
 % Revision 1.3  07/15/2019  16:17:27  jucuell
 % output parameter were reduced to one row to be used in the normalization
 % of the test set.
%
 % Revision 1.2  01/11/2019  13:01:04  akarlap
 % provide the min adn range values of train set as output to be used in
 % pattern_min_max_norm_cvip to normalize the test set
%
 % Revision 1.1  07/29/2016  16:29:05  norlama
 % Initial coding:
 % function creation and initial testing
%

    m = size(vector,1);
    fmin = min(vector);
    range = max(vector) - fmin;
    
    fmin = repmat(fmin,[m 1]);
    range = repmat(range,[m 1]);
    a = (vector - fmin)./range;
    
    a = (a*(s_max - s_min)) + s_min;
    
    %Reduce size of output vector
    fmin = fmin(1,:);
    range = range(1,:);
end