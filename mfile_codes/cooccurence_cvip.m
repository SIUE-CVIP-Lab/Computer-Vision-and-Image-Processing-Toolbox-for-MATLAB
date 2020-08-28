function  glcm = cooccurence_cvip(inImage, td, norm,  Ng)
% COOCCURENCE_CVIP - Gray level co-occurence matrices of an image.
% The function computes co-occurence matrix from A 2D input array.  
% The input image is remapped or scaled so that it will have Ng levels
% ranging from 0 to Ng.And, it creates a four Ng*Ng normalized GLCM 
% matrix corresponding to four directions (vertical,horizontal, right 
% diagonal, left diagonal).
%
% Syntax :
% -------
% glcm = COOCCURENCE_CVIP(inImage,td,Ng, norm)
%   
% Input Parameters include :
% ------------------------
%    'inImage'        2D input array or image of MxN size. 
%
%    'td'             Texture distance (integer value 1,2,...) 
%                     td = 2 (default)
%
%    'norm'           Option for Normalization of GLCM. 'y'->normalized GLCM
%                     and 'n'-> non-normalized GLCM
%                     norm = 'y' (default)
%
%    'Ng'             Total number of gray levels in GLCM matrix. The size of
%                     co-occurence matrix depends on Ng.
%                     If -1, Ng is total number of unique values in an input 
%                     2D array.  
%                     Ng = -1 (default)
%
%
% Output Parameter include :  
% ------------------------
%    glcm           Cooccurence matrix of Ng*Ng*4 size.
%                   glcm(:,:,1): glcm matrix for vertical direction (90° and 270°)
%                   glcm(:,:,2): glcm matrix for horizontal direction (0° and 180°)
%                   glcm(:,:,3): glcm matrix for right diagonal direction (45° and 225°)
%                   glcm(:,:,4): glcm matrix for left diagonal direction (135° and 315°)
%                                         
%
% Example :
% -------
%                   I = imread('cam.bmp');                  %original image
%                   O1 = cooccurence_cvip(I);       %default parameters       
%                   td = 3;                                 %texture distance
%                   O2 = cooccurence_cvip(I,td);     %user defined texture distance
%                   O3 = cooccurence_cvip(I,td,'y',10)    %user defined parameters for quantized-normalized glcm
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    2/25/2017
%           Latest update date:     3/28/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

if nargin ~=1 && nargin ~=2 && nargin ~= 3 && nargin ~= 4
    error('Too many or too few input arguments!');
end

%setup default parameters
if nargin == 1
    td =2;
    norm = 'y';
    Ng = -1;
elseif nargin == 2 
    norm = 'y';
    Ng = -1;
elseif nargin == 3
    Ng = -1;
end

if nargout ~= 1 && nargout ~=0
    error('Too many output arguments!');
end

%   If Ng = -1, the Number of gray levels (i.e. Ng)is recomputed as the
%   total number of unique values in input array. And, if Ng > 1, then Ng  
%   remains same. 

if Ng == -1
    % set Ng as total number of unique values in input array
    Ng=length(unique(inImage));
end

% Scale (remap) the input array in the range of 1 to Ng
scaledimg = scale_img(inImage,[1 Ng]);

%   Size of input array
[max_row,max_col] = size(inImage);
min_row = 1; min_col = 1; 

% Creating Gray level Co-occurence Matrix with size Ng*Ng*4 
% Ng = Total number of gray levels, Ng*Ng = total pairs in GLCM
num_dir = 4; % each matrix for four directions
glcm = zeros(Ng, Ng, num_dir);


% To avoid (r,c)indexes of ROI exceed the image dimension
r_start = min_row+td;         % r_end = max_row-td;
c_start = min_col+td;          c_end = max_col-td;


%Compute GLCM
%======================================================================

%__________________________________________________________________
% Vertical 90°  
dir = 1;
for r=r_start:max_row
    for c=min_col:max_col
        glcm(scaledimg(r,c),scaledimg(r-td,c),dir)=glcm(scaledimg...
            (r,c),scaledimg(r-td,c),dir)+1;             
    end
end
%__________________________________________________________________       
% Horizontal 0°
dir=2;
for r=min_row:max_row
    for c=min_col:c_end
        glcm(scaledimg(r,c),scaledimg(r,c+td),dir)=glcm(scaledimg...
            (r,c),scaledimg(r,c+td),dir)+1; 
    end
end
%__________________________________________________________________  
% Diagonal Top Right 45°
dir=3;
for r= r_start:max_row
    for c=min_col:c_end
        glcm(scaledimg(r,c),scaledimg(r-td,c+td),dir)=glcm(scaledimg...
            (r,c),scaledimg(r-td,c+td),dir)+1;  
    end
end
%__________________________________________________________________
%   Diagonal Top Left (135°)  
dir =4;
for r= r_start:max_row
    for c= c_start:max_col
        glcm(scaledimg(r,c),scaledimg(r-td,c-td),dir)=glcm(scaledimg...
            (r,c),scaledimg(r-td,c-td),dir)+1;
    end
end       
    
% GLCM is a symmetric matrix, i.e. transpose of GLCMs for 0°, 45°, 90° and 
% 135° are GLCMs for 180°, 225°, 270° and 315° respectively.
% Add corresponding symmetric pair to get final GLCM matrix
for i=1:dir
    glcm(:,:,i)=glcm(:,:,i)+(glcm(:,:,i))';
end

% Check if normalization option is ON or OFF
if norm == 'y' || norm == 'Y' || strcmp(norm,'yes') || strcmp(norm,'YES')
    return;
end

%Normalize glcm by total gray-level pairs 
col_vec = ones(Ng,1);
for i=1:dir
    total_pairs = (glcm(:,:,i)*col_vec)'*col_vec;  %sum of GLCM
    glcm(:,:,i)=glcm(:,:,i)/total_pairs;
end
   
end
%end of cooccurence_matrix function



% A function to scale the image into range of [low high]
function [ out_img ] = scale_img( in_img,gray_limits )
%SCALE_IMG Scales the input image in the range defined by gray_limits ([low high])

in_img = double(in_img);

ymin = gray_limits(1,1);
ymax = gray_limits(1,2);
xmin = min(in_img(:));
xmax = max(in_img(:));
out_img= fix(((ymax-ymin)/(xmax-xmin))*(in_img-xmax)+ymax);

end




