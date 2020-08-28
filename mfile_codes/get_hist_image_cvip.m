function get_hist_image_cvip(image)
% GET_HIST_IMAGE_CVIP - Displays the histogram of an input image.
% Z = GET_HIST_IMAGE_CVIP(X) displays the histogram of the input image
% X.It displays the single histogram if the input image is gray scale
% image and displays separate histogram for each band if the input image
% is color image. 
%
% Syntax:
% -------
% Z = GET_HIST_IMAGE_CVIP(X)
%
% Input Parameters include :
% -------------------------
%  'X'      Input Image. 
%    
%   The histogram of the image are adaptive in nature i.e. it automatically
%   changes x-axis and y-axis range depending upon the values in the input
%   image. It supports uint8, uint32 and double type image and indexed
%   image.
%
% Example 1 :
% ---------
%   Displays the histogram of an input grayscale image:
%
%                   X = imread('Cam.bmp'); % Grayscale Image
%                   figure;get_hist_image_cvip(X);
%
% Example 2 :
% ---------
%   Displays histogram of an input color image:
%
%                   X = imread('Car.bmp');
%                   figure;get_hist_image_cvip(X); % RGB Image
%
%
%   See also, histeq_cvip, gray_linear_cvip, hist_create_cvip,
%   hist_spec_cvip, hist_shrink_cvip, hist_slide_cvip, hist_stretch_cvip,
%   local_hist_eq_cvip, unsharp_cvip.
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Deependra Mishra
%           Initial coding date:    03/17/2017
%           Updated by:             Joey Olden
%           Latest update date:     10/15/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.4  10/10/2019  17:13:55  jolden
 % removing the remapping/hist-stretch of the input image
 % changing the xlimits to be based on range of data
 % always implementing 256 total bins
%
 % Revision 1.3  05/32/2019  09:59:33  jucuell
 % modifying y limits of each histogram to the 20% more of the maximum.
%
 % Revision 1.2  05/12/2019  15:14:56  jucuell
 % changing green color and keeping all image axes between 0 and 255,
 % displaying xticks each 32 gray levels until 255
%
 % Revision 1.1  03/17/2017  15:21:14  demish
 % function creating and initial testing.
%

% Determining the bin width based on the data type fo the image
    if isa(image,'uint8')
        minimum = 0;
        maximum = 255;
        binwidth = 1;
    elseif sum(sum(mod(image,1))) == 0
        minimum = min(image(:));
        maximum = max(image(:));
        binwidth = 1;
    else
        minimum = min(image(:));
        maximum = max(image(:));
        range = abs(maximum-minimum);
        binwidth = range/255;
    end
 
%---Creates the histogram of an input image-----------------    
    if size(image,3)==3
        r=image(:,:,1);
        g=image(:,:,2);
        b=image(:,:,3);
        
        %Red Band
        subplot(3,1,1);
        set(subplot(3,1,1),'Color','black');
        hold on;
        histogram(r,'BinWidth',binwidth,'FaceColor','r','EdgeColor', 'r');
        title('\fontsize{12}{\color{red}Red Band}');
        xlim([minimum maximum]);
        % limits the y-axis value depending upon the no. of pixels associated with
        % particular pixel value   
        
        %Green Band
        subplot(3,1,2);
        set(subplot(3,1,2),'Color','k');
        hold on;
        histogram(g,'BinWidth',binwidth,'FaceColor',[0.0157,0.5098,0.0157],...
                  'EdgeColor', [0.0157,0.5098,0.0157]);
        title('\fontsize{12}{\color[rgb]{0.0157 0.5098 0.0157}Green Band}');
        xlim([minimum maximum]);
        % limits the y-axis value depending upon the no. of pixels associated with
        % particular pixel value   
        ylabel('Total No. of Pixels');
        
        %Blue Band
        subplot(3,1,3);
        set(subplot(3,1,3),'Color','k');
        hold on;
        histogram(b,'BinWidth',binwidth,'FaceColor','b','EdgeColor', 'b');
        title('\fontsize{12}{\color{blue}Blue Band}');
        xlim([minimum maximum]);
        % limits the y-axis value depending upon the no. of pixels associated with
        % particular pixel value   
        xlabel('No. of Gray levels');   
    elseif size(image,3)==1
        set(gca,'Color','k');
        hold on;
        histogram(image,'BinWidth',binwidth,'FaceColor','white','EdgeColor', 'white');
        % limits the x-axis value depending upon the maximum pixel value of the image        
        xlim([minimum maximum]);
        xlabel('No. of Gray levels');
        ylabel('Total No. of Pixels');
    else
        error('Input Image error: Enter single band or 3 band image');
    end
end
