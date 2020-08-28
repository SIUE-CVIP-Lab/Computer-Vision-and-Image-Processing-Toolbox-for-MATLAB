function OutIma = btcdeco_cvip(fData,test)
% BTCDECO_CVIP - read btc compressed data and returns the reconstructed image.
% The function takes the extracted compressed data that corresponds to a
% btc image information and reconstructs it according to the information
% found in the data.
%
% Syntax :
% ------
% OutIma = btcdeco_cvip(fData)
%
% Input parameters include :
% ------------------------       
%   'fData'      Column vector from the compressed file
% 
% Output Parameter include :  
% ------------------------
%   'OutIma'     Reconstructed compressed btc image
%
%
% Example :
% -------
%
%                InIma = imread('car.bmp');          %read image
%                Blk = 50;                           %define block size
%                fileData = btcenco_cvip(InIma,Blk); %compress image
%                OutIma = btcdeco_cvip(fileData);    %decompress image data
%                figure, subplot(1,2,1)              %figure visualization
%                imshow(InIma), title('Input Image');
%                subplot(1,2,2), imshow(OutIma); 
%                title('Reconstructed BTC Image');
%
%
%  See also, btcenco_cvip, btcenco2_cvip, btcdecol_cvip, btcencol_cvip,
%  btcdvec_cvip, btcevec_cvip, vipmwrite_cvip, vipmread_cvip, vipmwrite2_cvip, 
%  vipmread2_cvip
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications 
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Julian Rene Cuellar Buritica
%           Initial coding date:    09/22/2018
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     09/25/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.3  12/10/2018  15:52:32  jucuell
 % adjusting of header reading
%
 % Revision 1.2  09/24/2018  18:53:21  jucuell
 % help update and testing!! fixed read of encoded images with a block
 % power of 2
%
 % Revision 1.1  09/22/2018  10:17:15  jucuell
 % Initial revision: Function creation and initial testing
 % 
%                         
    
%---------- Argument Check -----------------------------------------
    if nargin<1
        error('Too few arguments for btcdeco_cvip');
    elseif nargin>2
        error('Too many arguments for btcdeco_cvip');
    end

    %read btc header
    magic = char(fData(1:3)'-48);        %get magic number
    if ~strcmp(magic,'btc')
        error('Given compressed data is not for a btc file!!');
    end
    b = double(fData(4));        %getting bands
    d = fData(5);                %getting high cols byte
    e = fData(6);                %getting low cols byte 
    s = fData(7);                %getting high rows byte
    t = fData(8);                %low rows byte  
    Blk = double(fData(9));      %block size      
    %put cols bytes together
    c = bin2dec([dec2bin(d,8) dec2bin(e,8)]);
    %put rows bytes together
    r = bin2dec([dec2bin(s,8) dec2bin(t,8)]);
    
    rawData = double(fData(10:end));%raw image data
        
    nHBlk = floor(c/Blk);       %number of horizontal blocks
    nVBlk = floor(r/Blk);       %number of vertical blocks
    binLen = ceil(Blk^2/8)+2;   %computes amount of bits per block
    streShift = binLen*nHBlk;   %horizontal shift of bits in the image
    
    %verify if rawData and spected data match
    if binLen*nHBlk*nVBlk*b ~= size(rawData,1)
        error('Data dimensions does not match block and image size');
    end
    
    OutIma = zeros(r,c,b);      %empty out ima
    for band = 1:b
        for VBlk = 1:nVBlk
            for HBlk = 1:nHBlk
                offSet = binLen*((band-1)*nVBlk*nHBlk+(HBlk-1))+streShift*(VBlk-1);
                L = rawData(offSet+1);
                H = rawData(offSet+2);
                blo = rawData(offSet+3:offSet+binLen);
                
                blo = dec2bin(blo,8);%get binary stream
                %conver column array into row array
                bl=char(zeros(1,size(blo,1)*size(blo,2)));
                for i=1:size(blo,1)
                    bl(8*(i-1)+1:8*i)=blo(i,:);
                end
                if test==0      %basic decode implementation
                %build image block
                blo=char(zeros(Blk,Blk));
                for i=1:Blk
                    blo(i,1:Blk)=bl(Blk*(i-1)+1:Blk*i);
                end
                %convert each bit to num
                bl = zeros(Blk,Blk);
                for row=1:Blk   %scan stream values and replace with level
                    for col=1:Blk%values
                        if str2double(blo(row,col))==0
                            bl(row,col) = L;
                        else
                            bl(row,col) = H;
                        end
                    end
                end
                else            %improved decode implementation
                    bl=bl(1,1:Blk*Blk)';%block stream extraction
                    blo=bin2dec(bl);%decimal values
                    blo=reshape(blo,Blk,Blk)';
                    bl=(blo==1)*H + (blo==0)*L;%level values replacement
                end
                %new block in output image
                OutIma(Blk*(VBlk-1)+1:VBlk*Blk,Blk*(HBlk-1)+1:HBlk*Blk,band)=bl;
            end
        end
    end
    OutIma = uint8(OutIma);         %convert Output Image to byte (cvip_byte)
end
