function [ outputImage, time_taken] = threshold_lab( inputImage)
%THRESHOLD_LAB Image thresholding.
%The function performs the multiband thresholding of an input image.
%The user can select either Loop-based method or Vectorization method to
%perform the threshold operation. Vectorization method involves vectorized
%code, which looks like  a mathematical expressions and is easier to
%understand. Also, it runs much faster than the non-vectorized code, i.e. 
%loop-based code.  
%The threshold function will compare the actual gray level of the input
%image with the threshold value. If the gray-level value is greater than
%the threshold value, then the gray level is set to WHITE, else to BLACK. 
%This function assumes inputImage as of either 'double' or 'uint8' class.
%The output arguments are a thresholded image, and the execution time of 
%threshold operation.
%--------------------------------------------------------------------------
%
%              Credit(s): Norsang Lama, Scott E Umbaugh
%                         Southern Illinois University Edwardsville
%                  Date : 1-15-2017
%
%   Copyright (C) 2017 Scott Umbaugh and SIUE
%
%__________________________________________________________________________

MAX =255; %Maximum pixel value as 255

%Assuming the data type of input image as either 'double' or 'uint8'
if isa(inputImage,'double')  %check if datatype of image is double 
    WHITE_LAB = 1.0;    BLACK_LAB = 0.0; %double, data matrix's range 0 to 1 
elseif isa(inputImage,'uint8') %check if datatype of image is uint8
    WHITE_LAB = 255;    BLACK_LAB = 0; %uint8, data matrix's range 0 to 255 
end

while true %continues on until the successful threshold operation
    
    %Analyze the performance of Loop-based method vs. Vectorization method
    fprintf('\n\t\t1. Loop-based method');
    fprintf('\n\t\t2. Vectorization method');
    fprintf('\n\n\t\tPlease enter your choice:');
    option = input(' ');  %request user input, input argument is a space character
    fprintf('\t\t');
    if ~isnumeric(option ) || option ~= 1 && option ~=2 %check if user input is numeric, and equal to either 1 or 2
        warning('Incorrect choice!')  %display warning message for incorrect choice
        continue;   %avoid the remaining statements, repeat the loop
    end
    
    %  ask user to input threshold value (0 to 255)
    fprintf('\n\t\tPlease enter a threshold value (0 - 255):');
    threshval = input(' '); %request user input, input argument is a space character
    
    % convert threshold value in the range [0,1] if input image double type
    if ~(WHITE_LAB == MAX)   
        threshval = threshval/MAX;
    end 
      
    fprintf('\t\t'); 
    if (~isnumeric(threshval)) || (threshval < BLACK_LAB) || (threshval > WHITE_LAB) %check if entered value is numeric and within a range of 0-255.
        warning('Entered value is not numeric or not within the range of 0-255!');  
        continue;    %avoid remaining statements, repeat the loop
    end
    
    outputImage = inputImage; %create output image same as input image
    
    switch option   %switch option for two methods
        
        % loop-based method 
        case 1
            tic;   %start stopwatch timer
            [row,col,band] = size(inputImage); %get #rows, #columns, #bands
            for b=1:band  %first for-loop to run for each band
                for r=1:row %second for-loop to run for each row
                    for c=1:col %third for-loop to run for each column
                        if inputImage(r,c,b) > threshval %compare current pixel value with threshold 
                            outputImage(r,c,b) = WHITE_LAB; %set current pixel as WHITE if it is greater 
                        else
                            outputImage(r,c,b) = BLACK_LAB; % else set current pixel as BLACK 
                        end %end of if
                    end %end of third for-loop
                end %end of second for-loop
            end %end of first for-loop
            time_taken = toc; %stop timer, assign execution time to 'time_taken'
            return;  %return control to invoking function
        
        % vectorization method
        case 2
            tic; %start stopwatch timer
            outputImage(outputImage>threshval)=WHITE_LAB; %compare each pixel value with threshold, if greater set WHITE
            outputImage(outputImage<=threshval)=BLACK_LAB; %compare each pixel value with threshold, if less or equal set BLACK
            time_taken = toc; %stop timer, assign execution time to 'time_taken'
            return;   %return control to invoking function 
            
    end %end of switch
    
end %end of while 

end %end of function
    