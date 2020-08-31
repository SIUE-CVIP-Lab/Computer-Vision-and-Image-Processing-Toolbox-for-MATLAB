function varargout = mUSize(varargin)
% MUSIZE MATLAB code for mUSize.fig
%      MUSIZE, by itself, creates a new MUSIZE or raises the existing
%      singleton*.
%
%      H = MUSIZE returns the handle to a new MUSIZE or the handle to
%      the existing singleton*.
%
%      MUSIZE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MUSIZE.M with the given input arguments.
%
%      MUSIZE('Property','Value',...) creates a new MUSIZE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mUSize_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mUSize_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mUSize

% Last Modified by GUIDE v2.5 06-Jun-2019 11:11:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mUSize_OpeningFcn, ...
                   'gui_OutputFcn',  @mUSize_OutputFcn, ...
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


% --- Executes just before mUSize is made visible.
function mUSize_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mUSize (see VARARGIN)

% Choose default command line output for mUSize
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';%hide Analysis menu
hUtil = findobj('Tag','mUshos');
% hUtil(1).MenuSelectedFcn=@(hObject,eventdata)CVIPToolbox('mUshow_Callback',...
%     hObject,'Size',guidata(hObject));
hUtil(1).Callback=@(hObject,eventdata)CVIPToolbox('mUshow_Callback',...
    hObject,'Size',guidata(hObject));

function mVsaveHis_Callback(hObject, eventdata, handles)
% hObject    handle to mVsaveHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('Hola Magola, This is working!!!  :)');
hObject.Checked = 'On';



% --- Outputs from this function are returned to the command line.
function varargout = mUSize_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% CODE CALLBACKS ORDER:
% - Buttons (bApply, bCancel, bReset, ...)
% - Radio Buttons (Options, choices)
% - Pop-up Menús
% - Figure Callbacks (Resize, Click, ...)
% - Main Menus (fOpen, fSave)
% - Ui Main Menus (uiOpen, uiSave)
% - Menus (Others: View, Analysis, Compression...)


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
    errordlg('Please select the image to Process', 'Size Error', 'modal');
else
Ima=hNfig.UserData;             %Get image information
InIma = Ima.cvipIma;            %read image data
file = get(hNfig,'Name');       %get image name
histo = 0; OutIma = 0;          %initial vbles values

%Image Operations
[row,col,band]=size(InIma);         %size of input image
if handles.bCrop.Value              %perform Hist Stretch
    %capture parameters from GUI
    cCol = str2double(handles.popCcol.String(handles.popCcol.Value));
    cRow = str2double(handles.popCrow.String(handles.popCrow.Value));
    cWidth = str2double(handles.popCwid.String(handles.popCwid.Value));
    cHeight = str2double(handles.popChei.String(handles.popChei.Value));
    if cCol > col || cRow > row
       errordlg('Selected Row and Column are beyond Image size', ...
           'Size Error', 'modal');
    elseif cCol+cWidth > col || cRow+cHeight > row
       Ans = questdlg(['Width or Height are bigger than image size. ' ...
           'Do you want to continue?'],'Size Warning','Continue', ...
           'Cancel','Cancel');
       if strcmp(Ans,'Continue')
            %call crop function
            OutIma = crop_cvip(InIma, [cHeight cWidth], [cRow cCol]);
       end
       
    else
        %call crop function
        OutIma = crop_cvip(InIma, [cHeight cWidth], [cRow cCol]);
    end
    %name and show image
    Name = strcat(file,' > Crop (',num2str(cCol),',',num2str(cCol),')(',...
        num2str(cWidth),'-',num2str(cHeight),')');
    %update image history
    histo = [62 cHeight cWidth cCol cCol];     %update image history
    
elseif handles.bResz.Value   %perform Resize
    %returns resize width
    Col = str2double(handles.popRwid.String(handles.popRwid.Value)); 
    %returns returns Height
    Row = str2double(handles.popRhei.String(handles.popRhei.Value)); 
    if (Row <= row) && (Col <= col)  	%Reduce image with spatial quant
        %call spatial quant function
        OutIma=spatial_quant_cvip(InIma, Row, Col, 1);
        %update image history
        histo = [066 Row Col 1];              %update image history
        Name=strcat(file,' > Resize - Spa.Quan.(Avg)');

    elseif (Row >= row) && (Col >= col)     %Enlarge image  
        OutIma = enlarge_cvip(InIma, Row, Col);%call enlarge function
        Name = strcat(file,' > Resize - Enl.');    
        %update image history
        histo = [063 Row Col 0];
        
    else   
        Val = max([Row row Col col]);     	%get the max parameter to enlarge
        OutIma=enlarge_cvip(InIma, Val, Val);%call enlarge function
        %call spatial quant function
        OutIma=spatial_quant_cvip(OutIma, Row, Col, 1);
        %update image history
        histo = [063 Val Val 0; 066 Row Col 1];
        Name=strcat(file,' > Resize - Enl.&Red.');
    end
    
elseif handles.b2Siz.Value 
    OutIma = fast_doublesize_cvip(InIma);
    %update image history
    histo = [63 2*row 2*col];
    Name = [file,' > Double size '];
    
