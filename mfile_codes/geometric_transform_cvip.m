%Geomtric Transform Function for CVIPtools Matlab TOOLBOX
function [OutIma,fhm,fho] = geometric_transform_cvip(InIma,direction,option,method,mesh_size_r,mesh_size_c,scale,save)
%Geometric Transform Function
    %Attempts to restore image to estimation of original
    %After image has undergone geometric transformation
    %Pixel values are not changed, Pixel Location is changed
    %Warped, Stretched, Disformed, "Transformed"
    %Can Create Distorted Image "Irregular Image"
    %Can Restore Distorted Image to estimation of Original Image
    %
    %InIma                InputImage Selected by user REQUIRED
    %direction            Determines Reg ->  Irreg / Irreg -> Reg REQUIRED
    %                     1: Regular -> Irregular
    %                     2: Irregular -> Regular
    %option               Determines the 3 different ways for a mesh to be
    %                     created REQUIRED
    %                     1: Create New Mesh by Hand
    %                     2: Load in an Existing Mesh File
    %                     3: Creates a Random Mesh
    %method               Determines the Gray Level Interpolation Method
    %                     used in the mapping process REQUIRED
    %                     1: Nearest Neighbor
    %                     2: Neighborhood Average
    %                     3: Bilinear Interpolation
    %mesh_size_r          number of meshes along a row REQUIRED
    %                     can be [] with Irregular -> Regular
    %mesh_size_c          number of meshes along a column REQUIRED
    %                     can be [] with Irregular -> Regular
    %scale                A measure of how distorted an image will become
    %                     when using the random mesh generator
    %                     small is worse, large is closer to original
    %                     can be [] if not using random mesh
    %save                 Determines whether or not to save the mesh
    %                     0: Does not save
    %                     [] Also does not save 
    %                     1: Saves the mesh to a file
    %
    %OutIma               OutputImage, depending upon the previous options
    %                     could be either a distorted/restored image
    %Fhm                  Figure handle for the figure showing the mesh
    %Fho                  Figure hadnle for the figure showing the output
    %                     !These three(Fhm,Fho,GUI) are really only necessary for the
    %                     GUI!
    %
    %==========================================================================
    %
    %           Author:                 Joey Olden
    %           Initial coding date:    05/22/2019
    %           Latest update date:     09/10/2019
    %           Credit:                 Scott Umbaugh 
    %                                   CVIP Lab, SIUE
    %           Copyright (C) 2017-2018 Scott Umbaugh and SIUE
    %
    %==========================================================================
    
    %regular grid is needed and created regardless of users choices
    reg_grid_TP = regular_grid(InIma,mesh_size_r,mesh_size_c);
    
    %Creating the tie_points based on the users choices
    if option == 1
        [tie_points,fhm] = hand_draw_mesh(InIma,mesh_size_r,mesh_size_c);
    elseif option == 2
        tie_points = load_mesh_file(InIma);
        fhm = draw_mesh(InIma,tie_points);
    else
        tie_points = random_mesh(InIma,mesh_size_r,mesh_size_c,reg_grid_TP,scale);
        fhm = draw_mesh(InIma,tie_points);
    end
    
    %Creating the Regular/Irregular Image based on direction
    if direction == 1
        [kr_total,kc_total] = k_equation_solve(tie_points,reg_grid_TP);
    else
        [kr_total,kc_total] = k_equation_solve(reg_grid_TP,tie_points);
    end
    
    %Performing the Gray Level Interpolation based on the users choice
    if method == 1
        [OutIma,fho] = nearest_neighbor(InIma,reg_grid_TP,kr_total,kc_total,direction);
    elseif method == 2
        [OutIma,fho] = neighborhood_average(InIma,reg_grid_TP,kr_total,kc_total,direction);  
    else
        [OutIma,fho] = bilinear_interp(InIma,reg_grid_TP,kr_total,kc_total,direction);
    end
    
    %Saving or not based on users choice
    if save == 1
        save_mesh_to_file(InIma,tie_points);
    end

%% Bunch of functions that do different ish

%Updates the Window from cursordata to show row and column coordinates only
function [output_position] = real_time_update(~,event_obj)
    %changes the window in the figure to show row and column
    %changes from x and y to r and c
    %updates in real time after a click(selection of point)
    %
    % ~                   Not using for any purpose
    % event_obj           Object with event data structure
    %
    % output_position     Data Cursor information
    
    pos = get(event_obj, 'Position');
    output_position = {['r:' num2str(pos(2))] ['c:' num2str(pos(1))]};

