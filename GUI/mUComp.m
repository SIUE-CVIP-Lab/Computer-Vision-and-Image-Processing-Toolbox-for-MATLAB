function varargout = mUComp(varargin)
% MUCOMP MATLAB code for mUComp.fig
%      MUCOMP, by itself, creates a new MUCOMP or raises the existing
%      singleton*.
%
%      H = MUCOMP returns the handle to a new MUCOMP or the handle to
%      the existing singleton*.
%
%      MUCOMP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MUCOMP.M with the given input arguments.
%
%      MUCOMP('Property','Value',...) creates a new MUCOMP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mUComp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mUComp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mUComp

% Last Modified by GUIDE v2.5 29-Jun-2019 13:45:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mUComp_OpeningFcn, ...
                   'gui_OutputFcn',  @mUComp_OutputFcn, ...
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
%           Latest update date:     01/10/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
% 
 % Revision 1.4  06/01/2019  11:39:21  jucuell
 % Updating menu creation programmatically, callbacks to Main figure and
 % the use of the utilities menus in the Main figure.
%
 % Revision 1.3  01/10/2018  17:11:56  jucuell
 % updating two image handling, calling of visualization, history storage
 % and visualization
%
 % Revision 1.2  12/12/2018  15:18:44  jucuell
 % updating menu creation programmatically, callbacks to Main figure and
 % the use of the utilities menus in the Main figure.
%
 % Revision 1.1  11/21/2017  15:23:31  jucuell
 % Initial revision: Initial coding and testing.
%

% --- Executes just before mUComp is made visible.
function mUComp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mUComp (see VARARGIN)

% Choose default command line output for mUComp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';%hide Analysis menu
hUtil = findobj('Tag','mUshos');
% hUtil(1).MenuSelectedFcn=@(hObject,eventdata)CVIPToolbox('mUshow_Callback',...
%     hObject,'Comp',guidata(hObject));
hUtil(1).Callback=@(hObject,eventdata)CVIPToolbox('mUshow_Callback',...
    hObject,'Comp',guidata(hObject));

% --- Outputs from this function are returned to the command line.
function varargout = mUComp_OutputFcn(hObject, eventdata, handles) 
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
 close(handles.Comp)


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

if handles.cCfold.Value         %compare images in folders
    cMetric = sum([handles.bSub.UserData handles.bXOR.UserData ...
        handles.bPeak.UserData handles.bSNR.UserData handles.bRMS.UserData ...
        handles.bPratt.UserData]);
    if cMetric < 1
    errordlg(['You must select at least one comparison metric. Please ' ...
        'select Metric and try again.'],'Compare Error','modal'); 
    else
    Gray = str2double(handles.popGray.String(handles.popGray.Value));
    Sca = str2num(handles.popSca.String{handles.popSca.Value});
    out_table = compare_images_cvip(handles.txtIma1.String,handles.txtIma2.String...
        , [handles.bSub.UserData handles.cIstats.Value handles.bXOR.UserData ...
        handles.bPeak.UserData Gray handles.bSNR.UserData handles.bRMS.UserData ...
        handles.bPratt.UserData Sca], handles.cOutFile.Value);
    end
else
    
handles.txtRes.String = 'Working...';
handles.txtRres.String = 'Working...';
handles.txtGres.String = 'Working...';
handles.txtBres.String = 'Working...';
drawnow;                            %force GUI update
hMain = findobj('Tag','Main');      %get the handle of Main figure
hSHisto = findobj('Tag','mVsaveHis');%get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
Ima = handles.bIma1.UserData;       %get image handle
hNfig2 = handles.bIma2.UserData;    %get image handle
%check for Image to process
if isempty(Ima) && ~isfield(Ima,'cvipIma') 
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Compare Error','modal'); 
%check for required second image
elseif ~isfield(hNfig2,'cvipIma') && isempty(hNfig2)
    errordlg(['This operation requires 2 Images. Select a 2nd'...
                ' Image and try again!'],'Compare Error','modal');
    
elseif handles.bRMS.Value && sum(size(Ima.cvipIma) ~= size(hNfig2.cvipIma)) > 0
    errordlg('Images must have the same size','Compare Error','modal');

