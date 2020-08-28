function [OutIma] = hough_inverse_cvip(Hough_Image,RC_cell,LP)
% HOUGH_INVERSE_CVIP - returns the inverse hough image based on the input
%                      parameters
%
% Syntax :
% --------
% [OutIma] = hough_inverse_cvip(Hough_Image,RC_cell,LP)
%   
% Input Parameters include :
% --------------------------
%
%  'Hough_Image'    The output image from the hough transform
%                  
%  'RC_cell'        The output cell from the hough transform containing the 
%                   RC coordinates of each pixel in a specific rho-theta
%                   box
%
%  'LP'         	A single value determining the amount of pixels needed
%                   in each rho-theta box to constitute a line
%
% Output Parameter include :  
% --------------------------
%
%   'OutIma'        The outputted inverse hough image 
%
% Example :
% -------
%                   [Hough_Image,RC_cell] =
%                   hough_transform_cvip(imread('cameraman.tif',[0 1
%                   45],1);
%                   LP = 20;
%                   [OutIma] = hough_inverse_cvip(Hough_Image,RC_cell,LP);
%                   figure;imshow(OutIma);
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Joey Olden
%           Initial coding date:    05/13/2020
%           Latest update date:     06/08/2020
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

%THIS FUNCTION PRODUCES THE INVERSE HOUGH IMAGE
%removing the theta_range header of the input cells
theta_range = RC_cell{1,1,1};
ImageSize = RC_cell{2,1,1};
RC_cell(1:2,:,:) = [];
xI = ImageSize(1);  yI = ImageSize(2);

%findin the size of the Hough Image and RC_cell
[xH,yH,zH] = size(Hough_Image);

%filtering the Hough_Image based on the Line_Pixels user input
Hough_Image(Hough_Image < LP) = 0;

%filtering the RC coordinates based on the Line_Pixels user input
%I def copied this, dont be impressed
Valid_RC = cellfun(@times,RC_cell,num2cell(double(logical(Hough_Image))),'UniformOutput', false);

%removing the zero portions of the cell for the line drawing process
for zz = 1:zH
    for xx = xH:-1:1
        for yy = 1:yH
            if ~isempty(Valid_RC{xx,yy,zz}) && ~any(any(Valid_RC{xx,yy,zz}))
                Valid_RC{xx,yy,zz} = [];
            end
        end
    end
end

%determining the end points used to draw the lines
for zz = 1:zH
    for yy = 1:yH
        
        slope = tan(theta_range(1,yy));

        for xx = 1:xH
            
            if ~isempty(Valid_RC{xx,yy,zz})
                Coordinates = Valid_RC{xx,yy,zz};
                [xC,~,~] = size(Coordinates);
                
                %determining rows based on end col and first col
                row_R = round(-slope.*(yI - Coordinates(:,2)) + Coordinates(:,1));
                row_R = cat(2,row_R,yI.*ones(xC,1));
                row_L = round(-slope.*(1 - Coordinates(:,2)) + Coordinates(:,1));
                row_L = cat(2,row_L,ones(xC,1));
                row = cat(1,row_L,row_L,row_R,row_R);
                row(row > xI) = 0;
                %determining columns based on end row and first row
                col_B = round(((xI - Coordinates(:,1))/-slope) + Coordinates(:,2));
                col_B = cat(2,xI.*ones(xC,1),col_B);
                col_T = round(((1 - Coordinates(:,1))/-slope) + Coordinates(:,2));
                col_T = cat(2,ones(xC,1),col_T);
                col = cat(1,col_T,col_B,col_T,col_B);
                col(col > yI) = 0;
                
                %creating the same type pair cases to add
                extra_row = cat(2,row_L,row_R);
                extra_row(extra_row > xI) = 0;
                extra_col = cat(2,col_T,col_B);
                extra_col(extra_col > yI) = 0;
                                
                %creating the final array of all possible pair combos
                Point = cat(1,cat(2,row,col),extra_row,extra_col);
                Point(Point < 0) = 0;
                Point(isnan(Point)) = 0;
                %removing duplicate points
                for dd = 1:xC*5
                    if isequal(Point(dd,1:2),Point(dd,3:4))
                        Point(dd,1) = 0;
                    end
                end
                Point = Point(all(Point,2),:);
                Point = unique(Point,'rows');
                                
                Valid_RC{xx,yy,zz} = Point;
                
            end
        end 
    end
end

%drawing the lines based on the determined endpoints
OutIma = zeros(xI,yI,zH);
for zz = 1:zH
    for yy = 1:yH
        for xx = 1:xH
            
            %checking to see if the cell has valid endpoints
            if ~isempty(Valid_RC{xx,yy,zz})
                End_Points = Valid_RC{xx,yy,zz};
                [xE,~,~] = size(End_Points);

                %last minute fail safe to remove bad points
                test_slope = (End_Points(:,3) - End_Points(:,1)) ./ (End_Points(:,4) - End_Points(:,2));
                non_outlier = rmoutliers(test_slope);
                non_mean = mean(non_outlier);
                non_STD = std(non_outlier);
                
                %removing points based on non-outlier std
                for bad = xE:-1:1
                    if abs(test_slope(bad,1)-non_mean) > non_STD
                        End_Points(bad,:) = [];
                    end
                end
                
                [xE,~,~] = size(End_Points);
                %looping through each pair of points in the extracted array
                for ee = 1:xE
                    
                    %extracting the end points for the line
                    r1 = End_Points(ee,1);
                        if r1 == xI
                            r1 = xI - 1;
                        end
                    r2 = End_Points(ee,3);
                        if r2 == xI
                            r2 = xI - 1;
                        end
                    c1 = End_Points(ee,2);
                    c2 = End_Points(ee,4);
                    
                    %slope and y intercept
                    slope = (r2-r1)/(c2-c1);
                    b = r1 - slope*c1;
                                    
                    %Determining the direction of the row loop
                    if (r1-r2) < 0
                        r_step = 1;
                    else
                        r_step = -1;
                    end

                    %Determining the direction of the column loop
                    if (c1-c2) < 0
                        c_step = 1;
                    else
                        c_step = -1;
                    end

                    %Creating the pixels along the line of the edge of the polygon
                    %handling the case of no slope
                    if slope == 0 
                        OutIma(xI-r1,c1:c_step:c2,zz) = 1;
                    %handling the case of undefined slope
                    elseif slope == -Inf || slope == Inf
                        OutIma(xI-r1:-r_step:xI-r2,c1,zz) = 1;
                    %handling regular slope
                    else
                        R = (r1:r_step:r2)';
                        R(R == xI) = xI-1;
                        C = (c1:c_step:c2)';
                        new_r = xI - round(slope*C + b);
                        new_r(new_r <= 0) = 1;
                        new_r(new_r > xI) = xI;
                        new_c = round((R-b)/slope);
                        new_c(new_c <= 0) = 1;
                        new_c(new_c > yI) = yI;
                        
                        new = cat(1,cat(2,new_r,C),cat(2,xI-R,new_c));
                        
                        for oo = 1:size(new,1)
                            OutIma(new(oo,1),new(oo,2),zz) = 1;
                        end
                    end
                    
                end
                
            end
            
        end
    end
end

%flipping the output image to be oriented correctly
OutIma = flipud(OutIma);

end

