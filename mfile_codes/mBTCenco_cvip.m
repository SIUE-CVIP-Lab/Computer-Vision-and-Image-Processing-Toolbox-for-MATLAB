function [fData] = mBTCenco_cvip(originalImage,Block,Level)
% mBTCenco_cvip - A multi-level block truncation coding compression algorithm
% with four different level selecitons.
%
% Syntax :
% -------
% mBTC_Compress_CVIP(fileName,originalImage,Block,Level);
%   
% Input Parameters include:
% -------------------------
% originalImage - Image being compressed.
% Block - Size of a block (Block*Block area).                 
% Level - Number of pixel values allowed after compression per block.
%                   
% Output Parameters include :  
% --------------------------- 
% fData - Array of compressed data.
% 
% Example :
% -------
%   inputImage = imread('butterfly.tif')
%   fileName = "C\FileLocation\CompressedFile.txt"
%   mBTCenco_cvip(fileName, inputImage, 8, 4)
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

%Check if the Block size is a multiple of four.
if(mod(Block,4) ~= 0)
    disp('Block size must be a multiple of four.');
    disp('Function Not Performed!');
    return;
end

%Open Output File for Write Access
%outputFile = fopen(fileName, "w");


%Get Image Size
[row,col,band] = size(originalImage);

%Write Header Data:
fData = ('mbtc')';
s = dec2bin(row,16);
row1 = bin2dec(s(9:16));       %low rows byte
row2 = bin2dec(s(1:8));        %high rows byte
d = dec2bin(col,16);
col1 = bin2dec(d(9:16));       %low cols byte
col2 = bin2dec(d(1:8));        %high cols byte
fData(end+1:end+7) = [band;   %bands          
                      row1;   %high cols byte
                      row2;   %low cols byte 
                      col1;   %high rows byte
                      col2;   %low rows byte
                      Block;  %Block Size
                      Level]; %Level size  

%Used to eliminate extra pixels outside block boudaries. These
%are pixels right and bottom image edges.
row = row - mod(row,Block);
col = col - mod(col,Block);

byteCount = 0;

%Loop Through Bands.
for b = 1:band
   %Loop Through Blocks.
    for rB = 1:row/Block
       for cB = 1:col/Block
           min = 255; %Lowest pixel value in the block.
           max = 0;   %Highest pixel value in the block.
           hist = zeros(256,1); %Place to store histogram data.
           %Loop through each pixel inside the block.
           for j = ((rB-1)*Block + 1):(rB*Block)
               for k = ((cB-1)*Block + 1):(cB*Block)
                   %Fill Histogram.
                   hist(originalImage(j,k,b)+1,1) =  hist(originalImage(j,k,b)+1,1) + 1;
                   %Determine max pixel.
                   if(originalImage(j,k,b) > max)
                       max = originalImage(j,k,b);
                   end
                   %Determine min pixel
                   if(originalImage(j,k,b) < min)
                       min = originalImage(j,k,b);
                   end
               end
           end
           %Chose Level Value
           switch(Level)
               %One possible gray value for block.
               case 1
                   level = calculateLevel1(uint16(min),uint16(max));
               %Two possible gray values for block.
               case 2
                   level = calculateLevel2(hist,uint16(min),uint16(max));
               %Three possible gray values for block.
               case 3
                   level = calculateLevel3(hist,uint16(min),uint16(max));
               %Four possible gray values for block.
               case 4
                   level = calculateLevel4(hist,uint16(min),uint16(max));
               %Exit function if no level is selected
               otherwise
                   disp('No Level Selected.');
                   disp('Function Not Performed!');
                   return;
           end
           %Write Level Values to File:
            for i = 1:Level
                %fwrite(outputFile, level(i,1), 'uint8');
                fData(end + 1) = level(i,1); 
                byteCount = byteCount + 1;
            end
            buffer = uint8(0); %Holds four pixel level index values.
            bitnum = 0; %Keeps track of how full buffer is.
            %Loop through pixels inside block.
            for j = ((rB-1)*Block + 1):(rB*Block)
               for k = ((cB-1)*Block + 1):(cB*Block)
                   %Get Index For Smallest Difference
                   minDiff = abs(originalImage(j,k,b)-level(1,1));
                   levNum = 1; %Variable for index of smallest difference.
                   for levIndex = 2:Level
                       diff = abs(originalImage(j,k,b)-level(levIndex,1));
                       if(diff<minDiff)
                           minDiff = diff;
                           levNum = levIndex;
                       end
                   end

                   %Change Buffer Byte
                   buffer = buffer + (levNum - 1); %Add new index value to end of byte.
                   bitnum = bitnum + 2; %Increase byte fill count.
                   %Write byte to file when full.
                   if(bitnum == 8)
                       %fwrite(outputFile, buffer, 'uint8');
                       fData(end + 1) = buffer;
                       byteCount = byteCount + 1;
                       buffer = 0;
                       bitnum = 0;
                   else
                       buffer = bitshift(buffer,2); %Shift byte for next two bits.
                   end
               end
            end
       end
    end
