function varargout = mUConv(varargin)
% MUCONV MATLAB code for mUConv.fig
%      MUCONV, by itself, creates a new MUCONV or raises the existing
%      singleton*.
%
%      H = MUCONV returns the handle to a new MUCONV or the handle to
%      the existing singleton*.
%
%      MUCONV('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MUCONV.M with the given input arguments.
%
%      MUCONV('Property','Value',...) creates a new MUCONV or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mUConv_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mUConv_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mUConv

% Last Modified by GUIDE v2.5 04-Jun-2019 08:05:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mUConv_OpeningFcn, ...
                   'gui_OutputFcn',  @mUConv_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% Reference 
% ---------
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications 
%     with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Julian Rene Cuellar Buritica (GUIDE)
%           Initial coding date:    11/21/2017
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     12/12/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
 % Revision 1.2  12/12/2018  17:12:40  jucuell
 % updating menu creation programmatically, callbacks to Main figure and
 % the use of the utilities menus in the Main figure.
%
 % Revision 1.1  11/21/2017  15:23:31  jucuell
 % Initial revision: Initial coding and testing
 % 
%

% --- Executes just before mUConv is made visible.
function mUConv_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mUConv (see VARARGIN)

% Choose default command line output for mUConv
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';%hide Analysis menu
hUtil = findobj('Tag','mUshos');
% hUtil(1).MenuSelectedFcn=@(hObject,eventdata)CVIPToolbox('mUshow_Callback',...
%     hObject,'Conv',guidata(hObject));
hUtil(1).Callback=@(hObject,eventdata)CVIPToolbox('mUshow_Callback',...
    hObject,'Conv',guidata(hObject));


% --- Outputs from this function are returned to the command line.
function varargout = mUConv_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in bCancel.
function bCancel_Callback(hObject, eventdata, handles)
% hObject    handle to bCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Prepare to close application window
 close(handles.Conv)


% --- Executes on button press in bReset.
function bReset_Callback(hObject, eventdata, handles)
% hObject    handle to bReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bApply.
function bApply_Callback(hObject, eventdata, handles)
% hObject    handle to bApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc                                 %clear screen

%changing pointer arrow to watch on cursor
figure_set = findall(groot,'Type','Figure');
set(figure_set,'pointer','watch');

hMain = findobj('Tag','Main');      %get the handle of Main figure
hSHisto = findobj('Tag','mVsaveHis');%get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = hMain.UserData;             %get image handle
Ima=hNfig.UserData;                 %get image information
%check for Image to process
if isempty(Ima) && ~isfield(Ima,'cvipIma') 
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Convert Error','modal'); 
%check if grayscale image is required
elseif handles.bG2C.Value && size(Ima.cvipIma,3) == 3
    warndlg(['This operation requires a grayscale image. Select a '...
                'grayscale Image and try again!'],'Convert Warning','modal');

%check if color image is required
elseif (handles.bC2G.Value || handles.bCS.Value) && size(Ima.cvipIma,3) == 1
    warndlg(['This operation requires a color image. Select a '...
                'color Image and try again!'],'Convert Warning','modal');
     
else
    InIma = Ima.cvipIma;            %read image data
    file=get(hNfig,'Name');         %get image name
    band = size(InIma,3);           %get number of bands

%perform image operations
if handles.bBTh.Value==1         %perform binary Thresholding 
    %get Threshold value from GUI
    THlvl = str2double(handles.popTHlvl.String(handles.popTHlvl.Value));
    if max(max(InIma(:))) <= 1      %detect if image data type is double
        OutIma = threshold_cvip(InIma, THlvl/255);
    else
        OutIma = threshold_cvip(uint8(InIma), THlvl);
    end
    Name = [file,' > Threshold (',num2str(THlvl),')'];
    %update image history
    histo = [171 THlvl];
    
elseif handles.bDTyp.Value==1           %Convert data type
    Type = handles.popDtype.Value;      %Get convertion index
    OutIma = data_type_cvip(InIma, Type);%call convertion function
    %update image history
    Name = [file,' > Data Type - ',class(OutIma)];
    histo = [036 Type];

elseif handles.bHalf.Value==1           %perform Halftone
    Method = handles.popHalf.Value;     %get selected method
    if Method == 4                      %get simple Threshold value
        TH = str2double(handles.popHth.String(handles.popHth.Value));
        OutIma = halftone_cvip(InIma, Method, TH);
        Name = strcat(file, ' > Halftone (Threshold) ');
    else
        OutIma = halftone_cvip(InIma, Method);
        if Method == 1
            Name = strcat(file, ' > Halftone (Floyd) ');
        elseif Method == 2
            Name = strcat(file, ' > Halftone (Bayer) ');
        elseif Method == 3
            Name = strcat(file, ' > Halftone (Cluster) ');
        end
    end
    histo = [33 Method];                %update image history

elseif handles.bGray.Value==1           %perform Gray quantization
    Quanti = handles.popGquant.Value;   %get selected method
    Gray  = str2double(handles.popNgray.String(handles.popNgray.Value));

    if Quanti == 1                      %standard gray
        OutIma = gray_quant_cvip(InIma, Gray);
        histo = [173 Gray];            	%update image history
        Name = strcat(file, ' > GrayQuant (Std-',num2str(Gray),') ');
    else                                %IGS gray quant
        OutIma = igs_cvip(InIma, Gray);
        histo = [175 Gray];            	%update image history
        Name = strcat(file, ' > GrayQuant (IGS-',num2str(Gray),') ');
    end
    
elseif handles.bGrayN.Value==1          %perform Gray to Natural binary
    BinGray = handles.popGnat.Value;   
    
    if BinGray == 1                     %Bin to Gray
        OutIma = bin2graycode_cvip(InIma);
        Name = strcat(file, ' > Bin2Gray ');
        histo = 31;
    else                                %Gray to Bin
        OutIma = graycode2bin_cvip(InIma);
        Name = strcat(file, ' > Gray2Bin ');
        histo = 34;
    end
    
elseif handles.bG2C.Value==1         %perform gray to color 
    if handles.bGCfreq.Value           %by frequency mapping
        %check if the user select more than 1 time a color
        LPC = handles.popLPc.Value;     %LP color selection;
        BPC = handles.popPBc.Value;     %LP color selection;
        HPC = handles.popHPc.Value;     %LP color selection;

        if size(unique([LPC BPC HPC])) < 3
            errordlg('You must select a color just one time.','Convert Error','modal');
        else
            %%PROCEDURE
            %1. GET FFT OF GRAY IMAGE
            Spect = fft_cvip(InIma, []);     %call FFT function
            %2. Apply iFFT to LP, PB n HP filters (no keep DC)
            %get frequencies
            Lfreq = str2double(handles.popLfreq.String(handles.popLfreq.Value));
            Hfreq = str2double(handles.popHfreq.String(handles.popHfreq.Value));
%             Filt = butterworth_low_cvip(Spect, [], 'fft', 3, Lfreq);%LPF
            Filt = ideal_low_cvip(Spect, [], 'fft',0, Lfreq);%LPF
            LP = ifft_cvip(Filt,[]);        %LowPass Image
%             Filt = butterworth_bandpass_cvip(Spect, [],'fft', 3, Lfreq, Hfreq);%BPF
            Filt = ideal_bandpass_cvip(Spect, [],'fft', 0,Lfreq, Hfreq);%BPF
            BP = ifft_cvip(Filt,[]);        %BandPass Image
%             Filt = butterworth_high_cvip(Spect, [], 'fft', 3, Hfreq);%HPF
            Filt = ideal_high_cvip(Spect, [], 'fft',0, Hfreq);%HPF
            HP = ifft_cvip(Filt,[]);        %HighPass Image
            %3. Assemble bands according to selection
            switch LPC
                case 1  
                    R = LP;
                case 2  
                    G = LP;
                case 3
                    B = LP;
            end
            switch BPC
                case 1  
                    R = BP;
                case 2  
                    G = BP;
                case 3
                    B = BP;
            end
            switch HPC
                case 1  
                    R = HP;
                case 2  
                    G = HP;
                case 3
                    B = HP;
            end
%             OutIma = assemble_bands_cvip(R, G, B);
            %Update history
            Blk = size(R,1);
            histo = [212 Blk 0 0 0; 225 Blk 212 Lfreq 0; 227 Blk 212 ...
                Lfreq Hfreq; 226 Blk 212 Hfreq 0; 220 Blk 0 0 0; 79 0 1 ...
                0 0; 9 0 0 0 0];

            OutIma = assemble_bands_cvip(hist_stretch_cvip(R,0,1,0,0), ...
            hist_stretch_cvip(G,0,1,0,0), hist_stretch_cvip(B,0,1,0,0));
            %Update history
%             Blk = size(R,1);
%             histo = [212 Blk 0 0 0 0; 230 Blk 212 4 Lfreq 0; 232 Blk 212 ...
%                 4 Lfreq Hfreq; 231 Blk 212 4 Hfreq 0; 220 Blk 0 0 0 0];
            Name = strcat(file, ' > Gray2Col (Freq.Map.)(',num2str(Lfreq),',', ...
            num2str(Hfreq), ')');
        end
    else
        
%        Lfreq = str2double(handles.popLfreq.String(handles.popLfreq.Value));
%        Hfreq = str2double(handles.popHfreq.String(handles.popHfreq.Value));%by gray level mapping
        Rmap = handles.popRmap.Value;
        Gmap = handles.popGmap.Value;
        Bmap = handles.popBmap.Value;
        Lfreq=96;
        Hfreq =128;
        
        R = gray_levelmap_cvip(InIma, Rmap,Lfreq,Hfreq);
        G = gray_levelmap_cvip(InIma, Gmap,Lfreq,Hfreq);
        B = gray_levelmap_cvip(InIma, Bmap,Lfreq,Hfreq);
        
        OutIma = assemble_bands_cvip(R, G, B);
        Name = strcat(file, ' > Gray2Col (Gray.Map.)(',num2str(Rmap),',', ...
            num2str(Gmap),',',num2str(Bmap),')');
        histo = [85 Rmap Gmap Bmap; 72 0 0 0];%update histogram
    end

elseif handles.bC2G.Value==1            %perform Color to Gray  
    Gray = handles.popCgray.Value;   

    if Gray == 1                        %by Luminance
        OutIma = luminance_cvip(InIma);
        Name = strcat(file, ' > Lum. ');
        histo = 17;                     %Update history
    else                                %by Luminance Avg
        OutIma = lum_average_cvip(InIma);
        Name = strcat(file, ' > Lum. Avg. ');
        histo = 18;                     %Update history
    end

elseif handles.bCS.Value==1            %perform Color Space  
    CSpa = handles.popCspa.Value;   
    switch CSpa
        case 1
            if handles.cFor.Value     %XYZ Chromacity
                OutIma = rgb2xyz_cvip(InIma, handles.cNorm.Value);
                fun = 'RGB->XYZ';
                histo = [21 handles.cNorm.Value 0];%update history
%                 if handles.cRem.Value
%                     OutIma = uint8(relative_remap_cvip(OutIma, [0 255]));
%                     histo = [21 handles.cNorm.Value 0;...
%                         84 0 255];  %update history
%                 end
            else 
                %OutIma = xyz2rgb_cvip(InIma, handles.cNorm.Value);
                fun = 'IDEM';
                OutIma = InIma;
                histo = 0;
            end

        case 2                        %LAB-CIE 
            if handles.cFor.Value
                OutIma = rgb2lab_cvip(InIma, handles.cNorm.Value);
                fun = 'RGB->LAB';
                histo = [25 handles.cNorm.Value 0];%update history
            else 
                OutIma = lab2rgb_cvip(InIma, handles.cNorm.Value);
                fun = 'LAB->RGB';
                histo = [16 handles.cNorm.Value 0];%update history
            end
            
%             if handles.cRem.Value
%                 OutIma = uint8(relative_remap_cvip(OutIma, [0 255]));
%                 histo = [histo;...
%                     84 0 255];  %update history
%             end

        case 3                        %LUV-CIE 
            if handles.cFor.Value
                OutIma = rgb2luv_cvip(InIma, handles.cNorm.Value);
                fun = 'RGB->LUV';
                histo = [26 handles.cNorm.Value 0];%update history
            else 
                OutIma = luv2rgb_cvip(InIma, handles.cNorm.Value);
                fun = 'LUV->RGB';
                histo = [19 handles.cNorm.Value 0];%update history
            end

        case 4                        %CCT 
            if handles.cFor.Value
                OutIma = rgb2cct_cvip(InIma, handles.cNorm.Value);
                fun = 'RGB->CCT';
                histo = [24 handles.cNorm.Value 0];%update history
            else 
                OutIma = cct2rgb_cvip(InIma, handles.cNorm.Value);
                fun = 'CCT->RGB';
                histo = [12 handles.cNorm.Value 0];%update history
            end
        case 5                        %HSL 
            if handles.cFor.Value
                OutIma = rgb2hsl_cvip(InIma, handles.cNorm.Value);
                fun = 'RGB->HSL';
                histo = [22 handles.cNorm.Value 0];%update history
            else 
                OutIma = hsl2rgb_cvip(InIma, handles.cNorm.Value);
                fun = 'HSL->RGB';
                histo = [14 handles.cNorm.Value 0];%update history
            end

        case 6                        %HSV 
            if handles.cFor.Value
                OutIma = rgb2hsv_cvip(InIma, handles.cNorm.Value);
                fun = 'RGB->HSV';
                histo = [23 handles.cNorm.Value 0];%update history
            else 
                OutIma = hsv2rgb_cvip(InIma, handles.cNorm.Value);
                fun = 'HSV->RGB';
                histo = [15 handles.cNorm.Value 0];%update history
            end

        case 7                        %PCT 
            if handles.cFor.Value
                [OutIma, E] = pct_cvip(InIma);
                fun = 'PCT';
                histo = 20;           %update and save history
                Ima.fInfo.history_info = ...
                    historyupdate_cvip(Ima.fInfo.history_info,histo);
                Ima.fInfo.PCTeigen = E;%save Eigen vector
            else                      %apply inverse transformation
                %ask for spectral DCT info
                fun = 'iPCT';
                [ro,~]=find(Ima.fInfo.history_info==20);
                if ~isempty(ro)       %info trans 20 (PCT)
                    E = Ima.fInfo.PCTeigen;%read eigen vector
                    OutIma = ipct_cvip(InIma, E);
                    histo = 13;       %update history
                else                  
                    %show Error info
                    errordlg(['Selected image does not contain PCT ' ...
                        'transform information.'], 'Convert Error', 'modal');
                    histo = 0;
                    OutIma = 0;
                end
            end

        case 8                        %SCT
            if handles.cFor.Value
                OutIma = rgb2sct_cvip(InIma, handles.cNorm.Value);
                fun = 'RGB->SCT';
                histo = [27 handles.cNorm.Value 0];%update history
            else 
                OutIma = sct2rgb_cvip(InIma, handles.cNorm.Value);
                fun = 'SCT->RGB';
                histo = [28 handles.cNorm.Value 0];%update history
            end
    end
    Name = [file, ' > ', fun, '(' num2str(handles.cNorm.Value) ')'];  
    if handles.cRem.Value && CSpa ~= 7%remap output image to byte
        OutIma = uint8(relative_remap_cvip(OutIma, [0 255]));
        histo = [histo;...
            84 0 255];  %update history
    end
    
elseif handles.bLab.Value==1            %perform Image Labeling  
    if band == 3
        InIma = luminance_cvip(InIma);  %convert to gray by Luminance
        histo = [17; 151];
    else
        histo = 151;
    end                           
    OutIma = label_cvip(InIma);         %call label function
    if ~handles.cSlab.Value
        OutIma = single(OutIma);
    end
    Name = strcat(file, ' > Labeled Image (',num2str(max(OutIma(:))),')');                     
    
end

if sum(histo(:)) ~= 0
%check if need to save history
if strcmp(hSHisto(1).Checked,'on')	&& CSpa ~= 7%save new image history
    Ima.fInfo.history_info = historyupdate_cvip(Ima.fInfo.history_info,histo);  
end

%check if need to show function information
if strcmp(hVfinfo(1).Checked,'on')
    hIlist = findobj('Tag','txtIlist');%get handle of text element
    hIlist.String(end+1,1)=' ';    	%print an empty line
    txtInfo = historydeco_cvip(histo);     
    hIlist.String(end+1,1:size(file,2)+1)=[file ':']; 
    for i=1:size(txtInfo)
        sInfo = txtInfo{i};                 %exract row to print
        sInfo = sprintf(sInfo);
        [~,rr] = size(sInfo);
        hIlist.String(end+1,1:rr) = sInfo;
    end
    hIlist.Value = size(hIlist.String,1);   %goto last line
    figure(hMain);
end
end

if size(OutIma,1)>3
[row,col,band]=size(OutIma);       	%get new image size
%update image information
Ima.fInfo.no_of_bands=band;             
Ima.fInfo.no_of_cols=col;              
Ima.fInfo.no_of_rows=row;
%update image structure
Ima.cvipIma = OutIma;               %read image data
showgui_cvip(Ima, Name);            %show image in viewer
end
end

%changing pointer watch back to arrow on cursor
set(figure_set,'pointer','arrow');


% --- Executes on selection change in popRmap.
function popRmap_Callback(hObject, eventdata, handles)
% hObject    handle to popRmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popRmap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popRmap


% --- Executes during object creation, after setting all properties.
function popRmap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popRmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on key press with focus on popRmap and none of its controls.
function popRmap_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popRmap (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popGmap.
function popGmap_Callback(hObject, eventdata, handles)
% hObject    handle to popGmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popGmap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popGmap


% --- Executes during object creation, after setting all properties.
function popGmap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popGmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on popGmap and none of its controls.
function popGmap_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popGmap (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bBTh.
function bBTh_Callback(hObject, eventdata, handles)
% hObject    handle to bBTh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bBTh
hide_all(handles);               %hide all controls
handles.popTHlvl.Visible = 'On'; %show specific controls
handles.lblTHlvl.Visible = 'On';

% --- Executes on selection change in popHth.
function popHth_Callback(hObject, eventdata, handles)
% hObject    handle to popHth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popHth contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popHth


% --- Executes during object creation, after setting all properties.
function popHth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popHth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popNgray.
function popNgray_Callback(hObject, eventdata, handles)
% hObject    handle to popNgray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popNgray contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popNgray


% --- Executes during object creation, after setting all properties.
function popNgray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popNgray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popHPc.
function popHPc_Callback(hObject, eventdata, handles)
% hObject    handle to popHPc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popHPc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popHPc


% --- Executes during object creation, after setting all properties.
function popHPc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popHPc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popTHlvl.
function popTHlvl_Callback(hObject, eventdata, handles)
% hObject    handle to popTHlvl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popTHlvl contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popTHlvl


% --- Executes during object creation, after setting all properties.
function popTHlvl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popTHlvl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popDtype.
function popDtype_Callback(hObject, eventdata, handles)
% hObject    handle to popDtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popDtype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popDtype


% --- Executes during object creation, after setting all properties.
function popDtype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popDtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cRem.
function cRem_Callback(hObject, eventdata, handles)
% hObject    handle to cRem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cRem


% --- Executes on selection change in popHalf.
function popHalf_Callback(hObject, eventdata, handles)
% hObject    handle to popHalf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popHalf contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popHalf
if strcmp(hObject.String(hObject.Value),'Threshold')
    handles.popHth.Visible = 'On';      %show Threshold level control
else
    handles.popHth.Visible = 'Off';
end

% --- Executes during object creation, after setting all properties.
function popHalf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popHalf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popGquant.
function popGquant_Callback(hObject, eventdata, handles)
% hObject    handle to popGquant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popGquant contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popGquant


% --- Executes during object creation, after setting all properties.
function popGquant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popGquant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popGnat.
function popGnat_Callback(hObject, eventdata, handles)
% hObject    handle to popGnat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popGnat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popGnat


% --- Executes during object creation, after setting all properties.
function popGnat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popGnat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popCgray.
function popCgray_Callback(hObject, eventdata, handles)
% hObject    handle to popCgray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popCgray contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popCgray


% --- Executes during object creation, after setting all properties.
function popCgray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popCgray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popBmap.
function popBmap_Callback(hObject, eventdata, handles)
% hObject    handle to popBmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popBmap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popBmap


% --- Executes during object creation, after setting all properties.
function popBmap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popBmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bDTyp.
function bDTyp_Callback(hObject, eventdata, handles)
% hObject    handle to bDTyp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bDTyp
hide_all(handles);              %hide all controls
handles.popDtype.Visible = 'On'; %show specific controls

% --- Executes on button press in cFor.
function cFor_Callback(hObject, eventdata, handles)
% hObject    handle to cFor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cFor


% --- Executes on button press in cNorm.
function cNorm_Callback(hObject, eventdata, handles)
% hObject    handle to cNorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cNorm


% --- Executes on button press in bHalf.
function bHalf_Callback(hObject, eventdata, handles)
% hObject    handle to bHalf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bHalf
hide_all(handles);              %hide all controls
handles.popHalf.Visible = 'On'; %show specific controls


% --- Executes on button press in bGray.
function bGray_Callback(hObject, eventdata, handles)
% hObject    handle to bGray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bGray
hide_all(handles);                  %hide all controls
handles.popGquant.Visible = 'On';   %show specific controls
handles.lblPos.Visible = 'On';
handles.popNgray.Visible = 'On';

% --- Executes on button press in bGrayN.
function bGrayN_Callback(hObject, eventdata, handles)
% hObject    handle to bGrayN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bGrayN
hide_all(handles);              %hide all controls
handles.popGnat.Visible = 'On'; %show specific controls

% --- Executes on button press in bG2C.
function bG2C_Callback(hObject, eventdata, handles)
% hObject    handle to bG2C (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bG2C
%show and hide control
hide_all(handles);              %hide all controls
handles.bGcol.Visible = 'On';   %show specific controls

% --- Executes on selection change in popCspa.
function popCspa_Callback(hObject, eventdata, handles)
% hObject    handle to popCspa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popCspa contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popCspa
%initialize checkbox controls
handles.cNorm.Enable = 'On';
handles.cRem.Enable = 'On';
handles.cNorm.Value = 1;

switch hObject.Value    %modify some controls according to selection
    case 7
        handles.cNorm.Enable = 'Off';
        handles.cRem.Enable = 'Off';
    case 3
        handles.cNorm.Value = 0;
end


% --- Executes during object creation, after setting all properties.
function popCspa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popCspa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popLfreq.
function popLfreq_Callback(hObject, eventdata, handles)
% hObject    handle to popLfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popLfreq contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popLfreq


% --- Executes during object creation, after setting all properties.
function popLfreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popLfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popHfreq.
function popHfreq_Callback(hObject, eventdata, handles)
% hObject    handle to popHfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popHfreq contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popHfreq


% --- Executes during object creation, after setting all properties.
function popHfreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popHfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popLPc.
function popLPc_Callback(hObject, eventdata, handles)
% hObject    handle to popLPc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popLPc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popLPc


% --- Executes during object creation, after setting all properties.
function popLPc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popLPc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popPBc.
function popPBc_Callback(hObject, eventdata, handles)
% hObject    handle to popPBc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popPBc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popPBc


% --- Executes during object creation, after setting all properties.
function popPBc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popPBc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when Conv is resized.
function Conv_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to Conv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(hObject.UserData, 'BinTH')
    handles.bBTh.Value = 1;
elseif strcmp(hObject.UserData, 'DataT')
    bDTyp_Callback(handles.bDTyp, eventdata, handles);
    handles.bDTyp.Value = 1;
elseif strcmp(hObject.UserData, 'Half')
    bHalf_Callback(handles.bHalf, eventdata, handles);
    handles.bHalf.Value = 1;
elseif strcmp(hObject.UserData, 'GrayQ')
    bGray_Callback(handles.bGray, eventdata, handles);
    handles.bGray.Value = 1;
elseif strcmp(hObject.UserData, 'GrayN')
    bGrayN_Callback(handles.bGrayN, eventdata, handles);
    handles.bGrayN.Value = 1;
elseif strcmp(hObject.UserData, 'Gra2Col')
    bG2C_Callback(handles.bG2C, eventdata, handles);
    handles.bG2C.Value = 1;
elseif strcmp(hObject.UserData, 'Col2Gray')
    bC2G_Callback(handles.bC2G, eventdata, handles);
    handles.bC2G.Value = 1;
elseif strcmp(hObject.UserData, 'ColSpa')
    bCS_Callback(handles.bCS, eventdata, handles);
    handles.bCS.Value = 1;
elseif strcmp(hObject.UserData, 'Label')
    bLab_Callback(handles.bLab, eventdata, handles);
    handles.bLab.Value = 1;
end
hObject.UserData = 'NO';


% --- Executes on button press in bCGgray.
function bCGgray_Callback(hObject, eventdata, handles)
% hObject    handle to bCGgray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bCGgray
if strcmp(handles.axFun.UserData, 'NO')
    a = imread([pwd '\Resources\ColFunTyp.png']);
    axes(handles.axFun);
    imshow(a,'InitialMagnification','fit'); %%Rev
    handles.axFun.Visible = 'Off';
    handles.axFun.UserData = 'SI';
else
    handles.axFun.Children.Visible = 'On';
end
handles.lblFlp.String = 'Red Color:';
handles.lblFbp.String = 'Green Color:';
handles.lblFhp.String = 'Blue Color:';
handles.lblCfreq.Visible = 'Off';
handles.popLfreq.Visible = 'Off';
handles.popHfreq.Visible = 'Off';
handles.popLPc.Visible = 'Off';
handles.popPBc.Visible = 'Off';
handles.popHPc.Visible = 'Off';
handles.lblColM.Visible = 'On';
handles.popRmap.Visible = 'On';
handles.popGmap.Visible = 'On';
handles.popBmap.Visible = 'On';


% --- Executes on button press in bGCfreq.
function bGCfreq_Callback(hObject, eventdata, handles)
% hObject    handle to bGCfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bGCfreq
if strcmp(handles.axFun.UserData, 'NO')
    a = imread([pwd '\Resources\ColFunTyp.png']);
    axes(handles.axFun);
    imshow(a,'InitialMagnification','fit'); %%Rev
    handles.axFun.Visible = 'Off';
    handles.axFun.UserData = 'SI';
else
    handles.axFun.Children.Visible = 'On';
end
handles.lblFlp.String = 'Low-Pass Color:';
handles.lblFbp.String = 'Band-Pass Color:';
handles.lblFhp.String = 'High-Pass Color:';
handles.axFun.Children.Visible = 'Off';
handles.lblCfreq.Visible = 'On';
handles.popLfreq.Visible = 'On';
handles.popHfreq.Visible = 'On';
handles.popLPc.Visible = 'On';
handles.popPBc.Visible = 'On';
handles.popHPc.Visible = 'On';
handles.lblColM.Visible = 'Off';
handles.popRmap.Visible = 'Off';
handles.popGmap.Visible = 'Off';
handles.popBmap.Visible = 'Off';

function hide_all(handles)
handles.bGcol.Visible = 'Off';

handles.popCspa.Visible = 'Off';
handles.popHth.Visible = 'Off';
handles.popNgray.Visible = 'Off';
handles.lblTHlvl.Visible = 'Off';
handles.popTHlvl.Visible = 'Off';
handles.popDtype.Visible = 'Off';
handles.lblPos.Visible = 'Off';
handles.popHalf.Visible = 'Off';
handles.popGquant.Visible = 'Off';
handles.popGnat.Visible = 'Off';
handles.popCgray.Visible = 'Off';
handles.cFor.Visible = 'Off';
handles.cNorm.Visible = 'Off';
handles.cRem.Visible = 'Off';
handles.popCspa.Visible = 'Off';
handles.lblLabel.Visible = 'Off';   
handles.cSlab.Visible = 'Off';   


% --- Executes on button press in bCS.
function bCS_Callback(hObject, eventdata, handles)
% hObject    handle to bCS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bCS
hide_all(handles);              %hide all controls
handles.popCspa.Visible = 'On'; %show specific controls
handles.cFor.Visible = 'On';
handles.cNorm.Visible = 'On';
handles.cRem.Visible = 'On';


% --- Executes on button press in bC2G.
function bC2G_Callback(hObject, eventdata, handles)
% hObject    handle to bC2G (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bC2G
hide_all(handles);              %hide all controls
handles.popCgray.Visible = 'On';   %show specific controls


% --- Executes on button press in bLab.
function bLab_Callback(hObject, eventdata, handles)
% hObject    handle to bLab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bLab
hide_all(handles);              %hide all controls
handles.lblLabel.Visible = 'On';   %show specific controls
handles.cSlab.Visible = 'On';


% --------------------------------------------------------------------
function mFile_Callback(hObject, eventdata, handles)
% hObject    handle to mFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mAna_Callback(hObject, eventdata, handles)
% hObject    handle to mAna (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mGeo_Callback(hObject, eventdata, handles)
% hObject    handle to mGeo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mGeo_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mEdge_Callback(hObject, eventdata, handles)
% hObject    handle to mEdge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mEdge_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mSeg_Callback(hObject, eventdata, handles)
% hObject    handle to mSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mSeg_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mTrans_Callback(hObject, eventdata, handles)
% hObject    handle to mTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mTrans_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mFeat_Callback(hObject, eventdata, handles)
% hObject    handle to mFeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mFeat_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mPatt_Callback(hObject, eventdata, handles)
% hObject    handle to mPatt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mPatt_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function fOpen_Callback(hObject, eventdata, handles)
% hObject    handle to fOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMain = findobj('Tag','Main');              %get the handle of Main form
% get handles and other user-defined data associated to Gui1
g1data = guidata(hMain);
if ~isempty(hMain)
    CVIPToolbox('fOpen_Callback',g1data.fOpen,eventdata,guidata(g1data.fOpen))
end

% --------------------------------------------------------------------
function fSave_Callback(hObject, eventdata, handles)
% hObject    handle to fSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMain = findobj('Tag','Main');              %get the handle of Main form
% get handles and other user-defined data associated to Gui1
g1data = guidata(hMain);
if ~isempty(hMain)
    CVIPToolbox('fSave_Callback',g1data.fSave,eventdata,guidata(g1data.fSave))
end


% --------------------------------------------------------------------
function uiSaveIma_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiSaveIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMain = findobj('Tag','Main');              %get the handle of Main form
% get handles and other user-defined data associated to Gui1
g1data = guidata(hMain);
if ~isempty(hMain)
    CVIPToolbox('fSave_Callback',g1data.fSave,eventdata,guidata(g1data.fSave))
end

% --------------------------------------------------------------------
function uiOpenIma_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiOpenIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMain = findobj('Tag','Main');              %get the handle of Main form
% get handles and other user-defined data associated to Gui1
g1data = guidata(hMain);
if ~isempty(hMain)
    CVIPToolbox('fOpen_Callback',g1data.fOpen,eventdata,guidata(g1data.fOpen))
end

% --- Executes on button press in cSlab.
function cSlab_Callback(hObject, eventdata, handles)
% hObject    handle to cSlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cSlab


% --- Executes on key press with focus on popLfreq and none of its controls.
function popLfreq_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popLfreq (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);   %call function to add user data


% --- Executes on key press with focus on popHfreq and none of its controls.
function popHfreq_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popHfreq (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);   %call function to add user data


% --- Executes on key press with focus on popHth and none of its controls.
function popHth_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popHth (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on popTHlvl and none of its controls.
function popTHlvl_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popTHlvl (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);   %call function to add user data


% --- Executes on key press with focus on popNgray and none of its controls.
function popNgray_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popNgray (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);   %call function to add user data
