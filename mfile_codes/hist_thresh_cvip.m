function outImage = hist_thresh_cvip(inImage, pct)
% HIST_THRESH_CVIP -Performs adaptive thresholding segmentation.
%  The function performs adaptive thresholding segmentation. First, the
%  function automatically finds the number of thresholds by finding peaks
%  and valleys in an image histogram.To find the most important peaks, the
%  histogram is smoothened using an average filter of length 7 
%  (experimentally selected).The peaks lower than 20% of maximum peak value 
%  or not 10% higher than their valleys are discarded (experimentally 
%  choosen; it may not be optimal on all applications, change 
%  maxpeak3peak_ratio and peak2val_ratio in peak_valley_find function if  
%  needed).And, the valleys are only considered in between two peaks.The   
%  number of thresholds is equal to number of valleys.Once the peaks are
%  found, the thresholds in between two peaks are found using Otsu method.
%  After all threshold values are determined, the pixels values are
%  substituted by weihgted-mean gray value of its own range.If input image
%  is multiband image, the image is converted into single band image.The
%  user can specify either PCT method or rgb to gray conversion method.
%
% Syntax:
% -------
%  outImage = hist_thresh_cvip(inImage, pct)
%   
% 
% Input Parameters include:
% -------------------------
%  'inImage'       1-band input image of MxN size or 3-band input image of   
%                  MxNx3 size. The input image can be of uint8 or uint16 
%                  or double class. 
%  'pct'           Selects principal component transform (PCT) to convert
%                  multiband image to one band. (Only if inImage has more
%                  than one band)
%                      pct = 1        [PCT method]
%                      pct = 0        [RGB to gray conversion]
%
%
% Output Parameter include :  
% ------------------------
%  'outImage'      Segmented image.
%                                         
%
% Example :
% -------
%                   I = imread('butterfly.tif');    %original image
%                   O = hist_thresh_cvip(I, 0);
%                   figure; imshow(O);  %function returns as double
%                                              %type (range = 0-255) 
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Norsang Lama
%           Initial coding date:    4/14/2017
%           Latest update date:     4/14/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017 Scott Umbaugh and SIUE
%
%==========================================================================


%if input image is multiband image, select principal component  using 
%principal component transform or perform rgb to gray conversion
[~,~,B] = size(inImage);
if B > 1
    if pct
        [pctImage,ee] = pct_cvip(inImage); 
        inImage = uint8(remap_cvip(pctImage(:,:,1), [0 255]));
    else
        inImage = uint8(0.3*inImage(:,:,1)+0.6*inImage(:,:,2)+0.1*inImage(:,:,3));
    end
end

%Total number of gray levels (Considering 8-bit image)
T = 256;  

%compute the histogram of an input image
edges = 0:T;
hist = histcounts(inImage, edges);

%find the peaks from the histogram
%using second argument, the user can view the peaks and valleys
%the view option is turned of in default case 
[N_peaks, peak_gl] = peak_valley_find(hist,0);

%Number of thresholds = Number of peaks - 1
N_thresh = N_peaks - 1;

thresh_level = zeros(1, N_thresh);

%find the threshold levels inbetween two peaks
for i = 2:N_peaks
    temp_hist = zeros(1, T);
    temp_hist(peak_gl(i-1):peak_gl(i)) = hist(peak_gl(i-1):peak_gl(i));
    thresh_level(i-1) = thresval_histogram(temp_hist);
end


%applying mulitlevel thresholding
%pixel values are replaced by weighted mean of that range
outImage = inImage;
for i =1: N_thresh + 1
    temp_hist = hist;
    if i == 1
        temp_hist(thresh_level(i)+1:end) = 0;
        weighted_mean = floor(sum(temp_hist.*edges(1:end-1))/sum(temp_hist));
        outImage(outImage < thresh_level(i)) = weighted_mean;
    elseif i == N_thresh + 1
        temp_hist(1:thresh_level(i-1)) = 0;
        weighted_mean = floor(sum(temp_hist.*edges(1:end-1))/sum(temp_hist));
        outImage(outImage >= thresh_level(i-1)) = weighted_mean;
    else
        temp_hist(1:thresh_level(i-1)) = 0;
        temp_hist(thresh_level(i)+1:end) = 0;
        weighted_mean = floor(sum(temp_hist.*edges(1:end-1))/sum(temp_hist));
        outImage(outImage >= thresh_level(i-1) & outImage < thresh_level(i)) = weighted_mean;
    end          
end

end


