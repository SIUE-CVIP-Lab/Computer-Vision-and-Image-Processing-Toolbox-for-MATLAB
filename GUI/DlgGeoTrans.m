function varargout = DlgGeoTrans(varargin)
% DLGGEOTRANS MATLAB code for DlgGeoTrans.fig
%      DLGGEOTRANS, by itself, creates a new DLGGEOTRANS or raises the existing
%      singleton*.
%
%      H = DLGGEOTRANS returns the handle to a new DLGGEOTRANS or the handle to
%      the existing singleton*.
%
%      DLGGEOTRANS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DLGGEOTRANS.M with the given input arguments.
%
%      DLGGEOTRANS('Property','Value',...) creates a new DLGGEOTRANS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgGeoTrans_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgGeoTrans_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DlgGeoTrans

% Last Modified by GUIDE v2.5 11-Sep-2019 22:30:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgGeoTrans_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgGeoTrans_OutputFcn, ...
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
%           Author:                 Joey Olden
%           Initial coding date:    6/05/2019
%           Updated by:             Joey Olden
%           Latest update date:     9/11/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% --- Executes just before DlgGeoTrans is made visible.
function DlgGeoTrans_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DlgGeoTrans (see VARARGIN)

% Choose default command line output for DlgGeoTrans
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DlgGeoTrans wait for user response (see UIRESUME)
% uiwait(handles.GeoTrans);
%call menu creation function
menu_add_cvip(hObject);

handles.bLoad.Value = 0;
handles.bRandom.Value = 1;
handles.bSave.Visible = 'On';
handles.bSave.Value = 0;

%loading in the mesh directions image
cpath = mfilename( 'fullpath' );
cpath = cpath(1:end-11);
a = imread([cpath 'Resources\MeshDirections.png']);
axes(handles.axesMesh);
imshow(a,'InitialMagnification','fit'); %%Rev
handles.axesMesh.Visible = 'Off';
handles.axesMesh.UserData = 'SI';


function mVsaveHis_Callback(hObject, eventdata, handles)
% hObject    handle to mVsaveHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('Hola Magola, This is working!!!  :)');
hObject.Checked = 'On';


% --- Outputs from this function are returned to the command line.
function varargout = DlgGeoTrans_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% CODE CALLBACKS ORDER:
% - Buttons (bApply, bCancel, bReset, ...)
% - Radio Buttons (Options, choices)
% - Pop-up Men�s
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
    errordlg('Please select the image to Process', 'Filter Error', 'modal');
else
Ima=hNfig.UserData;             %Get image information
InIma = Ima.cvipIma;            %read image data
file = get(hNfig,'Name');       %get image name
histo = 0; OutIma = 0;          %initial vbles values

%IMAGE OPERATIONS

%Extracting Mesh Creation Mode from user input
if handles.bNew.Value
    option = 1;
    option_name = 'Hand';
elseif handles.bLoad.Value
    option = 2;
    option_name = 'Load';
elseif handles.bRandom.Value
    option = 3;
    option_name = 'Rand';
end

%Extracting Direction from user input
if handles.pDirection.Value == 1
    direction = 1;
    direction_name = 'RI';
elseif handles.pDirection.Value == 2
    direction = 2;
    direction_name = 'IR';
end

%Extracting Gray Level Interpolation Method from user input
if handles.pInterp.Value == 1
    method = 1;
    method_name = 'NN';
elseif handles.pInterp.Value == 2
    method = 2;
    method_name = 'NH';
elseif handles.pInterp.Value == 3
    method = 3;
    method_name = 'BI';
end

%Extracting Mesh size from user input
mesh_size_r = handles.pMeshR.Value - 1;
mesh_size_c = handles.pMeshC.Value - 1;
%Extracting Distortion Scale from user input
scale = handles.pScale.Value;
%Extracting Save option from user input
save = handles.bSave.Value;

[OutIma,fhm,~] = geometric_transform_cvip(InIma,direction,option,method,mesh_size_r,mesh_size_c,scale,save);

Name_Mesh = [file ' > geo_transform' ',' option_name ',' num2str(mesh_size_r) 'x' num2str(mesh_size_c)];
Name = [file ' > geo_transform' ',' num2str(mesh_size_r) 'x' num2str(mesh_size_c) ',' direction_name ',' method_name];

set(fhm,'Name',Name_Mesh);
setfigdocked('GroupName','CVIP Toolbox V.3.5','Figure',fhm);

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
 close(handles.GeoTrans)


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
function GeoTrans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GeoTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in bLoad.
function bLoad_Callback(hObject, eventdata, handles)
% hObject    handle to bLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bLoad
handles.txtScale.Visible = 'Off';
handles.pScale.Visible = 'Off';
handles.bSave.Visible = 'Off';


% --- Executes on button press in bNew.
function bNew_Callback(hObject, eventdata, handles)
% hObject    handle to bNew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bNew
handles.txtScale.Visible = 'Off';
handles.pScale.Visible = 'Off';
handles.bSave.Visible = 'On';
handles.bSave.Value = 0;


% --- Executes on button press in bRandom.
function bRandom_Callback(hObject, eventdata, handles)
% hObject    handle to bRandom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bRandom
handles.txtScale.Visible = 'On';
handles.pScale.Visible = 'On';
handles.bSave.Visible = 'On';
handles.bSave.Value = 0;


% --- Executes on selection change in pDirection.
function pDirection_Callback(hObject, eventdata, handles)
% hObject    handle to pDirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pDirection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pDirection


% --- Executes during object creation, after setting all properties.
function pDirection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pDirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pInterp.
function pInterp_Callback(hObject, eventdata, handles)
% hObject    handle to pInterp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pInterp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pInterp


% --- Executes during object creation, after setting all properties.
function pInterp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pInterp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pMeshC.
function pMeshC_Callback(hObject, eventdata, handles)
% hObject    handle to pMeshC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pMeshC contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pMeshC


% --- Executes during object creation, after setting all properties.
function pMeshC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMeshC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pMeshR.
function pMeshR_Callback(hObject, eventdata, handles)
% hObject    handle to pMeshR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pMeshR contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pMeshR


% --- Executes during object creation, after setting all properties.
function pMeshR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMeshR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pScale.
function pScale_Callback(hObject, eventdata, handles)
% hObject    handle to pScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pScale contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pScale


% --- Executes during object creation, after setting all properties.
function pScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bSave.
function bSave_Callback(hObject, eventdata, handles)
% hObject    handle to bSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bSave