end

%Creates the regular grid of the input image
function [reg_grid_TP] = regular_grid(InIma,mesh_size_r,mesh_size_c)
    %creates the regular grid needed during the process
    %based on the user defined mesh size
    %
    %InIma                InputImage Selected by the user
    %mesh_size_r          number of rows in the mesh
    %mesh_size_c          number of columns in the mesh
    %
    %reg_grid_TP          grid of regular portions created
    
    [xI,yI,~] = size(InIma);
    quad_div_r = floor(xI/mesh_size_r);
    quad_div_c = floor(yI/mesh_size_c);
    reg_grid_TP = zeros(mesh_size_r+1,mesh_size_c+1,2);

    for xx = 1:mesh_size_r+1
        for yy = 1:mesh_size_c+1
              
            reg_grid_TP(xx,yy,1) = (xx-1)*quad_div_r;
            reg_grid_TP(xx,yy,2) = (yy-1)*quad_div_c;
                   
        end
    end
    
    reg_grid_TP(reg_grid_TP <= 0) = 1;
    reg_grid_TP(reg_grid_TP(:,:,1) > xI) = xI-1;
    reg_grid_TP(reg_grid_TP(:,:,2) > yI) = yI-1;
    
end

%Creates A Randomly Generated Mesh
function[tie_points] = random_mesh(InIma,mesh_size_r,mesh_size_c,reg_grid_TP,scale)
    %Generates a mesh randomly
    %rather than having the user define
    %more for testing and development purposes
    %offers a faster process with the same results as a user defined
    %
    %InIma                InputImage Selected by the user
    %mesh_size_r          number of rows in the mesh
    %mesh_size_c          number of columns in the mesh
    %scale                a value of how similar to original,small is worse
    %
    %tie_points           tie_points needed for warping
    
    [xI,yI,~] = size(InIma);
    div_horz = floor(floor(yI/(mesh_size_c*scale))/2);
    div_vert = floor(floor(xI/(mesh_size_r*scale))/2);

    tie_points = zeros(mesh_size_r+1,mesh_size_c+1,2);
    
    for xx = 1:mesh_size_r+1
        for yy = 1:mesh_size_c+1
            
            center_point_r = reg_grid_TP(xx,yy,1);
            center_point_c = reg_grid_TP(xx,yy,2);
            
            range_row_low = center_point_r - div_vert;
            range_row_low(range_row_low <= 0) = reg_grid_TP(xx,yy,1);
            range_row_high = center_point_r + div_vert;
            range_row_high(range_row_high >= xI) = reg_grid_TP(xx,yy,1);
            range_col_low = center_point_c - div_horz;
            range_col_low(range_col_low <= 0) = reg_grid_TP(xx,yy,2);
            range_col_high = center_point_c + div_horz;
            range_col_high(range_col_high >= yI) = reg_grid_TP(xx,yy,2);
            
            tie_points(xx,yy,1) = randi([range_row_low range_row_high],1,1);
            tie_points(xx,yy,2) = randi([range_col_low range_col_high],1,1);

        end
    end    
end

%Writes the mesh to a file and returns nothing
function [] = save_mesh_to_file(InIma,tie_points)
    %Writes the recently created mesh to a file
    %Saving as percentages/scaled rather than pixel locations
    %Helps ensure the mesh will work across different sized images
    %
    %InaIma               InputImage Selected by user
    %tie_points           tie_points generated either by user or random
    %
    %NO OUTPUT
    
    [xI,yI,~] = size(InIma);
    [xT,~,~] = size(tie_points);
    tie_points(:,:,1) = tie_points(:,:,1)./xI;
    tie_points(:,:,2) = tie_points(:,:,2)./yI;
    
    tie_points_cat = cat(1,tie_points(:,:,1),zeros(1,xT),tie_points(:,:,2));
   
    [filename,path] = uiputfile('Mesh_File_0.txt');
    dlmwrite(strcat(path,filename),tie_points_cat);
    
end

