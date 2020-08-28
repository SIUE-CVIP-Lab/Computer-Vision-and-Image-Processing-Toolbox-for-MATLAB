
% batch_cvip: Script that can be used to perform image processing operations
% in batch mode. It reads multiple images as specified by the user and 
% perform multiple image processing operation on the input images and stores
% the output images in the folder specified by the user.
%
% Batch  file illustrates its use with a few sample functions.To run your
% own algorithm on a set of images,simply replace the sample functions
% with the sequence of functons you needed to implement your algorithm.
%

clc;
clear;
[filename, pathname] = uigetfile({'*.*', 'All Files (*.*)';...
        '*.tif','TIFF (*.tif)'; '*.bmp','BMP (*.bmp)';...
        '*.jpg', 'JPEG/JPEG2000 (*.jpg)'; '*.png','PNG (*.png)';...
        '*.pbm ; *.ppm;*.pgm; *.pnm',...
        'PBM/PPM/PGM/PNM (*.pbm,*.ppm,*.pgm, *.pnm)';...
        '*.gif','GIF (*.gif)'}, ...
        'Select an input image file', 'MultiSelect','on'); % prompts user to select input files

if ~isa(filename,'cell')
    filename = cellstr(filename); % convert filename to cell structure
end
folder_name = uigetdir; % prompts user to select folder to save output images   
for i = 1:size(filename,7) % iterate through all input image files
    imageName = char(filename(i)); % read the name of input image
    im = imread([pathname imageName]); % load the particular image for operation
    
    
     a=rgb2lab_cvip(im); % convert rgb image to L*a*b* color value  image
     b=luminance_cvip(a); % perform luminance operation
     c=not_cvip(b); % perform NOT operation
   
     

   
    [~,name,ext] = fileparts(filename{i}); % separates the filename and extension
    FinalImageName = strcat(name,'_',int2str(i),ext); % Create new output filename for each new image
    imwrite(a,[folder_name '\' FinalImageName]); % write image to disk
    disp(i); % display the image number being operated
end