else

InIma1 = Ima.cvipIma;               %read image data
file1=handles.txtIma1.String;       %get file name
InIma2=hNfig2.cvipIma;              %get 2nd image
file2=handles.txtIma2.String;       %second image name

[row,col,band] = size(InIma1);      %get image 1 size
[row2,col2,band2] = size(InIma2);   %get image 2 size
OutIma = 0;                         %no Output image

if handles.bXOR.Value                       %perform Xor 
    OutIma = xor_cvip(InIma1, InIma2);      %call Xor function
    Name=strcat(file1,' > XOR > ', file2);  %create image name
    histo = [007 -1];                       %update image history
    
elseif handles.bSub.Value                   %perform Subtraction
    OutIma = subtract_cvip(InIma1, InIma2); %call Sub function
    Name=strcat(file1,' > Sub > ', file2);  %create image name
    histo = [002 -1];                       %update image history
    
elseif handles.bPeak.Value                  %perform Peak SNR
    %check the size of two images before perform operations
    if row ~= row2 || col ~= col2
        errordlg('Images must have the same size','Compare Error','modal');
    else
        Gray = str2double(handles.popGray.String(handles.popGray.Value));
        Peak = peak_snr_cvip(InIma1, InIma2, Gray); %call peak SNR function
        histo = [112 Gray];                	%update image history
        if band == 3 || band2 == 3
            handles.txtresG.ForegroundColor = [0.2 0.5 0.2];
            handles.txtresR.String = Peak(1);
            handles.txtresG.String = Peak(2);
            handles.txtresB.String = Peak(3);
            handles.txtresR.Visible = 'On';
            handles.txtresB.Visible = 'On';
        else
            handles.txtresG.ForegroundColor = [0 0 0];
            handles.txtresR.Visible = 'Off';
            handles.txtresB.Visible = 'Off';
            handles.txtresG.String = Peak;
        end
    end
elseif handles.bSNR.Value                   %perform Multiplication
    %check the size of two images before perform operations
    if row ~= row2 || col ~= col2
        errordlg('Images must have the same size','Compare Error','modal');
    else
        SNR = snr_cvip(InIma1, InIma2); %call SNR function
        histo = 113;                        %update image history
        if band == 3 || band2 == 3
            handles.txtresG.ForegroundColor = [0.2 0.5 0.2];
            handles.txtresR.String = SNR(1);
            handles.txtresG.String = SNR(2);
            handles.txtresB.String = SNR(3);
            handles.txtresR.Visible = 'On';
            handles.txtresB.Visible = 'On';
        else
            handles.txtresG.ForegroundColor = [0 0 0];
            handles.txtresR.Visible = 'Off';
            handles.txtresB.Visible = 'Off';
            handles.txtresG.String = SNR;
        end
    end
elseif handles.bRMS.Value                   %perform NOT
    RMS = rms_error_cvip(InIma1, InIma2);   %call RMS function
    histo = 111;                            %update image history
    if band == 3 || band2 == 3
        handles.txtresG.ForegroundColor = [0.2 0.5 0.2];
        handles.txtresR.String = RMS(1);
        handles.txtresG.String = RMS(2);
        handles.txtresB.String = RMS(3);
        handles.txtresR.Visible = 'On';
        handles.txtresB.Visible = 'On';
    else
        handles.txtresG.ForegroundColor = [0 0 0];
        handles.txtresR.Visible = 'Off';
        handles.txtresB.Visible = 'Off';
        handles.txtresG.String = RMS;
    end
        