%loads in a mesh file as the tie_points
function [tie_points] = load_mesh_file(InIma)
    %loads a previously created mesh file
    %becomes the tie_points matrix to be used in the process
    %simply loads as tie_points
    %use other functions to draw, warp, and etc...
    %
    %InIma                InputImage Selected by user
    %
    %tie_points           tie_points needed for warping
    
    [filename,path] = uigetfile;
    saved_file = load(strcat(path,filename));
    [xI,yI,~] = size(InIma);
   
    row_sum = sum(saved_file,2);
    [~,ind] = min(row_sum);
    
    tie_points(:,:,1) = saved_file(1:ind-1,:);
    tie_points(:,:,2) = saved_file(ind+1:end,:);
    tie_points(:,:,1) = round(tie_points(:,:,1).*xI);
    tie_points(:,:,2) = round(tie_points(:,:,2).*yI);

end

%Draws the mesh on the input image
function[fhm] = draw_mesh(InIma,tie_points)
    %will draw the mesh on the input image
    %based on the tie_points
    %either random tie_points or user defined
    %
    %InIma            InputImage Selected by user
    %tie_points       tie_point matrix / can be random generated or user
    %
    %fhm              Figure handle for output figure
    
    
    fhm = figure('Name','Input');
    imshow(InIma);
    hold on;
    [tp_r,tp_c,~] = size(tie_points);
    
    for xx = 1:tp_r
        for yy = 1:tp_c

            %Purely horixontal Plotting on first row of mesh
            if xx == 1 && yy ~= 1
                p = plot([tie_points(xx,yy,2) tie_points(xx,yy-1,2)] , [tie_points(xx,yy,1) tie_points(xx,yy-1,1)]);
                p.Color = 'red';
                p.LineWidth = 1.75;
            end

            %Purely Vertical Plotting on first column of mesh
            if xx ~= 1 && yy == 1
                p = plot([tie_points(xx,yy,2) tie_points(xx-1,yy,2)] , [tie_points(xx,yy,1) tie_points(xx-1,yy,1)]);
                p.Color = 'red';
                p.LineWidth = 1.75;
            end

            %Combination of Horizontal and Vertical Plotting of mesh
            if xx~= 1 && yy ~= 1
                p_horz = plot([tie_points(xx,yy,2) tie_points(xx,yy-1,2)] , [tie_points(xx,yy,1) tie_points(xx,yy-1,1)]);
                p_vert = plot([tie_points(xx,yy,2) tie_points(xx-1,yy,2)] , [tie_points(xx,yy,1) tie_points(xx-1,yy,1)]);
                p_horz.Color = 'red';
                p_horz.LineWidth = 1.75;
                p_vert.Color = 'red';
                p_vert.LineWidth = 1.75;
            end

    %         %Plotting Circles at each intersection
    %         p1 = plot(tie_points(xx,yy,2) , tie_points(xx,yy,1),'o');
    %         set(p1,'MarkerEdgeColor','red');
    %         set(p1,'MarkerFaceColor','red');
    %         p1.MarkerSize = 7;

        end  
    end

    hold off;
    
end

%solves the mapping equations for k values 
function[kr_total,kc_total] = k_equation_solve(tie_points,reg_grid_TP)
    %solves the mapping equations for the k values
    %based on the regular grid and tie-points
    %
    %tie_points       tie_points from user or random
    %reg_grid_TP      regular grid from the function regular_grid
    %
    %kr_total         3D matrix of kr values for each grid
    %kc_total         3D matric of kc values for each grid
                     
    [tp_r,tp_c,~] = size(tie_points);
    kr_total = zeros(tp_r-1,tp_c-1,4);
    kc_total = zeros(tp_r-1,tp_c-1,4);

    for xx = 1:tp_r-1
        for yy = 1:tp_c-1
            
            A = [reg_grid_TP(xx,yy,1) reg_grid_TP(xx,yy,2) reg_grid_TP(xx,yy,1)*reg_grid_TP(xx,yy,2) 1;
                reg_grid_TP(xx,yy+1,1) reg_grid_TP(xx,yy+1,2) reg_grid_TP(xx,yy+1,1)*reg_grid_TP(xx,yy+1,2) 1;
                reg_grid_TP(xx+1,yy,1) reg_grid_TP(xx+1,yy,2) reg_grid_TP(xx+1,yy,1)*reg_grid_TP(xx+1,yy,2) 1;
                reg_grid_TP(xx+1,yy+1,1) reg_grid_TP(xx+1,yy+1,2) reg_grid_TP(xx+1,yy+1,1)*reg_grid_TP(xx+1,yy+1,2) 1];

            Br = [tie_points(xx,yy,1);
                tie_points(xx,yy+1,1);
                tie_points(xx+1,yy,1);
                tie_points(xx+1,yy+1,1)];                    
            Bc = [tie_points(xx,yy,2);
                tie_points(xx,yy+1,2);
                tie_points(xx+1,yy,2);
                tie_points(xx+1,yy+1,2)];

            kr = pinv(A)*Br;
            kc = pinv(A)*Bc;
            
            kc_total(xx,yy,:) = reshape(kc,[1 1 4]);
            kr_total(xx,yy,:) = reshape(kr,[1 1 4]);
                                            
        end
    end
    
