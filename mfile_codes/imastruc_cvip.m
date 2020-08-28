function vipmImage = imastruc_cvip(file)
% IMASTRUCT_CVIP - Creates an image data structure for the toolbox GUI.
% The function writes image data to the VIPM (visualization in image 
% processing Matlab) file specified by the filename.If filename exists,
% the function overwrites the image file.The vipm file format is similar
% to the vip format in CVIPtools, which was created to handle any data
% types and formats (i.e. real or complex).In addition, a history
% structure is included in the defined format for custom and future use.
%
% Modified to include if desired the number of rows and cols of the
% original image sometimes neccessary in processes like compression
%
% Syntax :
% -------
% vipmInfo = imastruc_cvip(file)
%   
% Input Parameters include :
% -------------------------
% 'file'          String containing the image name
%                 of uint8, int16, int32, single or double class.
%
%
% Output Parameter includes :  
% --------------------------
% 'vipmImage'     Structure with the followeing two elements:
%                 cvipIma = Raw image data
%
%                 fInfo = Structure with image information with fields:
%                       field1 = 'filename';                
%                       field2 = 'file_mod_date';             
%                       field3 = 'file_size';              
%                       field4 = 'image_format';           
%                       field5 = 'color_format';             
%                       field6 = 'cvip_type';                
%                       field7 = 'no_of_bands';             
%                       field8 = 'no_of_cols';              
%                       field9 = 'no_of_rows';             
%                       field10 = 'data_format';         
%                       field11 = 'cmpr_format';         
%                       field12 = 'history_info';     
%                                         
%
% Example :
% -------
%                   %get image data and information
%                   vipmIma = imastruc_cvip('butterfly.tif'); 
%                   InIma = vipmIma.cvipIma;        %Extract Image Data
%                   figure, imshow(InIma);          %Show image
%                   title('Readed Image');
%                   fInfo = vipmIma.fInfo,          %Get and show image
%                                                   %information
%
%
% More Information on input argument #3:
% --------------------------------------
% 'Image Format'       Image format type. Supported formats are:-  
%                        ('pbm', 'pgm', 'ppm', 'eps', 'tif', 'gif','ras',
%                        'itx', iris' , 'ccc', 'bin', 'vip', 'glr', 'btc',
%                        'brc','huf', 'zvl','arith','btc2', 'btc3', 'dpc',
%                        'zon', 'zon2', 'safvr', 'jpeg', 'wvq', 'fra',
%                        'vq','xvq', 'trcm', 'ps', 'bmp', 'jp2', 'png')
%
% 'Color Format'       Color format type. Supported formats are:-  
%                        ('binary', 'gray_scale', 'rgb', 'hsl', 'hsv',
%                        'sct', 'cct', 'luv', 'lab', 'xyz')    
%
% 'Image Data Type'    Image data type. Supported types are:-  
%                        ('cvip_byte', 'cvip_short', 'cvip_long', 
%                        'cvip_float', 'cvip_double')  
%
% 'Data Format'       Image Data format. Supported Data are:-
%                       ('real','complex')
% 
% 'Compress Format'   Compression format type. Supported formats are:-  
%                        ('none','btc', 'btc2', 'btc3', 'dpc', 'zvl',
%                        'glr', 'brc','huf', 'zon', 'zon2', 'jpg', 'wvq',
%                        'fra', 'vq', 'xvq', 'trcm', 'top', 'jp2') 
%
% 'History'           Record of processes performed to image - Not Available
% 
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications 
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Julian Rene Cuellar Buritica
%           Initial coding date:    09/21/2018
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     09/25/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.2  09/25/2018  13:26:34  jucuell
 % help information updating and example, check vip images
%
 % Revision 1.1  09/21/2018  17:48:03  jucuell
 % Initial revision: Function creation and initial testing
 % 
%
%check number of input arguments
if nargin ~=1
    error('Too many or too few input arguments!');
end
if nargout ~=0 && nargout ~=1
    error('Too many or too few output arguments!');
end

%open file according to format
if strcmp(file(end-4:end), '.vipm') 
    [imgData, vipImage] = vipmread2_cvip(file);  %read vipm file
