function varargout = DlgPseudo(varargin)
% DLGPSEUDO MATLAB code for DlgPseudo.fig
%      DLGPSEUDO, by itself, creates a new DLGPSEUDO or raises the existing
%      singleton*.
%
%      H = DLGPSEUDO returns the handle to a new DLGPSEUDO or the handle to
%      the existing singleton*.
%
%      DLGPSEUDO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DLGPSEUDO.M with the given input arguments.
%
%      DLGPSEUDO('Property','Value',...) creates a new DLGPSEUDO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgPseudo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgPseudo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DlgPseudo

% Last Modified by GUIDE v2.5 26-Jun-2019 11:36:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgPseudo_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgPseudo_OutputFcn, ...
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
%           Initial coding date:    /10/2017
%           Updated by:             Hridoy Bisws
%           Latest update date:     7/04/20
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
 % Revision 1.3  12/12/2018  17:10:24  jucuell
 % updating menu creation programmatically, callbacks to Main figure and
 % the use of the utilities menus in the Main figure.
%
 % Revision 1.2  04/03/2018  16:09:55  jucuell
 %  
 % 
%
 % Revision 1.1  11/21/2017  15:23:31  jucuell
 % Initial revision:
 % 
%

% --- Executes just before DlgPseudo is made visible.
function DlgPseudo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DlgPseudo (see VARARGIN)

% Choose default command line output for DlgPseudo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DlgPseudo wait for user response (see UIRESUME)
% uiwait(handles.Pseudo);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';%hide Analysis menu

cpath = mfilename( 'fullpath' );
cpath = cpath(1:end-9);
%Load image with mapping functions
a = imread([cpath 'Resources\ColFunTyp.png']);
axes(handles.axFun);
imshow(a,'InitialMagnification','fit'); %%Rev
handles.axFun.Visible = 'Off';
handles.axFun.UserData = 'SI';


% --- Outputs from this function are returned to the command line.
function varargout = DlgPseudo_OutputFcn(hObject, eventdata, handles) 
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
 close(handles.Pseudo)


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
clc                             %clear screen

%changing pointer arrow to watch on cursor
figure_set = findall(groot,'Type','Figure');
set(figure_set,'pointer','watch');

hMain = findobj('Tag','Main');  %get the handle of Main form
hSHisto = findobj('Tag','mVsaveHis'); %get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = hMain.UserData;         %get image handle
if hNfig == 0 || isempty(hNfig) || ~isfield(hNfig.UserData,'cvipIma')
    errordlg('Please select the image to Process', 'Pseudocolor Error', 'modal');
else
Ima=hNfig.UserData;             %Get image information
InIma = Ima.cvipIma;            %read image data
file = get(hNfig,'Name');       %get image name
band = size(InIma,3);           %get number of bands
histo = 0; OutIma = 0;          %initial vbles values

%check for gray sacale image
if band ~= 1
    errordlg(['Selected image is not gray scale image! Select a gray scale' ...
        ' image and try again.'], 'Pseudocolor Error', 'modal');