end

%lets the user draw their own mesh
function[tie_points,fhm] = hand_draw_mesh(InIma,mesh_size_r,mesh_size_c)
    %Different than draw_mesh
    %draw_mesh operates with having the tie_points already
    %hand_draw_mesh creates the tie_points from user input
    %
    %mesh_size_r      number of mesh rows
    %mesh_size_c      number of mesh columns
    %
    %tie_points       tie_points needed to warp image
    %fhm              Figure handle for output figure

    fhm = figure('Name','Hand Drawn Mesh');
    imshow(InIma);
    datacursormode on
    dcm_obj = datacursormode(fhm);
    dcm_obj.DisplayStyle = 'window';
    dcm_obj.SnapToDataVertex = 'on';
    hold on;
    set(dcm_obj,'UpdateFcn',@real_time_update);

    count = 0;
    tie_points = zeros(mesh_size_r+1,mesh_size_c+1,2);
     
    %Generates the ViewOnly Mesh on top of the image
    for xx = 1:mesh_size_r+1
        for yy = 1:mesh_size_c+1

                if yy == 1
                    changing_title = title(sprintf('You have %3.0f / %3.0f Tie-Points. \nPlease begin a new row.',count...
                    ,(mesh_size_r+1)*(mesh_size_c+1)));
                else
                    changing_title = title(sprintf('You have placed %3.0f / %3.0f Tie-Points.',count,(mesh_size_r+1)*(mesh_size_c+1)));
                end
                set(changing_title,'FontWeight','Bold');
                
        waitforbuttonpress;
        data = getCursorInfo(dcm_obj);
        point = data.Position;
        tie_points(xx,yy,1) = point(2);
        tie_points(xx,yy,2) = point(1);
                       
            %Purely horixontal Plotting on first row of mesh
            if xx == 1 && yy ~= 1
                p = plot([tie_points(xx,yy,2) tie_points(xx,yy-1,2)] , [tie_points(xx,yy,1) tie_points(xx,yy-1,1)]);
                p.Color = 'red';
                p.LineWidth = 1.75;
            end

            %Purely Vertical Plotting on first column of mesh
            if xx ~= 1 && yy == 1
                p = plot([tie_points(xx,yy,2) tie_points(xx-1,yy,2)] , [tie_points(xx,yy,1) tie_points(xx-1,yy,1)]);
                p.Color = 'red';
                p.LineWidth = 1.75;
            end

            %Combination of Horizontal and Vertical Plotting of mesh
            if xx ~= 1 && yy ~= 1
                p_horz = plot([tie_points(xx,yy,2) tie_points(xx,yy-1,2)] , [tie_points(xx,yy,1) tie_points(xx,yy-1,1)]);
                p_vert = plot([tie_points(xx,yy,2) tie_points(xx-1,yy,2)] , [tie_points(xx,yy,1) tie_points(xx-1,yy,1)]);
                p_horz.Color = 'red';
                p_horz.LineWidth = 1.75;
                p_vert.Color = 'red';
                p_vert.LineWidth = 1.75;
            end

%             %Plotting Circles at each intersection
%             p1 = plot(tie_points(xx,yy,2) , tie_points(xx,yy,1),'o');
%             set(p1,'MarkerEdgeColor','red');
%             set(p1,'MarkerFaceColor','red');
%             p1.MarkerSize = 7;

        count = count + 1;

        end  
    end

    changing_title = title(sprintf('You Have Placed All The Tie-Points.'));
    set(changing_title,'FontWeight','Bold');   
  
