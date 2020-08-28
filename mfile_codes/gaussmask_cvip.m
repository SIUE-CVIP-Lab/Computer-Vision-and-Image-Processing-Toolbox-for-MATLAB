function [gFilter] = gaussmask_cvip(Msiz)
%GAUSSMASK_CVIP Summary of this function goes here
%   Detailed explanation goes here

    gFilter = window(@chebwin,Msiz);
    [r,c] = meshgrid(gFilter,gFilter);
    gFilter = power(Msiz,2).*(r.*c);
    
end