else
%Image Operations
if handles.bGCfreq.Value           %Frequency Domain mapping
    %check if the user select more than 1 time a color
    LPC = handles.popLPc.Value;     %LP color selection;
    BPC = handles.popPBc.Value;     %BP color selection;
    HPC = handles.popHPc.Value;     %HP color selection;

    if size(unique([LPC BPC HPC])) < 3
        errordlg('You must select a color just one time.','Pseudocolor Error','modal');
    else
        %%PROCEDURE
        %get frequencies
        Lfreq = str2double(handles.popLfreq.String(handles.popLfreq.Value));
        Hfreq = str2double(handles.popHfreq.String(handles.popHfreq.Value));
        %1. GET Transform OF GRAY IMAGE
        if handles.popFreqT.Value == 1    %use FFT
            fun='fft';
            Spect = fft_cvip(InIma, []);%call FFT function
            %2. Apply iFFT to LP, PB n HP filters (no keep DC)
            Filt = ideal_low_cvip(Spect, [], fun,0, Lfreq);%LPF
            LP = ifft_cvip(Filt,[]);  	%LowPass Image
            Filt = ideal_bandpass_cvip(Spect, [],fun,0, Lfreq+1, Hfreq-1);%BPF
            BP = ifft_cvip(Filt,[]);   	%BandPass Image
            Filt = ideal_high_cvip(Spect, [], fun,0, Hfreq);%HPF
            HP = ifft_cvip(Filt,[]);   	%HighPass Image
            Blk = size(Spect,1);
            histo = [212 Blk 0 0 0; 225 Blk 212 Lfreq 0; 227 Blk 212 ...
            Lfreq Hfreq; 226 Blk 212 Hfreq 0; 220 Blk 0 0 0; 79 0 1 ...
            0 0; 9 0 0 0 0];
        elseif handles.popFreqT.Value == 2 
            fun = 'dct';
            Spect = dct_cvip(InIma, []);%call DCT function
            %2. Apply iFFT to LP, PB n HP filters (no keep DC)
            Filt = ideal_low_cvip(Spect, [], fun, Lfreq);%LPF
            LP = idct_cvip(Filt,[]);  	%LowPass Image
            Filt = ideal_bandpass_cvip(Spect, [],fun, Lfreq+1, Hfreq-1);%BPF
            BP = idct_cvip(Filt,[]);   	%BandPass Image
            Filt = ideal_high_cvip(Spect, [], fun, Hfreq);%HPF
            HP = idct_cvip(Filt,[]);   	%HighPass Image
            Blk = size(Spect,1);
            histo = [211 Blk 0 0 0; 225 Blk 211 Lfreq 0; 227 Blk 211 ...
            Lfreq Hfreq; 226 Blk 211 Hfreq 0; 219 Blk 0 0 0; 79 0 1 ...
            0 0; 9 0 0 0 0];
        elseif handles.popFreqT.Value == 3 
            fun='haar';
            Spect = haar_cvip(InIma, []);%call HAAR function
            %2. Apply iFFT to LP, PB n HP filters (no keep DC)
            Filt = ideal_low_cvip(Spect, [], fun, Lfreq);%LPF
            LP = ihaar_cvip(Filt,[]);  	%LowPass Image
            Filt = ideal_bandpass_cvip(Spect, [],fun, Lfreq+1, Hfreq-1);%BPF
            BP = ihaar_cvip(Filt,[]);   	%BandPass Image
            Filt = ideal_high_cvip(Spect, [], fun, Hfreq);%HPF
            HP = ihaar_cvip(Filt,[]);   	%HighPass Image
            Blk = size(Spect,1);
            histo = [215 Blk 0 0 0; 225 Blk 215 Lfreq 0; 227 Blk 215 ...
            Lfreq Hfreq; 226 Blk 215 Hfreq 0; 221 Blk 0 0 0; 79 0 1 ...
            0 0; 9 0 0 0 0];
        else
            fun='walsh';
            Spect = walhad_cvip(InIma, []);%call WALHAD function
            %2. Apply iFFT to LP, PB n HP filters (no keep DC)
            Filt = ideal_low_cvip(Spect, [], fun, Lfreq);%LPF
            LP = iwalhad_cvip(Filt,[]);  	%LowPass Image
            Filt = ideal_bandpass_cvip(Spect, [],fun, Lfreq+1, Hfreq-1);%BPF
            BP = iwalhad_cvip(Filt,[]);   	%BandPass Image
            Filt = ideal_high_cvip(Spect, [], fun, Hfreq);%HPF
            HP = iwalhad_cvip(Filt,[]);   	%HighPass Image
            Blk = size(Spect,1);
            histo = [218 Blk 0 0 0; 225 Blk 218 Lfreq 0; 227 Blk 218 ...
            Lfreq Hfreq; 226 Blk 218 Hfreq 0; 222 Blk 0 0 0; 79 0 1 ...
            0 0; 9 0 0 0 0];
        end
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
        
        OutIma = assemble_bands_cvip(hist_stretch_cvip(R,0,1,0,0), ...
        hist_stretch_cvip(G,0,1,0,0), hist_stretch_cvip(B,0,1,0,0));
        Name = [file ' > Freq. Dom. Map.(' fun ',' num2str(Lfreq) ',' ...
        num2str(Hfreq) ')'];

    end
    
