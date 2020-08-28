function [ imageData, imageFileInfo ] = vipmread2_cvip( filename )
% VIPMREAD2_CVIP - Read image data from the VIPM file.
% The function reads image data from the VIPM (visualization in image 
% processing Matlab) file specified by the filename.The vipm file format 
% is similar to the vip format in CVIPtools,which was created to handle
% any data types and formats. 
%
% Syntax :
% -------   
% [imageData, vipmInfo] = vipmread2_cvip(filename)
%   
% Input Parameters include :
% ------------------------
%   
% 'filename'      Character vector specifying the name of a VIPM file.
%
%
% Output Parameter include :  
% ------------------------
% 'imageData'     Image array (real or complex format). The image can be
%                   of uint8, int16, int32, single or double class.
% 'vipmInfo'      Information of the VIPM image file. 
%                                           
% Example :
% -------
%                   I = vipmread_cvip2('test.vipm');    %test.vipm must be 
%                                                       %stored in your disk
%                   [I, Info] = vipmread2_cvip('test.vipm');%also VIPM
%                   disp(Info);                         %file info
%
%  See also, vipmwrite2_cvip, vipmwrite_cvip, vipmread_cvip,
%  historydeco_cvip, historyupdate_cvip, btcdeco_cvip, btcenco_cvip.
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    4/10/2017
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     12/10/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================


% Revision History
%
 % Revision 1.3  12/10/2018  17:10:10  jucuell
 % including case to select which BTC decode function use according to the
 % magic number btc -> btcdeco, btd - btcdecol n bte -> btcdvec.
%
 % Revision 1.2  10/10/2018  16:12:05  jucuell
 % function is saving information about transforms information such as the
 % FFT by using the trans vble and the info in the history.
%
 % Revision 1.1  10/04/2018  13:10:40  jucuell
 % Initial revision: Copying from original file and start adding
 % modifications to save history and BTC compress data
%

%--------------------------------------------------------------------------
%create VIP image structure
vipImage = create_vip_image();
vipImage.filename = filename;  

%--------------------------------------------------------------------------
%open the vipm file in reading mode
fileID = fopen(filename,'r');
if fileID == -1
    error('The file does not exist!')
end

%find the byte ordering of VIP file
vipImage.byte_order = (fread(fileID,2,'*char'))';
fclose(fileID);

%--------------------------------------------------------------------------
%open file again with specific Byte Ordering
if strcmp(vipImage.byte_order,'be')
    fileID = fopen(filename,'r','b');
elseif strcmp(vipImage.byte_order,'le')
    fileID = fopen(filename,'r','l');
end

%--------------------------------------------------------------------------
%jump to 3rd byte to read VIP version
fseek(fileID,2,'bof');

%check if input image is VIP image or not
vipImage.vip_version = (fread(fileID,4,'*char'))';
if ~strcmp(vipImage.vip_version,'vipm')
    error('Image file is not VIPM file!')
end

%find the last file modification date 
serialdateNum = fread(fileID,1,'double');
vipImage.file_mod_date = datestr(serialdateNum); 

%Find cmpr_formation in image (next byte)
nextByte= fread(fileID,1,'uint8');
vipImage.cmpr_format = get_cmpr_Type(nextByte);

%Find the image format of VIP image
nextByte = fread(fileID,1,'uint8');
vipImage.image_format = get_imageFormat(nextByte);

%Find the color format of VIP image
nextByte = fread(fileID,1,'uint8');
vipImage.color_format = get_colorFormat(nextByte);

%Find the data type of the VIP image
datatype = fread(fileID,1,'uint8');
vipImage.cvip_type = get_cvipDataType(datatype);

%Find the number of bands of the VIP image
vipImage.no_of_bands = fread(fileID,1,'uint8');

%Find the number of cols of the VIP image
vipImage.no_of_cols = fread(fileID,1,'uint16');

%Find the number of rows of the VIP image
vipImage.no_of_rows = fread(fileID,1,'uint16'); 

