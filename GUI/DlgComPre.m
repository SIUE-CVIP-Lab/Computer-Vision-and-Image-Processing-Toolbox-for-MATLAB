function varargout = DlgComPre(varargin)
% DLGCOMPRE MATLAB code for DlgComPre.fig
%      DLGCOMPRE, by itself, creates a new DLGCOMPRE or raises the existing
%      singleton*.
%
%      H = DLGCOMPRE returns the handle to a new DLGCOMPRE or the handle to
%      the existing singleton*.
%
%      DLGCOMPRE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DLGCOMPRE.M with the given input arguments.
%
%      DLGCOMPRE('Property','Value',...) creates a new DLGCOMPRE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgComPre_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgComPre_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DlgComPre

% Last Modified by GUIDE v2.5 19-Dec-2018 16:39:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgComPre_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgComPre_OutputFcn, ...
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
%           Initial coding date:    09/03/2018
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     12/17/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.3  12/17/2018  10:33:24  jucuell
 % Including information for history and funtion information
 % Updating menu creation programmatically, callbacks to Main figure and
 % the use of the utilities menus in the Main figure.
%
 % Revision 1.2  09/06/2018  08:12:05  jucuell
 % adding functions for pre and post - processing, check hist equ for shapes
 % in color, te function has bad example, check remap, need Gauss mask,
 % check image used as input after processed (Ima structure), updating save
 % and open functions
%
 % Revision 1.1  09/03/2018  10:05:15  jucuell
 % Initial revision: Creating figure and initial coding
 % 
%

% --- Executes just before DlgComPre is made visible.
function DlgComPre_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DlgComPre (see VARARGIN)

% Choose default command line output for DlgComPre
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DlgComPre wait for user response (see UIRESUME)
% uiwait(handles.CPre);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';%hide Analysis menu
handles.mComp.Visible = 'Off';%hide Compression menu

% --- Outputs from this function are returned to the command line.
function varargout = DlgComPre_OutputFcn(hObject, eventdata, handles) 
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
 close(handles.CPre)


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
Ima=hNfig.UserData;             %Get image name
InIma = Ima.cvipIma;            %read image data
file=get(hNfig,'Name');         %get image name

if handles.bBin2Gray.Value      %perform Bin 2 Gray conversion 
    OutIma=bin2graycode_cvip(InIma);                 %call function
    Func = 'Bin2Gray';
    Name=strcat(file,' > ',Func);
    histo = 31;

elseif handles.bGray2Bin.Value                       %perform Gray 2 Bin
	OutIma = graycode2bin_cvip(InIma);               %call function
    Func = 'Gray2Bin';
    Name=strcat(file,' > ',Func);
    %update image history
    histo = 34;
    
elseif handles.bSpaQuant.Value                       %perform Spatial Quant
    %get Height
    Rows=str2double(handles.popHei.String(handles.popHei.Value));
    %get Width
    Cols=str2double(handles.popWid.String(handles.popWid.Value));
    Met=handles.popMet.Value;                       %get Method
    OutIma = spatial_quant_cvip(InIma, Rows, Cols, Met);
    Func = 'SpaQuant';
    Name=strcat(file,' > ',Func,'(',num2str(Rows),',',num2str(Cols),...
        ',',num2str(Met),')');
    %update image history
    histo = [066 Rows Cols Met];

elseif handles.bGrayQuant.Value                           %perform Graylvl Quant
    %get gray level value
    Lvl=str2double(handles.popNgray.String(handles.popNgray.Value));
    if handles.bQStan.Value                               %standard Quant
        OutIma=gray_quant_cvip(InIma, Lvl);               %call function
        Func = 'GrayQuant';
        Name=strcat(file,' > ',Func,'(',num2str(Lvl),')');
        %update image history
        histo = [173 Lvl];

    else                                                  %igs Quant
        OutIma=igs_cvip(InIma, Lvl);                      %call function
        Func = 'IGSQuant';
        Name=strcat(file,' > ',Func,'(',num2str(Lvl),')');
        %update image history
        histo = [175 Lvl];

    end
    
end
if strcmp(hSHisto(1).Checked,'on')          %save new image history
    Ima.fInfo.history_info = updatehist_cvip(Ima.fInfo.history_info,histo);  
