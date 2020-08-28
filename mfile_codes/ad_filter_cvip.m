function out = ad_filter_cvip( I,iter,lambda,K, opt)
% AD_FILTER_CVIP - anisotropic diffusion filter.
% This is an edge preserving,smoothing filter.The filter is anisotropic
% which means it will respond differently in different directions,based on
% image characteristics.This will enable the filter to stop the diffusion process
% at the edges,while still smoothing in areas of homogeneity.It operates
% by a diffusion process that iteratively smoothes the image.At each
% iteration of the filter more smoothing is performed and more image
% detail is lost.coefficient controls the rate at which the smoothing 
% takes place and is usually a function of the image gradient so the
% details in the image are retained and provides a more natural looking image.
%
% Syntax :
% ------
% out = ad_filter_cvip( I,iter,lambda,K, opt)
%   
% Input Parameters Include :
% ------------------------
% 'I'             Input image can be gray image or rgb image of MxN size. 
%                   
% 'iter'          Number of iterations.  
%     
% 'lambda'        Smoothing per iteration.  
%       
% 'K'             Edge threshold.  
%                   
% 'opt'           Coefficient functions suggested by Perona & Malik. 
%                          1 - c(x,y,t) = exp(-(||nablaI||/K).^2),    
%                          2 - c(x,y,t) = 1./(1 + (||nablaI||/K).^2),
%                              
%                      
% Output Parameters Include :  
% -------------------------
% 'out'            The output image after filtering.
%                  An image with the same size as the input image.
%
% Example :
% -------
%                   I = imread('Butterfly.gaussian.tif');
%                   iter = 20;
%                   sPerIter = 1;
%                   K = 6;
%                   opt = 2;
%                   out = ad_filter_cvip( I,iter,sPerIter,K, opt);
%                   figure; imshow(hist_stretch_cvip(out,0,1,0,0),[]);
%
%
% Reference
% ---------
%  1.Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.
%
%  2.P.Perona and J. Malik. 
%   Scale-Space and Edge Detection Using Anisotropic Diffusion.
%   IEEE Transactions on Pattern Analysis and Machine Intelligence, 
%   12(7):629-639, July 1990.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    4/24/2017
%           Latest update date:     4/27/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================


out = double(I);

for i=1:iter
    
[Fx, Fy] = gradient(out);

norm_grad = sqrt(Fx.^2 + Fy.^2);
var = (norm_grad.^2)/ (K^2);

if opt ==1 
    c = exp(-var);
elseif opt ==2
    c = 1./(1 + var);
end


[adx,~] = gradient(c.*Fx);
[~,ady] = gradient(c.*Fy);

out = out + (lambda)*(adx+ady);
end

end

