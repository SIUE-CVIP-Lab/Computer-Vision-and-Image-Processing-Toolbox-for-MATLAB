function OutIma = edge_link_filter_cvip(InIma, connection)
% edge_link_filter_cvip - connects lines within an image that passed a
% threshold test given by connection. All lines/points are then connected
% to all others that are within a maximum distance.
%
% Syntax :
% -------
% edge_link_filter_cvip(InIma, connection)
%   
% Input Parameters include :
% ------------------------ 
%   'InIma'        1-band input image of MxN size or 3-band input image of   
%                  MxNx3 size. The input image can be of uint8 or uint16
%                  or double class. All image data types are remaped to
%                  0 to 255 values. For 3-band image just the R-band is
%                  taken for processing.
%   'connection'   number to indicate the maximum distance to be linked on a 
%                  line which will be joined to get a continuos border.
%
%                                
% Output Parameter include :  
%   ------------------------
%   'OutIma'      1-band Linked image having same size of input image.
%                   
%
% Example :
% ---------
%                 I = imread('unconnect.bmp');   %original image
%                 distance = 4;                  %4 pixels for link
%                 O1 = edge_link_filter_cvip(InIma, distance);
%                 figure;imshow(I,[]);
%                 title('Input Image');
%                 figure;imshow(O1,[]);
%                 title('Output Image - Edge Link');
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Julián René Cuellar Buriticá
%           Initial coding date:    03/06/2018
%           Latest update date:     03/12/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% "Image will be remapped into CVIP_BYTE\n");
InIma = remap_cvip(InIma(:,:,1), [0 255]);
OutIma = InIma;

[rows, cols, bands] = size(InIma);          %get image size

for no_of_bands = 1:bands
   for y = 1:rows
       for x = 1:cols
            if InIma(y,x) == 255
              u_x = x - connection;
              u_y = y - connection;
              d_x = x + connection;
              d_y = y + connection;
              
              if (u_x <= 0) 
                  u_x = 1;
              end
              if (u_y <= 0) 
                  u_y = 1;
              end
              if (d_x >= cols)
                  d_x = cols-1;
              end
              if (d_y >= rows) 
                  d_y = rows-1;
              end
              
              for j = u_y:d_y
                for i = u_x:d_x
                    if (InIma(j,i) == 255 && ~(i==x && j==y))
                        x_inc = x - i;
                        y_inc = y - j;
                        x_abs = abs(x_inc);
                        y_abs = abs(y_inc);
                            if (x_abs > y_abs)
                                if (x_inc > 0)
                                    direction = 1;
                                else
                                    direction = -1;
                                end
                                slope = y_inc/x_inc;
                                
                                    for r_i = i:direction:x
                                       r_j = round(slope*(r_i - i) + j);
                                       OutIma(r_j,r_i) = 255;
                                    end

                            else
                                if (y_inc > 0)
                                    direction = 1;
                                else
                                    direction = -1;
                                end
                                slope = x_inc/y_inc;

                                    for r_j = j:direction:y
                                       r_i = round(slope*(r_j - j) + i);
                                       OutIma(r_j,r_i) = 255;
                                    end
                            end
                    end
                end
              end
            end
       end
   end
end
