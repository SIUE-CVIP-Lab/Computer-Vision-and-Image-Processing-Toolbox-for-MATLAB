function varargout = mUEnh(varargin)
% MUENH MATLAB code for mUEnh.fig
%      MUENH, by itself, creates a new MUENH or raises the existing
%      singleton*.
%
%      H = MUENH returns the handle to a new MUENH or the handle to
%      the existing singleton*.
%
%      MUENH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MUENH.M with the given input arguments.
%
%      MUENH('Property','Value',...) creates a new MUENH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mUEnh_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mUEnh_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mUEnh

% Last Modified by GUIDE v2.5 05-Jun-2019 11:37:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mUEnh_OpeningFcn, ...
                   'gui_OutputFcn',  @mUEnh_OutputFcn, ...
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
%           Updated by:             Hridoy Biswas
%           Latest update date:     6/28/2020
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

% --- Executes just before mUEnh is made visible.
function mUEnh_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mUEnh (see VARARGIN)

% Choose default command line output for mUEnh
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';%hide Analysis menu
hUtil = findobj('Tag','mUshos');
% hUtil(1).MenuSelectedFcn=@(hObject,eventdata)CVIPToolbox('mUshow_Callback',...
%     hObject,'Enha',guidata(hObject));
hUtil(1).Callback=@(hObject,eventdata)CVIPToolbox('mUshow_Callback',...
    hObject,'Enha',guidata(hObject));


% --- Outputs from this function are returned to the command line.
function varargout = mUEnh_OutputFcn(hObject, eventdata, handles) 
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
 close(handles.Enha)


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
hMain = findobj('Tag','Main');  %get the handle of Main form
hSHisto = findobj('Tag','mVsaveHis'); %get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = hMain.UserData;         %get image handle
if hNfig == 0 || isempty(hNfig) || ~isfield(hNfig.UserData,'cvipIma')
    errordlg('Please select the image to Process', 'Enhance Error', 'modal');
else
Ima=hNfig.UserData;             %Get image information
InIma = Ima.cvipIma;            %read image data
file = get(hNfig,'Name');       %get image name
band = size(InIma,3);           %get number of bands
histo = 0; OutIma = 0;          %initial vbles values

%Image OPerations
if handles.bBrDa.Value==1     	%perform binary Thresholding 
    %get Threshold value from GUI
    Fact = str2double(handles.popFac.String(handles.popFac.Value));
    OutIma = multiply_cvip(InIma, Fact);
    %show ima
    Name = [file,' > Multiply (',num2str(Fact),')'];
    histo = [4 Fact];
    
elseif handles.bEdge.Value==1	%Edhe enhancement   
    edMet = handles.popEdge.Value;
    switch edMet
        case 1                  %HfE
            OutIma = highfreqemphasis_cvip(InIma, [], 128, 1.5, 4);
            row = size(OutIma,1);
            Name = [file,' > hfe (',num2str(row),',128,1.5,4)'];
            histo = [235 row 128 1.5 4];
        case 2                  %Unsharp Mask
            sLow = str2double(handles.popELow.String(handles.popELow.Value));
            sHigh = str2double(handles.popEHigh.String(handles.popEHigh.Value));
            lClip = str2double(handles.popELclip.String(handles.popELclip.Value));
            hClip = str2double(handles.popEHclip.String(handles.popEHclip.Value));
            OutIma = unsharp_cvip(InIma, [sLow sHigh], [lClip hClip]);
            Name = [file ' > UnsharpMask (' num2str(sLow) ',' num2str(sHigh)...
                ',' num2str(lClip) ',' num2str(hClip) ')'];
            histo = [80 sLow sHigh lClip hClip];
        case 3                  %FFT
            OutIma = fft_cvip(InIma, []);
            row = size(OutIma,1);
            OutIma = butterworth_high_cvip(OutIma, [], 'fft','n', 4, 128);
            OutIma = ifft_cvip(OutIma, []);
            OutIma = add_cvip(InIma, OutIma);
            OutIma=hist_stretch_cvip(OutIma,0,255,0.01,0.01);%call function
            Name = [file,' > FFT Sharp '];
            %update image history
            histo = [212 row 0 0 0; 231 row 212 4 128; 220 row 0 0 0;...
                1 -1 0 0 0; 79 0 255 0.01 0.01];
        case 4                  %DCT
            OutIma = dct_cvip(InIma, []);
            row = size(OutIma,1);
            OutIma = butterworth_high_cvip(OutIma, [], 'fft','n', 4, 128);
            OutIma = idct_cvip(OutIma, []);
            OutIma = add_cvip(InIma, OutIma);
            OutIma=hist_stretch_cvip(OutIma,0,255,0.01,0.01);%call function
            Name = [file,' > DCT Sharp '];
            %update image history
            histo = [211 row 0 0 0; 231 row 211 4 128; 219 row 0 0 0;...
                1 -1 0 0 0; 79 0 255 0.01 0.01];
    end

