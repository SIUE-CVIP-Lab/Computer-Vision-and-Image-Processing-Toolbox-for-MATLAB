function varargout = mUArith(varargin)
% MUARITH MATLAB code for mUArith.fig
%      MUARITH, by itself, creates a new MUARITH or raises the existing
%      singleton*.
%
%      H = MUARITH returns the handle to a new MUARITH or the handle to
%      the existing singleton*.
%
%      MUARITH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MUARITH.M with the given input arguments.
%
%      MUARITH('Property','Value',...) creates a new MUARITH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mUArith_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mUArith_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mUArith

% Last Modified by GUIDE v2.5 04-Jun-2019 23:00:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mUArith_OpeningFcn, ...
                   'gui_OutputFcn',  @mUArith_OutputFcn, ...
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
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications 
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Julian Rene Cuellar Buritica
%           Initial coding date:    09/08/2017
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     01/09/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
% 
 % Revision 1.4  01/12/2019  16:23:21  jucuell
 % updating two image handling, calling of visualization, history storage
 % and visualization
% 
 % Revision 1.3  12/19/2018  14:35:14  jucuell
 % including full menus (View, Compresion, Utilities, Help, WebPage)
%
 % Revision 1.2  09/23/2018  13:14:08  jucuell REV
 % 
%
 % Revision 1.1  09/08/2018  17:48:03  jucuell REV
 % Initial revision: Function creation and initial testing
 % 
%

% --- Executes just before mUArith is made visible.
function mUArith_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mUArith (see VARARGIN)

% Choose default command line output for mUArith
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';%hide Analysis menu
hUtil = findobj('Tag','mUshos');
% hUtil(1).MenuSelectedFcn=@(hObject,eventdata)CVIPToolbox('mUshow_Callback',...
%     hObject,'Arith',guidata(hObject));
hUtil(1).Callback=@(hObject,eventdata)CVIPToolbox('mUshow_Callback',...
    hObject,'Arith',guidata(hObject));

% --- Outputs from this function are returned to the command line.
function varargout = mUArith_OutputFcn(hObject, eventdata, handles) 
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
 close(handles.Arith)


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
clc

%changing pointer arrow to watch on cursor
figure_set = findall(groot,'Type','Figure');
set(figure_set,'pointer','watch');

hMain = findobj('Tag','Main');      %get the handle of Main figure
hSHisto = findobj('Tag','mVsaveHis');%get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
Ima = handles.bIma1.UserData;       %get image handle
hNfig2 = handles.bIma2.UserData;    %get image handle
%check for Image to process
if isempty(Ima) && ~isfield(Ima,'cvipIma') 
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Arith/Logic Error','modal'); 
%check if a second image is required
elseif ~handles.cByC.Value && isempty(hNfig2)
    warndlg(['This operation requires 2 Images. Select a 2nd'...
                ' Image and try again!'],'Arith/Logic Warning','modal');
    