%Find the data format (real or complex) of the VIP image
nextByte = fread(fileID,1,'uint8');
vipImage.data_format= get_cvipDataFormat(nextByte);

%Find the byte size of history information of the VIP image
nextByte = fread(fileID,1,'uint8');
if nextByte == 0
    vipImage.history_info = 'none';
    histo_pixdata_offset = 0;
elseif nextByte == 1
    nextByte = fread(fileID,1,'uint16');
    histosize = nextByte;
    nextByte = fread(fileID,1,'uint32');
    histo_pixdata_offset = nextByte;
end

%Find the offset to Image Data (real part) 
fseek(fileID,31,'bof');
vipImage.real_pixdata_offset = fread(fileID,1,'uint32');

%Find the offset to Image Data (Imaginary part, only if complex image) 
fseek(fileID,35,'bof');
vipImage.imag_pixdata_offset = fread(fileID,1,'uint32');

%----------------------------------------------------------------------
%check if the image history is present. If yes, extract the data
if histo_pixdata_offset ~= 0
    fseek(fileID, histo_pixdata_offset,'bof');
    tempData = fread(fileID,histosize,'uint16=>uint16');
    vipImage.history_info = reshape(tempData,histosize/10,10);
end

%----------------------------------------------------------------------
%check if the image data is present. If yes, extract the data
%extract real part of Image Data
if vipImage.real_pixdata_offset  ~= 0
    fseek(fileID, vipImage.real_pixdata_offset,'bof');
    trans = vipImage.history_info(:,1);
    %check if there is compressed data
    if ~strcmp(vipImage.cmpr_format,'none') && sum(trans > 210 & trans < 219) == 0
        %for compressed data read its size at first - 4 Bytes
        totalpels = fread(fileID,1,'uint32');
    else
        totalpels = vipImage.no_of_bands * vipImage.no_of_cols * ...
            vipImage.no_of_rows;    %compute data according to image size
    end
    
    switch datatype
        case 0             %'cvip_byte'
            tempData = fread(fileID,totalpels,'uint8=>uint8');
        case 1             %'cvip_short'
            tempData = fread(fileID,totalpels,'short=>short');
        case 2             %'cvip_long'
            tempData = fread(fileID,totalpels,'long=>long');
        case 3             %'cvip_float'
            tempData = fread(fileID,totalpels,'float=>float');
        case 4             %'cvip_double'
            tempData = fread(fileID,totalpels,'double');
    end
    if ~strcmp(vipImage.cmpr_format,'none') && sum(trans > 210 & trans < 219) == 0
        realImage = tempData;
        vipImage.cmpr = realImage;
    else
        realImage= reshape(tempData,[vipImage.no_of_rows ...
            vipImage.no_of_cols vipImage.no_of_bands]);
    end
else
    vipImage.real_pixdata_offset = [];
    realImage = [];
end

%extract the imaginary part of Image Data (Only for complex image)
if strcmp(vipImage.data_format,'complex') && vipImage.imag_pixdata_offset  ~= 0
    fseek(fileID,vipImage.imag_pixdata_offset,'bof');
    switch datatype
        case 0             %'cvip_byte'
            tempData = fread(fileID,totalpels,'uint8=>uint8');
        case 1             %'cvip_short'
            tempData = fread(fileID,totalpels,'short=>short');
        case 2             %'cvip_long'
            tempData = fread(fileID,totalpels,'long=>long');
        case 3             %'cvip_float'
            tempData = fread(fileID,totalpels,'float=>float');
        case 4             %'cvip_double'
            tempData = fread(fileID,totalpels,'double');
    end
    imagImage = reshape(tempData,[vipImage.no_of_rows vipImage.no_of_cols ...
        vipImage.no_of_bands]);
    
    %combine real part and imaginary part to form complex image data
    imageData = complex(realImage,imagImage);
else  %real Image is only available
    imageData = realImage;
    vipImage.imag_pixdata_offset = [];