elseif handles.bHisEqu.Value==1        	%Histogram Equalization
    Method = handles.popHistEqu.Value; 	%get selected method
    if band == 1
        OutIma = histeq_cvip(InIma,0); 	%call function
        Func = 'HistEquGray';
        %update image history
        histo = [73 1];
    else
        switch Method
            case 1             %lightness
            OutIma = rgb2hsl_cvip(InIma,1);%convert to hsl OutIma(1:10)
            Light = OutIma(:,:,3);%extract lightness
            Light = histeq_cvip(floor(Light*255),0);%call function
            OutIma(:,:,3) = double(Light)/255;%assemble new light band
            OutIma = uint8(hsl2rgb_cvip(OutIma,1)*255);%call function
            Func = 'HistEquL'; 	%image function for image name
            %update image history
            histo = [22 1; 10 3; 73 1; 9 3; 14 1];
            
            case 2              %equalize red band
            OutIma = (histeq_cvip(InIma,0));%call function
            Func = 'HistEquR';
            %update image history
            histo = [73 1];
            
            case 3              %equalize green band
            OutIma = (histeq_cvip(InIma,1));%call function
            Func = 'HistEquG';
            %update image history
            histo = [73 2];
            
            case 4              %equalize blue band
            OutIma = (histeq_cvip(InIma,2));%call function
            Func = 'HistEquB';
            %update image history
            histo = [73 3];
            
        end
    end
    Name = strcat(file,' > ',Func);

elseif handles.bHisStre.Value==1           %perform Gray quantization
    %get low gray level value
    Low=str2double(handles.popLLim.String(handles.popLLim.Value));
    %get high gray level value
    High=str2double(handles.popHLim.String(handles.popHLim.Value));
    %get low clip % value
    lClip=str2double(handles.popLClip.String(handles.popLClip.Value));
    %get high clip %  value
    hClip=str2double(handles.popHClip.String(handles.popHClip.Value));
    OutIma=hist_stretch_cvip(InIma,Low,High,lClip,hClip);   %call function
    %update image history
    histo = [79 Low High lClip hClip];
    Func = 'HistStre';
    Name=strcat(file,' > ',Func,'(',num2str(Low),',',num2str(High),...
        ',',num2str(lClip),',',num2str(hClip),')'); 

elseif handles.bPseu.Value==1          %perform Gray to Natural binary
    if handles.bGCfreq.Value           %by frequency mapping
        %check if the user select more than 1 time a color
        LPC = handles.popLPc.Value;     %LP color selection;
        BPC = handles.popPBc.Value;     %BP color selection;
        HPC = handles.popHPc.Value;     %HP color selection;

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
            Filt = ideal_low_cvip(Spect, [], 'fft', Lfreq);%LPF
            LP = ifft_cvip(Filt,[]);        %LowPass Image
            Filt = ideal_bandpass_cvip(Spect, [],'fft', Lfreq, Hfreq);%BPF
            BP = ifft_cvip(Filt,[]);        %BandPass Image
            Filt = ideal_high_cvip(Spect, [], 'fft', Hfreq);%HPF
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
            Blk = size(R,1);
            OutIma = assemble_bands_cvip(hist_stretch_cvip(R,0,1,0,0), ...
            hist_stretch_cvip(G,0,1,0,0), hist_stretch_cvip(B,0,1,0,0));
            Name = strcat(file, ' > Gray2Col (Freq.Map.)(',num2str(Lfreq),',', ...
            num2str(Hfreq), ')');
            histo = [212 Blk 0 0 0; 225 Blk 212 Lfreq 0; 227 Blk 212 ...
                Lfreq Hfreq; 226 Blk 212 Hfreq 0; 220 Blk 0 0 0; 79 0 1 ...
                0 0; 9 0 0 0 0];
        end
    else                        %by gray level mapping
        Lfreq = str2double(handles.popLfreq.String(handles.popLfreq.Value));
        Hfreq = str2double(handles.popHfreq.String(handles.popHfreq.Value));
        Rmap = handles.popRmap.Value;
        Gmap = handles.popGmap.Value;
        Bmap = handles.popBmap.Value;
        
        R = gray_levelmap_cvip(InIma, Rmap,Lfreq,Hfreq);
        G = gray_levelmap_cvip(InIma, Gmap,Lfreq,Hfreq);
        B = gray_levelmap_cvip(InIma, Bmap,Lfreq,Hfreq);
        OutIma = assemble_bands_cvip(R, G, B);
        Name = strcat(file, ' > Gray2Col (Gray.Map.)(',num2str(Rmap),',', ...
            num2str(Gmap),',',num2str(Bmap),')');
        histo = [85 Rmap Gmap Bmap; 72 0 0 0];%update histogram
    end
    
elseif handles.bSharp.Value==1         %Create Rectangle 
%     width = str2double(handles.popFac.String(handles.popFac.Value));
%     height = str2double(handles.popEdge.String(handles.popEdge.Value));
    if handles.cSadd.Value
        var1 =1;
    else
        var1=0;
    end
    if handles.I_ra.Value
         var2 =1;
    else
        var2=0;
    end
     size1 = str2double(handles.popSsob.String(handles.popSsob.Value));
     L_mask= str2double(handles.popSMask.String(handles.popSMask.Value));
     l_clip = str2double(handles.popSlclip.String(handles.popSlclip.Value));
     h_clip = str2double(handles.popSHclip.String(handles.popSHclip.Value));
     OutIma = sharp_i_cvip(InIma,L_mask,size1,l_clip,h_clip,var1,var2);
      Name = strcat(file, ' > Sharpening (',num2str(l_clip),',', ...
            num2str(h_clip), ')');
      histo = [79 L_mask size1 l_clip h_clip];
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


