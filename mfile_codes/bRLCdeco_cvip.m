function [outputImage] = bRLCdeco_cvip(fData)
% bRLCdeco_cvip - A bitplane run-length coding decompression algorithm.
%
% Syntax :
% -------
% outputImage = bRLC_DeCompress_CVIP(fileName)
%   
% Input Parameters include:
% -------------------------
% fData - Array of compressed image.
%
% Output Parameters include :  
% --------------------------- 
% outputImage - Decompressed image.
%
% Example :
% -------
%   outputImage = bRLCdeco_cvip(fData)
%   imshow(outputImage)
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

% %Open compressed file
% inputFile = fopen(fileName, "r");
% 
% %Place contents of file into array.
% fID = fopen(fileName, 'r');
% fileInfo = dir(fileName);
% fData = fread(fID, fileInfo.bytes, 'uint8'); %Array used to store each byte from the file.

%Write Header Data:
%Check if the file is a bitplane run-length coding file.
if(fData(1) ~= 'b' || fData(2) ~= 'r' || fData(3) ~= 'c')
 fprintf("File has incorrect format");
 return;
end
band = double(fData(4));
row = typecast(uint8(fData([5 6])), 'uint16'); %Number of rows in original image.
col = typecast(uint8(fData([7 8])), 'uint16'); %Number of columns in original image.
section = uint8(fData(9)); %Determines bits that were saved in each byte.
outputImage = uint8(zeros(row,col,band)); %Empty image created. Used for output.
index = 10; %First non-header byte from file.

%Loop through bits.
for bit = 1:8
    %Check if the current bit was used for compression.
    if(bitget(section,bit) == 0)
        continue;
    end
    %Loop through bands.
    for b = 1:band
    r = 1; %Current row.
    c = 0; %Current column.
    currentPixel = 1; %Used to determine current bit value.
    %Loop through all pixels.
    while(true)
        currentNumber = uint8(fData(index)); %Current pixel's bit value.
        prevNumber = uint8(fData(index-1)); %Previous pixel's bit value.
        num = uint8(currentNumber); %Uint8 of current pixel's bit value.
        prevNum = uint8(prevNumber); %Uint8 of previous pixel's bit value.
        %If the first value in a row is 0, start pixels with 0's.
        if((c == 0 && num == 0))
            currentPixel = 0;
        %Checks if a max byte situation occurred. (count reached 255 during compression).
        elseif(c ~= 0 && prevNum == 255 && index ~= 11)
        %Inverse current pixel value.   
        else
            currentPixel = ~currentPixel;
        end
        %Loop used to fill in a 'num' sized sequence of pixels with the same value.
        for same = 1:num
            c = c + 1;
            if(currentPixel == 1)
                outputImage(r,c,b) = outputImage(r,c,b) + (2^(bit-1));
            end
        end
        index = index + 1;
        %Checks if it is the end of the column
        if(c >= col)
            r = r + 1;
            c = 0;
            currentPixel = 1;
            %Checks if it is the end of the last row.
            if(r > row)
                break;
            end
        end
    end
    end
end
%Close file.
%fclose(inputFile);
end