elseif strcmp(file(end-3:end), '.vip') 
    [imgData, vipImage] = vipread_cvip(file);   %read vip file
else
    imgInfo = imfinfo(file);       %read image file information
    [imgData, map] = imread(file);  %read image data and color map
    [rows,cols,bands] = size(imgData);
    %check image is either indexed image or rgb image
    %indexed image consists of a data matrix and a colormap matrix.
    %rgb image consists of a data matrix only.        
    if ~isempty(map) %indexed image if map is not empty
        if bands==1
            %imgData = ind2gray(imgData,map);%convert indexed image into gray image 
            imgData = remap_cvip(imgData,[double(min(imgData(:))) double(max(imgData(:)))]);
        else
            imgData = ind2rgb(imgData,map);%convert indexed image into rgb image 
        end
    end
    
    %define color format according to image information
    if bands==1
        if median(imgData) ~= 0
            colorFormat = 'gray_scale';
        else
            colorFormat = 'binary';
        end
    else
        colorFormat = 'rgb'; 
    end

    %define cvip data type according to image data type
    if isa(imgData,'uint8')
        datatype = 'cvip_byte';
    elseif isa(imgData,'int16')
        datatype = 'cvip_short';
    elseif isa(imgData, 'int32')
        datatype = 'cvip_long';
    elseif isa(imgData, 'single')
        datatype = 'cvip_float';
    else
        datatype = 'cvip_double';
    end    

    %create VIP image structure
    vipImage = create_vip_image();

    %set fields of VIP image
    vipImage.filename = file;
    vipImage.file_mod_date = imgInfo.FileModDate;   %File modification date
    vipImage.file_size = imgInfo.FileSize;          %file size
    vipImage.image_format = imgInfo.Format;         %image format
    vipImage.color_format = colorFormat;            %Colorspace format
    vipImage.cvip_type = datatype;                  %Data type 
    vipImage.no_of_bands = bands;                   % #bands
    vipImage.no_of_rows = rows;                     % #rows
    vipImage.no_of_cols = cols;                     % #cols
    
    if isreal(imgData)                            %Image Data format
        vipImage.data_format= 'real'; 
    else
        vipImage.data_format= 'complex'; 
    end
    
    try         %search for compression format
        vipImage.cmpr_format = imgInfo.CompressionType; %for bmp
    catch
        try
            vipImage.cmpr_format = imgInfo.Compression; %for tiff
        catch
            try
                vipImage.cmpr_format = imgInfo.CodingMethod; %for jpg
            catch
                vipImage.cmpr_format = 'none';
            end
        end
    end
    vipImage.history_info = 'none';
end

vipmImage = struct('cvipIma',imgData,'fInfo',vipImage); 

end %end of imastruc_cvip function

%--------------------------------------------------------------------------
%Function to create vipImage
%--------------------------------------------------------------------------
function vipImage = create_vip_image()
    field1 = 'filename';                   value1 = [];
    field2 = 'file_mod_date';              value2 = [];   
    field3 = 'file_size';                  value3 = [];
    field4 = 'image_format';               value4 = [];
    field5 = 'color_format';               value5 = [];
    field6 = 'cvip_type';                  value6 = [];
    field7 = 'no_of_bands';                value7 = [];
    field8 = 'no_of_cols';                 value8 = [];
    field9 = 'no_of_rows';                 value9 = [];
    field10 = 'data_format';               value10 = [];
    field11 = 'cmpr_format';               value11 = [];
    field12 = 'history_info';              value12 = []; 
         
    vipImage = struct(field1,value1,field2,value2,field3,value3,...
    field4,value4,field5,value5,field6,value6,field7,value7,field8,value8,...
    field9,value9,field10,value10,field11,value11,field12,value12);
end

%VIP IMAGE
% Ima = reshape(InIma,fInfo.no_of_rows,fInfo.no_of_cols,fInfo.no_of_bands);
% OutIma = Ima;
% for i=1:fInfo.no_of_bands
%     OutIma(:,:,i) = Ima(:,:,i)';
% end
% figure, imshow(Ima)
% figure, imshow(OutIma)