elseif handles.bPratt.Value             	%perform Pratt Figure of Merit
    
    %Checking to make sure the input images are binary
    if size(unique(InIma1(:)),1) ~= 2 
        f = uifigure;
        uialert(f,'Please use an image with only 2 unique values','Warning');
    end

    Sca = str2num(handles.popSca.String{handles.popSca.Value});
    histo = [051 Sca];
    handles.txtRres.String = '...';
    handles.txtGres.String = '...';
    handles.txtBres.String = '...';
    tic
    if band == 3 || band2 == 3
        [FOMR, FOMG, FOMB] = pratt_merit_cvip(InIma1, InIma2, Sca);
        handles.txtRres.String = FOMR;
        handles.txtGres.String = FOMG;
        handles.txtBres.String = FOMB;
        handles.txtGres.ForegroundColor = [0.2 0.5 0.2];
        handles.txtRres.Visible = 'On';
        handles.txtGres.Visible = 'On';
        handles.txtBres.Visible = 'On';
    else
        FOM = pratt_merit_cvip(InIma1, InIma2, Sca);
        handles.txtGres.String = FOM;
        handles.txtGres.ForegroundColor = [0 0 0];
        handles.txtRres.Visible = 'Off';
        handles.txtGres.Visible = 'On';
        handles.txtBres.Visible = 'Off';
    end
    toc
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
    hIlist.String(end+1,1:size(file1,2)+1)=[file1 ':']; 
    for i=1:size(txtInfo)
        sInfo = txtInfo{i};                     %extract row to print
        sInfo = sprintf(sInfo);
        [~,rr] = size(sInfo);
        hIlist.String(end+1,1:rr) = sInfo;
    end
    hIlist.Value = size(hIlist.String,1);       %goto last line
    figure(hMain);
end

if size(OutIma,1) > 1
    [row,col,band]=size(OutIma);               	%get new image size
    %update image information
    Ima.fInfo.no_of_bands=band;             
    Ima.fInfo.no_of_cols=col;              
    Ima.fInfo.no_of_rows=row;
    %update image structure
    Ima.cvipIma = OutIma;                     	%read image data
    showgui_cvip(Ima, Name);                  	%show image in viewer
end
end

end %comparison

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
CVIPToolbox('fSave_Callback',hObject,eventdata,guidata(hObject))

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
CVIPToolbox('fSave_Callback',hObject,eventdata,guidata(hObject))



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
if ~handles.cCfold.Value
    hMain = findobj('Tag','Main');  %get the handle of Main form
    hNfig = hMain.UserData;         %get image handle
    if hNfig ~= 0 && isfield(hNfig.UserData,'cvipIma')%check for Image to save
        file=get(hNfig,'Name');    	%get image name
        hObject.UserData = hNfig.UserData;%read image info
        handles.txtIma1.String = file;  %show image name
    end
else
    cpath = mfilename( 'fullpath' );
    cpath = [cpath(1:end-6) '/Images'];
    file = uigetdir(cpath,'Select First Folder...');
    handles.txtIma1.String = file;  %show folder name
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
if ~handles.cCfold.Value
    hMain = findobj('Tag','Main');  %get the handle of Main form
    hNfig = hMain.UserData;         %get image handle
    if hNfig ~= 0 && isfield(hNfig.UserData,'cvipIma')%check for Image to save
        file=get(hNfig,'Name');    	%get image name
        hObject.UserData = hNfig.UserData;%read image info
        handles.txtIma2.String = file;  %show image name
    end
else
    cpath = mfilename( 'fullpath' );
    cpath = [cpath(1:end-6) '/Images'];
    file = uigetdir(cpath,'Select Second Folder...');
    handles.txtIma2.String = file;  %show folder name
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

% --- Executes on button press in bXOR.
function bSub_Callback(hObject, eventdata, handles)
% hObject    handle to bXOR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bXOR
if ~handles.cCfold.Value
    hide_all(handles);
    hObject.UserData = 0;
else
    hObject.UserData = ~hObject.UserData;

end
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in bXOR.
function bXOR_Callback(hObject, eventdata, handles)
% hObject    handle to bXOR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bXOR
if ~handles.cCfold.Value
    hide_all(handles);
    hObject.UserData = 0;
else
    hObject.UserData = ~hObject.UserData;
end


% --- Executes on button press in bPeak.
function bPeak_Callback(hObject, eventdata, handles)
% hObject    handle to bPeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bPeak
if ~handles.cCfold.Value
    show_peak(handles);
    hObject.UserData = 0;
else
    hObject.UserData = ~hObject.UserData;
end


% --- Executes on button press in bSNR.
function bSNR_Callback(hObject, eventdata, handles)
% hObject    handle to bSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bSNR
if ~handles.cCfold.Value
    show_resE(handles);
    hObject.UserData = 0;
