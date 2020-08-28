function [ opFlag, vipmInfo ] = vipmwrite2_cvip(imageData, fileName, imageArgs, history)
% VIPMWRITE2_CVIP- Writes image data to the VIPM file.
% The function writes image data to the VIPM (visualization in image 
% processing Matlab) file specified by the filename.If filename exists,
% the function overwrites the image file.The vipm file format is similar
% to the vip format in CVIPtools, which was created to handle any data
% types and formats (i.e. real or complex).In addition, a history
% structure is included in the defined format to store encoded information
% about the operations performed to the saved image.
%
% Modified to include if desired the number of rows and cols of the
% original image sometimes neccessary in processes like compression
%
% Syntax :
% -------
% [opFlag, vipmInfo] = vipmwrite2_cvip(imageData,fileName,imageArgs,history)
%   
% Input Parameters include :
% -------------------------
% 'imageData'     Image array (real or complex format). The image can be
%                 of uint8, int16, int32, single or double class.
% 'filename'      Character vector specifying the name of new VIPM file.
% 'imageArgs'     Image information of original image or new image 
%                   information you want to store.
%                   imageArgs(1): Image Format          ('tif'| default)
%                   imageArgs(2): Color Format          (for 2-D image, 'gray_scale' as default 
%                                                        for 3-D image, 'rgb' as default) 
%                   imageArgs(3): compress format type  ('none'| default)
%                   imageArgs(4): Byte Ordering         ('le'| default)
%                   imageArgs(5): Image data type       (class of imageData 
%                                                       as default)                   
%                   imageArgs(6): Original # bands      (imageData bands default)
%                   imageArgs(7): Original # cols       (imageData cols default)
%                   imageArgs(8): Original # rows       (imageData rows default)
% 'history'         History structure 
%                   Row vector containing up to 10 decimal values
%                   corresponding to the CVIP toolbox function and
%                   it user defined parameters. See historydeco_cvip.
%                   [funcode param1 param2 ... param 9]
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
% 'Compress Format'    Compression format type. Supported formats are:-  
%                        ('none','btc', 'btc2', 'btc3', 'dpc', 'zvl',
%                        'glr', 'brc','huf', 'zon', 'zon2', 'jpg', 'wvq',
%                        'fra', 'vq', 'xvq', 'trcm', 'top', 'jp2')   
%
% 'Byte Ordering'      Byte Ordering type. Supported types are:-  
%                        ('le','be') 
%
% 'Image Data Type'    Image data type. Supported types are:-  
%                        ('cvip_byte', 'cvip_short', 'cvip_long', 
%                        'cvip_float', 'cvip_double')
%
%
% Output Parameter includes :  
% --------------------------
% 'opFlag'        Indicates the completion of vipm file write operation,
%                 1 if success
% 'vipmInfo'      Information structure of saved VIPM image file 
%   
%                                         
%
% Example :
% -------
%                   I = imread('butterfly.tif');        %original image
%                   vipmwrite2_cvip(I,'test');           %default parameters       
%                   %a combination of user specified arguments and default arguments 
%                   [Op, Info] = vipmwrite2_cvip(I,'test1',{'tif','rgb'})            
%
%  See also, vipmread2_cvip, vipmwrite_cvip, vipmread_cvip,
%  historydeco_cvip, historyupdate_cvip, btcdeco_cvip, btcenco_cvip.
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
%    with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    04/10/2017
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     12/10/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================


% Revision History
%
 % Revision 1.2  10/10/2018  16:12:05  jucuell
 % function is saving information about transforms information such as the
 % FFT by using the trans vble and the info in the history.
%
 % Revision 1.1  10/04/2018  13:10:40  jucuell
 % Initial revision: Copying from original file and start adding
 % modifications to save history and BTC compress data
%

%check number of input arguments
if nargin ~=1 && nargin ~= 2 && nargin ~= 3 && nargin ~= 4
    error('Too many or too few input arguments!');
end
if nargout ~=0 && nargout ~=1 &&  nargout ~= 2
    error('Too many or too few output arguments!');
end

%Default image arguments
%imageArgs = {imgFormat, colorFormat, cmpr_Type, ByteOrder, CVIP_DataType}
if isa(imageData,'uint8')
    datatype = 'cvip_byte';
