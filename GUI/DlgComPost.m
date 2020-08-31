function varargout = DlgComPost(varargin)
% DLGCOMPOST MATLAB code for DlgComPost.fig
%      DLGCOMPOST, by itself, creates a new DLGCOMPOST or raises the existing
%      singleton*.
%
%      H = DLGCOMPOST returns the handle to a new DLGCOMPOST or the handle to
%      the existing singleton*.
%
%      DLGCOMPOST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DLGCOMPOST.M with the given input arguments.
%
%      DLGCOMPOST('Property','Value',...) creates a new DLGCOMPOST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgComPost_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgComPost_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DlgComPost

% Last Modified by GUIDE v2.5 19-Dec-2018 16:41:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgComPost_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgComPost_OutputFcn, ...
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
 % Revicion 1.4  12/17/2018  10:55:21  jucuell
 % Updating menu creation programmatically, callbacks to Main figure and
 % the use of the utilities menus in the Main figure.
%
 % Revision 1.3  10/04/2018  15:44:20  jucuell
 % gauss filt was added, updating save and open functions, including
 % history and information for images and functions
%
 % Revision 1.2  09/04/2018  08:12:05  jucuell
 % adding functions for pre and post - processing, check hist equ for shapes
 % in color, te function has bad example, check remap, need Gauss mask,
 % check image used as input after processed (Ima structure)
%
 % Revision 1.1  09/03/2018  10:05:15  jucuell
 % Initial revision: Creating figure and initial coding
 % 
%

% --- Executes just before DlgComPost is made visible.
function DlgComPost_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DlgComPost (see VARARGIN)

% Choose default command line output for DlgComPost
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';%hide Analysis menu
handles.mComp.Visible = 'Off';%hide Analysis menu



% --- Outputs from this function are returned to the command line.
function varargout = DlgComPost_OutputFcn(hObject, eventdata, handles) 
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
 close(handles.CPost)


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
Ima=hNfig.UserData;         %Get image name
InIma = Ima.cvipIma;        %read image data
file=get(hNfig,'Name');         %get image name

if handles.bHistEqu.Value                           %perform Hist Equ
    bands = size(InIma,3);                      %get number of bands
    if bands == 1
        OutIma = histeq_cvip(InIma,0);               %call function
        Func = 'HistEquGray';
        %update image history
        histo = [73 0];
    else
        if handles.bLight.Value             %lightness 
            OutIma = rgb2hsl_cvip(InIma,1); %convert to hsl OutIma(1:10)
            Light = OutIma(:,:,3);          %extract lightness
            Light = histeq_cvip(floor(Light*255),0);%call function
            OutIma(:,:,3) = double(Light)/255;%assemble new light band
            OutIma = uint8(hsl2rgb_cvip(OutIma,1)*255);%call function
            Func = 'HistEquL';              %image function for image name
            %update image history
            histo = [22 1; 10 3; 73 0; 9 3; 14 1];
            
        elseif handles.bRed.Value           %equalize red band
            OutIma = uint8(histeq_cvip(InIma,0));               %call function
            Func = 'HistEquR';
            %update image history
            histo = [73 0];
            
        elseif handles.bGreen.Value           %equalize green band
            OutIma = uint8(histeq_cvip(InIma,1));               %call function
            Func = 'HistEquG';
            %update image history
            histo = [73 1];
            
        else                                %equalize blue band
            OutIma = uint8(histeq_cvip(InIma,2));               %call function
            Func = 'HistEquB';
            %update image history
            histo = [73 2];
            
        end
    end
    Name = strcat(file,' > ',Func);

elseif handles.bHistStre.Value                           %perform Hist Stretch
    %get low gray level value
    Low=str2double(handles.popLow.String(handles.popLow.Value));
    %get high gray level value
    High=str2double(handles.popHigh.String(handles.popHigh.Value));
    %get low clip % value
    lClip=str2double(handles.popLclip.String(handles.popLclip.Value));
    %get high clip %  value
    hClip=str2double(handles.popHclip.String(handles.popHclip.Value));
    OutIma=hist_stretch_cvip(InIma,Low,High,lClip,hClip);   %call function
    %update image history
    histo = [79 Low High lClip hClip];
    Func = 'HistStre';
    Name=strcat(file,' > ',Func,'(',num2str(Low),',',num2str(High),...
        ',',num2str(lClip),',',num2str(hClip),')');
    