end
%check if need to show function information
if strcmp(hVfinfo(1).Checked,'on')
    hIlist = findobj('Tag','txtIlist');     %get handle of text element
    hIlist.String(end+1,1)=' ';             %print an empty line
    txtInfo = decohistory_cvip(histo);
    for i=1:size(txtInfo)
        sInfo = txtInfo{i};                 %exract row to print
        hIlist.String(end+1:end+size(sInfo,1),1:size(sInfo,2)) = sInfo;
    end
    hIlist.Value = size(hIlist.String,1);   %goto last line
    figure(hMain);
end
[row,col,band]=size(OutIma);            %get new image size
%update image information
Ima.fInfo.no_of_bands=band;             
Ima.fInfo.no_of_cols=col;              
Ima.fInfo.no_of_rows=row;
%update image structure
Ima.cvipIma = OutIma;   %read image data
showgui_cvip(Ima, Name);

%changing pointer watch back to arrow on cursor
set(figure_set,'pointer','arrow');


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



function fPrep_Callback(hObject, eventdata, handles)
% hObject    handle to fPrep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fPrep as text
%        str2double(get(hObject,'String')) returns contents of fPrep as a double


% --- Executes during object creation, after setting all properties.
function fPrep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fPrep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fParam_Callback(hObject, eventdata, handles)
% hObject    handle to fParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fParam as text
%        str2double(get(hObject,'String')) returns contents of fParam as a double


% --- Executes during object creation, after setting all properties.
function fParam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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



function Div01_Callback(hObject, eventdata, handles)
% hObject    handle to Div01 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Div01 as text
%        str2double(get(hObject,'String')) returns contents of Div01 as a double


% --- Executes during object creation, after setting all properties.
function Div01_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Div01 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Div02_Callback(hObject, eventdata, handles)
% hObject    handle to Div02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Div02 as text
%        str2double(get(hObject,'String')) returns contents of Div02 as a double


% --- Executes during object creation, after setting all properties.
function Div02_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Div02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popHei.
function popHei_Callback(hObject, eventdata, handles)
% hObject    handle to popHei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popHei contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popHei


% --- Executes during object creation, after setting all properties.
function popHei_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popHei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popWid.
function popWid_Callback(hObject, eventdata, handles)
% hObject    handle to popWid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popWid contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popWid


% --- Executes during object creation, after setting all properties.
function popWid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popWid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popMet.
function popMet_Callback(hObject, eventdata, handles)
% hObject    handle to popMet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMet contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMet


% --- Executes during object creation, after setting all properties.
function popMet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function mComp_Callback(hObject, eventdata, handles)
% hObject    handle to mComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mCpre_Callback(hObject, eventdata, handles)
% hObject    handle to mCpre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mCless_Callback(hObject, eventdata, handles)
% hObject    handle to mCless (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mCless_Callback',hObject,eventdata,guidata(hObject))


% --------------------------------------------------------------------
function mClossy_Callback(hObject, eventdata, handles)
% hObject    handle to mClossy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mClossy_Callback',hObject,eventdata,guidata(hObject))

function hide_all(handles)
% hide all parameters panels
handles.bQuant.Visible = 'Off';
handles.bSpQuant.Visible = 'Off';

% --- Executes on button press in bBin2Gray.
function bBin2Gray_Callback(hObject, eventdata, handles)
% hObject    handle to bBin2Gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bBin2Gray
hide_all(handles);                      % hide all parameters panels

% --- Executes on button press in bSpaQuant.
function bSpaQuant_Callback(hObject, eventdata, handles)
% hObject    handle to bSpaQuant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bSpaQuant
hide_all(handles);                      % hide all parameters panels
handles.bSpQuant.Visible = 'On';

% --- Executes on button press in bGrayQuant.
function bGrayQuant_Callback(hObject, eventdata, handles)
% hObject    handle to bGrayQuant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bGrayQuant
hide_all(handles);                      % hide all parameters panels
handles.bQuant.Visible = 'On';

% --- Executes on button press in bGray2Bin.
function bGray2Bin_Callback(hObject, eventdata, handles)
% hObject    handle to bGray2Bin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bGray2Bin
hide_all(handles);                      % hide all parameters panels

% --------------------------------------------------------------------
function mCpost_Callback(hObject, eventdata, handles)
% hObject    handle to mCpost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mCpost_Callback',hObject,eventdata,guidata(hObject))


% --- Executes on key press with focus on popNgray and none of its controls.
function popNgray_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popNgray (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data


% --- Executes on key press with focus on popHei and none of its controls.
function popHei_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popHei (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data


% --- Executes on key press with focus on popWid and none of its controls.
function popWid_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popWid (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data


% --- Executes on key press with focus on popMet and none of its controls.
function popMet_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popMet (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data