end
%Close output file.
% fclose(outputFile);
end

%Gets four possible pixel values for the output block.
function [level] = calculateLevel4(hist,min,max)
    level = zeros(4,1); %Holds possible pixel values.
    thresh = uint16(zeros(3,3)); %Used to measure histogram ranges
    thresh(2,1) = (min+max)/2; 
    thresh(1,1) = (thresh(2,1)+min)/2;
    thresh(3,1) = (max+thresh(2,1))/2;

    %Checks if pixel value is in the histogram.
    if(hist(thresh(1,1)+1) == 0)
       thresh(1,2) = thresh(1,1);
       thresh(1,3) = thresh(1,1);
       thresh(1,1) = 0;
       %Counts down until the pixel is in the histogram.
       if(thresh(1,2) > 0)
            thresh(1,2) = thresh(1,2) - 1;
            while(hist(thresh(1,2)+1) == 0 && thresh(1,2) > min)
                thresh(1,2) = thresh(1,2) - 1;
            end
       end
       %Counts up until the pixel is in the histogram.
       if(thresh(1,3) < 255)
           thresh(1,3) = thresh(1,3) + 1;
           while(hist(thresh(1,3)+1) == 0 && thresh(1,3) < max)
               thresh(1,3) = thresh(1,3) + 1;
           end
       end
       %Recalculate remaining sections.
       thresh(2,1) = ((max - thresh(1,3))/3)+thresh(1,3);
       thresh(3,1) = ((max - thresh(1,3))*2/3)+thresh(1,3 );
    end
    %Checks if pixel value is in the histogram.
    if(hist(thresh(2,1)+1) == 0)
       thresh(2,2) = thresh(2,1);
       thresh(2,3) = thresh(2,1);
       thresh(2,1) = 0;
       %Counts down until the pixel is in the histogram.
       if(thresh(2,2) > 0)
            thresh(2,2) = thresh(2,2) - 1;
            while(hist(thresh(2,2)+1) == 0 && thresh(2,2) > min)
            thresh(2,2) = thresh(2,2) - 1;
            end
       end
       %Counts up until the pixel is in the histogram.
       if(thresh(2,3) < 255)
           thresh(2,3) = thresh(2,3) + 1;
           while(hist(thresh(2,3)+1) == 0 && thresh(2,3) < max)
               thresh(2,3) = thresh(2,3) + 1;
           end
       end
       %Recalculate remaining section.
       thresh(3,1) = (max + thresh(2,3))/2;
    end
    %Checks if pixel value is in the histogram.
    if(hist(thresh(3,1)+1) == 0)
       thresh(3,2) = thresh(3,1);
       thresh(3,3) = thresh(3,1);
       thresh(3,1) = 0;
       %Counts down until the pixel is in the histogram.
       if(thresh(3,2) > 0)
            thresh(3,2) = thresh(3,2) - 1;
            while(hist(thresh(3,2)+1) == 0 && thresh(3,3) > min)
                thresh(3,2) = thresh(3,2) - 1;
            end
       end
       %Counts up until the pixel is in the histogram.
       if(thresh(3,3) < 255)
           thresh(3,3) = thresh(3,3) + 1;
           while(hist(thresh(3,3)+1) == 0 && thresh(3,3) < max)
               thresh(3,3) = thresh(3,3) + 1;
           end
       end
    end
    %If initial pixel was in histogram, save values without counting.
    for i = 1:3
        if(thresh(i,1) ~= 0)
            thresh(i,2) = thresh(i,1);
            thresh(i,3) = thresh(i,1);
        end
    end
    %Calculate level values.
    level(1,1) = (min + thresh(1,2))/2;
    level(2,1) = (thresh(1,3)+thresh(2,2))/2;
    level(3,1) = (thresh(2,3)+thresh(3,2))/2;
    level(4,1) = (max + thresh(3,3))/2;