else
    hObject.UserData = ~hObject.UserData;
end

% --- Executes on button press in bRMS.
function bRMS_Callback(hObject, eventdata, handles)
% hObject    handle to bRMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bRMS
if ~handles.cCfold.Value
    show_resE(handles);
    hObject.UserData = 0;
else
    hObject.UserData = ~hObject.UserData;
end


% --- Executes on button press in bPratt.
function bPratt_Callback(hObject, eventdata, handles)
% hObject    handle to bPratt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bPratt
if ~handles.cCfold.Value
    show_pratt(handles);
    hObject.UserData = 0;
else
    if ~hObject.UserData
        hObject.UserData = 1;
        warndlg(['Pratt FOM is time consumming, be sure you want to use this'...
            ' method for image comparison!'], 'Compare Warning', 'modal');
    else
        hObject.UserData = 0;
    end
end

% --- Executes when Comp is resized.
function Comp_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to Comp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(hObject.UserData, 'Pratt')
    handles.bPratt.Value = 1;
    show_pratt(handles);
elseif strcmp(hObject.UserData, 'Sub')
    handles.bSub.Value = 1;
    hide_all(handles);
end
hObject.UserData = 'NO';

% --- Executes on selection change in popSca.
function popSca_Callback(hObject, eventdata, handles)
% hObject    handle to popSca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popSca contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSca
if ~handles.cCfold.Value
    handles.txtRres.String = '...';
    handles.txtGres.String = '...';
    handles.txtBres.String = '...';
end

% --- Executes during object creation, after setting all properties.
function popSca_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popSca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txtGres_Callback(hObject, eventdata, handles)
% hObject    handle to txtBres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBres as text
%        str2double(get(hObject,'String')) returns contents of txtBres as a double


% --- Executes during object creation, after setting all properties.
function txtGres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txtBres_Callback(hObject, eventdata, handles)
% hObject    handle to txtBres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBres as text
%        str2double(get(hObject,'String')) returns contents of txtBres as a double


% --- Executes during object creation, after setting all properties.
function txtBres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtRres_Callback(hObject, eventdata, handles)
% hObject    handle to txtRres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtRres as text
%        str2double(get(hObject,'String')) returns contents of txtRres as a double


% --- Executes during object creation, after setting all properties.
function txtRres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtRres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtresG_Callback(hObject, eventdata, handles)
% hObject    handle to txtresG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtresG as text
%        str2double(get(hObject,'String')) returns contents of txtresG as a double


% --- Executes during object creation, after setting all properties.
function txtresG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtresG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtresR_Callback(hObject, eventdata, handles)
% hObject    handle to txtresR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtresR as text
%        str2double(get(hObject,'String')) returns contents of txtresR as a double


% --- Executes during object creation, after setting all properties.
function txtresR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtresR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtresB_Callback(hObject, eventdata, handles)
% hObject    handle to txtresB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtresB as text
%        str2double(get(hObject,'String')) returns contents of txtresB as a double


% --- Executes during object creation, after setting all properties.
function txtresB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtresB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popGray.
function popGray_Callback(hObject, eventdata, handles)
% hObject    handle to popGray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popGray contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popGray


% --- Executes during object creation, after setting all properties.
function popGray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popGray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function hide_all(handles)      %show and hide control for Subtraction n XOR
handles.lblGray.Visible = 'Off';
handles.popGray.Visible = 'Off';
handles.lblRerr.Visible = 'Off';
handles.txtresR.Visible = 'Off';
handles.txtresG.Visible = 'Off';
handles.txtresB.Visible = 'Off';
handles.lblSca.Visible = 'Off';
handles.popSca.Visible = 'Off';
handles.lblRes.Visible = 'Off';
handles.txtRres.Visible = 'Off';
handles.txtGres.Visible = 'Off';
handles.txtBres.Visible = 'Off';