else
    if handles.cByC.Value           %get constant value
        if handles.bMul.Value || handles.bDiv.Value
            InIma2 = str2double(handles.popMCons.String(handles.popMCons.Value));
        else
            InIma2 = str2double(handles.popCons.String(handles.popCons.Value));
        end
        file2 = num2str(InIma2);    %second image name
        va = InIma2;                %value for history
    else                            %2 images operation
        InIma2=hNfig2.cvipIma;      %get 2nd image
        file2=handles.txtIma2.String;%second image name
        va = -1;                    %value for history         
    end
    
    InIma1 = Ima.cvipIma;           %read image data
    file1=handles.txtIma1.String;   %get file name

    %perform image operations
    if handles.bAdd.Value                       %perform Add 
        OutIma = add_cvip(InIma1, InIma2);      %call Add function
        Name=strcat(file1,' > Add > ', file2);  %create image name
        histo = [001 va];                       %update image history

    elseif handles.bSub.Value                   %perform Subtraction
        OutIma = subtract_cvip(InIma1, InIma2); %call Sub function
        Name=strcat(file1,' > Sub > ', file2);  %create image name
        histo = [002 va];                       %update image history
        
    elseif handles.bMul.Value                   %perform Multiplication
        OutIma = multiply_cvip(InIma1, InIma2); %call Mul function
        Name=strcat(file1,' > Mul > ', file2);  %create image name
        histo = [004 va];                       %update image history

    elseif handles.bDiv.Value                   %perform Division
        OutIma = divide_cvip(InIma1, InIma2);   %call Div function
        Name=strcat(file1,' > Div > ', file2);  %create image name
        histo = [006 va];                       %update image history

    elseif handles.bAnd.Value                   %perform And 
        OutIma = and_cvip(InIma1, InIma2);      %call And function
        Name=strcat(file1,' > AND > ', file2);  %create image name
        histo = [003 va];                       %update image history
        
    elseif handles.bNOT.Value                   %perform NOT
        OutIma = not_cvip(InIma1);              %call NOT function
        Name=strcat(file1,' > NOT >');          %create image name
        histo = [005 va];                       %update image history
        if handles.cNotB.Value
            OutIma2 = not_cvip(InIma2);         %call NOT function
            Name2=strcat(file2,' > NOT >');     %create image name
            hNfig2.cvipIma = OutIma2;           %update image info
            showgui_cvip(hNfig2, Name2);        %show image in viewer
        end
    elseif handles.bOr.Value                    %perform Or
        OutIma = or_cvip(InIma1, InIma2);       %call Or function
        Name=strcat(file1,' > OR > ', file2);   %create image name
        histo = [008 va];                       %update image history
        
    elseif handles.bXor.Value                   %perform Xor
        OutIma = xor_cvip(InIma1, InIma2);      %call Xor function
        Name=strcat(file1,' > XOR > ', file2);  %create image name
        histo = [007 va];                       %update image history

    end
    

%check if need to save history
if strcmp(hSHisto(1).Checked,'on')              %save new image history
    Ima.fInfo.history_info = historyupdate_cvip(Ima.fInfo.history_info,histo);  
end
%check if need to show function information
if strcmp(hVfinfo(1).Checked,'on')
    hIlist = findobj('Tag','txtIlist');         %get handle of text element
    hIlist.String(end+1,1)=' ';                 %print an empty line
    txtInfo = historydeco_cvip(histo);     
    hIlist.String(end+1,1:size(Name,2)+1)=[Name ':']; 
    for i=1:size(txtInfo)
        sInfo = txtInfo{i};                     %extract row to print
        sInfo = sprintf(sInfo);
        [~,rr] = size(sInfo);
        hIlist.String(end+1,1:rr) = sInfo;
    end
    hIlist.Value = size(hIlist.String,1);       %goto last line
    figure(hMain);
end
[row,col,band]=size(OutIma);                    %get new image size
%update image information
Ima.fInfo.no_of_bands=band;             
Ima.fInfo.no_of_cols=col;              
Ima.fInfo.no_of_rows=row;
%update image structure
Ima.cvipIma = OutIma;                           %read image data
showgui_cvip(Ima, Name);                        %show image in viewer

end

%changing pointer watch back to arrow on cursor
set(figure_set,'pointer','arrow');


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



function txtIma1_Callback(hObject, eventdata, handles)
% hObject    handle to txtIma1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtIma1 as text
%        str2double(get(hObject,'String')) returns contents of txtIma1 as a double


% --- Executes during object creation, after setting all properties.
function txtIma1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtIma1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bIma1.
function bIma1_Callback(hObject, eventdata, handles)
% hObject    handle to bIma1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc                             %clear screen
hMain = findobj('Tag','Main');  %get the handle of Main form
hNfig = hMain.UserData;         %get image handle
if hNfig ~= 0 && isfield(hNfig.UserData,'cvipIma')%check for Image to save
    file=get(hNfig,'Name');    	%get image name
    hObject.UserData = hNfig.UserData;%read image info
    handles.txtIma1.String = file;  %show image name
end

function txtIma2_Callback(hObject, eventdata, handles)
% hObject    handle to txtIma2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtIma2 as text
%        str2double(get(hObject,'String')) returns contents of txtIma2 as a double