%Function to find number of peaks in histogram of image
function [num_peaks, peak_gLvl] = peak_valley_find(hist, viewPeakValley)
% Input Parameter:
%   hist              Histogram. Considers 256 levels from 0 to 255.
%   viewPeakValley    Display peaks and valleys if set ON (1).
%
%
% Output Parameter:
%   num_peaks         Number of peaks in histogram of image
%   peak_gLvl         Graylevel values corresponding to the peaks


%Total number of gray levels (Considering 8-bit image)
T = 256;  

%smoothing the histogram using average filter
avg_filtSize = 7;
hist = filter(ones(1,avg_filtSize), 1, hist);

%maximum peak value
max_peak = max(hist);

%considering peak or valley if it is maximum or minimum in neighborhood of 
%7
neighbor = [3 5 7];

%create peak and valley arrays
peak = ones(1,T);
valley = peak;


%finding the peaks or valleys that are maximum or minimum respectively in 
%its neighborhood
for i = 1:length(neighbor)
    t = floor(neighbor(i)/2);
    histL = [zeros(1, t)  hist(1:end-t)];
    histR = [hist(t+1:end) zeros(1,t)];
    
    peak = peak & (hist > histL & hist > histR);
    valley = valley & (hist < histL & hist < histR);    
end

%eliminating peaks that is smaller than 20% of maximum peak value 
maxpeak2peak_ratio = 0.2;
peak(hist < maxpeak2peak_ratio*max_peak) = 0;


%find peak and valley indices 
peakInd = find(peak == 1);

%now find single valley between peaks; choose valley with minimum value if
%multiple valleys inbetween two peaks
k =1;
for i = 1:length(peakInd)-1
    minm = max_peak;
    local_val_count = 0;  
    for j=peakInd(i)+1:peakInd(i+1)-1
        if valley(j) 
            if hist(j) < minm
                minm = hist(j);
                valInd(k) = j;                
            end
            local_val_count = local_val_count + 1; 
        end
    end  
    if local_val_count < 1
        peak(peakInd(i))= 0;  %drop the peak because no valley was detected
        %next to this peak by our valley-peak detecting algorithm
    else
        k = k+1;
    end
end

%find new peak indices as some of the peaks are dropped 
peakInd = find(peak == 1);

valley = 0*valley;
valley(valInd) = 1;

%drop a peak P that is not 0.1*P (5 percent of its magnitude) greater than 
%its valleys on bothsides
peak2val_ratio = 0.1;
for i =1:length(peakInd)
    if i == 1  %checking right side for first peak
        if hist(peakInd(i))-hist(valInd(i)) < peak2val_ratio *hist(peakInd(i))
            peak(peakInd(i)) = 0;  %drop the peak
            valley(valInd(i)) = 0; %drop the valley 
        end
    elseif i == length(peakInd) %checking left side for last peak
        if hist(peakInd(i))-hist(valInd(i-1)) < peak2val_ratio *hist(peakInd(i))
            peak(peakInd(i)) = 0;  %drop the peak
            valley(valInd(i-1)) = 0;  %drop the valley
        end
    else
        if (hist(peakInd(i))-hist(valInd(i-1))) < peak2val_ratio *hist(peakInd(i))
            peak(peakInd(i)) = 0;  %drop the peak
            valley(valInd(i-1)) = 0; %drop the valley
            continue;
        end
        if (hist(peakInd(i))-hist(valInd(i))) < peak2val_ratio *hist(peakInd(i))
            peak(peakInd(i)) = 0;  %drop the peak
            valley(valInd(i)) = 0; %drop the valley 
        end
    end        
end

if viewPeakValley
    figure; plot(hist)
    hold on
    stem(valley.*hist)
    stem(peak.*hist)
    hold off
    title('Peaks and Valleys')
end

%total number of peaks
num_peaks = sum(peak);
peak_gLvl = find(peak == 1);

end

%find the threshold between two peak using Otsu method
function threshval = thresval_histogram(hist)

%probability of each gray level
hist_prob = hist/sum(hist); 
    
%find the otsu threshold for each band and perform thresholding
tmp = 0;
for t=1:256
    w0t = sum(hist_prob(1:t));
    w1t = sum(hist_prob(t+1:end));
    a=1:t;
    b=t+1:256;
    mean0t = sum(a.*hist_prob(1:t))/w0t;
    mean1t = sum(b.*hist_prob(t+1:end))/w1t;
    sigma(t) = w0t*w1t*(mean0t-mean1t)^2;    
    %update the otsu_threshold, until the maximum variance is not
    %achieved
    if (sigma(t)>tmp)
        threshval = t-1;
        tmp = sigma(t);
    end
end

end