% * =========================================================================
% *
% *   Computer Vision and Image Processing Lab - Dr. Scott Umbaugh SIUE
% * 
% * =========================================================================
% *
% *             File Name: CVIPlab.m 
% *           Description: This  is the skeleton program for the Computer Vision
% *			               and Image Processing Labs
% *   Initial Coding Date: Jan 15, 2017
% *      Last Update Date: March 9, 2017
% *             Credit(s): Norsang Lama, Scott E Umbaugh
% *                        Southern Illinois University Edwardsville
% *
% *  Copyright (C) 2017 Scott E Umbaugh and SIUE
% * 
% *  Permission to use, copy, modify, and distribute this software and its
% *  documentation for any non-commercial purpose and without fee is hereby
% *  granted, provided that the above copyright notice appear in all copies
% *  and that both that copyright notice and this permission notice appear
% *  in supporting documentation.  This software is provided "as is"
% *  without express or implied warranty.
% * 
% ****************************************************************************

    clc; %clear command window
    close all;  %close all the figure windows
    exitLab = false;   %flag to exit program or continue on, flag is OFF
    
    %Create user interface (UI), print the string in command window
    fprintf('\n***************************************'); 
    fprintf('****************************  ');
	fprintf('\n*\t\t\t Computer Vision and Image Processing Lab\t\t\t  *');
	fprintf('\n*\t\t\t\t\t\t <Your Name Here> \t\t\t\t\t\t  *');
	fprintf('\n******************************************');
	fprintf('*************************\n');
	
	while ~exitLab  %continue until user selects the Exit option.
		fprintf('\n\t0.\tExit ');
		fprintf('\n\t1.\tThreshold Operation \n\n\t');
        
        % obtain an integer between 0 and CASE_MAX from the user		
		choice = input('Enter your choice: ');      %input from user  
        
        %switch case for multiple operations
        switch choice	
            
            %   0. Exit
            case 0 
                exitLab = true;  %turn exit program flag ON to exit program
                
            %   1. Threshold Operation   
            case 1 
                % Get the input image from user
                cvipImage = input_image();  %call input_image function                          
                if isempty(cvipImage), continue;  %check if input image entered , otherwise escape the remaining statements
                end	
                figure;  %creates new figure window 
                subplot(1,2,1); %divide whole figure window into two sub-regions, and select first sub-region to plot
                datacursormode on;  %allows viewer to see pixel values
                imshow(cvipImage);  %display input image in first sub-region
                title('Input Image');   %show title of input image in figure window
                
                % calls the threshold function
                [outputImage, time_taken] = threshold_lab(cvipImage);      %call threshold_lab function to perform threshold operation
                fprintf('The execution time was %f sec.\n\n', time_taken); %display execution time of threshold operation                   
                
                % display the resultant image
                subplot(1,2,2); %select second sub-region to plot
                imshow(outputImage); %display output image in second sub-region
                title('Thresholded Image'); %show title of output image in figure window
                
            % Other cases    
            otherwise
                fprintf('Sorry ! You Entered a wrong choice\n'); %display warning message for incorrect choice in command window
                
        end %end of switch
        
    end %end of while
	