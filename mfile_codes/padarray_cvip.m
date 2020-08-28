function output_img = padarray_cvip(input_img,M,N)
% PADARRAY_CVIP - pads with zeros a small image according to the given
% number of rows M and columns N. It conserves the original number of bands
% in the input image. If the input image is uint8 it will bring back a
% uint8 output image, otherwise it will bring a double output image.
%
% Syntax :
% -------
% padarray_cvip(input_img, M, N)
%   
% Input Parameters include :
% ------------------------ 
%   'input_img'     The orignial image which can be grayscale or RGB.
%
%   'M'             The new number of rows for the output image.
%
%   'N'             The new number of columns for the output image.
%                                
%
% Example 1 :   Pad with zeros an smaller image
%
%               input_img = input_image();
%               M = 512;        %new number of rows
%               N = 512;        %new number of columns
%               output_img = padarray_cvip(input_img,M,N);
%               figure; imshow(input_img), title('Input Image');
%               figure; imshow(output_img), title('Padded with zeros Image');
%                 
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Sujata Bista
%                                   Murat Aslan
%           Initial coding date:    04/18/2019
%           Updated by:             Sujata Bista
%                                   Murat Aslan
%           Latest update date:     04/23/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.2  04/23/2019  14:11:53  sbista, maslan
 % Changed for loop for vectorization implementation, the size of the input
 % image is computed inside this function
%
 % Revision 1.1  04/18/2019  16:33:22  sbista, maslan
 % Initial coding:
 % getting the new M and N size for the output image and use for loop to
 % put the input image into the new one
%            

%get the size of input image
[m,n,b] = size(input_img);

if isa(input_img,'uint8')
    output_img=uint8(zeros(M,N,b));    %create uint8 output image
else
    output_img=zeros(M,N,b);           %create double output image
end

%for loop implementation
%for r=1:m
%    for c=1:n
%        output_img(r,c)=input_img(r,c);
%    end
%end
%vectorization implementation
output_img(1:m,1:n,:) = input_img;