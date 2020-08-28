function [fData, OutIma, time] = btcencol_cvip(InIma,Blk)
% BTCENCOL_CVIP - Encodes an input image using Block truncation Coding and
%                the given Block size. Function was improved by processing
%                the block bit stream as MATLAB Column arrays.
%  
% Syntax :
% ------
% [fData, OutIma, time] = btcencol_cvip(InIma,Blk)
%
% Input parameters include :
% ------------------------       
%   'InIma'      Binary, Grayscale or RGB Image
%   'Blk'        block size (>2 Blk < Image size)
% 
% Output parameters include :
% ------------------------       
%   'fData'      Raw encoded data for file saving
%   'OutIma'     Output image after the BTC compression
%   'time'       Processing time of the operation
% 
% Example 1:
% -------
% Read a RGB image, computes its BTC data and show the compressed image:
%
%                InIma = imread('car.bmp');          %read image
%                Blk = 50;                           %define block size
%                %compress and show how will look the decompressed image
%                [fileData, OutIma, t] = btcencol_cvip(InIma,Blk); 
%                figure, subplot(1,2,1)              %figure visualization
%                imshow(InIma), title('Input Image');
%                subplot(1,2,2), imshow(OutIma); 
%                title('Reconstructed BTC Image');
%                disp(['Processing time was: ' num2str(t) ' Seconds']);
%
%
%  See also, btcdecol_cvip, btcenco_cvip, btcdeco_cvip, btcenco2_cvip, 
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
%           Initial coding date:    09/08/2018
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     10/03/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.4  11/23/2018  15:29:37  jucuell
 % updating function description
%
 % Revision 1.3  09/13/2018  17:27:56  jucuell
 % start Stream, 14 fix bit order in block
%
 % Revision 1.2  09/23/2018  13:14:08  jucuell
 % change name from btc_cvip to btcenco_cvip and change order of output
 % parameters the file data (fData) will be first, help info update
%
 % Revision 1.1  09/08/2018  17:48:03  jucuell
 % Initial revision: Function creation and initial testing
 % 
%
tic;                            %start timer    
%---------- Argument Check -----------------------------------------
    if nargin<1
        error('Too few arguments for btc_cvip');
    elseif nargin>2
        error('Too many arguments for btc_cvip');
    end

%--------- BTC computing ------------------------------------
    [r,c,b] = size(InIma);      %getting rows, cols and bands
    nHBlk = floor(c/Blk);       %number of horizontal blocks
    nVBlk = floor(r/Blk);       %number of vertical blocks
    %split cols and rows in two bytes
    s = dec2bin(r,16);
    t = bin2dec(s(9:16));       %low rows byte
    s = bin2dec(s(1:8));        %high rows byte
    d = dec2bin(c,16);
    e = bin2dec(d(9:16));       %low cols byte
    d = bin2dec(d(1:8));        %high cols byte
    fData = ('btd'+48)';        %image Format Info (magic number)
    %image Header Info
    fData(end+1:end+6) = [b;    %bands          1 byte
                          d;    %high cols byte
                          e;    %low cols byte  2 bytes
                          s;    %high rows byte
                          t;    %low rows byte  2 bytes
                          Blk]; %block size     1 byte    
    
    InIma = double(InIma);      %changing data type
    OutIma = zeros(r,c,b);      %creating empty output image
%--------- BTC computing ------------------------------------
    for band = 1:b
        for VBlk = 1:nVBlk
            for HBlk = 1:nHBlk
                %extract current block
                bl = InIma(Blk*(VBlk-1)+1:VBlk*Blk,Blk*(HBlk-1)+1:HBlk*Blk,band); 
                mb = mean(bl(:));       %Blk mean
                b2 = power(bl,2);       %Blk squared
                %block variance
                sigb = sqrt((sum(b2(:))/power(Blk,2) - power(mb,2)));
                q = sum(bl(:)>=mb);     %values in block > mb
                %computing high and low values for quantizer
                if q == power(Blk,2)    %id Blk = gray level
                    H = mb;
                    L = mb;
                else                    %computed h and L values for block
                    H = round(mb + sigb * sqrt((power(Blk,2)-q)/q));
                    L = round(mb - sigb * sqrt(q/(power(Blk,2)-q)));
                end
                b2 = (bl>=mb)*H + (bl<mb)*L;%new block gray levels
                Stream=char((bl(:)>=mb)+48);
                Siza = size(Stream,1);
                if mod(Siza,8) ~= 0     %round to 8 bits per row
                    bits = floor(size(Stream,1)/8);
                    bits = (bits+1)*8 - Siza;
                    temp = [Stream; dec2bin(0,bits)'];  %zero padded
                    Stream = temp;
                    Siza = size(Stream,1);
                end
                Stream2 = reshape(Stream,Siza/8,8);
                Stream=zeros(2+Siza/8,1);
                %create new stream variable and include 2 first fields for
                %H and L values
                Stream(3:end) = bin2dec(Stream2);      %convert stream to decimal
                %new block in output image
                OutIma(Blk*(VBlk-1)+1:VBlk*Blk,Blk*(HBlk-1)+1:HBlk*Blk,band)=b2;
                Stream(1) = L;      %save L value on stream
                Stream(2) = H;      %save H value on stream
                %update stream values
                fData(end+1:end+size(Stream,1),1) = Stream;
            end
        end
    end
    OutIma = uint8(OutIma);     %convert Output Image to byte (cvip_byte)
    fData = uint8(fData);       %convert File Data to byte (cvip_byte)
    time = toc;                 %save the processing time
end