end

%Nearest Neighbor method for non-integer location values
function [OutIma,fho] = nearest_neighbor(InIma,reg_grid_TP,kr_total,kc_total,direction)
    %Nearest neighbor rounds non-integer pixels
    %rounds in all four directions
    %assigns pixel to  four corners of non-integer location
    %could be overidden later with lower error value
    %should assign pixel with closest to integer value 
    %
    %InIma            InputImage selected by user
    %reg_grid_TP      regular grid of tie_points
    %kr_total         3D matrix of k values for row equations
    %kc_total         3D matrix of k values for column equations
    %direction        indicates Irregular to Regular, vice versa
    %
    %OutIma           OutIma as final product
    %fho              Figure handle for output figure
    
    [tp_r,tp_c,~] = size(reg_grid_TP);
    [xI,yI,zI] = size(InIma);
    Error_Matrix = (InIma.*0) + 2;
     
    if direction == 2
        OutIma = NaN(xI,yI,zI);
    else 
        OutIma = 0.*InIma;
    end
    
    for xx = 1:tp_r-1
        for yy = 1:tp_c-1
            for zz = 1:zI
                for rr = reg_grid_TP(xx,yy,1):reg_grid_TP(xx+1,yy,1)
                    for cc = reg_grid_TP(xx,yy,2):reg_grid_TP(xx,yy+1,2)

                        R = kr_total(xx,yy,1)*rr + kr_total(xx,yy,2)*cc + kr_total(xx,yy,3)*rr*cc + kr_total(xx,yy,4);
                        C = kc_total(xx,yy,1)*rr + kc_total(xx,yy,2)*cc + kc_total(xx,yy,3)*rr*cc + kc_total(xx,yy,4);

                        R_error_up = abs(ceil(R) - R);
                        R_error_down = abs(R - floor(R));
                        C_error_up = abs(ceil(C) - C);
                        C_error_down = abs(C - floor(C));

                        Ru = abs(ceil(R)) + 1;
                        Ru(Ru > xI) = xI;
                        Cu = abs(ceil(C)) + 1;
                        Cu(Cu > yI) = yI;
                        Rd = abs(floor(R)) + 1;
                        Rd(Rd > xI) = xI;
                        Cd = abs(floor(C)) + 1;
                        Cd(Cd > yI) = yI;

                        if (R_error_down + C_error_down) <= Error_Matrix(Rd,Cd,zz)
                            OutIma(Rd,Cd,zz) = InIma(rr,cc,zz);
                            Error_Matrix(Rd,Cd,zz) = (R_error_down + C_error_down);
                        end

                        if(R_error_down + C_error_up) <= Error_Matrix(Rd,Cu,zz)
                            OutIma(Rd,Cu,zz) = InIma(rr,cc,zz);
                            Error_Matrix(Rd,Cu,zz) = (R_error_down + C_error_up);
                        end

                        if (R_error_up + C_error_down) <=  Error_Matrix(Ru,Cd,zz)
                            OutIma(Ru,Cd,zz) = InIma(rr,cc,zz);
                            Error_Matrix(Ru,Cd,zz) = (R_error_up + C_error_down);
                        end

                        if (R_error_up + C_error_up) <= Error_Matrix(Ru,Cu,zz)
                            OutIma(Ru,Cu,zz) = InIma(rr,cc,zz);
                            Error_Matrix(Ru,Cu,zz) = (R_error_up + C_error_up);
                        end

                        OutIma(Rd:Ru,Cd:Cu,zz) = InIma(rr,cc,zz);
                        
                    end
                end
            end
        end       
    end
    
    if direction == 2
        duh_NaN = isnan(OutIma);
        for zz = 1:zI
            for ii = 2:xI-1
                for jj = 2:yI-1
                    if duh_NaN(ii,jj,zz) == 0
                        selection = OutIma(ii-1:ii+1,jj-1:jj+1,zz);
                        selection(isnan(selection)) = [];
                        OutIma(ii,jj,zz) = round(mean(nonzeros(selection)));
                    end
                end
            end
        end
    end
    
    OutIma = uint8(OutIma);
    fho = figure('Name','Output');
    imshow(uint8(OutIma));
    
end