elseif handles.bSpaQ.Value    
    %returns resize width
    Col=str2double(handles.popRwid.String(handles.popRwid.Value)); 
    %returns returns Height
    Row=str2double(handles.popRhei.String(handles.popRhei.Value)); 
    Met=handles.popMSpa.Value;           %returns returns Height
    if (Row <= row) && (Col <= col)  	%Reduce image with spatial quant
        %call spatial quant function
        OutIma=spatial_quant_cvip(InIma, Row, Col, Met);
        %update image history
        histo = [066 Row Col Met];              %update image history
        switch Met
            case 1
                Name=strcat(file,' > Resize - Spa.Quan.(Avg)');
            case 2
                Name=strcat(file,' > Resize - Spa.Quan.(Med)');
            case 3
                Name=strcat(file,' > Resize - Spa.Quan.(Dec)');
            case 4
                Name=strcat(file,' > Resize - Spa.Quan.(Max)');
            case 5
                Name=strcat(file,' > Resize - Spa.Quan.(Min)');
        end
    else
        errordlg(['Spatial Quantization is to reduce image size. Check ' ...
           'desired size and try again!.'],'Size Error', 'modal');
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


% --- Executes on button press in bCancel.
function bCancel_Callback(hObject, eventdata, handles)
% hObject    handle to bCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Prepare to close application window
 close(handles.Size)


% --- Executes on button press in bReset.
function bReset_Callback(hObject, eventdata, handles)
% hObject    handle to bReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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


% --- Executes during object creation, after setting all properties.
function Size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in b2Siz.
function b2Siz_Callback(hObject, eventdata, handles)
% hObject    handle to b2Siz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of b2Siz
hide_all(handles)               %hide all objects in figure


% --- Executes on button press in bCrop.
function bCrop_Callback(hObject, eventdata, handles)
% hObject    handle to bCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bCrop
hide_all(handles)               %hide all objects in figure
handles.popCcol.Visible = 'On';
handles.popCwid.Visible = 'On';
handles.popChei.Visible = 'On';
handles.popCrow.Visible = 'On';
handles.lblC1.Visible = 'On';
handles.lblC2.Visible = 'On';


% --- Executes on button press in bResz.
function bResz_Callback(hObject, eventdata, handles)
% hObject    handle to bResz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bResz
hide_all(handles)               %hide all objects in figure
handles.popRhei.Visible = 'On';
handles.popRwid.Visible = 'On';
handles.lblR1.Visible = 'On';


% --- Executes on button press in bSpaQ.
function bSpaQ_Callback(hObject, eventdata, handles)
% hObject    handle to bSpaQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bSpaQ
hide_all(handles)               %hide all objects in figure
handles.popRhei.Visible = 'On';
handles.popRwid.Visible = 'On';
handles.lblR1.Visible = 'On';
handles.lblR2.Visible = 'On';
handles.popMSpa.Visible = 'On';

% --- Executes when Size is resized.
function Size_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to Size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(hObject.UserData, 'Crop')
    bCrop_Callback(handles.bCrop, eventdata, handles);
    handles.bCrop.Value = 1;
elseif strcmp(hObject.UserData, '2Size')
    b2Siz_Callback(handles.b2Siz, eventdata, handles);
    handles.b2Siz.Value = 1;
elseif strcmp(hObject.UserData, 'Resize')
    bResz_Callback(handles.bResz, eventdata, handles);
    handles.bResz.Value = 1;
elseif strcmp(hObject.UserData, 'SpaQuant')
    bSpaQ_Callback(handles.bSpaQ, eventdata, handles);
    handles.bSpaQ.Value = 1;
end
hObject.UserData = 'NO';


function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popCcol.
function popCcol_Callback(hObject, eventdata, handles)
% hObject    handle to popCcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popCcol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popCcol


% --- Executes during object creation, after setting all properties.
function popCcol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popCcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popCrow.
function popCrow_Callback(hObject, eventdata, handles)
% hObject    handle to popCrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popCrow contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popCrow


% --- Executes during object creation, after setting all properties.
function popCrow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popCrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popCwid.
function popCwid_Callback(hObject, eventdata, handles)
% hObject    handle to popCwid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popCwid contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popCwid


% --- Executes during object creation, after setting all properties.
function popCwid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popCwid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popChei.
function popChei_Callback(hObject, eventdata, handles)
% hObject    handle to popChei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popChei contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popChei


% --- Executes during object creation, after setting all properties.
function popChei_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popChei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popRwid.
function popRwid_Callback(hObject, eventdata, handles)
% hObject    handle to popRwid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popRwid contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popRwid


% --- Executes during object creation, after setting all properties.
function popRwid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popRwid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popRhei.
function popRhei_Callback(hObject, eventdata, handles)
% hObject    handle to popRhei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popRhei contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popRhei


% --- Executes during object creation, after setting all properties.
function popRhei_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popRhei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popMSpa.
function popMSpa_Callback(hObject, eventdata, handles)
% hObject    handle to popMSpa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMSpa contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMSpa


% --- Executes during object creation, after setting all properties.
function popMSpa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMSpa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on popCcol and none of its controls.
function popCcol_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popCcol (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);   %call function to add user data


% --- Executes on key press with focus on popCrow and none of its controls.
function popCrow_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popCrow (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on popCwid and none of its controls.
function popCwid_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popCwid (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on popChei and none of its controls.
function popChei_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popChei (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on popRwid and none of its controls.
function popRwid_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popRwid (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on popRhei and none of its controls.
function popRhei_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popRhei (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);   %call function to add user data


function hide_all(handles)
%hide all objects in figure
handles.popCcol.Visible = 'Off';
handles.popCwid.Visible = 'Off';
handles.popChei.Visible = 'Off';
handles.popCrow.Visible = 'Off';
handles.lblC1.Visible = 'Off';
handles.lblC2.Visible = 'Off';
handles.popRhei.Visible = 'Off';
handles.popRwid.Visible = 'Off';
handles.lblR1.Visible = 'Off';
handles.lblR2.Visible = 'Off';
handles.popMSpa.Visible = 'Off';