end
%--------------------------------------------------------------------------
%Currently,saving history is not fully developed.....thus not included here
%user can write history encoder and decoder functions and store them in
%files.
%Now, history will be returned as array of bytes (uint8)
%--------------------------------------------------------------------------
%check if need to apply a decompression algorithm
 if strcmp(vipImage.cmpr_format,'btc') && sum(trans > 210 & trans < 219) == 0
    switch imageData(3)
        case 147
            imageData = btcdeco_cvip(imageData,1);      %call btc decoder
        case 148
            imageData = btcdecol_cvip(imageData);      %call btc decoder
        case 149
            imageData = btcdvec_cvip(imageData);      %call btc decoder
    end
 else
%  if strcmp(vipImage.cmpr_format,'k-mean') && sum(trans > 210 & trans < 219) == 0
%       imageData
         
    %call another decompressor
end
%vip image file info
imageFileInfo = vipImage;
fseek(fileID,0,'eof');
imageFileInfo.file_size = ftell(fileID);

%close the file
fclose(fileID);

end %end of vipmread_cvip function
%__________________________________________________________________________

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
%__________________________________________________________________________


%--------------------------------------------------------------------------
%Function to get compression type
%--------------------------------------------------------------------------
function cmpr_Type = get_cmpr_Type(typeID)     
    key_names = 0:22;
    value_names = {'none','btc','mbtc', 'btc2', 'brlc','btc3', 'dpc', 'zvl', 'glr', 'brc',...
        'huf', 'zon', 'zon2', 'jpg', 'wvq', 'fra', 'vq', 'xvq', 'trcm',...
        'top', 'jp2','K-means','K-means_plus'}; 
    mapObj = containers.Map(key_names,value_names);  %map values to unqiue keys
    cmpr_Type = mapObj(typeID);
end
%__________________________________________________________________________


%--------------------------------------------------------------------------
%Function to get image format
%--------------------------------------------------------------------------
function imageFormat = get_imageFormat(imageID)
    key_names = 0:38;
    value_names  =  {'pbm', 'pgm', 'ppm', 'eps', 'tif', 'gif',...
            'ras', 'itx','iris', 'ccc', 'bin', 'vip', 'glr', 'btc','mbtc'...
            'brc','brlc', 'huf', 'zvl','arith','btc2', 'btc3', 'dpc', 'zon', ...
            'zon2', 'safvr', 'jpeg', 'wvq', 'fra', 'vq','xvq', 'trcm', ....
            'ps', 'bmp', 'jp2', 'png', 'jpg','K-means','K-means_plus'};
    mapObj = containers.Map(key_names,value_names);  %map values to unqiue keys
    imageFormat = mapObj(imageID);
end
%__________________________________________________________________________


%--------------------------------------------------------------------------
%Function to get color format
%--------------------------------------------------------------------------
function colorFormat = get_colorFormat(colorID)
    key_names = 0:9;
    value_names = {'binary', 'gray_scale', 'rgb', 'hsl', 'hsv',...
            'sct', 'cct', 'luv', 'lab', 'xyz'};
    mapObj = containers.Map(key_names,value_names);  %map values to unqiue keys
    colorFormat = mapObj(colorID);    
end
%__________________________________________________________________________


%--------------------------------------------------------------------------
%Function to get data type of CVIP image
%--------------------------------------------------------------------------
function cvipDataType = get_cvipDataType(datatypeID)
    key_names = 0:4;
    value_names = {'cvip_byte', 'cvip_short', 'cvip_long', ...
        'cvip_float', 'cvip_double'};  %float = 4 bytes
    mapObj = containers.Map(key_names,value_names);  %map values to unqiue keys
    cvipDataType = mapObj(datatypeID);    
end
%__________________________________________________________________________


%--------------------------------------------------------------------------
%Function to get data format of CVIP image
%--------------------------------------------------------------------------
function cvipDataFormat = get_cvipDataFormat(dataFormatID)   
if dataFormatID == 0
   cvipDataFormat = 'real';
elseif dataFormatID == 1
    cvipDataFormat = 'complex';
end
end
%__________________________________________________________________________

    