elseif handles.bCGgray.Value==1  	%Gray level mapping
    Rmap = handles.popRmap.Value;
    Gmap = handles.popGmap.Value;
    Bmap = handles.popBmap.Value;
    %get gray level limits
    Llim = str2double(handles.popLLim1.String(handles.popLLim1.Value));
    Hlim = str2double(handles.popHLim1.String(handles.popHLim1.Value));
    R = gray_levelmap_cvip(InIma, Rmap, Llim, Hlim);
    Llim = str2double(handles.popLLim2.String(handles.popLLim2.Value));
    Hlim = str2double(handles.popHLim2.String(handles.popHLim2.Value));
    G = gray_levelmap_cvip(InIma, Gmap, Llim, Hlim);
    Llim = str2double(handles.popLLim3.String(handles.popLLim3.Value));
    Hlim = str2double(handles.popHLim3.String(handles.popHLim3.Value));
    B = gray_levelmap_cvip(InIma, Bmap, Llim, Hlim);

    OutIma = assemble_bands_cvip(R, G, B);
    Name = strcat(file, ' > Gray Lvl. Map.(',num2str(Rmap),',', ...
        num2str(Gmap),',',num2str(Bmap),')');
    histo = [85 Rmap Gmap Bmap; 72 0 0 0];%update histogram

elseif handles.bCGsli.Value==1   	%Intensity Slicing
    %create image according to Out of range values
    OutIma = zeros([size(InIma) 3]);
    %get range values
    Ran1 = str2double(handles.popR11.String(handles.popR11.Value));
    Ran2 = str2double(handles.popR12.String(handles.popR12.Value));
    RanTot = ones(1,256);
    RanTot(Ran1+1:Ran2+1) = 0;
    %get color values
    R = str2double(handles.popR1.String(handles.popR1.Value));
    G = str2double(handles.popG1.String(handles.popG1.Value));
    B = str2double(handles.popB1.String(handles.popB1.Value));
    %setup Image for Range 1
    tIma = (InIma >= Ran1) & (InIma <= Ran2);
    %set up colors for Range 1
    OutIma(:,:,1) = or_cvip(OutIma(:,:,1),tIma*R);
    OutIma(:,:,2) = or_cvip(OutIma(:,:,2),tIma*G);
    OutIma(:,:,3) = or_cvip(OutIma(:,:,3),tIma*B);
    
    %get range values
    Ran1 = str2double(handles.popR21.String(handles.popR21.Value));
    Ran2 = str2double(handles.popR22.String(handles.popR22.Value));
    RanTot(Ran1+1:Ran2+1) = 0;
    %get color values
    R = str2double(handles.popR2.String(handles.popR2.Value));
    G = str2double(handles.popG2.String(handles.popG2.Value));
    B = str2double(handles.popB2.String(handles.popB2.Value));
    %setup Image for Range 2
    tIma1 = (InIma >= Ran1) & (InIma <= Ran2);
    %set up colors for Range 2
    OutIma(:,:,1) = or_cvip(OutIma(:,:,1),tIma1*R);
    OutIma(:,:,2) = or_cvip(OutIma(:,:,2),tIma1*G);
    OutIma(:,:,3) = or_cvip(OutIma(:,:,3),tIma1*B);
    
    %get range values
    Ran1 = str2double(handles.popR31.String(handles.popR31.Value));
    Ran2 = str2double(handles.popR32.String(handles.popR32.Value));
    RanTot(Ran1+1:Ran2+1) = 0;
    %get color values
    R = str2double(handles.popR3.String(handles.popR3.Value));
    G = str2double(handles.popG3.String(handles.popG3.Value));
    B = str2double(handles.popB3.String(handles.popB3.Value));
    %setup Image for Range 3
    tIma2 = (InIma >= Ran1) & (InIma <= Ran2);
    %set up colors for Range 3
    OutIma(:,:,1) = or_cvip(OutIma(:,:,1),tIma2*R);
    OutIma(:,:,2) = or_cvip(OutIma(:,:,2),tIma2*G);
    OutIma(:,:,3) = or_cvip(OutIma(:,:,3),tIma2*B);
    
    %get range values
    Ran1 = str2double(handles.popR41.String(handles.popR41.Value));
    Ran2 = str2double(handles.popR42.String(handles.popR42.Value));
    RanTot(Ran1+1:Ran2+1) = 0;
    %get color values
    R = str2double(handles.popR4.String(handles.popR4.Value));
    G = str2double(handles.popG4.String(handles.popG4.Value));
    B = str2double(handles.popB4.String(handles.popB4.Value));
    %setup Image for Range 4
    tIma3 = (InIma >= Ran1) & (InIma <= Ran2);
    %set up colors for Range 4
    OutIma(:,:,1) = or_cvip(OutIma(:,:,1),tIma3*R);
    OutIma(:,:,2) = or_cvip(OutIma(:,:,2),tIma3*G);
    OutIma(:,:,3) = or_cvip(OutIma(:,:,3),tIma3*B);
    
    if handles.cOut.Value   %Out of range gray levels    
        vOutR = str2double(handles.popOutR.String(handles.popOutR.Value));
        vOutG = str2double(handles.popOutG.String(handles.popOutG.Value));
        vOutB = str2double(handles.popOutB.String(handles.popOutB.Value));
        [~,b]=find(RanTot==1);
        for i = 1:size(b,2)
            tIma = (InIma == b(i)-1);
            if sum(tIma(:))>0
                OutIma(:,:,1) = or_cvip(OutIma(:,:,1),tIma*vOutR);
                OutIma(:,:,2) = or_cvip(OutIma(:,:,2),tIma*vOutG);
                OutIma(:,:,3) = or_cvip(OutIma(:,:,3),tIma*vOutB);
            end
        end
    else
        InIma = double(InIma);
        tempIma = not(tIma1 + tIma2 + tIma3 + tIma);
        OutIma(:,:,1) = or_cvip(OutIma(:,:,1),tempIma.*InIma);
        OutIma(:,:,2) = or_cvip(OutIma(:,:,2),tempIma.*InIma);
        OutIma(:,:,3) = or_cvip(OutIma(:,:,3),tempIma.*InIma);
    end
    Name = strcat(file,' > Inten. Sli.');
    histo = [4 -1; 8 0; 9 0];

