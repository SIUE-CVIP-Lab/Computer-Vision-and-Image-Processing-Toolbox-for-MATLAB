function [ Out_table ] = compare_images_cvip( folder1 , folder2, comMeas, flag)
% COMPARE_IMAGES_CVIP - creates a table with the results of the comparison
% metrics specified in comMeas for the images located in the folders
% 'folder1' and 'folder2'. Images to compare must have the same name but
% can have different file format. The output table is written in an excel
% spreadsheet in the prompted directory or the current MATLAB working
% directory using the name 'ImaCompa' + 'date stamp' .xls. After the file
% writting process a confirmation windows appears showing the path of the
% file and given the option to open the file.
%
% Syntax :
% ------
% [out_table] = compare_images_cvip( folder1 , folder2, comMeas)
% [out_table] = compare_images_cvip( folder1 , folder2, [Sub Stats XOR pSNR SNR Gray RMS FOM Scale])
%   
% Input Parameters include :
% ------------------------
%
%  'folder1'       Address relative to the current directory, or absolute
%                  address to a folder containing one set of images to be
%                  compared with images in folder2.
%                  The names of the images in folder1 should match the
%                  names of the images in folder2. Also the number of
%                  images should be the same in both folders.
%                    
%  'folder2'       Address relative to the current directory, or absolute
%                  address to a folder containing a set of images to be
%                  compared with images in folder1.
%                  The names of the images in folder1 should match the
%                  names of the images in folder2. Also the number of
%                  images should be the same in both folders.
%
%  'comMeas'       A row vector of 9 elemets, that selects the desired
%                  comparison measures to be included in the Output Table:
%
%                  comMeas(1) --> Include subtraction
%                  comMeas(2) --> Include stats from subtraction (histogram features)
%                  comMeas(3) --> Include XOR operation (Objects found and pixel density)
%                  comMeas(4) --> Include peak SNR
%                  comMeas(5) --> Include SNR
%                  comMeas(6) --> Number of gray levels to be used in SNR
%                  comMeas(7) --> Include RMS Error
%                  comMeas(8) --> Include Pratt FOM
%                  comMeas(9) --> Scale factor for Pratt FOM
%
%  'flag'          Binary input for the use of the uiputfile function to
%                  specify the output file name and directory.
%
%   
% Output :
% ------
%
%  'Out_table'    Table MATLAB object containing the results of the
%                 selected comparison metrics including the name of the
%                 images in comparison.
%
%   
% Example 1 :
% ---------
%             %use the folder selection dialog to get the following
%             %folder for the first set of images: 
%             %C:\Users\[CurrentUser]\Documents\MATLAB\Add-Ons\Toolboxes\
%             %CVIP_Toolbox\images\CFolder1 
%             folder1 = uigetdir(pwd, 'Select First Folder for Comparison...');
%             %C:\Users\[CurrentUser]\Documents\MATLAB\Add-Ons\Toolboxes\
%             %CVIP_Toolbox\images\CFolder2
%             folder2 = uigetdir(pwd, 'Select Second Folder for Comparison ...');
%             %specify subtraction with stats, peak SNR and RMS Error
%             comMeas = [1 1 0 1 0 0 1 0 0];
%             [ out_table ] = compare_images_cvip(folder1, folder2, comMeas)
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Julian Rene Cuellar Buritica
%           Initial coding date:    06/17/2019
%           Latest update date:     06/27/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
% 
 % Revision 1.3  06/27/2019  22:19:15  jucuell
 % The help example was updated, the uiputfile function was implemented and
 % a new path definition was defined
% 
 % Revision 1.2  06/25/2019  22:11:50  jucuell
 % The button 'Open file...' was included and the help file was updated.
%
 % Revision 1.1  06/17/2019  17:11:56  jucuell
 % Initial coding based on feature_images_cvip written by Mehrdad Alvandipour
%
if isempty(flag)
    flag = 0;
end
list1 = dir(folder1);
list2 = dir(folder2);
% list is the folder of images.
% mask_list is the folder for masks.
% They should contain the same number of images with the same names.
% list contains:        . , .. , A_folder, images
% mask_list contains:   . , .. , images
% Thus the the third elements of list is the name of the mask folder that
% we need to look into.

if length(list1)-2 ~= length(list2) -2
    error('The folders should contain the same number of images!');
else
    num_of_images = length(list1)-2;
    Out_table = 0;
end