elseif handles.bGauss.Value                           %perform Gauss Smoothing
    Mask=str2double(handles.popMask.String(handles.popMask.Value));
    gMask=gaussmask_cvip(Mask);
    OutIma=convolve_filter_cvip(InIma,gMask);
    %remap output
    OutIma = remap_cvip(OutIma, [0 255]);
    %update image history
    histo = [204 Mask 0; 202 0 0; 081 0 255];
    Func = 'GaussFilt';
    Name=strcat(file,' > ',Func,'(',num2str(Mask),')');
    
elseif handles.bMean.Value                           %perform Mean Smoothing
    %get mask size
    Mask=str2double(handles.popMask.String(handles.popMask.Value));
    OutIma=arithmetic_mean_cvip(InIma,Mask);
    %update image history
    histo = [195 Mask];
    Func = 'MeanFilt';
    Name=strcat(file,' > ',Func,'(',num2str(Mask),')');
    
end
%check if need to save history
if strcmp(hSHisto(1).Checked,'on')          %save new image history
    Ima.fInfo.history_info = historyupdate_cvip(Ima.fInfo.history_info,histo);  
end
%check if need to show function information
if strcmp(hVfinfo(1).Checked,'on')
    hIlist = findobj('Tag','txtIlist');     %get handle of text element
    hIlist.String(end+1,1)=' ';             %print an empty line
    txtInfo = historydeco_cvip(histo);     
    hIlist.String(end+1,1:size(file,2)+1)=[file ':']; 
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

function fPost_Callback(hObject, eventdata, handles)
% hObject    handle to fPost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fPost as text
%        str2double(get(hObject,'String')) returns contents of fPost as a double


% --- Executes during object creation, after setting all properties.
function fPost_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fPost (see GCBO)
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


% --- Executes on selection change in popMask.
function popMask_Callback(hObject, eventdata, handles)
% hObject    handle to popMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMask contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMask


% --- Executes during object creation, after setting all properties.
function popMask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popBand.
function popBand_Callback(hObject, eventdata, handles)
% hObject    handle to popBand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popBand contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popBand


% --- Executes during object creation, after setting all properties.
function popBand_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popBand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popLow.
function popLow_Callback(hObject, eventdata, handles)
% hObject    handle to popLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popLow contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popLow


% --- Executes during object creation, after setting all properties.
function popLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popHigh.
function popHigh_Callback(hObject, eventdata, handles)
% hObject    handle to popHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popHigh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popHigh


% --- Executes during object creation, after setting all properties.
function popHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popLclip.
function popLclip_Callback(hObject, eventdata, handles)
% hObject    handle to popLclip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popLclip contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popLclip


% --- Executes during object creation, after setting all properties.
function popLclip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popLclip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popHclip.
function popHclip_Callback(hObject, eventdata, handles)
% hObject    handle to popHclip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popHclip contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popHclip


% --- Executes during object creation, after setting all properties.
function popHclip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popHclip (see GCBO)
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
CVIPToolbox('mCpre_Callback',hObject,eventdata,guidata(hObject))

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
handles.bFilter.Visible = 'Off';
handles.bHstre.Visible = 'Off';
handles.bEquBand.Visible = 'Off';

% --- Executes on button press in bHistEqu.
function bHistEqu_Callback(hObject, eventdata, handles)
% hObject    handle to bHistEqu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bHistEqu
hide_all(handles);                      % hide all parameters panels
handles.bEquBand.Visible = 'On';

% --- Executes on button press in bHistStre.
function bHistStre_Callback(hObject, eventdata, handles)
% hObject    handle to bHistStre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bHistStre
hide_all(handles);                      % hide all parameters panels
handles.bHstre.Visible = 'On';

% --- Executes on button press in bMean.
function bMean_Callback(hObject, eventdata, handles)
% hObject    handle to bMean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bMean
hide_all(handles);                      % hide all parameters panels
handles.bFilter.Visible = 'On';

% --- Executes on button press in bGauss.
function bGauss_Callback(hObject, eventdata, handles)
% hObject    handle to bGauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bGauss
hide_all(handles);                      % hide all parameters panels
handles.bFilter.Visible = 'On';


% --------------------------------------------------------------------
function mCpost_Callback(hObject, eventdata, handles)
% hObject    handle to mCpost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on popMask and none of its controls.
function popMask_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popMask (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data


% --- Executes on key press with focus on popLow and none of its controls.
function popLow_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popLow (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data


% --- Executes on key press with focus on popHigh and none of its controls.
function popHigh_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popHigh (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data


% --- Executes on key press with focus on popLclip and none of its controls.
function popLclip_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popLclip (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data


% --- Executes on key press with focus on popHclip and none of its controls.
function popHclip_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popHclip (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data