elseif handles.bCGgra2.Value==1     %Gray level mapping 2
    
    
end

end

if sum(histo) ~= 0
%check if need to save history
if strcmp(hSHisto(1).Checked,'on')              %save new image history
    Ima.fInfo.history_info = historyupdate_cvip(Ima.fInfo.history_info,histo);  
end
%check if need to show function information
if strcmp(hVfinfo(1).Checked,'on')
    hIlist = findobj('Tag','txtIlist');         %get handle of text element
    hIlist.String(end+1,1)=' ';                 %print an empty line
    txtInfo = historydeco_cvip(histo);     
    hIlist.String(end+1,1:size(file,2)+1)=[file ':']; 
    for i=1:size(txtInfo)
        sInfo = txtInfo{i};                     %extract row to print
        sInfo = sprintf(sInfo);
        [~,rr] = size(sInfo);
        hIlist.String(end+1,1:rr) = sInfo;
    end
    hIlist.Value = size(hIlist.String,1);       %goto last line
    figure(hMain);
end

end
if size(OutIma,1) > 3
    [row,col,band]=size(OutIma);                    %get new image size
    %update image information
    Ima.fInfo.no_of_bands=band;             
    Ima.fInfo.no_of_cols=col;              
    Ima.fInfo.no_of_rows=row;
    %update image structure
    Ima.cvipIma = OutIma;                           %read image data
    showgui_cvip(Ima, Name);                        %show image in viewer
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

%show correspondent gray level ranges
if hObject.Value < 4
    handles.popLLim1.Visible = 'On';
    handles.popHLim1.Visible = 'On';
else
    handles.popLLim1.Visible = 'Off';
    handles.popHLim1.Visible = 'Off';
end

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

%show correspondent gray level ranges
if hObject.Value < 4
    handles.popLLim2.Visible = 'On';
    handles.popHLim2.Visible = 'On';
else
    handles.popLLim2.Visible = 'Off';
    handles.popHLim2.Visible = 'Off';
end

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


% --- Executes on button press in bBrDa.
function bBrDa_Callback(hObject, eventdata, handles)
% hObject    handle to bBrDa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bBrDa
hide_all(handles);               %hide all controls
handles.popFac.Visible = 'On'; %show specific controls
handles.lblFac.Visible = 'On';

% --- Executes on selection change in popTrans.
function popTrans_Callback(hObject, eventdata, handles)
% hObject    handle to popTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popTrans contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popTrans


% --- Executes during object creation, after setting all properties.
function popTrans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popTrans (see GCBO)
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

% --- Executes on selection change in popFac.
function popFac_Callback(hObject, eventdata, handles)
% hObject    handle to popFac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popFac contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popFac


