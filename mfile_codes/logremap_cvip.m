function [ realImage, phaseImage ] = logremap_cvip( inputImage, band)
% LOGREMAP_CVIP  - Logarithmic remapping of an image data.
% The function performs the logarithmic remapping of an input image.  
% The input image can be either real image or complex image.If complex, 
% the function computes real image and phase phase, returns two 
% log remapped images.If the input image is multi-band image, the user
% has option to select single band for remap and return the remapped 
% version of that band only.Or the user can select all bands by not
% passing band parameter during the function call.After logarithmic
% remapping,the histograms of the image are stretched for better display.
%
% Syntax:
% -------
% outImage = logremap_cvip(inImage, band)
% 
% Input Parameters include :
% ------------------------
%   'inImage'       1-band input image of MxN size or 3-band input image of   
%                   MxNx3 size. The input image can be of uint8 or uint16
%                   or double or complex double class. If double class,
%                   the function assumes the data range of image is from
%                   0 to 1.
%   'band'          Selection of single band. 
%                   ('R' - red, 'G' - green, 'B' - blue, others - all bands)
%                   Band is of characters and strings class.
%                   All bands (default)
%
%
%
% Output Parameters include :  
% -------------------------
%   'realImage'     Log-remapped image having same size of input image. It 
%                   is magnitude image if the input image is of complex 
%                   double type.  
%   'phaseImage'    Linearly remapped phase image. Only for complex double  
%                   class type input image. If input image is real image, 
%                   phase image is empty matrix.
%                                         
%
% Example :
% -------
%                   I = imread('SkinLesion.jpg');     % original image
%                   fftimg = fft_cvip(I,[]);          % complex image                        
%                   M = logremap_cvip(fftimg);            % magnitude Image and all bands are selected (default)
%                   band = 'r';                           % select red band only
%                   [M1,P1] = logremap_cvip(fftimg,band); % magnitude image M1 and phase image P1
%                   figure;imshow(I);title('Input Image');
%                   figure;imshow(M,[]);title('Output Log Remapped Image - FFT Magnitude Image');
%                   figure;imshow(P1,[]);title('Output Remapped Image - FFT Phase Image');	
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    3/15/2017
%           Latest update date:     3/23/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================

%check number of input and output arguments
if nargin ~= 1  && nargin ~= 2
    error('Too many or too few input arguments!')
end
if nargout ~= 0 && nargout ~= 1 && nargout~=2
    error('Too many or too few output arguments!')
end

%check input image type is either complex or real
if nargin == 1    
     band = 'all';
elseif nargin == 2
    if ~ischar(band)
        band = 'all';
    end
end 
if ~isreal(inputImage)
    realImage = abs(inputImage);
    phaseImage = angle(inputImage); 
else
   realImage = double(inputImage);
   phaseImage = [];     
end  

%find which band is selected or all bands are selected
switch band
    case 'r'
        realImage = realImage(:,:,1);
        if ~isempty(phaseImage)
            phaseImage = phaseImage(:,:,1);
        end
    case 'g'
        realImage = realImage(:,:,2);
        if ~isempty(phaseImage)
            phaseImage = phaseImage(:,:,2);
        end
    case 'b'
        realImage = realImage(:,:,3);
        if ~isempty(phaseImage)
            phaseImage = phaseImage(:,:,3);
        end
    otherwise       
end
        
%perform log-remapping, then linear remapping to 0-255 
realImage = log10(1+realImage);
realImage = condremap_cvip(realImage,[0 2^8-1],'uint8');
if ~isempty(phaseImage)
    %angle function returns values between -pi and +pi, remap phase image
    %range into 0 to 2pi
%     phaseImage = remap_cvip(phaseImage,[0 2*pi]);  
    phaseImage = condremap_cvip(phaseImage,[0 2^8-1],'uint8');
end

end %end of log-remap function



