function OutIma = polygon_cvip(ImSize,sides,radius,center,color,outline_color,varargin)
% POLYGON_CVIP - create images with various types of regular polygons
%                can be used to create shapes with holes in them.
%
%                Julian had this coded as an option, yet never actually
%                wrote the function. So this is an attempt to finish
%                whatever it is he wanted.
%  
% Syntax :
% ------
% OutIma = polygon_cvip(ImSize,sides,radius,center,color,varargin);
%   
% Input Parameters include :
% ------------------------
%   'ImSize'        2 element array dictating the size of the image                                
%   'sides'         The number of sides in the desired polygon
%   'radius'        The distance from the center location to each vertex
%   'center'        2 element array dictating the starting R and C
%   'color'         3 element array dictating the color of the polygon
%   'outline_color' 3 element array for optional outline color
%   
%   'varargin{1}'   If you want to place another polygon in the image
%                   load in a previously created polygon image here
%
%                   DONT USE ALL 1s AS THE COLOR
%
% Output Parameters include :
% -------------------------
%
%   'OutIma'        The created image with 1+ regular polygons
% 
%
% Example :
% -------
%                   OutIma = polygon_cvip([256 256],5,50,[100 100],[255 0 0],[0 255 0]);
%                   OutIma = polygon_cvip([256 256],3,20,[100 100],[0 0 255],[255 255 255],OutIma);
%                   figure('Name','Polygons');
%                   imshow(OutIma);
%  
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Joey Olden
%           Initial coding date:    9/23/2019
%           Update by:              Hridoy Biswas
%           Latest update date:     7/18/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

ImR = ImSize(1);    
ImC = ImSize(2);    

%handling creating an additional object with black as the color
if ~any(color)
    color = [1 1 1];
end

%choosing a outline color if defined by the user input
if ~isempty(outline_color)
    color_out = outline_color;
else 
    color_out = color;
end
%creating the color matrix for later ANDING (&)
color_out = cat(3,color_out(1).*ones(ImR,ImC),color_out(2).*ones(ImR,ImC),color_out(3).*ones(ImR,ImC));
color = cat(3,color(1).*ones(ImR,ImC),color(2).*ones(ImR,ImC),color(3).*ones(ImR,ImC));

%checking for boundary issues
%% Not Needed as it can create image from any center
% CMax = (radius + center(2)) > ImC;
% CMin = (center(2) - radius) < 0;
% RMax = (radius + center(1)) > ImR;
% RMin = (center(1) - radius) < 0;
% 
% if CMax || CMin || RMax || RMin
%     error('PLEASE choose a radius that remains within the image or change the starting location.');
% end
%%
%determinig the polygon properties
angle = (360/sides)*(pi/180);
length = 1:sides;
SR = center(1);
SC = center(2);
vertices = zeros(2,sides);
outline = zeros(ImR,ImC);

%creating the vertice angles based on the angle
if rem(sides,2) == 0
    length = length-.5;
    current_angle = (length.*angle)+1.5708;
else
    length = length-1;
    current_angle = (length.*angle)+1.5708;
end

%creating the vertice points based on the angle and radius
for xx = 1:sides

    col = round(radius*cos(current_angle(xx)));
    row = -round(radius*sin(current_angle(xx)));
    vertices(1,xx) = SR + row;
    if vertices(1,xx)<1    %% check for strating row
        vertices(1,xx)=1;
    end
    vertices(2,xx) = SC + col;
    if vertices(2,xx)<1    %% check for starting column
        vertices(2,xx)=1;
    end
    
    outline(SR+row>0,SC+col>0,:) = 1; %% make outline based on the condition
    
end

%adding the first to the last to complete the loop needed
vertices(1,sides+1) = vertices(1,1);
vertices(2,sides+1) = vertices(2,1);

%Creating lines that are edges from vertice to vertice
for xx = 1:sides
    
    r1 = ImR - vertices(1,xx);
    r2 = ImR - vertices(1,xx+1);
    c1 = vertices(2,xx);
    c2 = vertices(2,xx+1);
    
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
        outline(ImR-r1,c1:c_step:c2) = 1;
    %handling the case of undefined slope
    elseif slope == -Inf || slope == Inf
        outline(ImR-r1:-r_step:ImR-r2,c1) = 1;
    %handling regular slope
    else
        for rr = r1+r_step:r_step:r2-r_step
            new_c = round((rr-b)/slope);
            outline(ImR-rr,new_c) = 1;
        end
        
        for cc = c1+c_step:c_step:c2-c_step
            new_r = ImR - round(slope*cc + b);
            outline(new_r,cc) = 1;
        end
    end
        
end

%Filling the shape
%dont know how to explain all this ish
binary = outline > 0;
col_sum = sum(binary,2);
col_index = repmat(1:1:ImR,[ImR 1 1]).*binary;
col_index(col_index == 0) = NaN;
col_max = max(col_index,[],2);
col_min = min(col_index,[],2);
blank = zeros(ImR,ImC,3);

%actual loop that fills the shape
for yy = 1:ImC 
    if col_sum(yy,1,1) ~= 0
        blank(yy,col_min(yy,1):col_max(yy,1),:) = 1;
    end
end

%Addressing the outline color possibilty
if ~isempty(outline_color)
    X = xor(outline,blank);
    final = uint8(outline.*color_out+  X.*color);
else
    final = uint8(blank.*color);
end
    
%Possibly including another shape on top based on user input
if ~isempty(varargin)
    prior = uint8(varargin{1});
    intersection = ~(rgb2gray(prior) & rgb2gray(final));
    intersection = repmat(intersection,[1 1 3]);
    intersection = prior.*uint8(intersection);
    OutIma = intersection + final;
else
    OutIma = final;
end

OutIma(OutIma == 1) = 0;

end