% --- Executes during object creation, after setting all properties.
function popFac_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popFac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popEdge.
function popEdge_Callback(hObject, eventdata, handles)
% hObject    handle to popEdge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popEdge contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popEdge
if strcmp(hObject.String(hObject.Value),'Unsharp Masking')
    handles.popELow.Visible = 'On';      %show Threshold level control
    handles.popEHigh.Visible = 'On';      %show Threshold level control
    handles.lblEdgLim.Visible = 'On';      %show Threshold level control
    handles.popEHclip.Visible = 'On';      %show Threshold level control
    handles.popELclip.Visible = 'On';      %show Threshold level control
    handles.lblEdgeClip.Visible = 'On';      %show Threshold level control
    handles.popTrans.Visible = 'Off';      %show Threshold level control
else
    handles.popELow.Visible = 'Off';      %show Threshold level control
    handles.popEHigh.Visible = 'Off';      %show Threshold level control
    handles.lblEdgLim.Visible = 'Off';      %show Threshold level control
    handles.popEHclip.Visible = 'Off';      %show Threshold level control
    handles.popELclip.Visible = 'Off';      %show Threshold level control
    handles.lblEdgeClip.Visible = 'Off';      %show Threshold level control
end
% if strcmp(hObject.String(hObject.Value),'High Frequency Emphasis')
%     handles.popTrans.Visible = 'On';      %show Threshold level control
% end

% --- Executes during object creation, after setting all properties.
function popEdge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popEdge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popHistEqu.
function popHistEqu_Callback(hObject, eventdata, handles)
% hObject    handle to popHistEqu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popHistEqu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popHistEqu

% --- Executes during object creation, after setting all properties.
function popHistEqu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popHistEqu (see GCBO)
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

%show correspondent gray level ranges
if hObject.Value < 4
    handles.popLLim3.Visible = 'On';
    handles.popHLim3.Visible = 'On';
else
    handles.popLLim3.Visible = 'Off';
    handles.popHLim3.Visible = 'Off';
end

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


% --- Executes on button press in bCGsli.
function bCGsli_Callback(hObject, eventdata, handles)
% hObject    handle to bCGsli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bCGsli
hide_all(handles);              %hide all controls
handles.pSli.Visible = 'On'; %show specific controls
%update panel colors
update_panels(handles);

% --- Executes on button press in bCGgra2.
function bCGgra2_Callback(hObject, eventdata, handles)
% hObject    handle to bCGgra2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bCGgra2
hide_all(handles);                  %hide all controls
% handles.pHisStre.Visible = 'On';   %show specific controls


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

% --- Executes when Pseudo is resized.
function Pseudo_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to Pseudo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if strcmp(hObject.UserData, 'BriDa')
%     handles.bBrDa.Value = 1;
% elseif strcmp(hObject.UserData, 'Edge')
%     bEdge_Callback(handles.bEdge, eventdata, handles);
%     handles.bEdge.Value = 1;
% elseif strcmp(hObject.UserData, 'HEqu')
%     bHisEqu_Callback(handles.bCGsli, eventdata, handles);
%     handles.bCGsli.Value = 1;
% elseif strcmp(hObject.UserData, 'HStre')
%     bHisStre_Callback(handles.bCGgra2, eventdata, handles);
%     handles.bCGgra2.Value = 1;
% elseif strcmp(hObject.UserData, 'Pseu')
%     bPseu_Callback(handles.bPseu, eventdata, handles);
%     handles.bPseu.Value = 1;
% elseif strcmp(hObject.UserData, 'Sharp')
%     bSharp_Callback(handles.bSharp, eventdata, handles);
%     handles.bSharp.Value = 1;
% end
% hObject.UserData = 'NO';


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
hide_all(handles)
handles.pGray.Visible = 'On';    


% --- Executes on button press in bGCfreq.
function bGCfreq_Callback(hObject, eventdata, handles)
% hObject    handle to bGCfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bGCfreq
hide_all(handles) 
handles.pFreq.Visible = 'On';   

function hide_all(handles)
handles.pGray.Visible = 'Off';  
handles.pFreq.Visible = 'Off';   
handles.pSli.Visible = 'Off';   