elseif isa(imageData,'int16')
    datatype = 'cvip_short';
elseif isa(imageData, 'int32')
    datatype = 'cvip_long';
elseif isa(imageData, 'single')
    datatype = 'cvip_float';
else
    datatype = 'cvip_double';
end
%default color based on number of bands
if size(imageData,1)
    default_color = 'gray_scale';
else
    default_color = 'rgb';
end
    
default_imageArgs = [{'tif',default_color,'none','le'} datatype];

%set up the default parameters
if nargin == 1              
    imageArgs = default_imageArgs;
    fileName = 'test.vipm';        
    history = [];
elseif nargin == 2               
    imageArgs = default_imageArgs; 
    history = [];
elseif nargin == 3 || nargin == 4
    if length(imageArgs) ~= 5    %check all elements in imageArguments
        imageArgs = [imageArgs default_imageArgs(length(imageArgs)+1:end)];
    end
    if nargin == 3
        history = [];
    end
end

%add vip2 to filename
if ~strcmp(fileName(end-4:end),'.vipm')
    fileName = [fileName '.vipm'];
end

%create VIP image structure
vipImage = create_vip_image();
 
%set fields of VIP image
vipImage.filename = fileName;
vipImage.byte_order = char(imageArgs(4));               %Byte Ordering
vipImage.vip_version = 'vipm';                          %vip version
vipImage.file_mod_date = now;                      %File modification date
vipImage.cmpr_format = set_cmpr_Type(imageArgs(3));     %compression type
vipImage.image_format = set_imageFormat(imageArgs(1));  %image format
vipImage.color_format = set_colorFormat(imageArgs(2));  %Colorspace format
vipImage.cvip_type = set_cvipDataType(imageArgs(5));    %Data type
if size(imageArgs,2) < 6                                %size from file
    vipImage.no_of_bands = size(imageData,3);           % #rows
    vipImage.no_of_cols = size(imageData, 2);           % #cols
    vipImage.no_of_rows = size(imageData, 1);           % #bands
else                                                    % size from user
    vipImage.no_of_bands = imageArgs{6};                % #rows
    vipImage.no_of_cols = imageArgs{7};                 % #cols
    vipImage.no_of_rows = imageArgs{8};                 % #bands
end
if isreal(imageData)                                    %Image Data format
    vipImage.data_format= set_cvipDataFormat('real'); 
else
    vipImage.data_format= set_cvipDataFormat('complex'); 
end

%-----------Open file to write VIP image data in file---------------------
if strcmp(vipImage.byte_order,'be')             %Big-endian ordering
    fileID = fopen(vipImage.filename,'w','b');
elseif strcmp(vipImage.byte_order,'le')         %Little-endian  ordering
    fileID = fopen(vipImage.filename,'w','l');
end
%check if file is opened to write
if fileID == -1
    error('Cannot open the file!')
end

%----------------------write VIP image data in file-----------------------
%write Byte Order (type- char, size - 2 bytes)
fwrite(fileID,vipImage.byte_order,'char','l'); %first two bytes always in 
                                               %little endian ordering

%write Version   (type- char, size - 4 bytes)     
fwrite(fileID,vipImage.vip_version,'char');

%write Latest file modification date  (type- double, size - 8 bytes)     
fwrite(fileID,vipImage.file_mod_date,'double');

%write cmpr_formation type  (type- uint8, size - 1 byte)     
fwrite(fileID,vipImage.cmpr_format,'uint8');

%write Image Format  (type- uint8, size - 1 byte)     
fwrite(fileID,vipImage.image_format,'uint8');

%write Color Format (type- uint8, size - 1 byte)     
fwrite(fileID,vipImage.color_format,'uint8');

%write CVIP Data type (type- uint8, size - 1 byte)     
fwrite(fileID,vipImage.cvip_type,'uint8');

%write #Bands (type- uint8, size - 1 byte)     
fwrite(fileID,vipImage.no_of_bands,'uint8');

%write #Cols (type- uint16, size - 2 bytes)     
fwrite(fileID,vipImage.no_of_cols,'uint16');

%write #Rows (type- uint16, size - 2 bytes)     
fwrite(fileID,vipImage.no_of_rows,'uint16');

%write Image Data Format (type- uint8, size - 1 byte)     
fwrite(fileID,vipImage.data_format,'uint8');

