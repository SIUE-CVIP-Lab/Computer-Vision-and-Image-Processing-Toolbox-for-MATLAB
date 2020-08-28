function [ outImage ] = hist_spec_cvip( inImage, histFunc, cA, cB)
% HIST_SPEC_CVIP -Histogram specification of an input image.
% The function performs a histogram specification on an image. For single
% or multi-band image, the histograms can be specified separately for 
% each band.The specified histogram is computed by calculating the
% cumulative distribution function of both the original histogram and the
% desired histogram.The cdf for the original histogram is then mapped to
% the desired histogram using  the inverse cdf.If Pr(x) is the original
% histogram, and Pz(x) is the desired histogram, then the cdf[Pr(x)] = T(r)
% = s, and cdf[Pz(x)] = G(z) = v.The inverse of this is z = inv[G(v)].
% Therefore z = inv[G(T(r))]. Where r is the original grey-level, and z is
% the new grey-level. 
%
% Syntax:
% -------
% outImage = hist_spec_cvip( inImage, histFunc, cA, cB)
%   
% 
% Input Parameters include:
% -------------------------
%  'inImage'      Input image of MxN or MxNxB size.The input image can be
%                  of uint8 or uint16 or double class. 
%  'histFunc'     Single value or array with the number of the functions to
%                  specify histogram per each band. The inputs to the
%                  functions have the expression cAx+cB. Where x are gray
%                  values, and cA & cB are constants. 
%                       histFunc(1): specified histogram of band 1
%                       histFunc(2): specified histogram of band 2
%                               .                 
%                               .                 
%                               .
%                       histFunc(B): specified histogram of band B
%
%                  Functions available for histogram specification are:
%                  1  ---> sin(Ax + B)
%                  2  ---> Ax+B   
%                  3  ---> ramp(Ax + B)  
%                  4  ---> exp(Ax+B)
%                  5  ---> log(Ax + B)
%                  6  ---> cos(Ax + B)
%                  7  ---> sinh(Ax + B)
%                  8  ---> cosh(Ax + B)
%                  9  ---> tanh(Ax + B)
%                  10 ---> sqrt(Ax + B)
%                                                       ([1 1 1] | default)
%
%  'cA'           Values of constant cA of expression cAx+cB.
%                        cA(1): value of constant cA for band 1
%                        cA(2): value of constant cA for band 2
%                                   .                 
%                                   .                 
%                                   .
%                        cA(B): value of constant cA for band B
%                                                       ([1 1 1] | default)
%
%  'cB'           Values of constant cB of expression cAx+cB.
%                        cB(1): value of constant cB for band 1
%                        cB(2): value of constant cB for band 2
%                                   .                 
%                                   .                 
%                                   .
%                        cB(B): value of constant cB for band B
%                                                       ([0 0 0] | default)
%
%
% Output Parameter includes :  
% -------------------------
%  'outImage'      Histogram specified image.
%                                         
%
% Example :
% -------
%         I = imread('butterfly.tif');    %original image
%         O1 = hist_spec_cvip(I);         %default parameters  
%         figure; imshow(O1/255);
%         %user defined parameters [sine line exp] for histFunc    
%         O2 = hist_spec_cvip(I,[1 2 4], [0.025 1 0.03], [1 0.5 1]); 
%         figure; imshow(O2/255);              
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    04/14/2017
%           Modified by:            Julian Rene Cuellar Buritica
%           Latest update date:     06/14/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.2  06/14/2019  11:35:07  jucuell
 % The function information was updated in order to be more concise with
 % previous functions and undertandable by the user.
%
 % Revision 1.1  04/14/2017  17:22:00  norlama
 % Initial coding and testing.
%

%check number of input arguments
if nargin ~=1 && nargin ~= 2 && nargin ~= 3 && nargin ~=4   
    error('Too many or too few input arguments!');
end

%check number of output arguments
if nargout ~= 1 && nargout ~= 0
    error('Too many output arguments!');
end

L = 256;  %maximum number of Levels
inImage = double(inImage);

%find the size of an input image
[P, Q, R] = size(inImage);

%check if coefficients A and B exists and has finite value
if ~exist('histFunc', 'var') || isempty(histFunc)
    histFunc = [1 1 1];
end
if ~exist('A', 'var') || isempty(cA)
    cA = [1 1 1];
end
if ~exist('B', 'var') || isempty(cB)
    cB = [0 0 0];
end

%create output image
outImage = zeros(P,Q,R);


%histogram specification/matching
for b = 1:R
    %Mapping table 1
    %find the histogram equalized mapping values of input image
    tempImage = inImage(:,:,b);
    histeq_vals = histeq_mapvals(tempImage, L);  

    %Mapping table 2
    %setting up desired histogram  and compute desired histogram's mapping values
    switch histFunc(b)
        case 1  %  sin(Ax + B)
            tempHist = sin(cA(b)*(0:L-1) + cB(b));
            minvalue = min(tempHist);
            if minvalue < 0    %if less than 0, shift the values to make it positive or zero
               tempHist = tempHist - minvalue;
            end         
            
        case 2  %  Ax+B
            tempHist = cA(b)*(0:L-1)+cB(b);
            
        case 3  %  ramp(Ax + B)
            tempHist = cA(b)*(0:L-1) + cB(b);
            
        case 4  %  exp(Ax+B)
            tempHist = exp(cA(b)*(0:L-1) + cB(b));
            
        case 5  %  log(Ax + B)
            tempHist = log10(cA(b)*(0:L-1) + cB(b));
            tempHist(1) = 0;  %log10(0) = -Inf, make it zero  
            
        case 6  %  cos(Ax + B)
            tempHist = cos(cA(b)*(0:L-1) + cB(b));
            minvalue = min(tempHist);
            if minvalue < 0   %if less than 0, shift the values to make it positive or zero
               tempHist = tempHist - minvalue;
            end   
            
        case 7  %  sinh(Ax + B)
            tempHist = sinh(cA(b)*(0:L-1) + cB(b));
            
        case 8  %  cosh(Ax + B)
            tempHist = sinh(cA(b)*(0:L-1) + cB(b));
            
        case 9  %  tanh(Ax + B)
            tempHist = sinh(cA(b)*(0:L-1) + cB(b));
            
        case 10  %  sqrt(Ax + B)
            tempHist = sqrt(cA(b)*(0:L-1) + cB(b));
        otherwise 
            error('No such function available! Choose other function for band %d.', b);
            
    end    
    %compute CDF of desired histogram
    desiredHistCDF = tempHist/sum(tempHist);
    
    desiredHist_vals = cumsum(desiredHistCDF) *(L-1);

    %map the original pixel values using table 1 and table 2    
    for i =1:L
        [~,ind] = min(abs(histeq_vals(i) - desiredHist_vals)); 
        tempImage(inImage(:,:,b) == i-1) = ind-1;
    end
    
    %output image of histogram specification process
    outImage(:,:,b) = tempImage;
end



end % end of function


%**************************************************************************
%%%%%%function to compute histogram equalization mapping values%%%%%%%%%%%%

function histeq_vals = histeq_mapvals(inImage, L)

[P,Q] = size(inImage);


%compute the histogram
edges = 0:L;
hist_count = histcounts(inImage, edges)/(P*Q);
hist_cumsum = cumsum(hist_count); 

%map old pixel levels to new one
histeq_vals = (L-1)*hist_cumsum;

end

