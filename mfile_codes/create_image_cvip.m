function OutIma = create_image_cvip(height, width, object, varargin)
% CREATE_IMAGE_CVIP - creates black or rgb color images according to given
% height and different geometry objects such as rectangles, circles and
% ellipses.
%
% Syntax :
% -------
% create_image_cvip(height, width, object, varargin)
% create_image_cvip(height, width, object, [rowini], [colini], [obj_height], [obj_width], [bands], [R], [G], [B])
%   
% Input Parameters include :
% ------------------------ 
%   'height'    Image height
%   'width'     Image width
%
%   'object':
% 
%     0  – Black               	----> bands = 0
%     1  – Gray/RGB Image    	----> bands = 1 or 3, Gray or R, G, B
%     2  – Line                	----> rowini, colini, rowend, colend, bands = 1 or 3, R, G, B
%     3  – Rectangle Outline	----> rowini, colini, rowend, colend, bands = 1 or 3, R, G, B
%     4  – Filled Rectangle    	----> rowini, colini, rowend, colend, bands = 1 or 3, R, G, B
%     5  – Filled Ellipse     	----> centerrow, centercol, hor_len, ver_len, bands = 1 or 3, R, G, B
%     6  – Filled Diamond     	----> centerrow, centercol, hor_len, ver_len, bands = 1 or 3, R, G, B
%     7  – Circle Outline      	----> centerrow, centercol, radius, bands = 1 or 3, R, G, B
%     8  – Filled Circle       	----> centerrow, centercol, radius, bands = 1 or 3, R, G, B
%     9  – Blur Circle         	----> centerrow, centercol, radius1, radius2, bands = 1 or 3, R, G, B
%     10 – Checkerboard        	----> startrow, startcol, rectheight, rectwidth, bands = 1 or 3, R, G, B
%     11 – Cosine Wave         	----> frequency, direction, bands = 1 or 3, R, G, B
%     12 – Sine Wave          	----> frequency, direction, bands = 1 or 3, R, G, B
%     13 – Square Wave         	----> frequency, direction, bands = 1 or 3, R, G, B
%     14 - Polygon              Using "polygon_cvip"
%                                
%
% Example 1 : Create a RGB (100, 50, 200) color Image
% ---------
%                   OutIma = create_image_cvip(256, 256, 1, 3, 100, 50, 200);
%                   figure, imshow(OutIma);
%                   title('RGB Image');
%                  
%
% Example 2 : Create a centered RGB Blurred Circle (200, 100, 40) color Image
% ---------
%                   OutIma = create_image_cvip(256, 256, 9, 128, 128, 50, 70, 3, 200, 100, 40);
%                   figure, imshow(OutIma);
%                   title('Blurred Circle');
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Julián René Cuellar Buriticá
%           Initial coding date:    02/27/2018
%           Latest update date:     04/30/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
 % Revision 1.3  01/11/2019  13:03:53  akarlap
 % 
%
 % Revision 1.2  04/30/2018  15:39:04  jucuell
 % outline objects and filled were setup help documentation was prepared
 % and final testing was performed.
%
 % Revision 1.1  02/27/2018  16:29:05  jucuell
 % Initial coding:
 % function creation and initil testing
%

switch object
    case 0  % Black Image
        %syntax = create_image_cvip(height, width, object=0, [bands=0])
        if (nargin ~= 4) || (varargin{1} ~= 0)
            error(['You should have 3 input arguments when object = ' ...
                num2str(object) ' and aditional argument must be equal to 0 for black image']);
        end
        OutIma= zeros(height, width);
        
    case 1  % RGB Image
        %syntax = create_image_cvip(height, width, object=1, [bands=3], [R], [G], [B])