end

%Gets three possible pixel values for the output block.
function [level] = calculateLevel3(hist,min,max)
    level = zeros(3,1);
    thresh = uint16(zeros(2,3));
    thresh(1,1) = min + ((max-min)/3);
    thresh(2,1) = thresh(1,1) + ((max-min)/3);
    %Checks if pixel value is in the histogram.
    if(hist(thresh(1,1)+1) == 0)
       thresh(1,2) = thresh(1,1);
       thresh(1,3) = thresh(1,1);
       thresh(1,1) = 0;
       %Counts down until the pixel is in the histogram.
       if(thresh(1,2) > 0)
           thresh(1,2) = thresh(1,2) - 1;
           while(hist(thresh(1,2)+1) == 0 && thresh(1,2) > min)
               thresh(1,2) = thresh(1,2) - 1;
           end
       end
       %Counts up until the pixel is in the histogram.
       if(thresh(1,3) < 255)
           thresh(1,3) = thresh(1,3) + 1;
           while(hist(thresh(1,3)+1) == 0 && thresh(1,3) < max)
               thresh(1,3) = thresh(1,3) + 1;
           end
       end
       %Recalculate remaining section.
       thresh(2,1) = ((max - thresh(1,3))/2)+thresh(1,3);
    end
    %Checks if pixel value is in the histogram.
    if(hist(thresh(2,1)+1) == 0)
       thresh(2,2) = thresh(2,1);
       thresh(2,3) = thresh(2,1);
       thresh(2,1) = 0;
       %Counts down until the pixel is in the histogram.
       if(thresh(2,2) > 0)
           thresh(2,2) = thresh(2,2) - 1;
           while(hist(thresh(2,2)+1) == 0 && thresh(2,2) > min)
               thresh(2,2) = thresh(2,2) - 1;
           end
       end
       %Counts up until the pixel is in the histogram.
       if(thresh(2,3) < 255)
           thresh(2,3) = thresh(2,3) + 1;
           while(hist(thresh(2,3)+1) == 0 && thresh(2,3) < max)
               thresh(2,3) = thresh(2,3) + 1;
           end
       end
    end
    %If initial pixel was in histogram, save values without counting.
    for i = 1:2
        if(thresh(i,1) ~= 0)
            thresh(i,2) = thresh(i,1);
            thresh(i,3) = thresh(i,1);
        end
    end
    %Calculate level values.
    level(1,1) = (min + thresh(1,2))/2;
    level(2,1) = (thresh(1,3)+thresh(2,2))/2;
    level(3,1) = (max + thresh(2,3))/2;
end

%Gets two possible pixel values for the output block.
function [level] = calculateLevel2(hist,min,max)
    level = zeros(2,1);
    thresh = uint16(zeros(1,3));
    thresh(1,1) = (max - min)/2;
    %Checks if pixel value is in the histogram.
    if(hist(thresh(1,1)+1) == 0)
       thresh(1,2) = thresh(1,1);
       thresh(1,3) = thresh(1,1);
       thresh(1,1) = 0;
       %Counts down until the pixel is in the histogram.
       if(thresh(1,2) > 0)
           thresh(1,2) = thresh(1,2) - 1;
           while(hist(thresh(1,2)+1) == 0 && thresh(1,2) > min)
               thresh(1,2) = thresh(1,2) - 1;
           end
       end
       %Counts up until the pixel is in the histogram.
       if(thresh(1,3) < 255)
           thresh(1,3) = thresh(1,3) + 1;
           while(hist(thresh(1,3)+1) == 0 && thresh(1,3) < max)
               thresh(1,3) = thresh(1,3) + 1;
           end
       end
    end
    %If initial pixel was in histogram, save values without counting.
    if(thresh(1,1) ~= 0)
        thresh(1,2) = thresh(1,1);
        thresh(1,3) = thresh(1,1);
    end
    %Calculate level values.
    level(1,1) = (min + thresh(1,2))/2;
    level(2,1) = (max + thresh(1,3))/2;
end

%Gets the pixel value for the output block.
function [level] = calculateLevel1(min,max)
    %Calculate level value.
    level = zeros(1,1);
    level(1,1) = (max + min)/2;
end