%write History Information
if isempty(history)
    trans = 0;
    vipImage.history_info = 'none';
    %create random sized empty memory space (between 5-15 bytes) before
    %write History Information (type- uint8, size - 1 byte) 
    fwrite(fileID,0,'uint8');
    %writing the image data 
    fwrite(fileID,zeros(randi(10)+5,1),'uint8');
else
    trans = history(:,1);       %last transform info
    vipImage.history_info = [1;0;0];
    histbytes = history(:);
    vipImage.history_info(2) = size(histbytes,1);
    %----this feature is not available now------
    %first two bytes will give the size of the History
    %write History Information (type- uint8, size - 1 byte) 
    fwrite(fileID,vipImage.history_info(1),'uint8');
    %write History Information (size- uint16, size - 2 byte) 
    fwrite(fileID,vipImage.history_info(2),'uint16');

    %create random sized empty memory space (between 5-15 bytes) before
    %writing the image data 
    fwrite(fileID,zeros(randi(10)+5,1),'uint8');

    %write history pointer offset   (type- uint32, size - 4 bytes)
    histo_pixdata_offset = ftell(fileID);
    vipImage.history_info(3) = histo_pixdata_offset;
    fseek(fileID,27,'bof');
    fwrite(fileID,histo_pixdata_offset,'uint32');

    %write history information, if available, (type- , size- variable bytes)
    fseek(fileID,histo_pixdata_offset,'bof');
    fwrite(fileID,histbytes,'uint16');          %history information
end

%write real Image Data pointer offset   (type- uint32, size - 4 bytes)
vipImage.real_pixdata_offset = ftell(fileID);
fseek(fileID,31,'bof');
fwrite(fileID,vipImage.real_pixdata_offset,'uint32');

%write real Image data or real part of complex Image data  
%  (type- defined by cvip_type byte) 
%convert 2D or 3D pixel data into 1D vector
if vipImage.data_format == 0    %real image only
    pixelVectr = imageData(:);
elseif vipImage.data_format == 1  %complex image
    pixvals = real(imageData); 
    pixelVectr = pixvals(:);
end

fseek(fileID,vipImage.real_pixdata_offset,'bof');
if vipImage.cmpr_format ~= 0 && sum(trans > 210 & trans < 219) == 0
    %for compressed data store its size at first - 4 Bytes
    fwrite(fileID,size(pixelVectr,1),'uint32');
end
switch vipImage.cvip_type
    case 0             %'cvip_byte'
        fwrite(fileID,pixelVectr,'uint8');
    case 1             %'cvip_short'
        fwrite(fileID,pixelVectr,'short');
    case 2             %'cvip_long'
        fwrite(fileID,pixelVectr,'long');
    case 3             %'cvip_float'
        fwrite(fileID,pixelVectr,'float');
    case 4             %'cvip_double'
        fwrite(fileID,pixelVectr,'double');
end

%write Imaginary part of complex Image Data, if available
%   First, If imaginary part is available, create random size empty memory 
%   (between 5-15 bytes) before writing imaginary part of image data space 
if vipImage.data_format == 1  
    fwrite(fileID,zeros(randi(10)+5,1),'uint8');
    vipImage.imag_pixdata_offset = ftell(fileID);
    pixvals = imag(imageData);
    pixelVectr = pixvals(:);
    switch vipImage.cvip_type
        case 0             %'cvip_byte'
            fwrite(fileID,pixelVectr,'uint8');
        case 1             %'cvip_short'
            fwrite(fileID,pixelVectr,'short');
        case 2             %'cvip_long'
            fwrite(fileID,pixelVectr,'long');
        case 3             %'cvip_float'
            fwrite(fileID,pixelVectr,'float');
        case 4             %'cvip_double'
            fwrite(fileID,pixelVectr,'double');
    end
    %write Imaginary-Image Data pointer offset   
    %      (type- uint32, size - 4 bytes)   
    fseek(fileID,35,'bof');
    fwrite(fileID,vipImage.imag_pixdata_offset,'uint32');
end


opFlag = 1;  %successful written
vipmInfo = vipImage;  %VIPM file info
fseek(fileID,0,'eof');
vipmInfo.file_size = ftell(fileID);  %total file size in bytes

fclose(fileID); %close the file