% --- Executes on button press in bEdge.
function bEdge_Callback(hObject, eventdata, handles)
% hObject    handle to bEdge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bEdge
hide_all(handles);              %hide all controls
handles.pEdge.Visible = 'On';   %show specific controls
handles.popTrans.Visible = 'Off'; 


% --- Executes on button press in bHisEqu.
function bHisEqu_Callback(hObject, eventdata, handles)
% hObject    handle to bHisEqu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bHisEqu
hide_all(handles);              %hide all controls
handles.popHistEqu.Visible = 'On'; %show specific controls

% --- Executes on button press in bHisStre.
function bHisStre_Callback(hObject, eventdata, handles)
% hObject    handle to bHisStre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bHisStre
hide_all(handles);                  %hide all controls
handles.pHisStre.Visible = 'On';   %show specific controls

% --- Executes on button press in bPseu.
function bPseu_Callback(hObject, eventdata, handles)
% hObject    handle to bPseu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bPseu
hide_all(handles);              %hide all controls
handles.bGpseu.Visible = 'On'; %show specific controls

% --- Executes on button press in bSharp.
function bSharp_Callback(hObject, eventdata, handles)
% hObject    handle to bSharp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bSharp
%show and hide control
hide_all(handles);              %hide all controls
handles.pSharp.Visible = 'On';   %show specific controls

% --- Executes on selection change in popCspa.
function popCspa_Callback(hObject, eventdata, handles)
% hObject    handle to popCspa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popCspa contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popCspa


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

% --- Executes when Enha is resized.
function Enha_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to Enha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(hObject.UserData, 'BriDa')
    handles.bBrDa.Value = 1;
elseif strcmp(hObject.UserData, 'Edge')
    bEdge_Callback(handles.bEdge, eventdata, handles);
    handles.bEdge.Value = 1;
elseif strcmp(hObject.UserData, 'HEqu')
    bHisEqu_Callback(handles.bHisEqu, eventdata, handles);
    handles.bHisEqu.Value = 1;
elseif strcmp(hObject.UserData, 'HStre')
    bHisStre_Callback(handles.bHisStre, eventdata, handles);
    handles.bHisStre.Value = 1;
elseif strcmp(hObject.UserData, 'Pseu')
    bPseu_Callback(handles.bPseu, eventdata, handles);
    handles.bPseu.Value = 1;
elseif strcmp(hObject.UserData, 'Sharp')
    bSharp_Callback(handles.bSharp, eventdata, handles);
    handles.bSharp.Value = 1;
end
hObject.UserData = 'NO';


% --- Executes on button press in bCGgray.
function bCGgray_Callback(hObject, eventdata, handles)
% hObject    handle to bCGgray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bCGgray
if strcmp(handles.axFun.UserData, 'NO')
    cpath = mfilename( 'fullpath' );
    a = imread([cpath(1:end-5) 'Resources\ColFunTyp.png']);
    axes(handles.axFun);
    imshow(a,'InitialMagnification','fit'); %%Rev
    handles.axFun.Visible = 'Off';
    handles.axFun.UserData = 'SI';
else
    handles.axFun.Children.Visible = 'On';
end
handles.lblCfreq.String= 'Lower limit:                                                      Higher limit:';
handles.lblFlp.String = 'Red Color:';
handles.lblFbp.String = 'Green Color:';
handles.lblFhp.String = 'Blue Color:';
handles.lblCfreq.Visible = 'On';
handles.popLfreq.Visible = 'On';
handles.popHfreq.Visible = 'On';
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
handles.lblCfreq.String= 'Lower cutoff frequency:                                                Higher cutoff frequency:';

function hide_all(handles)
handles.bGpseu.Visible = 'Off';
handles.lblFac.Visible = 'Off';
handles.popFac.Visible = 'Off';
handles.popHistEqu.Visible = 'Off';
handles.pHisStre.Visible = 'Off';   
handles.pEdge.Visible = 'Off';   
handles.pSharp.Visible = 'Off';   

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


% --- Executes on selection change in popLLim.
function popLLim_Callback(hObject, eventdata, handles)
% hObject    handle to popLLim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popLLim contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popLLim


% --- Executes during object creation, after setting all properties.
function popLLim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popLLim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popHLim.
function popHLim_Callback(hObject, eventdata, handles)
% hObject    handle to popHLim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popHLim contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popHLim


% --- Executes during object creation, after setting all properties.
function popHLim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popHLim (see GCBO)
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

% --- Executes on key press with focus on popLLim and none of its controls.
function popLLim_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popLLim (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data

% --- Executes on key press with focus on popHLim and none of its controls.
function popHLim_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popHLim (see GCBO)
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