%Neighborhood Average method for non-integer location values
function [OutIma,fho] = neighborhood_average(InIma,reg_grid_TP,kr_total,kc_total,direction)
    %neighborhood average to assign non-integer pixel location values
    %neighborhood avergaes the 4 surrounding pixels for the output value
    %also uses some nearest neighbor logic with location assignment
    %
    %InIma            InputImage selected by user
    %reg_grid_TP      regular grid of tie_points
    %kr_total         3D matrix of k values for row equations
    %kc_total         3D matrix of k values for column equations
    %direction        indicates irregular to regular / vice versa
    %
    %OutIma           OutIma as final product
    %fho              Figure handle for output figure
           
    [tp_r,tp_c,~] = size(reg_grid_TP);
    [xI,yI,zI] = size(InIma);
    Error_Matrix = (InIma.*0) + 2;
     
    if direction == 2
        OutIma = NaN(xI,yI,zI);
    else 
        OutIma = 0.*InIma;
    end
    
    for xx = 1:tp_r-1
        for yy = 1:tp_c-1
            for zz = 1:zI
                for rr = reg_grid_TP(xx,yy,1):reg_grid_TP(xx+1,yy,1)-1
                    for cc = reg_grid_TP(xx,yy,2):reg_grid_TP(xx,yy+1,2)-1

                        R = kr_total(xx,yy,1)*rr + kr_total(xx,yy,2)*cc + kr_total(xx,yy,3)*rr*cc + kr_total(xx,yy,4);
                        C = kc_total(xx,yy,1)*rr + kc_total(xx,yy,2)*cc + kc_total(xx,yy,3)*rr*cc + kc_total(xx,yy,4);

                        R_error_up = abs(ceil(R) - R);
                        R_error_down = abs(R - floor(R));
                        C_error_up = abs(ceil(C) - C);
                        C_error_down = abs(C - floor(C));

                        Ru = abs(ceil(R)) + 1;
                        Ru(Ru > xI) = xI;
                        Cu = abs(ceil(C)) + 1;
                        Cu(Cu > yI) = yI;
                        Rd = abs(floor(R)) + 1;
                        Rd(Rd > xI) = xI;
                        Cd = abs(floor(C)) + 1;
                        Cd(Cd > yI) = yI;

                        average_value = mean([InIma(rr,cc,zz) InIma(rr,cc+1,zz) InIma(rr+1,cc,zz) InIma(rr+1,cc+1,zz)]);

                        if (R_error_down + C_error_down) <= Error_Matrix(Rd,Cd,zz)
                            OutIma(Rd,Cd,zz) = average_value;
                            Error_Matrix(Rd,Cd,zz) = (R_error_down + C_error_down);
                        end

                        if(R_error_down + C_error_up) <= Error_Matrix(Rd,Cu,zz)
                            OutIma(Rd,Cu,zz) = average_value;
                            Error_Matrix(Rd,Cu,zz) = (R_error_down + C_error_up);
                        end

                        if (R_error_up + C_error_down) <=  Error_Matrix(Ru,Cd,zz)
                            OutIma(Ru,Cd,zz) = average_value;
                            Error_Matrix(Ru,Cd,zz) = (R_error_up + C_error_down);
                        end

                        if (R_error_up + C_error_up) <= Error_Matrix(Ru,Cu,zz)
                            OutIma(Ru,Cu,zz) = average_value;
                            Error_Matrix(Ru,Cu,zz) = (R_error_up + C_error_up);
                        end

                        OutIma(Rd:Ru,Cd:Cu,zz) = average_value;
                    end
                end
            end
        end
    end

    if direction == 2
        duh_NaN = isnan(OutIma);
        for zz = 1:zI
            for ii = 2:xI-1
                for jj = 2:yI-1
                    if duh_NaN(ii,jj,zz) == 0
                        selection = OutIma(ii-1:ii+1,jj-1:jj+1,zz);
                        selection(isnan(selection)) = [];
                        OutIma(ii,jj,zz) = round(mean(nonzeros(selection)));
                    end
                end
            end
        end
    end

    OutIma = uint8(OutIma);
    fho = figure('Name','Output');
    imshow(uint8(OutIma));
    
end

