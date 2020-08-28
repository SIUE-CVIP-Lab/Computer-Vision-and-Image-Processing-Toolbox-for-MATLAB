function [fData] = bRLCenco_cvip(originalImage,Section)
% bRLC_Compress_CVIP - A bitplane run-length coding compression algorithm.
%
% Syntax :
% -------
% bRLC_Compress_CVIP(fileName,originalImage,Section)
%   
% Input Parameters include:
% -------------------------
% fileName - Location of compressed output file.
% originalImage - Image being compressed.
% Section - Used to determine what bits are saved.
%   bits     8    7    6    5    4   3   2   1
%   value   128   64   32   16   8   4   2   1 
%   keep?    1    1    0    0    0   1   1   0 (1 = Yes, 0 = No)
%   Section = (128 + 64 + 4 + 2) = 198. Bits 8,7,3,2 will be kept in compression. 
%
% Output Parameters include :  
% --------------------------- 
% N/A
% 
% Example :
% -------
%   inputImage = imread('butterfly.tif')
%   fileName = "C\FileLocation\CompressedFile.txt"
%   bRLC_Compress_CVIP(fileName, inputImage, 198)
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Charles Stacey
%           Initial coding date:    5/12/2020
%           Latest update date:     5/14/2020
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2020 Scott Umbaugh and SIUE
%
%==========================================================================

%Open Output File for Write Access
%outputFile = fopen(fData, "w");

%Get Image Data
[row,col,band] = size(originalImage);

%Write Header Data:
fData = ('brc')';
s = dec2bin(row,16);
row1 = bin2dec(s(9:16));       %low rows byte
row2 = bin2dec(s(1:8));        %high rows byte
d = dec2bin(col,16);
col1 = bin2dec(d(9:16));       %low cols byte
col2 = bin2dec(d(1:8));        %high cols byte
fData(end+1:end+6) = [band;      %bands          
                      row1;      %high rows byte
                      row2;      %low rows byte 
                      col1;      %high cols byte
                      col2;      %low cols byte
                      uint8(Section)];  %Block Size

byteCount = 0;

%Loop Through Each Bit
for bit = 1:8
    %Check if the User Wants to Include This Bit.
    %If not, skip the rest of the loops.
    if(bitget(Section,bit) == 0)
        continue;
    end
    %Loop Through Bands
    for i = 1:band
       %Loop Through Rows
       for j = 1:row
            %k is used to loop through the columns.
            k = 1;
            %Extract the bit value of the number at a specified location
            pixelBit = bitget(originalImage(j,k,i),bit);
            %Write 0 if the row starts with a 1.
            if(pixelBit ~= 0)
                %fwrite(outputFile,0,'uint8');
                fData(end + 1) = uint8(0);
                byteCount = byteCount + 1;
            end
            count = 0;
            currentBit = pixelBit;
            %Loop Through Columns
            while (k <= col)
                %Get individual bit from pixel.
                pixelBit = bitget(originalImage(j,k,i),bit);
                %Loop while the next bit is the same as the previous bit.
                while(pixelBit == currentBit && k <= col)
                    count = count + 1;
                    k = k + 1;
                    %If the end of the column is reached, exit loop.
                    if(k <= col)
                    currentBit = bitget(originalImage(j,k,i),bit);
                    end
                    %If the count gets to 255, the max byte number has been
                    %reached. Print 255. Reset count values.
                    if(count == 255)
                        %fwrite(outputFile,255,'uint8');
                        fData(end + 1) = uint8(255);
                        byteCount = byteCount + 1;
                        count = 0;
                        %Write 0 if the next bit is the same as the
                        %previous bit after the 255th bit. If not, only write 255.
                        if(currentBit ~= pixelBit)
                            %fwrite(outputFile,0,'uint8');
                            fData(end + 1) = uint8(0);
                            byteCount = byteCount + 1;
                        end
                    end
                end
                %Write the number of same bits found in a row.
                if(count ~= 0)
                    %fwrite(outputFile,count,'uint8');
                    fData(end + 1) = uint8(count);
                    byteCount = byteCount + 1;
                    count = 0;
                end
            end 
       end
    end
end
%Close file.
%fclose(outputFile);
end