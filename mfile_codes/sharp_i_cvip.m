function [OutIma] = sharp_i_cvip(InIma,L_mask,mask_size,low_clip,high_clip,varargin)
%SHARP_II_CVIP - performs the sharpening I algorithm based on the algortim
%                in CVIPtools. Info can be viewed in the help pages.
%
%Syntax :
% -------
% OutIma = shapr_ii_cvip(InIma);
%
% Input Parameters:
% -----------------
%
% 'InIma'               Input image to the algorithm. Can be either color or gray
%                       scale image.
%
% 'L_mask'              One of two Laplacian Mask options
%
% 'mask_size'           size of a sobel filter mask
%
% 'low_clip'            Percentage clipped during the histogram strecth
%
% 'high_clip'           Percentage clipped during the histogram stretch
%
% 'varargin'            The first input represents the intermediate remap
%                       The second input represents the add to original
%                       Use (1 or 0) for (yes or no)
%                       Default is to do both
%
% Output Parameters:
% ------------------
%
% 'OutIma'      Output image result of the algorithm
%
% Example:
% --------
%
%               InIma = imread('cameraman.tif');
%               OutIma = sharp_i_cvip(InIma,1,3,0.005,0.005);
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Joey Olden
%           Initial coding date:    05/01/2020
%           Latest update date:     05/01/2020
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

%determining the Laplacian mask to be used
if L_mask == 1
    Lap = [-1 -1 -1;-1 8 -1;-1 -1 -1];
else 
    Lap = [-2 1 -2;1 4 1;-2 1 -2];
end

%performing the filtering with the chosen laplacian mask
Lap = convolve_filter_cvip(InIma,Lap);

%performing the sobel operation
Sobel = sobel_ed_cvip(InIma,mask_size);

%Multiply the two images
Mult = multiply_cvip(Lap,Sobel);

%handling the intermediate remap option
if varargin{1}
    Mult = remap_cvip(Mult,[0 255]);
end

%handling the optional add original image option
if varargin{2} 
    OutIma = double(InIma) + Mult;
else
    OutIma = Mult;
end

%hist stretch the image
OutIma = uint8(hist_stretch_cvip(OutIma,0,255,low_clip,high_clip));

end