% --- Executes during object creation, after setting all properties.
function txtIma2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtIma2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bIma2.
function bIma2_Callback(hObject, eventdata, handles)
% hObject    handle to bIma2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc                             %clear screen
hMain = findobj('Tag','Main');  %get the handle of Main form
hNfig = hMain.UserData;         %get image handle
if hNfig ~= 0 && isfield(hNfig.UserData,'cvipIma')%check for Image to save
    file=get(hNfig,'Name');    	%get image name
    hObject.UserData = hNfig.UserData;%read image info
    handles.txtIma2.String = file;  %show image name
end


function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cByC.
function cByC_Callback(hObject, eventdata, handles)
% hObject    handle to cByC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cByC
if handles.cByC.Value && (handles.bAdd.Value || handles.bSub.Value)
    handles.popMCons.Visible = 'Off';
    handles.popCons.Visible = 'On';
    handles.cBClip.Visible = 'Off';
    handles.txtIma2.Enable = 'Off';
    handles.bIma2.Enable = 'Off';
elseif handles.cByC.Value && (handles.bMul.Value || handles.bDiv.Value)
    handles.popMCons.Visible = 'On';
    handles.popCons.Visible = 'Off';    
    handles.cBClip.Visible = 'Off';
    handles.txtIma2.Enable = 'Off';
    handles.bIma2.Enable = 'Off';
else
    handles.popMCons.Visible = 'Off';
    handles.popCons.Visible = 'Off';    
    handles.cBClip.Visible = 'Off';
    handles.txtIma2.Enable = 'On';
    handles.bIma2.Enable = 'On';
end

% --- Executes on selection change in popMCons.
function popMCons_Callback(hObject, eventdata, handles)
% hObject    handle to popMCons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMCons contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMCons


% --- Executes during object creation, after setting all properties.
function popMCons_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMCons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cBClip.
function cBClip_Callback(hObject, eventdata, handles)
% hObject    handle to cBClip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cBClip


% --- Executes on selection change in popCons.
function popCons_Callback(hObject, eventdata, handles)
% hObject    handle to popCons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popCons contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popCons


% --- Executes during object creation, after setting all properties.
function popCons_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popCons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bAdd.
function bAdd_Callback(hObject, eventdata, handles)
% hObject    handle to bAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bAdd
handles.cByC.Value = 0;
handles.cBClip.Value = 0;
handles.popMCons.Visible = 'Off';
handles.popCons.Visible = 'Off';    
handles.cBClip.Visible = 'Off';
handles.cNotB.Visible = 'Off';
handles.txtIma2.Enable = 'On';
handles.bIma2.Enable = 'On';
handles.cByC.Visible = 'On';

% --- Executes on button press in bSub.
function bSub_Callback(hObject, eventdata, handles)
% hObject    handle to bSub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bSub
handles.cByC.Value = 0;
handles.cBClip.Value = 0;
handles.popMCons.Visible = 'Off';
handles.popCons.Visible = 'Off';    
handles.cBClip.Visible = 'Off';
handles.cNotB.Visible = 'Off';
handles.txtIma2.Enable = 'On';
handles.bIma2.Enable = 'On';
handles.cByC.Visible = 'On';