end %end of vip2_write function

%--------------------------------------------------------------------------
%Function to create vipImage
%--------------------------------------------------------------------------
function vipImage = create_vip_image()
    field1 = 'filename';                   value1 = [];
    field2 = 'vip_version';                value2 = [];   
    field3 = 'file_mod_date';              value3 = [];
    field4 = 'image_format';               value4 = [];
    field5 = 'color_format';               value5 = [];
    field6 = 'cvip_type';                  value6 = [];
    field7 = 'no_of_bands';                value7 = [];
    field8 = 'no_of_cols';                 value8 = [];
    field9 = 'no_of_rows';                 value9 = [];
    field10 = 'byte_order';                value10 = [];
    field11 = 'data_format';               value11 = [];
    field12 = 'cmpr_format';               value12 = [];
    field13 = 'history_info';              value13 = [];
    field14 = 'real_pixdata_offset';       value14 = []; 
    field15 = 'imag_pixdata_offset';       value15 = [];  
         
    vipImage = struct(field1,value1,field2,value2,field3,value3,...
    field4,value4,field5,value5,field6,value6,field7,value7,field8,value8,...
    field9,value9,field10,value10,field11,value11,field12,value12,field13,...
    value13,field14,value14,field15,value15);
end

%--------------------------------------------------------------------------
%Function to set image format
%--------------------------------------------------------------------------
function imageFormatID = set_imageFormat(imageTypeName)
    
    key_names  = {'pbm', 'pgm', 'ppm', 'eps', 'tif', 'gif',...
            'ras', 'itx','iris', 'ccc', 'bin', 'vip', 'glr', 'btc','mbtc'...
            'brc','brlc', 'huf', 'zvl','arith','btc2', 'btc3', 'dpc', 'zon', ...
            'zon2', 'safvr', 'jpeg', 'wvq', 'fra', 'vq','xvq', 'trcm', ....
            'ps', 'bmp', 'jp2', 'png', 'jpg','K-means','K-means_plus'};
    value_names = 0:38;
    mapObj = containers.Map(key_names,value_names);  %map values to unqiue keys
    imageFormatID = mapObj(char(imageTypeName));
end

%--------------------------------------------------------------------------
%Function to set color format
%--------------------------------------------------------------------------
function colorFormatID = set_colorFormat(colorSpaceName)
    
    key_names = {'binary', 'gray_scale', 'rgb', 'hsl', 'hsv',...
            'sct', 'cct', 'luv', 'lab', 'xyz'};
    value_names = 0:9;
    mapObj = containers.Map(key_names,value_names);  %map values to unqiue keys
    colorFormatID = mapObj(char(colorSpaceName));    
end

%--------------------------------------------------------------------------
%Function to set data type of CVIP image
%--------------------------------------------------------------------------
function cvipDataTypeID = set_cvipDataType(dataTypeName)   
    key_names = {'cvip_byte', 'cvip_short', 'cvip_long', ...
        'cvip_float', 'cvip_double'};  %float = 4 bytes
    value_names = 0:4;
    mapObj = containers.Map(key_names,value_names);  %map values to unqiue keys
    cvipDataTypeID = mapObj(char(dataTypeName));    
end

%--------------------------------------------------------------------------
%Function to set data format of CVIP image
%--------------------------------------------------------------------------
function cvipDataFormatID = set_cvipDataFormat(dataFormatName)   
    if strcmp(char(dataFormatName), 'real')
       cvipDataFormatID = 0;
    elseif strcmp(char(dataFormatName), 'complex')
        cvipDataFormatID = 1;
    end
end

%--------------------------------------------------------------------------
%Function to set cmpr_formation type
%--------------------------------------------------------------------------
function cmpr_TypeID = set_cmpr_Type(typeName) 
    key_names = {'none','btc','mbtc', 'btc2', 'brlc','btc3', 'dpc', 'zvl', 'glr', 'brc',...
        'huf', 'zon', 'zon2', 'jpg', 'wvq', 'fra', 'vq', 'xvq', 'trcm',...
        'top', 'jp2','K-means','K-means_plus'}; 
    value_names = 0:22;
    mapObj = containers.Map(key_names,value_names);  %map values to unqiue keys
    cmpr_TypeID = mapObj(char(typeName));
end