function update_panels(handles)
R = str2double(handles.popR1.String(handles.popR1.Value));
G = str2double(handles.popG1.String(handles.popG1.Value));
B = str2double(handles.popB1.String(handles.popB1.Value));
handles.pCol1.BackgroundColor = [R G B]/255;
R = str2double(handles.popR2.String(handles.popR2.Value));
G = str2double(handles.popG2.String(handles.popG2.Value));
B = str2double(handles.popB2.String(handles.popB2.Value));
handles.pCol2.BackgroundColor = [R G B]/255;
R = str2double(handles.popR3.String(handles.popR3.Value));
G = str2double(handles.popG3.String(handles.popG3.Value));
B = str2double(handles.popB3.String(handles.popB3.Value));
handles.pCol3.BackgroundColor = [R G B]/255;
R = str2double(handles.popR4.String(handles.popR4.Value));
G = str2double(handles.popG4.String(handles.popG4.Value));
B = str2double(handles.popB4.String(handles.popB4.Value));
handles.pCol4.BackgroundColor = [R G B]/255;
R = str2double(handles.popOutR.String(handles.popOutR.Value));
G = str2double(handles.popOutG.String(handles.popOutG.Value));
B = str2double(handles.popOutB.String(handles.popOutB.Value));
handles.pColOut.BackgroundColor = [R G B]/255;

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


% --- Executes on selection change in popLLim1.
function popLLim1_Callback(hObject, eventdata, handles)
% hObject    handle to popLLim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popLLim1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popLLim1


% --- Executes during object creation, after setting all properties.
function popLLim1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popLLim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popHLim1.
function popHLim1_Callback(hObject, eventdata, handles)
% hObject    handle to popHLim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popHLim1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popHLim1


% --- Executes during object creation, after setting all properties.
function popHLim1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popHLim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popLClip.
function popLClip_Callback(hObject, eventdata, handles)
% hObject    handle to popLClip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popLClip contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popLClip


% --- Executes during object creation, after setting all properties.
function popLClip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popLClip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popHClip.
function popHClip_Callback(hObject, eventdata, handles)
% hObject    handle to popHClip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popHClip contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popHClip


% --- Executes during object creation, after setting all properties.
function popHClip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popHClip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popELow.
function popELow_Callback(hObject, eventdata, handles)
% hObject    handle to popELow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popELow contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popELow


% --- Executes during object creation, after setting all properties.
function popELow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popELow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popEHigh.
function popEHigh_Callback(hObject, eventdata, handles)
% hObject    handle to popEHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popEHigh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popEHigh


% --- Executes during object creation, after setting all properties.
function popEHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popEHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popEHclip.
function popEHclip_Callback(hObject, eventdata, handles)
% hObject    handle to popEHclip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popEHclip contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popEHclip


% --- Executes during object creation, after setting all properties.
function popEHclip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popEHclip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popELclip.
function popELclip_Callback(hObject, eventdata, handles)
% hObject    handle to popELclip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popELclip contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popELclip


% --- Executes during object creation, after setting all properties.
function popELclip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popELclip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popSMask.
function popSMask_Callback(hObject, eventdata, handles)
% hObject    handle to popSMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popSMask contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSMask


% --- Executes during object creation, after setting all properties.
function popSMask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popSMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popSlclip.
function popSlclip_Callback(hObject, eventdata, handles)
% hObject    handle to popSlclip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popSlclip contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSlclip


% --- Executes during object creation, after setting all properties.
function popSlclip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popSlclip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popSHclip.
function popSHclip_Callback(hObject, eventdata, handles)
% hObject    handle to popSHclip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popSHclip contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSHclip


% --- Executes during object creation, after setting all properties.
function popSHclip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popSHclip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popSsob.
function popSsob_Callback(hObject, eventdata, handles)
% hObject    handle to popSsob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popSsob contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSsob


% --- Executes during object creation, after setting all properties.
function popSsob_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popSsob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cSint.
function cSint_Callback(hObject, eventdata, handles)
% hObject    handle to cSint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cSint


% --- Executes on button press in cSadd.
function cSadd_Callback(hObject, eventdata, handles)
% hObject    handle to cSadd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cSadd


