% LOAD_PREBUILT_CVIP - loads all of the current MATLAB prebuilt demo
% images. Loads them into the workspace with the name of the image as the
% variable name. It does not have any inputs or outputs needed.
% this was pretty much only used to try and find images that broke
% functions. It was also shamelessly copied from a forum somewhere with no
% intention of citing the original author.
%
% Syntax:
% -------
% LOAD_PREBUILT_CVIP
%
% Input Parameters include :
% -------------------------
%  NONE
%    
% Example 1 :
% ---------
%   loads the entire current prebuilt image database:
%
%                   load_prebuilt_cvip;
%                   figure;imshow(lighthouse);
%
% Example 2 :
% ---------
%   loads the entire current prebuilt image database:
%
%                   load_prebuilt_cvip;
%                   figure;imshow(greens)
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Joey Olden
%           Initial coding date:    10/09/2019
%           Updated by:             Joey Olden
%           Latest update date:     02/23/2020
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

path = fileparts(which('cameraman.tif'));
D = dir(path);
C = {'.tif';'.jpg';'.png';'.bmp'};
idx = false(size(D));
for ii = 1:length(C)
    idx = idx | (arrayfun(@(x) any(strfind(x.name,C{ii})),D));
end
D = D(idx);
for ii = 1:length(D)
    variable_name = D(ii).name;
    period_spot = strfind(variable_name,'.');
    variable_name = variable_name(1:period_spot-1);
    if ~any(strfind(variable_name,'-'))
        eval([variable_name ' = imread(D(ii).name);']);
    end
end
%removing the variables to keep the workspace clear of any mess
clear path D C idx variable_name ii period_spot