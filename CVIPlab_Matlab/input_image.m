function cvipImage = input_image()
%INPUT_IMAGE Input an image file using file selection dialog box. 
%The function reads an image selected by user via file selection dialog
%box, and returns it as a RGB image. If the input image is an indexed
%image, it will be converted to RGB image using ind2rgb() function.
%Furthermore, if user cancels the file selection, the function will return
%an empty matrix.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    01/15/2017
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     01/10/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================


% Revision History
%
 % Revision 1.2  01/10/2019  16:12:05  jucuell
 % Adding code to detect gray sacle images that are detected with a map as
 % indexed images and just convert those to gray scale images.
%
 % Revision 1.1  01/15/2017  13:10:40  norlama
 % Function creation and initial testing
%
    %open file selection dialog box to input image
    [filename, pathname] = uigetfile({'*.*', 'All Files (*.*)';...
        '*.tif','TIFF (*.tif)'; '*.bmp','BMP (*.bmp)';...
        '*.jpg', 'JPEG/JPEG2000 (*.jpg)'; '*.png','PNG (*.png)';...
        '*.pbm ; *.ppm;*.pgm; *.pnm',...
        'PBM/PPM/PGM/PNM (*.pbm,*.ppm,*.pgm, *.pnm)';...
        '*.gif','GIF (*.gif)'}, ...
        'Select an input image file', 'MultiSelect','off'); %mulitple file selection option is OFF, single image file only 

    %check if user has successfuly made the file selection
    if ~isequal(filename,0)
        % read the selected image from given path
        [cvipImage,map]=imread([pathname filename]);
        
        %check image is either indexed image or rgb image
        %indexed image consists of a data matrix and a colormap matrix.
        %rgb image consists of a data matrix only.        
        if ~isempty(map) %indexed image if map is not empty
            if size(cvipImage,3)==1
                %cvipImage = ind2gray(cvipImage,map);%convert indexed image into gray image 
                cvipImage = remap_cvip(cvipImage,[double(min(cvipImage(:))) double(max(cvipImage(:)))]);
            else
                cvipImage = ind2rgb(cvipImage,map);%convert indexed image into rgb image 
            end
        end
        
    else 
        warning('Image file not selected!!!');  %warn user if cancelled
        cvipImage=[];             %return empty matrix if user has cancelled the selection
    end

end %end of input_image function

