function [fData, OutIma, time] = btcevec_cvip(InIma,Blk)
% BTCEVEC_CVIP - Encodes an input image using Block truncation Coding and
%                the given Block size. Function was improved by processing 
%                all image bands using vectorization.
%  
% Syntax :
% ------
% [fData, OutIma, time] = btcevec_cvip(InIma,Blk)
%
% Description :
% -----------
% Block truncation coding (BTC) works by dividing the image into small 
% subimages and then reducing the number of gray levels within each block. 
% This reduction is performed by a quantizer that adapts to the local image 
% statistics. The levels for the quantizer are chosen to minimize a 
% specified error criterion, and then all the pixel values within each
% block are mapped to the quantized levels.
% The basic form of BTC divides the image into n × n blocks and codes each
% block using a two-level quantizer. The two levels are selected so that the
% mean and variance of the gray levels within the block are preserved. Each
% pixel value within the block is then compared. with a threshold, typically
% the block mean, and then is assigned to one of the two levels. If it is
% above the mean it is assigned the high level code, if it is below the mean,
% it is assigned the low level code. If we call the high value H and the low
% value L, we can find these values via the following equations:
%
%                   b = current block
%                   mb = block mean
%                   sigb = block variance
%                   n = block size (Blk)
%                   q = number of values n the block >= mb
%
%                   H = mb + sigb * sqrt((n^2-q)/q)
%
%                   L = mb - sigb * sqrt(q/(n^2-q))
%
% After computing block parameters the file stream of data (fData) is 
% conformed, if the block size (Blk) is not a power of two the block
% information is zero padded to complete the closest 8 bit.
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
%                [fileData, OutIma, t] = btcevec_cvip(InIma,Blk); 
%                figure, subplot(1,2,1)              %figure visualization
%                imshow(InIma), title('Input Image');
%                subplot(1,2,2), imshow(OutIma); 
%                title('Reconstructed BTC Image');
%                disp(['Processing time was: ' num2str(t) ' Seconds']);
%
%
%  See also, btcdvec_cvip, btcenco_cvip, btcdeco_cvip, btcenco2_cvip,
%  btcdecol_cvip, btcencol_cvip, vipmwrite_cvip, vipmread_cvip, vipmwrite2_cvip, 
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
 % Revision 1.4  11/23/2018  18:28:02  jucuell
 % updating function description and header configuration
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

%--------- BTC Header Info ------------------------------------
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
    fData = ('bte'+48)';        %image Format Info (magic number)
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
    for VBlk = 1:nVBlk
        for HBlk = 1:nHBlk
            %extract current block
            bl = InIma(Blk*(VBlk-1)+1:VBlk*Blk,Blk*(HBlk-1)+1:HBlk*Blk,:); 
            mb = mean(mean(bl));    %Blk mean
            b2 = power(bl,2);       %Blk squared
            %block variance
            sigb = sqrt((sum(sum(b2))/power(Blk,2) - power(mb,2)));

            mb3=repmat(mb,Blk,Blk);
            Stream=bl>=mb3;
            q=sum(sum(Stream));
            %computing high and low values for quantizer
            pBlk = repmat(power(Blk,2),1,1,b);
            H = round(mb + sigb .* sqrt((pBlk-q)./q));
            L = round(mb - sigb .* sqrt(q./(pBlk-q)));
            if any(q == repmat(power(Blk,2),1,1,b))%if Blk = gray level
                [~,n]=find(q == repmat(power(Blk,2),1,1,b));
                for i=1:size(n)
                    H(n(i)) = mb(n(i));
                    L(n(i)) = mb(n(i));
                end
            end
            %new block gray levels
            b2 = (bl>=mb3).*repmat(H,Blk,Blk) + (bl<mb3).*repmat(L,Blk,Blk);
            Stream = char(Stream(:)+48);
            if mod(b*Blk^2,8) ~= 0	%round to 8 bits per row
                bits = floor(b*Blk^2/8);
                bits = (bits+1)*8 - b*Blk^2;
                temp = [Stream; dec2bin(0,bits)'];  %zero padded
                Stream = temp;
            end
            Siza = size(Stream,1);
            %create new stream variable and include 2 first fields for
            %H and L values
            Stream = reshape(Stream,Siza/8,8);
            Stream = bin2dec(Stream);      %convert stream to decimal
            Siza = size(Stream,1);
            %new block in output image
            OutIma(Blk*(VBlk-1)+1:VBlk*Blk,Blk*(HBlk-1)+1:HBlk*Blk,:)=b2;
            if b == 1
                Stream2 = zeros(Siza+2,1);
                Stream2(1) = L(1,1,1);      %save L value on stream band 1
                Stream2(2) = H(1,1,1);      %save H value on stream band 1
                Stream2(3:end,1) = Stream;
            else
                Stream2 = zeros(Siza+6,1);
                Stream2(1) = L(1,1,1);      %save L value on stream band 1
                Stream2(2) = H(1,1,1);      %save H value on stream band 1
                Stream2(3) = L(1,1,2);      %save L value on stream band 2
                Stream2(4) = H(1,1,2);      %save H value on stream band 2
                Stream2(5) = L(1,1,3);      %save L value on stream band 3
                Stream2(6) = H(1,1,3);      %save H value on stream band 3
                Stream2(7:end,1) = Stream;
            end
            %update stream values
            fData(end+1:end+size(Stream2,1),1) = Stream2;
        end
    end
    OutIma = uint8(OutIma);     %convert Output Image to byte (cvip_byte)
    fData = uint8(fData);       %convert File Data to byte (cvip_byte)
    time = toc;                    %save the processing time
end