function d =  minkowski_distance_cvip( vector1, vector2,r)
% MINKOWSKI_DISTANCE_CVIP - calculates the Minkowski distance between two feature vectors
% 
% Syntax :
% ------
% d =  minkowski_distance_cvip( vector1, vector2,n)
%   
% Input Parameters include :
% ------------------------
%   'vector1'   	Feature vector 1.
%                   A numeric array of n elements.
%   'vector2'       Feature vector 2.
%                   A numeric array of n elements.
%   'r'             size of the feature vectors
%                   positive integer.
%                 
%
%
% Output Parameter include :  
% ------------------------
%   'd'             The Minkowski distance between vector1 and vector2
%                    
% Example :
% -------
%                   vector1 = [1 3 4 2];
%                   vector2 = [-3 3.2 sqrt(2) pi];
%                   d =  minkowski_distance_cvip( vector1, vector2,3)
%                  
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    12/27/2016
%           Latest update date:     3/19/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

    if size(vector1) ~= size(vector2)
        error('Size of the input vectors do not match');
    end
    vector1 = vector1(:);
    vector2 = vector2(:); 
    
    if r< 1
        error('r should be a positive integer');
    elseif round(r) ~= r
        error('r should be a positive integer, not a float');
    end

    d = norm(vector1 - vector2, r);

end