%Bilinear Interpolation for non-integer location values
function [OutIma,fho] = bilinear_interp(InIma,reg_grid_TP,kr_total,kc_total,direction)
    %biliner interpolation to assign non-integer values
    %interpolates between surrounding pixel values
    %
    %InIma            InputImage selected by the user
    %reg_grid_TP      regular grid of tie_points
    %kr_total         3D matrix of k values for row equations
    %kc_total         3D matrix of k values for column equations
    %direction        indicates irregular to regular / vice versa
    %
    %OutIma           OutIma as final product
    %fho              figure handle for output figure
    
    [tp_r,tp_c,~] = size(reg_grid_TP);
    [xI,yI,zI] = size(InIma);
    Error_Matrix = (InIma.*0) + 2;
     
    if direction == 2
        OutIma = NaN(xI,yI,zI);
    else 
        OutIma = 0.*InIma;
    end
    
    for xx = 1:tp_r-1
        for yy = 1:tp_c-1
            for zz = 1:zI
                for rr = reg_grid_TP(xx,yy,1):reg_grid_TP(xx+1,yy,1)
                    for cc = reg_grid_TP(xx,yy,2):reg_grid_TP(xx,yy+1,2)

                        R = kr_total(xx,yy,1)*rr + kr_total(xx,yy,2)*cc + kr_total(xx,yy,3)*rr*cc + kr_total(xx,yy,4);
                        C = kc_total(xx,yy,1)*rr + kc_total(xx,yy,2)*cc + kc_total(xx,yy,3)*rr*cc + kc_total(xx,yy,4);

                        R_error_up = abs(ceil(R) - R);
                        R_error_down = abs(R - floor(R));
                        C_error_up = abs(ceil(C) - C);
                        C_error_down = abs(C - floor(C));

                        Ru = abs(ceil(R)) + 1;
                        Ru(Ru > xI) = xI;
                        Cu = abs(ceil(C)) + 1;
                        Cu(Cu > yI) = yI;
                        Rd = abs(floor(R)) + 1;
                        Rd(Rd > xI) = xI;
                        Cd = abs(floor(C)) + 1;
                        Cd(Cd > yI) = yI;

                        A = [rr cc rr*cc 1;
                             rr cc+1 (rr)*(cc+1) 1;
                             rr+1 cc (rr+1)*(cc) 1;
                             rr+1 cc+1 (rr+1)*(cc+1) 1];
                        B = double([InIma(rr,cc,zz);
                             InIma(rr,cc+1,zz);
                             InIma(rr+1,cc,zz);
                             InIma(rr+1,cc+1,zz)]);
                        k = pinv(A)*B;

                        bilinear_interp_value = round(k(1)*rr + k(2)*cc + k(3)*rr*cc + k(4));

                        if (R_error_down + C_error_down) <= Error_Matrix(Rd,Cd,zz)
                            OutIma(Rd,Cd,zz) = bilinear_interp_value;
                            Error_Matrix(Rd,Cd,zz) = (R_error_down + C_error_down);
                        end

                        if(R_error_down + C_error_up) <= Error_Matrix(Rd,Cu,zz)
                            OutIma(Rd,Cu,zz) = bilinear_interp_value;
                            Error_Matrix(Rd,Cu,zz) = (R_error_down + C_error_up);
                        end

                        if (R_error_up + C_error_down) <=  Error_Matrix(Ru,Cd,zz)
                            OutIma(Ru,Cd,zz) = bilinear_interp_value;
                            Error_Matrix(Ru,Cd,zz) = (R_error_up + C_error_down);
                        end

                        if (R_error_up + C_error_up) <= Error_Matrix(Ru,Cu,zz)
                            OutIma(Ru,Cu,zz) = bilinear_interp_value;
                            Error_Matrix(Ru,Cu,zz) = (R_error_up + C_error_up);
                        end

                        OutIma(Rd:Ru,Cd:Cu,zz) = bilinear_interp_value;
                        
                    end
                end
            end
        end
    end
    
    if direction == 2
        duh_NaN = isnan(OutIma);
        for zz = 1:zI
            for ii = 2:xI-1
                for jj = 2:yI-1
                    if duh_NaN(ii,jj,zz) == 0
                        selection = OutIma(ii-1:ii+1,jj-1:jj+1,zz);
                        selection(isnan(selection)) = [];
                        OutIma(ii,jj,zz) = round(mean(nonzeros(selection)));
                    end
                end
            end
        end
    end
    
    OutIma = uint8(OutIma);
    fho = figure('Name','Output');
    imshow(OutIma);
    
end

end