% --- Executes on button press in bMul.
function bMul_Callback(hObject, eventdata, handles)
% hObject    handle to bMul (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bMul
handles.cByC.Value = 0;
handles.cBClip.Value = 0;
handles.popMCons.Visible = 'Off';
handles.popCons.Visible = 'Off';    
handles.cBClip.Visible = 'Off';
handles.cNotB.Visible = 'Off';
handles.txtIma2.Enable = 'On';
handles.bIma2.Enable = 'On';
handles.cByC.Visible = 'On';


% --- Executes on button press in bDiv.
function bDiv_Callback(hObject, eventdata, handles)
% hObject    handle to bDiv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bDiv
handles.cByC.Value = 0;
handles.cBClip.Value = 0;
handles.popMCons.Visible = 'Off';
handles.popCons.Visible = 'Off';    
handles.cBClip.Visible = 'Off';
handles.cNotB.Visible = 'Off';
handles.txtIma2.Enable = 'On';
handles.bIma2.Enable = 'On';
handles.cByC.Visible = 'On';


% --- Executes on button press in bAnd.
function bAnd_Callback(hObject, eventdata, handles)
% hObject    handle to bAnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bAnd
handles.cByC.Value = 0;
handles.cByC.Visible = 'Off';
handles.popMCons.Visible = 'Off';
handles.popCons.Visible = 'Off';    
handles.cBClip.Visible = 'Off';
handles.cNotB.Visible = 'Off';
handles.cNotB.Value = 1;
handles.txtIma2.Enable = 'On';
handles.bIma2.Enable = 'On';


% --- Executes on button press in bNOT.
function bNOT_Callback(hObject, eventdata, handles)
% hObject    handle to bNOT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bNOT
handles.cByC.Value = 0;
handles.cByC.Visible = 'Off';
handles.popMCons.Visible = 'Off';
handles.popCons.Visible = 'Off';    
handles.cBClip.Visible = 'Off';
handles.txtIma2.Enable = 'Off';
handles.bIma2.Enable = 'Off';
handles.cNotB.Value = 0;
handles.cNotB.Visible = 'On';


% --- Executes on button press in bOr.
function bOr_Callback(hObject, eventdata, handles)
% hObject    handle to bOr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bOr
handles.cByC.Value = 0;
handles.cByC.Visible = 'Off';
handles.popMCons.Visible = 'Off';
handles.popCons.Visible = 'Off';    
handles.cBClip.Visible = 'Off';
handles.cNotB.Visible = 'Off';
handles.cNotB.Value = 1;
handles.txtIma2.Enable = 'On';
handles.bIma2.Enable = 'On';


% --- Executes on button press in bXor.
function bXor_Callback(hObject, eventdata, handles)
% hObject    handle to bXor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bXor
handles.cByC.Value = 0;
handles.cByC.Visible = 'Off';
handles.popMCons.Visible = 'Off';
handles.popCons.Visible = 'Off';    
handles.cBClip.Visible = 'Off';
handles.cNotB.Visible = 'Off';
handles.cNotB.Value = 1;
handles.txtIma2.Enable = 'On';
handles.bIma2.Enable = 'On';


% --- Executes when Arith is resized.
function Arith_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to Arith (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(hObject.UserData, 'Add')
    handles.bAdd.Value = 1;
    bAdd_Callback(hObject, eventdata, handles);
elseif strcmp(hObject.UserData, 'Sub')
    handles.bSub.Value = 1;
    bSub_Callback(hObject, eventdata, handles);
elseif strcmp(hObject.UserData, 'Mul')
    handles.bMul.Value = 1;
    bMul_Callback(hObject, eventdata, handles);
elseif strcmp(hObject.UserData, 'Div')
    handles.bDiv.Value = 1;
    bDiv_Callback(hObject, eventdata, handles);
elseif strcmp(hObject.UserData, 'And')
    handles.bAnd.Value = 1;
    bAnd_Callback(hObject, eventdata, handles);
elseif strcmp(hObject.UserData, 'Not')
    handles.bNOT.Value = 1;
    bNOT_Callback(handles.bNOT, eventdata, handles);
elseif strcmp(hObject.UserData, 'Or')
    handles.bOr.Value = 1;
    bOr_Callback(handles.bOr, eventdata, handles);
elseif strcmp(hObject.UserData, 'Xor')
    handles.bXor.Value = 1;
    bXor_Callback(hObject, eventdata, handles);
end
hObject.UserData = 'NO';


% --- Executes on button press in cNotB.
function cNotB_Callback(hObject, eventdata, handles)
% hObject    handle to cNotB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cNotB
if hObject.Value
    handles.txtIma2.Enable = 'On';
    handles.bIma2.Enable = 'On';
else
    handles.txtIma2.Enable = 'Off';
    handles.bIma2.Enable = 'Off';
end


% --- Executes on key press with focus on popCons and none of its controls.
function popCons_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popCons (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data


% --- Executes on key press with focus on popMCons and none of its controls.
function popMCons_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popMCons (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data