function show_peak(handles)     %show and hide control for Peak SNR
handles.lblGray.Visible = 'On';
handles.popGray.Visible = 'On';
handles.lblRerr.Visible = 'On';
handles.txtresR.String = '';
handles.txtresG.String = '';
handles.txtresB.String = '';
handles.txtresR.Visible = 'Off';
handles.txtresG.Visible = 'On';
handles.txtresB.Visible = 'Off';
handles.lblSca.Visible = 'Off';
handles.popSca.Visible = 'Off';
handles.lblRes.Visible = 'Off';
handles.txtRres.Visible = 'Off';
handles.txtGres.Visible = 'Off';
handles.txtBres.Visible = 'Off';

function show_resE(handles)     %show and hide control for SNR n RMS
handles.lblGray.Visible = 'Off';
handles.popGray.Visible = 'Off';
handles.lblRerr.Visible = 'On';
handles.txtresR.String = '';
handles.txtresG.String = '';
handles.txtresB.String = '';
handles.txtresR.Visible = 'Off';
handles.txtresG.Visible = 'On';
handles.txtresB.Visible = 'Off';
handles.lblSca.Visible = 'Off';
handles.popSca.Visible = 'Off';
handles.lblRes.Visible = 'Off';
handles.txtRres.Visible = 'Off';
handles.txtGres.Visible = 'Off';
handles.txtBres.Visible = 'Off';

function show_pratt(handles)    %show and hide control for FOM
handles.lblGray.Visible = 'Off';
handles.popGray.Visible = 'Off';
handles.lblRerr.Visible = 'Off';
handles.txtresR.Visible = 'Off';
handles.txtresG.Visible = 'Off';
handles.txtresB.Visible = 'Off';
handles.lblSca.Visible = 'On';
handles.popSca.Visible = 'On';
handles.lblRes.Visible = 'On';
handles.txtRres.String = '';
handles.txtGres.String = '';
handles.txtBres.String = '';
handles.txtRres.Visible = 'Off';
handles.txtGres.Visible = 'On';
handles.txtBres.Visible = 'Off';


% --- Executes on button press in cCfold.
function cCfold_Callback(hObject, eventdata, handles)
% hObject    handle to cCfold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cCfold
if hObject.Value
    handles.txtIma1.String = 'Select First Image Folder...';
    handles.txtIma2.String = 'Select Second Image Folder...';
    handles.bSub.Value = 1;
    handles.bSub.UserData = 1;
    handles.bSub.Style = 'checkbox';
    handles.bXOR.Style = 'checkbox';
    handles.bPeak.Style = 'checkbox';
    handles.bSNR.Style = 'checkbox';
    handles.bRMS.Style = 'checkbox';
    handles.bPratt.Style = 'checkbox';
    handles.cIstats.Visible = 'On';
    handles.lblGray.Visible = 'On';
    handles.popGray.Visible = 'On';
    handles.popSca.Visible = 'On';
    handles.lblRerr.Visible = 'Off';
    handles.txtresR.Visible = 'Off';
    handles.txtresG.Visible = 'Off';
    handles.txtresB.Visible = 'Off';
    handles.lblRes.Visible = 'Off';
    handles.txtRres.Visible = 'Off';
    handles.txtBres.Visible = 'Off';
    handles.txtGres.Visible = 'Off';
else
    handles.txtIma1.String = 'Select First Image to Operate...';
    handles.txtIma2.String = 'Select Second Image to Operate...';
    handles.bSub.Style = 'radiobutton';
    handles.bXOR.Style = 'radiobutton';
    handles.bPeak.Style = 'radiobutton';
    handles.bSNR.Style = 'radiobutton';
    handles.bRMS.Style = 'radiobutton';
    handles.bPratt.Style = 'radiobutton';
    handles.cIstats.Visible = 'Off';
    hide_all(handles);
    handles.bSub.Value = 1;
end
handles.bXOR.UserData = 0;
handles.bPeak.UserData = 0;
handles.bSNR.UserData = 0;
handles.bRMS.UserData = 0;
handles.bPratt.UserData = 0;


% --- Executes on button press in cIstats.
function cIstats_Callback(hObject, eventdata, handles)
% hObject    handle to cIstats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cIstats


% --- Executes on button press in cOutFile.
function cOutFile_Callback(hObject, eventdata, handles)
% hObject    handle to cOutFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cOutFile