% --- Executes on key press with focus on popSsob and none of its controls.
function popSsob_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popSsob (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popSHclip and none of its controls.
function popSHclip_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popSHclip (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popSlclip and none of its controls.
function popSlclip_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popSlclip (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popELclip and none of its controls.
function popELclip_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popELclip (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popEHclip and none of its controls.
function popEHclip_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popEHclip (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popEHigh and none of its controls.
function popEHigh_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popEHigh (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popELow and none of its controls.
function popELow_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popELow (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popFac and none of its controls.
function popFac_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popFac (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popLLim1 and none of its controls.
function popLLim1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popLLim1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popHLim1 and none of its controls.
function popHLim1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popHLim1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popLClip and none of its controls.
function popLClip_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popLClip (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popHClip and none of its controls.
function popHClip_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popHClip (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data


% --- Executes on key press with focus on popLfreq and none of its controls.
function popLfreq_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popLfreq (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popHfreq and none of its controls.
function popHfreq_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popHfreq (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data


% --- Executes on selection change in popLLim2.
function popLLim2_Callback(hObject, eventdata, handles)
% hObject    handle to popLLim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popLLim2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popLLim2


% --- Executes during object creation, after setting all properties.
function popLLim2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popLLim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popHLim2.
function popHLim2_Callback(hObject, eventdata, handles)
% hObject    handle to popHLim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popHLim2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popHLim2


% --- Executes during object creation, after setting all properties.
function popHLim2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popHLim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popLLim3.
function popLLim3_Callback(hObject, eventdata, handles)
% hObject    handle to popLLim3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popLLim3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popLLim3


% --- Executes during object creation, after setting all properties.
function popLLim3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popLLim3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popHLim3.
function popHLim3_Callback(hObject, eventdata, handles)
% hObject    handle to popHLim3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popHLim3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popHLim3


% --- Executes during object creation, after setting all properties.
function popHLim3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popHLim3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popR11.
function popR11_Callback(hObject, eventdata, handles)
% hObject    handle to popR11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popR11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popR11


% --- Executes during object creation, after setting all properties.
function popR11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popR11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popR12.
function popR12_Callback(hObject, eventdata, handles)
% hObject    handle to popR12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popR12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popR12


% --- Executes during object creation, after setting all properties.
function popR12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popR12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popR21.
function popR21_Callback(hObject, eventdata, handles)
% hObject    handle to popR21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popR21 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popR21


% --- Executes during object creation, after setting all properties.
function popR21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popR21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popR22.
function popR22_Callback(hObject, eventdata, handles)
% hObject    handle to popR22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popR22 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popR22


% --- Executes during object creation, after setting all properties.
function popR22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popR22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popR31.
function popR31_Callback(hObject, eventdata, handles)
% hObject    handle to popR31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popR31 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popR31


% --- Executes during object creation, after setting all properties.
function popR31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popR31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popR32.
function popR32_Callback(hObject, eventdata, handles)
% hObject    handle to popR32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popR32 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popR32


% --- Executes during object creation, after setting all properties.
function popR32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popR32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popR41.
function popR41_Callback(hObject, eventdata, handles)
% hObject    handle to popR41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popR41 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popR41


% --- Executes during object creation, after setting all properties.
function popR41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popR41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popR42.
function popR42_Callback(hObject, eventdata, handles)
% hObject    handle to popR42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popR42 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popR42


% --- Executes during object creation, after setting all properties.
function popR42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popR42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popR1.
function popR1_Callback(hObject, eventdata, handles)
% hObject    handle to popR1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popR1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popR1
%update panel colors
update_panels(handles);

% --- Executes during object creation, after setting all properties.
function popR1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popR1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popG1.
function popG1_Callback(hObject, eventdata, handles)
% hObject    handle to popG1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popG1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popG1
%update panel colors
update_panels(handles);

% --- Executes during object creation, after setting all properties.
function popG1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popG1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popR2.
function popR2_Callback(hObject, eventdata, handles)
% hObject    handle to popR2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popR2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popR2
%update panel colors
update_panels(handles);

% --- Executes during object creation, after setting all properties.
function popR2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popR2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popG2.
function popG2_Callback(hObject, eventdata, handles)
% hObject    handle to popG2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popG2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popG2
%update panel colors
update_panels(handles);

% --- Executes during object creation, after setting all properties.
function popG2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popG2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popR3.
function popR3_Callback(hObject, eventdata, handles)
% hObject    handle to popR3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popR3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popR3
%update panel colors
update_panels(handles);

% --- Executes during object creation, after setting all properties.
function popR3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popR3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popG3.
function popG3_Callback(hObject, eventdata, handles)
% hObject    handle to popG3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popG3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popG3
%update panel colors
update_panels(handles);

% --- Executes during object creation, after setting all properties.
function popG3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popG3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popR4.
function popR4_Callback(hObject, eventdata, handles)
% hObject    handle to popR4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popR4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popR4
%update panel colors
update_panels(handles);

% --- Executes during object creation, after setting all properties.
function popR4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popR4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popG4.
function popG4_Callback(hObject, eventdata, handles)
% hObject    handle to popG4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popG4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popG4
%update panel colors
update_panels(handles);

% --- Executes during object creation, after setting all properties.
function popG4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popG4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popB1.
function popB1_Callback(hObject, eventdata, handles)
% hObject    handle to popB1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popB1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popB1
%update panel colors
update_panels(handles);

% --- Executes during object creation, after setting all properties.
function popB1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popB1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popB2.
function popB2_Callback(hObject, eventdata, handles)
% hObject    handle to popB2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popB2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popB2
%update panel colors
update_panels(handles);

% --- Executes during object creation, after setting all properties.
function popB2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popB2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popB3.
function popB3_Callback(hObject, eventdata, handles)
% hObject    handle to popB3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popB3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popB3
%update panel colors
update_panels(handles);

% --- Executes during object creation, after setting all properties.
function popB3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popB3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popB4.
function popB4_Callback(hObject, eventdata, handles)
% hObject    handle to popB4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popB4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popB4
%update panel colors
update_panels(handles);

% --- Executes during object creation, after setting all properties.
function popB4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popB4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popOutR.
function popOutR_Callback(hObject, eventdata, handles)
% hObject    handle to popOutR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popOutR contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popOutR
update_panels(handles);

% --- Executes during object creation, after setting all properties.
function popOutR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popOutR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on popHLim3 and none of its controls.
function popHLim3_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popHLim3 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popLLim3 and none of its controls.
function popLLim3_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popLLim3 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popHLim2 and none of its controls.
function popHLim2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popHLim2 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popLLim2 and none of its controls.
function popLLim2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popLLim2 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popB3 and none of its controls.
function popB3_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popB3 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popB2 and none of its controls.
function popB2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popB2 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popB1 and none of its controls.
function popB1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popB1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popG4 and none of its controls.
function popG4_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popG4 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popR4 and none of its controls.
function popR4_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popR4 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popG3 and none of its controls.
function popG3_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popG3 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popR3 and none of its controls.
function popR3_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popR3 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popG2 and none of its controls.
function popG2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popG2 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popR2 and none of its controls.
function popR2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popR2 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popG1 and none of its controls.
function popG1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popG1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popR1 and none of its controls.
function popR1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popR1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popR42 and none of its controls.
function popR42_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popR42 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popR41 and none of its controls.
function popR41_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popR41 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popR32 and none of its controls.
function popR32_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popR32 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popR31 and none of its controls.
function popR31_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popR31 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popR22 and none of its controls.
function popR22_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popR22 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popR21 and none of its controls.
function popR21_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popR21 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popR12 and none of its controls.
function popR12_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popR12 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popR11 and none of its controls.
function popR11_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popR11 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popOutR and none of its controls.
function popOutR_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popOutR (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popB4 and none of its controls.
function popB4_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popB4 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on button press in cOut.
function cOut_Callback(hObject, eventdata, handles)
% hObject    handle to cOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cOut


% --- Executes on selection change in popFreqT.
function popFreqT_Callback(hObject, eventdata, handles)
% hObject    handle to popFreqT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popFreqT contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popFreqT


% --- Executes during object creation, after setting all properties.
function popFreqT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popFreqT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popOutG.
function popOutG_Callback(hObject, eventdata, handles)
% hObject    handle to popOutG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popOutG contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popOutG
update_panels(handles);

% --- Executes during object creation, after setting all properties.
function popOutG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popOutG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popOutB.
function popOutB_Callback(hObject, eventdata, handles)
% hObject    handle to popOutB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popOutB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popOutB
update_panels(handles);

% --- Executes during object creation, after setting all properties.
function popOutB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popOutB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on popOutG and none of its controls.
function popOutG_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popOutG (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data


% --- Executes on key press with focus on popOutB and none of its controls.
function popOutB_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popOutB (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data
