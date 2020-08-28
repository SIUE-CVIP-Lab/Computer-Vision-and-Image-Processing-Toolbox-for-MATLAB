function labeledImage = label_cvip(orignialImage)
% LABEL_CVIP - labels objects based on 6-connectivity, NW/SE diagonal.
% 
% Syntax :
% ------
% labeledImage = label_cvip(orignialImage)
%   
% Input Parameter include :
% -----------------------
%
%   'originalImage'     The orignial image which can be grayscale or RGB.
%                
%
% Output Parameter include :  
% -------------------------
%
%   'labelImage'    Labeled image of the same size as the original image.  
%                   Each object has unique gray value.
%                                       
% Example :
% -------
%                   I = imread('Shapes.bmp');
%                   lab_image = label_cvip(I);
%                   figure;imshow(lab_image,[]);
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    12/27/2016
%           Latest update date:     3/19/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

    [rows,cols,dim] = size(orignialImage);
    if dim > 1
        orignialImage = luminance_cvip(orignialImage);
%         disp('Color image')
    end
    if ~isa(orignialImage,'double')
        orignialImage = im2double(orignialImage);
%         disp('image is not double');
    end
    labeledImage = zeros(rows,cols);
    count = 1;
    for i=1:rows
        for j = 1:cols
            A = orignialImage(i,j);
            if A== 0
                continue;
            end

            if i>1 && j > 1
                D = orignialImage(i-1,j-1);
                D_label = labeledImage(i-1,j-1);
            else
                D = 0;
                D_label = 0;
            end
            if A == D
                labeledImage(i,j) = D_label;    %A_label = D_label
                continue;
            end

            % At this point you need B and C
            if j > 1
                B = orignialImage(i,j-1);
                B_label = labeledImage(i,j-1);
            else
                B = 0;
                B_label = 0;
            end
            if i > 1
                C = orignialImage(i-1,j);
                C_label = labeledImage(i-1,j);
            else
                C = 0;
                C_label = 0;
            end

            if A == B
                if A == C
                    if B_label ~= C_label
                        %update
                        if B_label > C_label
                            labeledImage(labeledImage == B_label) = C_label;
                            labeledImage(labeledImage > B_label) = labeledImage(labeledImage > B_label) - 1;

                            labeledImage(i,j) = C_label;
                            count =  count - 1;
                            B_label = C_label;
                        else
    %                         disp([B_label C_label]);
                            labeledImage(labeledImage == C_label) = B_label;
                            labeledImage(labeledImage > C_label) = labeledImage(labeledImage > C_label) - 1;

                            labeledImage(i,j) = B_label;
                            count = count - 1 ;
                            C_label = B_label;
    %                         disp([B_label C_label]);
                        end
                    end
                end
                    % A_label = B_label; continue;
                    labeledImage(i,j) = B_label; continue;
            else
                if A == C
                    %A_label = C_label; continue;
                    labeledImage(i,j) =  C_label; continue;
                else
                    %A_label = count; count = count + 1; continue;
                    labeledImage(i,j) = count; count = count + 1; continue;
                end
            end

        end
    end
end
% figure; imshow(labeledImage,[])


% for i=1:max(max(cv))
%     a= find(labeledImage == i);
%     if isempty(a)
%         disp(i)
%     end
% end