n=2;    %figure image index in directory
m=2;    %figure image index in masks directory
for i=1:num_of_images
    if list1(i+n).isdir
        n=n+1;      %increase index if detect an intermediate directory
    end
    if list2(i+m).isdir
        m=m+1;      %increase index if detect an intermediate directory
    end
    fname1 = list1(i+n).name(1:end-4);%remove file extension
    fname2 = list2(i+m).name(1:end-4);
    if ~strcmp(fname1, fname2)
        warning('The Image names do not match')
    end
    
    img1_add = [folder1 '\' list1(i+n).name];
    imag2_add = [folder2 '\' list2(i+m).name];
    I1 = imread(img1_add);
    I2 = imread(imag2_add);
    [row, col, band] = size(I1);
    %perform image comparisons
    if comMeas(1)       %use subtraction
        InIma = subtract_cvip(I1, I2);%call Sub function
        if band == 3
            maxRR = max(max(real(InIma(:,:,1))));%Real Max band R
            minRR = min(min(real(InIma(:,:,1))));
            maxIR = max(max(imag(InIma(:,:,1))));%Imaginary Max band R
            minIR = min(min(imag(InIma(:,:,1))));
            maxRG = max(max(real(InIma(:,:,2))));
            minRG = min(min(real(InIma(:,:,2))));
            maxIG = max(max(imag(InIma(:,:,2))));
            minIG = min(min(imag(InIma(:,:,2))));
            maxRB = max(max(real(InIma(:,:,3))));
            minRB = min(min(real(InIma(:,:,3))));
            maxIB = max(max(imag(InIma(:,:,3))));
            minIB = min(min(imag(InIma(:,:,3))));
            final_table = table(minRR, maxRR, minIR, maxIR, minRG, maxRG, minIG, ...
                maxIG, minRB, maxRB, minIB, maxIB);
        else
            maxRR = max(max(real(InIma(:,:,1))));%Real Max band R
            minRR = min(min(real(InIma(:,:,1))));
            maxIR = max(max(imag(InIma(:,:,1))));%Imaginary Max band R
            minIR = min(min(real(InIma(:,:,1))));
            final_table = table(minRR, maxRR, minIR, maxIR);
        end
        if comMeas(2)               %compute image stats (Means STD Skew...)
            segmen = ones(row, col);
            if band == 3
                histfeats1 = hist_feature_cvip(int8(real(InIma(:,:,1))), ...
                    segmen, 1, []);
                histfeats2 = hist_feature_cvip(int8(real(InIma(:,:,2))), ...
                    segmen, 1, []);
                histfeats3 = hist_feature_cvip(int8(real(InIma(:,:,3))), ...
                    segmen, 1, []);
                histfeats1 = cell2table([histfeats1(2,2:end) ...
                    histfeats2(2,2:end) histfeats3(2,2:end)]);
                histfeats1.Properties.VariableNames = {'Mean_1','STD_1'...
                    'Skew_1', 'Energy_1', 'Entropy_1','Mean_2','STD_2'...
                    'Skew_2', 'Energy_2', 'Entropy_2','Mean_3','STD_3'...
                    'Skew_3', 'Energy_3', 'Entropy_3'};
            else
                histfeats1 = hist_feature_cvip(int8(real(InIma(:,:,1))), ...
                    segmen, 1, []);
                histfeats1 = cell2table(histfeats1(2,2:end));
                 histfeats1.Properties.VariableNames = {'Mean_1','STD_1'...
                    'Skew_1', 'Energy_1', 'Entropy_1'};
            end
            final_table = [final_table histfeats1];
        end
    end
    if comMeas(3)               %compute XOR
        InIma = xor_cvip(I1, I2);  	%call Xor function
        pDens = sum(sum(InIma>0.5))/(row*col);
        if band == 3
            Objects_1 = label_cvip(InIma(:,:,1));
            Objects_1 = max(Objects_1(:));
            Objects_2 = label_cvip(InIma(:,:,2));
            Objects_2 = max(Objects_2(:));
            Objects_3 = label_cvip(InIma(:,:,3));
            Objects_3 = max(Objects_3(:));
            Objects_1 = table(Objects_1, Objects_2, Objects_3);
            pDens = table([pDens(:,:,1) pDens(:,:,2) pDens(:,:,3)]);
            pDens.Properties.VariableNames = {'pDens'};
        else
            Objects_1 = label_cvip(InIma);
            Objects_1 = max(Objects_1(:));
            Objects_1 = table(Objects_1);
            pDens = table(pDens);
        end
        final_table = [final_table Objects_1 pDens];
    end
    if comMeas(4)               %compute peak SNR
        Peak = peak_snr_cvip(I1, I2, comMeas(5)); %call peak SNR function
        Peak = table(Peak);
        final_table = [final_table Peak];
    end
    if comMeas(6)               %compute SNR
        SNR = snr_cvip(I1, I2); %call SNR function
        SNR = table(SNR);
        final_table = [final_table SNR];
    end
    if comMeas(7)               %compute SNR
        RMS = rms_error_cvip(I1, I2);   %call RMS function
        RMS = table(RMS);
        final_table = [final_table RMS];
    end
    if comMeas(8)               %compute SNR
        if band == 3 || band2 == 3
        [FOMR, FOMG, FOMB] = pratt_merit_cvip(I1, I2, Sca);
        else
            FOM = pratt_merit_cvip(I1, I2, Sca);
        end
        final_table = [final_table Objects_1];
    end
    FileName = cell2table({list1(i+n).name});
    FileName.Properties.VariableNames={'FileName'};
    final_table = [FileName final_table];
    if i~=1
        Out_table = [Out_table; final_table];
    else
        Out_table = final_table;
    end
end

if size(Out_table,2) > 1
    cpath = mfilename( 'fullpath' );
    cpath = [cpath(1:end-32) '\GUI'];
    if flag
        %save comparison file including timestamp
        [file, path] = uiputfile({'*.xlsx','Excel Workbook (*.xlsx)';...
        '*.xls','Excel 97-2003 Workbook (*.xls)';'*.csv','Comma delimited (*.csv)';  ... 
        '*.dat','Text-based DAT file (*.dat)'; '*.txt', 'Documentos de texto (*.txt)'; ...
        '*.*','All files (*.*)'}, 'Save Comparison file as...', ...
        [cpath '\ImageCompare' datestr(now,'yymmddHHMMSS') '.xlsx']);
        if ~isequal(file,0)
            OutFile = [path file];
        else
            OutFile = [cpath '\Temp\ImageCompare' datestr(now,'yymmddHHMMSS') '.xls'];
        end
    else
        OutFile = [cpath '\Temp\ImageCompare' datestr(now,'yymmddHHMMSS') '.xls'];
    end
    writetable(Out_table, OutFile);
%     msgbox(['Output file was saved in "Temp" directory as ' OutFile], ...
%         'Comparison File Saving');
    Rta = questdlg(['Output file was saved in the specified directory as ' ...
        OutFile],'Comparison File Saving','Open File...', 'OK', 'OK');
    if strcmp(Rta,'Open File...')
        winopen(OutFile);
    end
end

end

