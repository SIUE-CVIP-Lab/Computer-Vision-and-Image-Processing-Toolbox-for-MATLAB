function [outputImage] = mBTCdeco_cvip(fData)
% mBTC_DeCompress_CVIP - A multi-level block truncation coding decompression algorithm.
%
% Syntax :
% -------
% outputImage = mBTC_DeCompress_CVIP(fileName)
%   
% Input Parameters include:
% -------------------------
% fData - compressed image array.                  
%
% Output Parameters include :  
% --------------------------- 
% outputImage - Decompressed Image.
% 
% Example :
% -------
%   outputImage = mBTC_DeCompress_CVIP(fData)
%   imshow(outputImage)
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Charles Stacey
%           Initial coding date:    5/26/2020
%           Latest update date:     6/1/2020
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2020 Scott Umbaugh and SIUE
%
%==========================================================================

%Open compressed file.
% inputFile = fopen(fData, "r");
% 
% %Place contents of file into array
% fID = fopen(fData, 'r');
% fileInfo = dir(fData);
% fData = fread(fID, fileInfo.bytes, 'uint8'); %Array of bytes from compressed file.
% fclose(inputFile); %Close file

%Read Header Data:
%Check if the compressed file is a multilevel BTC file.
 if(fData(1) ~= 'm' || fData(2) ~= 'b' || fData(3) ~= 't' || fData(4) ~= 'c')
     fprintf("File has incorrect format");
     return;
 end
 band = double(fData(5)); %Number of bands in original image.
 row = typecast(uint8(fData([6 7])), 'uint16'); %Row size of original image.
 col = typecast(uint8(fData([8 9])), 'uint16'); %Col size of original image.
 block = double(fData(10)); %Block size used for compression.
 level = double(fData(11)); %Number of grey levels used for compression per block.
 
% band = double(fData(4));        %getting bands
% row1 = fData(5);                %getting high cols byte
% row2 = fData(6);                %getting low cols byte 
% col1 = fData(7);                %getting high rows byte
% col2 = fData(8);                %low rows byte  
% band = double(fData(4));        %getting bands
% block = double(fData(9));      %block size 
% level = fData(10);
% %put cols bytes together
% row = bin2dec([dec2bin(row1,8) dec2bin(row2,8)]);
% %put rows bytes together
% col = bin2dec([dec2bin(col1,8) dec2bin(col2,8)]);
 
 outputImage = uint8(zeros(row,col,band)); %Empty image created with original parameters
 row = row - mod(row,block); %Determine row count without extra edge pixels.
 col = col - mod(col,block); %Determine col count without extra edge pixels.
 index = double(12); %First Byte after header data.
 %Loop through bands.
 for b = 1:band
   %Loop Through Blocks
    for rB = 1:row/block
       for cB = 1:col/block
           levelArr = zeros(level,1); %Holds possible pixel gray values for block.
           %Get values from fData.
           for i = 1:level
               levelArr(i,1) = uint8(fData(index + i - 1));
           end
           index = index + level; %Move to pixel bytes.
           blockArray = uint8(zeros(block*(block/4),1)); %Holds data from compressed pixels in block.
           %Get values from file array.
           for i = index:(index + block*(block/4) - 1)
               blockArray((i-index)+1,1) = uint8(fData(i));
           end
           index = index + (block*(block/4)); %Move to next level bytes.
           buff = 1; %Used to determine current blockArray byte.
           levNum = zeros(4,1); %Holds level indexes from current blockArray byte.
           num = 1; %Used to determine when the full byte has been read.
           %Loop through inside of block.
           for j = ((rB-1)*block + 1):(rB*block)
               for k = ((cB-1)*block + 1):(cB*block)
                   %Enter this if a new byte is being read.
                   if(mod(k,4) == 1)
                       %Get the four two-bit indexes for the current four
                       %pixels. Determines level chosen for pixel.
                       levNum(1,1) = bitget(blockArray(buff,1),7) + 2*bitget(blockArray(buff,1),8);
                       levNum(2,1) = bitget(blockArray(buff,1),5) + 2*bitget(blockArray(buff,1),6);
                       levNum(3,1) = bitget(blockArray(buff,1),3) + 2*bitget(blockArray(buff,1),4);
                       levNum(4,1) = bitget(blockArray(buff,1),1) + 2*bitget(blockArray(buff,1),2);
                   end
                   %Change pixel to correct level.
                   outputImage(j,k,b) = levelArr(levNum(num) + 1,1);
                   %Increment num for each two bits in a byte.
                   num = num + 1;
                   %If num counts past four, load new byte.
                   if(num > 4)
                       num = 1;
                       buff = buff + 1;
                   end
               end
           end
       end
    end
 end
end
