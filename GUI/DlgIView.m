function varargout = DlgIView(varargin)
% DLGIVIEW MATLAB code for DlgIView.fig
%      DLGIVIEW, by itself, creates a new DLGIVIEW or raises the existing
%      singleton*.
%
%      H = DLGIVIEW returns the handle to a new DLGIVIEW or the handle to
%      the existing singleton*.
%
%      DLGIVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DLGIVIEW.M with the given input arguments.
%
%      DLGIVIEW('Property','Value',...) creates a new DLGIVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgIView_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgIView_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DlgIView

% Last Modified by GUIDE v2.5 06-Oct-2018 00:31:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgIView_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgIView_OutputFcn, ...
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
%           Latest update date:     09/05/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.2  10/04/2018  15:46:38  jucuell
 % Including the menus for file, view, analysis and compression
%
 % Revision 1.1  09/30/2018  10:05:15  jucuell
 % Initial revision: Creating figure and initial coding
 % 
%

% --- Executes just before DlgIView is made visible.
function DlgIView_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DlgIView (see VARARGIN)

% Choose default command line output for DlgIView
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';%hide Analysis menu
handles.mComp.Visible = 'Off';%hide Compression menu
handles.mView.Visible = 'Off';%hide View menu

% --- Outputs from this function are returned to the command line.
function varargout = DlgIView_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in txtLst.
function txtLst_Callback(hObject, eventdata, handles)
% hObject    handle to txtLst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns txtLst contents as cell array
%        contents{get(hObject,'Value')} returns selected item from txtLst


% --- Executes during object creation, after setting all properties.
function txtLst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtLst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when DlgIView is resized.
function DlgIView_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to DlgIView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Pos = hObject.Position;
handles.txtLst.Position = [5 2.5 Pos(3)-10 Pos(4)-5];

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

% --------------------------------------------------------------------
function mComp_Callback(hObject, eventdata, handles)
% hObject    handle to mComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mCless_Callback(hObject, eventdata, handles)
% hObject    handle to mCless (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mClossy_Callback(hObject, eventdata, handles)
% hObject    handle to mClossy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function mCpre_Callback(hObject, eventdata, handles)
% hObject    handle to mCpre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hCpre=DlgComPre;                %call Create Form
hCpre.UserData = 'CprePo';      %indicate selected option
set(gcf,'Name','Compress - Preprocessing','NumberTitle','off')
group = setfigdocked('GroupName','CVIP Toolbox V.3.5','Figure',hCpre);
figure(hCpre);

% --------------------------------------------------------------------
function mCpost_Callback(hObject, eventdata, handles)
% hObject    handle to mCpost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hCpos=DlgComPost;                %call Create Form
hCpos.UserData = 'CprePo';      %indicate selected option
set(gcf,'Name','Compress - Postprocessing','NumberTitle','off')
group = setfigdocked('GroupName','CVIP Toolbox V.3.5','Figure',hCpos);
figure(hCpos);

% --------------------------------------------------------------------
function mView_Callback(hObject, eventdata, handles)
% hObject    handle to mView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mVfi_Callback(hObject, eventdata, handles)
% hObject    handle to mVfi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hVfun = findobj('Tag','mVfi');
hIlist = findobj('Tag','txtIlist');
if strcmp(hObject.Checked,'off')
    for i=1:size(hVfun,1)
        hVfun(i).Checked = 'on';
    end
    hIlist.Visible = 'On';
else
    for i=1:size(hVfun,1)
        hVfun(i).Checked = 'off';
    end
    hIlist.Visible = 'Off';
end

% --------------------------------------------------------------------
function mViHis_Callback(hObject, eventdata, handles)
% hObject    handle to mViHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mVvimaHis_Callback(hObject, eventdata, handles)
% hObject    handle to mVvimaHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMain = findobj('Tag','Main');              %get the handle of Main form
% get handles and other user-defined data associated to Gui1
g1data = guidata(hMain);
if ~isempty(hMain)
    CVIPToolbox('mVvimaHis_Callback',g1data.mVvimaHis,eventdata,guidata(hMain))
end

% --------------------------------------------------------------------
function mVsaveHis_Callback(hObject, eventdata, handles)
% hObject    handle to mVsaveHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hShist = findobj('Tag','mVsaveHis');
if strcmp(hObject.Checked,'off')
    for i=1:size(hShist,1)
        hShist(i).Checked = 'on';
    end
else
    for i=1:size(hShist,1)
        hShist(i).Checked = 'off';
    end
end


% --------------------------------------------------------------------
function ImClear_Callback(hObject, eventdata, handles)
% hObject    handle to ImClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.txtLst.String = '.:: CVIPTools History Viewer ::.';
handles.txtLst.Value = 1;

% --------------------------------------------------------------------
function ImCopy_Callback(hObject, eventdata, handles)
% hObject    handle to ImCopy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('Select text and Use "Ctrl + C" to copy History','CVIPTools Message');

% --------------------------------------------------------------------
function Imenu_Callback(hObject, eventdata, handles)
% hObject    handle to Imenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