%         if (nargin ~= 7) || (varargin{1} == 1)
%             error(['You should have 7 input arguments when object = ' ...
%                 num2str(object) ' and aditional argument must be equal to 3 for RGB image']);
%         end
        R = varargin{2};
        if varargin{1} == 1
            OutIma = uint8(R*ones(height, width));
        else
            G = varargin{3};
            B = varargin{4};
            OutIma = zeros(height, width, 3);
            OutIma(:,:,1) = uint8(R*ones(height, width));
            OutIma(:,:,2) = uint8(G*ones(height, width));
            OutIma(:,:,3) = uint8(B*ones(height, width));
        end
        
    case 2  %draw_line
        %syntax = create_image_cvip(height, width, object=2, [rowini], 
        %           [colini], [rowend], [colend],[bands], [R], [G], [B])
        if (nargin ~= 8) || ((varargin{5} == 2) || (varargin{5} > 3))
            if (nargin ~= 11) || ((varargin{5} == 2) || (varargin{5} > 3))
                error(['You should have at least 8 input arguments when object = ' ...
                    num2str(object) ' and aditional argument bands must be' ...
                    ' equal to 1 for monocrome or 3 for RGB outline object']);
            end

        end
        no_bands = varargin{5};
        tlx = varargin{2};
        tly = varargin{1};
        brx = varargin{4};
        bry = varargin{3};
        OutIma = zeros(width, height,no_bands);

        for i=1:no_bands
            if i == 1                       %R band Color
                if varargin{5} == 1
                    color = 255;              %monocrome outline
                else
                    color = varargin{6};    %color outline
                end
            elseif i == 2
                color=varargin{7};         %G band Color
            else
                color=varargin{8};         %B band Color
            end
            difx = brx-tlx;
            dify = bry-tly;
            if(difx==0)
                if(bry>=tly)
                    if(tly<1)
                        tly = 1;
                    end
                    if(bry >= height)
                        bry = height; 
                    end
                    for y=tly:bry
                        OutIma(y,tlx,i) = color;
                    end
                else 
                    if(bry<1)
                        bry = 1;
                    end
                    if(tly>=height)
                        tly = height;
                    end
                    for y=bry:tly
                        OutIma(y,tlx,i) = color;
                    end
                end
            
            elseif(dify == 0) 
                if(brx>=tlx)
                    if(tlx<1)
                        tlx = 1;
                    end
                    if(brx>=width)
                        brx = width;
                    end
                    for x=tlx:brx
                        OutIma(tly,x,i) = color;
                    end
        
                else 
                    if(brx<1)
                        brx = 1;
                    end
                    if(tlx>=width)
                        tlx = width;
                    end
                    for x=brx:tlx
                        OutIma(tly,x, i) = color;
                    end
                end
        
            elseif(dify>difx)
                namda = difx/dify;
                if(bry>=tly) 
                    for y=tly:bry
                        if(y>=0 && y<height)
                            move = uint8(namda*(y-tly))+tlx;
                            if (move>=0 && move<width)
                                OutIma(y,move,i) = color;
                            end
                        end
                    end
        
                else 
                    for y=bry:tly
                        if(y>=0 && y<height)
                            move = uint8(namda*(y-tly))+tlx;
                            if(move>=0 && move<width)
                                OutIma(y,move,i) = color;
                            end
                        end
                    end
                end
        
            else
                namda = dify/difx;
                if(brx>=tlx) 
                    for x=tlx:brx
                        if(x>=0 && x<width) 
                            move = uint8(namda*(x-tlx))+tly;
                            if(move>=0 && move<height)
                                OutIma(move,x,i) = color;
                            end
                        end
                    end
        
                else 
                    for x=brx:tlx
                        if(x>=0 && x<width)
                            move = uint8(namda*(x-tlx))+tly;
                            if(move>=0 && move<height)
                                OutIma(move,x,i) = color;
                            end
                        end
                    end
                end
            end
        end
    case 3  %Rectangle Outline
        %syntax = create_image_cvip(height, width, object=3, [rowini], 
        %           [colini], [obj_height], [obj_width],[bands], [R], [G], [B])
        if (nargin ~= 8) || ((varargin{5} == 2) || (varargin{5} > 3))
            if (nargin ~= 11) || ((varargin{5} == 2) || (varargin{5} > 3))
                error(['You should have at least 8 input arguments when object = ' ...
                    num2str(object) ' and aditional argument bands must be equal to' ...
                    ' 1 for monocrome or 3 for RGB outline object']);
            end
        end
        
        no_bands = varargin{5};
        tlx = varargin{2};
        tly = varargin{1};
        sqwidth = varargin{4};
        sqheight = varargin{3};
        OutIma = zeros(width, height,no_bands);
        
        for i=1:no_bands
            if i == 1                       %R band Color
                if varargin{5} == 1
                    color = 255;              %monocrome outline
                else
                    color = varargin{6};    %color outline
                end
            elseif i == 2
                color=varargin{7};         %G band Color
            else
                color=varargin{8};         %B band Color
            end
            xlimit = tlx + sqwidth;
            if (xlimit>width)
                xlimit = width;
            end
            ylimit = tly + sqheight;
            if(ylimit>height)
                ylimit = height;
            end
            for x=tlx:xlimit
                OutIma(tly,x,i) = color;
                OutIma(ylimit,x,i) = color;		
            end
            for y=tly+1:ylimit
                OutIma(y,tlx,i) = color;
                OutIma(y,xlimit,i) = color;		
            end
        end
        
    case 4  %FILLED RECTANGLE
        %syntax = create_image_cvip(height, width, object=4, [rowini], 
        %       [colini], [obj_height], [obj_width],[bands], [R], [G], [B])
        if (nargin ~= 8) || ((varargin{5} == 2) || (varargin{5} > 3))
            if (nargin ~= 11) || ((varargin{5} == 2) || (varargin{5} > 3))
                error(['You should have at least 8 input arguments when object = ' ...
                    num2str(object) ' and aditional argument bands must be equal to' ...
                    ' 1 for monocrome or 3 for RGB outline object']);
            end
        end
        no_bands = varargin{5};
        tlx = varargin{2};
        tly = varargin{1};
        sqwidth = varargin{4};
        sqheight = varargin{3};
        OutIma = zeros(width, height,no_bands);
        
        for i=1:no_bands
            if i == 1           %R band Color
                if varargin{5} == 1
                        color = 255;              %monocrome outline
                    else
                        color = varargin{6};    %color outline
                end
            elseif i == 2
                color=varargin{7};      %G band Color
            else
                color=varargin{8};      %B band Color
            end
            xlimit = tlx + sqwidth;
            if(xlimit>width)
                xlimit = width;
            end
            ylimit = tly + sqheight;
            if(ylimit>height)
                ylimit = height;
            end
            for y=tly:ylimit
                for x=tlx:xlimit
                    OutIma(y,x,i) = color;
                end
            end
        end
    case 5  %FILL ELLIPSE
        %syntax = create_image_cvip(height, width, object=5, [centerrow], 
        %   [centercol], [hor_length], [ver_length],[bands], [R], [G], [B])
        if (nargin ~= 8)
            if (nargin ~= 11) || ((varargin{5} == 2) || (varargin{5} > 3))
                error(['You should have at least 8 input arguments when object = ' ...
                    num2str(object) ' and aditional argument bands must be equal to' ...
                    ' 1 for monocrome or 3 for RGB outline object']);
            end
        end
        no_bands = varargin{5};
        centerrow = varargin{1};
        centercol = varargin{2};
        hor_length = varargin{3};
        ver_length = varargin{4};
        
        %convert horizontal length (hor_length) and vertical length
        %(ver_length) to a and b respectively. 
        hor_length = hor_length/2;
        ver_length = ver_length/2;
        %make sure a and b are not zero to prevent "Division by zero" error.
        
        if(hor_length < 1) 
            hor_length = 1;
        end
        if(ver_length < 1) 
            ver_length = 1;
        end
        OutIma = zeros(width, height,no_bands);
        for BandCount = 1:no_bands
            if BandCount == 1           %R band Color
                if varargin{5} == 1
                        color = 255;              %monocrome outline
                    else
                        color = varargin{6};    %color outline
                end
            elseif BandCount == 2
                color=varargin{7};      %G band Color
            else
                color=varargin{8};      %B band Color
            end
            for RowCount = 1:width
                d_RowParts = (RowCount-centerrow-1)/(ver_length);
                d_RowParts = d_RowParts * d_RowParts;
                % or rombo: 
                % d_RowParts = abs(RowCount-centerrow-1)/(ver_length);
                for ColCount = 1:height
                    d_ColParts = (ColCount-centercol-1)/(hor_length);
                    d_ColParts = d_ColParts * d_ColParts;
                    if(d_ColParts+d_RowParts <= 1)
                        OutIma(RowCount,ColCount,BandCount) = color;
                    end
                end
            end
        end
        
    case 6  %Filled Rhombus
        %syntax = create_image_cvip(height, width, object=5, [centerrow],
        %[centercol], [hor_length], [ver_length],[bands], [R], [G], [B]) 
        if (nargin ~= 8)
            if (nargin ~= 11) || ((varargin{5} == 2) || (varargin{5} > 3))
                error(['You should have at least 8 input arguments when object = ' num2str(object) ' and aditional argument bands must be equal to 1 for monocrome or 3 for RGB outline object']);
            end
        end
        no_bands = varargin{5};
        centerrow = varargin{1};
        centercol = varargin{2};
        hor_length = varargin{3};
        ver_length = varargin{4};
        
        %convert horizontal length (hor_length) and vertical length
        %(ver_length) to a and b respectively. 
        hor_length = hor_length/2;
        ver_length = ver_length/2;
        %make sure a and b are not zero to prevent "Division by zero" error.
        
        if(hor_length < 1) 
            hor_length = 1;
        end
        if(ver_length < 1) 
            ver_length = 1;
        end
        OutIma = zeros(width, height,no_bands);
        for BandCount = 1:no_bands
            if BandCount == 1           %R band Color
                if varargin{5} == 1
                        color = 255;              %monocrome outline
                    else
                        color = varargin{6};    %color outline
                end
            elseif BandCount == 2
                color=varargin{7};      %G band Color
            else
                color=varargin{8};      %B band Color
            end
            for RowCount = 1:width
                d_RowParts = abs(RowCount-centerrow-1)/(ver_length);
                for ColCount = 1:height
                    d_ColParts = abs(ColCount-centercol-1)/(hor_length);
                    if(d_ColParts+d_RowParts <= 1)
                        OutIma(RowCount,ColCount,BandCount) = color;
                    end
                end
            end
        end

    case 7  %DRAW CIRCLE
        %syntax = create_image_cvip(height, width, object=7, [centerrow],
        %[centercol], [radius], [bands], [R], [G], [B]) 
        if (nargin ~= 7)
            if (nargin ~= 10) || ((varargin{4} == 2) || (varargin{4} > 3))
                error(['You should have at least 8 input arguments when object = ' ...
                    num2str(object) ' and aditional argument bands must be equal to' ...
                    ' 1 for monocrome or 3 for RGB outline object']);
            end
        end
        no_bands = varargin{4};
        radius = varargin{3};
        centerx = varargin{2};	
        centery = varargin{1};	
        
        OutIma = zeros(width, height,no_bands);
        
        for i=1:no_bands
            if i == 1           %R band Color
                if varargin{4} == 1
                        color = 255;              %monocrome outline
                    else
                        color = varargin{5};    %color outline
                end
            elseif i == 2
                color=varargin{6};      %G band Color
            else
                color=varargin{7};      %B band Color
            end
            rsquare = radius^2;
            small_1 = round(centerx - radius*3/4);
            if(small_1<1)
                small_1 = 1;
            end
            big = round(centerx + radius*3/4);
            if(big>width)
                big = width;	
            end
            for x=small_1:big
                string = round(sqrt(rsquare-(x-centerx)^2));
                if(centery+string<=height)
                    OutIma(centery+string,x,i) = color;
                end
                if(centery-string>=0)
                    OutIma(centery-string,x,i) = color;
                end
            end
            small_1 = round(centery - radius*3/4);
            if(small_1<1)
                small_1 = 1;
            end
            big = round(centery + radius*3/4);
            if(big>height)
                big = height;
            end
            for y=small_1:big
                string = round(sqrt(rsquare-(y-centery)^2));
                if(centerx+string<=width)
                    OutIma(y,centerx+string,i) = color;
                end
                if(centerx-string>=0)
                    OutIma(y,centerx-string,i) = color;		
                end
            end
        end

    case 8  %paint_circle
        %     8 – Filled Circle             ----> centerrow, centercol,
        %     radius, bands = 1 or 3, R, G, B 
        if (nargin ~= 7)
            if (nargin ~= 10) || ((varargin{4} == 2) || (varargin{4} > 3))
                error(['You should have at least 8 input arguments when object = ' ...
                    num2str(object) ' and aditional argument bands must be equal to' ...
                    ' 1 for monocrome or 3 for RGB outline object']);
            end
        end
        
        no_bands = varargin{4};
        radius = varargin{3};
        centerx = varargin{2};	
        centery = varargin{1};	
        
        OutIma = zeros(width, height,no_bands);
        
        rsquare = radius^2;
        xsmall = centerx - radius;
        if(xsmall<1)
            xsmall = 1;
        end
        xbig = centerx + radius;
        if(xbig>width)
            xbig = width;
        end
        ysmall = centery - radius;
        if(ysmall<1)
            ysmall = 1;
        end
        ybig = centery + radius;
        if(ybig>height)
            ybig = height;
        end
        
        for i=1:no_bands
            if i == 1           %R band Color
                if varargin{4} == 1
                        color = 255;              %monocrome outline
                    else
                        color = varargin{5};    %color outline
                end
            elseif i == 2
                color=varargin{6};      %G band Color
            else
                color=varargin{7};      %B band Color
            end
            for x=xsmall:xbig
                for y=ysmall:ybig
                    if ((x-centerx)^2+(y-centery)^2)<=rsquare
                        OutIma(y,x,i)=color;
                    end
                end
            end
        end
        
    case 9  %BLUR_circle
        %syntax = create_image_cvip(height, width, object=5, [centerrow],
        %[centercol], [hor_length], [ver_length],[bands], [R], [G], [B]) 
        if (nargin ~= 8)
            if (nargin ~= 11) || ((varargin{5} == 2) || (varargin{5} > 3))
                error(['You should have at least 8 input arguments when object = ' ...
                    num2str(object) ' and aditional argument bands must be equal to' ...
                    ' 1 for monocrome or 3 for RGB outline object']);
            end
        end
        
        no_bands = varargin{5};
        radius1 = varargin{3};
        radius2 = varargin{4};
        centerx = varargin{2};	
        centery = varargin{1};	
        
        OutIma = zeros(width, height,no_bands);
        
        rsquare1 = radius1^2;
        if (radius2 <= radius1) 
            radius2 = radius1+1;
        end
        
        rsquare2 = radius2^2;
        xsmall = centerx - radius2;
        if(xsmall<1)
            xsmall = 1;
        end
        xbig = centerx + radius2;
        if(xbig> width)
            xbig = width;
        end
        ysmall = centery - radius2;
        if(ysmall<1)
            ysmall = 1;
        end
        ybig = centery + radius2;
        if(ybig>height)
            ybig = height;
        end
        
        for i=1:no_bands
            if i == 1           %R band Color
                if varargin{5} == 1
                        color = 255;              %monocrome outline
                    else
                        color = varargin{6};    %color outline
                end
            elseif i == 2
                color=varargin{7};      %G band Color
            else
                color=varargin{8};      %B band Color
            end
            for x=xsmall:xbig
                for y=ysmall:ybig
                    temp = (x-centerx)^2+(y-centery)^2;
                    if(temp<=rsquare1)
                        OutIma(y,x, i)=color;
                    elseif (temp <= rsquare2)
                        OutIma(y,x, i) = uint8(color * (radius2 - sqrt(temp)) ...
                            / (radius2 - radius1));
                    end
                end
            end
        end

    case 10 %CHECKBOARD
        %syntax = create_image_cvip(height, width, object=10, [startrow],
        %[startcol], [rectwidth], [rectwidth],[bands], [R], [G], [B]) 
        if (nargin ~= 8)
            if (nargin ~= 11) || ((varargin{5} == 2) || (varargin{5} > 3))
                error(['You should have at least 8 input arguments when object = ' ...
                    num2str(object) ' and aditional argument bands must be equal to' ...
                    ' 1 for monocrome or 3 for RGB object']);
            end
        end
        
        no_bands = varargin{5};
        firstx = varargin{2};
        firsty = varargin{1};
        blocky = varargin{4};
        blockx = varargin{3};

        OutIma = zeros(width, height,no_bands);
        
        dx = bitshift(blockx,1);
        dy = bitshift(blocky,1);
        
        for k=1:no_bands
            if k == 1           %R band Color
                if varargin{5} == 1
                        color = 255;              %monocrome outline
                    else
                        color = varargin{6};    %color outline
                end
            elseif k == 2
                color=varargin{7};      %G band Color
            else
                color=varargin{8};      %B band Color
            end
            for i=1:firsty    %fill first row
                for j=1:firstx
                    OutIma(i,j,k) = color;
                end

                for y=1:firsty
                    for x=(firstx+blockx):dx:width 
                        for j=1:blockx 
                            if (y+i<=height) && (x+j<=width)
                                OutIma(y,x+j,k) = color;
                            end
                        end
                    end
                end   
            end

                for y=firsty+blocky:dy:height    %fill first column
                    for x=1:firstx
                        for i=1:blocky
                            if(y+i<=height) && (x+j<=width)
                                OutIma(y+i,x,k) = color;	
                            end
                        end
                    end
                end

                for y=firsty:dy:height      %fill odd rows
                    for x=firstx:dx:width 
                        for i=1:blocky
                            for j=1:blockx
                                if (y+i<=height) && (x+j<=width)
                                    OutIma(y+i,x+j,k) = color;	
                                end
                            end
                        end
                    end
                end

                for y=firsty+blocky:dy:height     %fill even rows
                    for x=firstx+blockx:dx:width 
                        for i=1:blocky
                            for j=1:blockx 
                                if (y+i<=height) && (x+j<=width)
                                    OutIma(y+i,x+j,k) = color;	
                                end
                            end
                        end
                    end
                end
        end
        
    case 11                         %Cosine Wave
        % ----> frequency, direction, bands = 1 or 3, R, G, B
        if (nargin ~= 6)
            if (nargin ~= 9) || ((varargin{3} == 2) || (varargin{3} > 3))
                error(['You should have at least 6 input arguments when object = ' ...
                    num2str(object) ' and aditional argument bands must be equal to' ...
                    ' 1 for monocrome or 3 for RGB object']);
            end
        end
        if varargin{2} == 1         %horizontal
            x = 0:1:width-1;
            ysin=0.5+0.5*cos(2*pi*varargin{1}*x/width); 
            OutIma=repmat(ysin,height,1);            %create a matrix with values
        else                        %vertical
            x = 0:1:height-1;
            ysin=0.5+0.5*cos(2*pi*varargin{1}*x/height); 
            OutIma=repmat(ysin',1,width);            %create a matrix with values
        end
        if varargin{3} == 1         %B/W image
            OutIma = OutIma*255;
        else                        %color image
            tIma = zeros(height,width,3);
            tIma(:,:,1) = OutIma*varargin{4};
            tIma(:,:,2) = OutIma*varargin{5};
            tIma(:,:,3) = OutIma*varargin{6};
            OutIma = tIma;
        end
        
    case 12                         %Sine Wave
        % ----> frequency, direction, bands = 1 or 3, R, G, B
        if (nargin ~= 6)
            if (nargin ~= 9) || ((varargin{3} == 2) || (varargin{3} > 3))
                error(['You should have at least 6 input arguments when object = ' ...
                    num2str(object) ' and aditional argument bands must be equal to' ...
                    ' 1 for monocrome or 3 for RGB object']);
            end
        end
        if varargin{2} == 1         %horizontal
            x = 0:1:width-1;
            ysin=0.5+0.5*sin(2*pi*varargin{1}*x/width); 
            OutIma=repmat(ysin,height,1);            %create a matrix with values
        else                        %vertical
            x = 0:1:height-1;
            ysin=0.5+0.5*sin(2*pi*varargin{1}*x/height); 
            OutIma=repmat(ysin',1,width);            %create a matrix with values
        end
        if varargin{3} == 1         %B/W image
            OutIma = OutIma*255;
        else                        %color image
            tIma = zeros(height,width,3);
            tIma(:,:,1) = OutIma*varargin{4};
            tIma(:,:,2) = OutIma*varargin{5};
            tIma(:,:,3) = OutIma*varargin{6};
            OutIma = tIma;
        end
        
    case 13                         %Square Wave
        % ----> frequency, direction, bands = 1 or 3, R, G, B
        if (nargin ~= 6)
            if (nargin ~= 9) || ((varargin{3} == 2) || (varargin{3} > 3))
                error(['You should have at least 6 input arguments when object = ' ...
                    num2str(object) ' and aditional argument bands must be equal to' ...
                    ' 1 for monocrome or 3 for RGB object']);
            end
        end
        if varargin{2} == 1         %horizontal
            num = round(width/varargin{1});
            ysin = [ones(1,round(num/2)) zeros(1,round(num/2))]; 
            ytem = repmat(ysin, 1, varargin{1});
            if size(ytem,2) > width
                ysin = ytem(1:width);
            elseif size(ytem,2) < width
                ysin = zeros(1,width);
                ysin(1:size(ytem,2)) = ytem;
            else
                ysin = ytem;
            end
            OutIma=repmat(ysin,height,1);%create a matrix with values
        else                        %vertical
            num = round(height/varargin{1});
            ysin = [ones(1,round(num/2)) zeros(1,round(num/2))]; 
            ytem = repmat(ysin, 1, varargin{1});
            if size(ytem,2) > height
                ysin = ytem(1:height);
            elseif size(ytem,2) < height
                ysin = zeros(1,height);
                ysin(1:size(ytem,2)) = ytem;
            else
                ysin = ytem;
            end
            OutIma=repmat(ysin',1,width);%create a matrix with values
        end
        if varargin{3} == 1         %B/W image
            OutIma = OutIma*255;
        else                        %color image
            tIma = zeros(height,width,3);
            tIma(:,:,1) = OutIma*varargin{4};
            tIma(:,:,2) = OutIma*varargin{5};
            tIma(:,:,3) = OutIma*varargin{6};
            OutIma = tIma;
        end
        
    otherwise
        error('object should be a number btween 0-10');
end

OutIma=uint8(OutIma);
end