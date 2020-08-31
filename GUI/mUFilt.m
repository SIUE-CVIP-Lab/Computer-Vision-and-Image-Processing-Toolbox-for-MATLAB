function varargout = mUFilt(varargin)
% MUFILT MATLAB code for mUFilt.fig
%      MUFILT, by itself, creates a new MUFILT or raises the existing
%      singleton*.
%
%      H = MUFILT returns the handle to a new MUFILT or the handle to
%      the existing singleton*.
%
%      MUFILT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MUFILT.M with the given input arguments.
%
%      MUFILT('Property','Value',...) creates a new MUFILT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mUFilt_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mUFilt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mUFilt

% Last Modified by GUIDE v2.5 19-Dec-2018 16:02:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mUFilt_OpeningFcn, ...
                   'gui_OutputFcn',  @mUFilt_OutputFcn, ...
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
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     12/12/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
 % Revision 1.3  12/12/2018  17:09:52  jucuell
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

% --- Executes just before mUFilt is made visible.
function mUFilt_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mUFilt (see VARARGIN)

% Choose default command line output for mUFilt
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mUFilt wait for user response (see UIRESUME)
% uiwait(handles.Filt);
handles.Filt.Position(4) = 22.5;
%handles.mFilt.Position(2) = 4;

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';%hide Analysis menu
hUtil = findobj('Tag','mUshos');
% hUtil(1).MenuSelectedFcn=@(hObject,eventdata)CVIPToolbox('mUshow_Callback',...
%     hObject,'Filt',guidata(hObject));
hUtil(1).Callback=@(hObject,eventdata)CVIPToolbox('mUshow_Callback',...
    hObject,'Filt',guidata(hObject));


% --- Outputs from this function are returned to the command line.
function varargout = mUFilt_OutputFcn(hObject, eventdata, handles) 
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
 close(handles.Filt)


% --- Executes on button press in bReset.
function bReset_Callback(hObject, eventdata, handles)
% hObject    handle to bReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hObject.Value = ~hObject.Value;

if hObject.Value
    handles.Filt.Position(4) = 50;
else
    handles.Filt.Position(4) = 22.5;
end

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

%Image Operations
if handles.bMean.Value==1       %Mean filtering
    %get mask size
    Mask=str2double(handles.popMask.String(handles.popMask.Value));
    OutIma = arithmetic_mean_cvip(InIma,Mask);
    %update image history
    histo = [195 Mask];
    Name=strcat(file,' > MeanFilt(',num2str(Mask),')');
    
elseif handles.bMedian.Value==1	%Median filtering
    %get mask size
    Mask=str2double(handles.popMask.String(handles.popMask.Value));
    switch handles.popMedian.Value
        case 1
            OutIma = median_filter_cvip(InIma,Mask);
            %update image history
            histo = [208 Mask];
            Name=strcat(file,' > MedianFilt(',num2str(Mask),')');
        case 2
            OutIma = adapt_median_filter_cvip(InIma,Mask);
            %update image history
            histo = [189 Mask];
            Name=strcat(file,' > MedianAdapFilt(',num2str(Mask),')');
    end
    
elseif handles.bLap.Value==1 	%Laplacian filtering
    Mask = handles.Mask.Data;
    OutIma = convolve_filter_cvip(InIma,Mask);
    %update image history
    histo = 202;
    Name=strcat(file,' > LaplaceFilt(',num2str(handles.popLap.Value),')');

elseif handles.bDiff.Value==1  	%Difference filtering
    mSize=handles.popFSize.String(handles.popFSize.Value);
    Mask = handles.Mask.Data;
    OutIma = convolve_filter_cvip(InIma,Mask);
    %update image history
    histo = 202;
    Name=strcat(file,' > DiffFilt(',mSize{1},')');   

elseif handles.bSpe.Value==1 	%Specify filter
    mSize = handles.popSsiz.String(handles.popSsiz.Value);
    func = handles.popStyp.String(handles.popStyp.Value);
    Mask = handles.Mask.Data;
    OutIma = convolve_filter_cvip(InIma,Mask);
    %update image history
    histo = 202;
    Name=strcat(file,' > ',func{1},'(',mSize{1},')');   
    
elseif handles.bBlur.Value==1 	%Specify Blur
    width = str2double(handles.popMwid.String(handles.popMwid.Value));
    height = str2double(handles.popMhei.String(handles.popMhei.Value));
    blur = handles.popMet.Value;

    mask = h_image_cvip(blur, height, width);
    OutIma=convolve_filter_cvip(InIma,mask);
    %update image history
    histo = [237 blur height width; 202 0 0 0];
    Name=strcat(file,' > Blur','(',num2str(blur),',',num2str(height),...
        ',',num2str(width),')');   
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


% --- Executes on button press in bMean.
function bMean_Callback(hObject, eventdata, handles)
% hObject    handle to bMean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bMean
hide_all(handles);               %hide all controls
handles.popMask.Visible = 'On'; %show specific controls
handles.lblMsize.Visible = 'On';
handles.pFilt.Visible = 'On';

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


% --- Executes on selection change in popLap.
function popLap_Callback(hObject, eventdata, handles)
% hObject    handle to popLap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popLap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popLap
handles.cKeep.Value = 0;
switch handles.popLap.Value     %handles.Mask.Data = [{0.00},{-1.00},{0.00};{-1.00},{4.00},{-1.00};{0.00},{-1.00},{0.00}]; %{[0.00,-1.00,0.00;-1.00,4.00,-1.00;0.00,-1.00,0.00]};
    case 1
        handles.Mask.Data = [0.00,-1.00,0.00;-1.00,4.00,-1.00;0.00,-1.00,0.00];
        handles.lblMfilt.String = 'Laplacian Filter - Type 1';
    case 2
        handles.Mask.Data = [-1.00,-1.00,-1.00;-1.00,8.00,-1.00;-1.00,-1.00,-1.00];
        handles.lblMfilt.String = 'Laplacian Filter - Type 2';
    case 3
        handles.Mask.Data = [-2.00,1.00,-2.00;1.00,4.00,1.00;-2.00,1.00,-2.00];
        handles.lblMfilt.String = 'Laplacian Filter - Type 3';
end
% --- Executes during object creation, after setting all properties.
function popLap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popLap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bMedian.
function bMedian_Callback(hObject, eventdata, handles)
% hObject    handle to bMedian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bMedian
hide_all(handles);              %hide all controls
handles.popMask.Visible = 'On';   %show specific controls
handles.popMedian.Visible = 'On'; 
handles.lblMsize.Visible = 'On'; 
handles.pFilt.Visible = 'On'; 


% --- Executes on button press in bLap.
function bLap_Callback(hObject, eventdata, handles)
% hObject    handle to bLap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bLap
hide_all(handles);              %hide all controls
handles.popLap.Visible = 'On'; %show specific controls
handles.bEmask.Visible = 'On'; 
handles.pFilt.Visible = 'On'; 

% --- Executes on button press in bDiff.
function bDiff_Callback(hObject, eventdata, handles)
% hObject    handle to bDiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bDiff
hide_all(handles);                  %hide all controls
handles.lblDiff.Visible = 'On';   %show specific controls
handles.bEmask.Visible = 'On'; 
handles.popFSize.Visible = 'On';
handles.pFilt.Visible = 'On'; 

% --- Executes on button press in bSpe.
function bSpe_Callback(hObject, eventdata, handles)
% hObject    handle to bSpe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bSpe
hide_all(handles);              %hide all controls
handles.pSpe.Visible = 'On'; %show specific controls

% --- Executes on button press in bBlur.
function bBlur_Callback(hObject, eventdata, handles)
% hObject    handle to bBlur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bBlur
%show and hide control
hide_all(handles);              %hide all controls
handles.pBlur.Visible = 'On';   %show specific controls


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

% --- Executes when Filt is resized.
function Filt_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to Filt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(hObject.UserData, 'Mean')
    bMean_Callback(handles.bMean, eventdata, handles);
    handles.bMean.Value = 1;
elseif strcmp(hObject.UserData, 'Median')
    bMedian_Callback(handles.bMedian, eventdata, handles);
    handles.bMedian.Value = 1;
elseif strcmp(hObject.UserData, 'Lapla')
    bLap_Callback(handles.bLap, eventdata, handles);
    handles.bLap.Value = 1;
elseif strcmp(hObject.UserData, 'Diff')
    bDiff_Callback(handles.bDiff, eventdata, handles);
    handles.bDiff.Value = 1;
elseif strcmp(hObject.UserData, 'Spe')
    bSpe_Callback(handles.bSpe, eventdata, handles);
    handles.bSpe.Value = 1;
elseif strcmp(hObject.UserData, 'Blur')
    bBlur_Callback(handles.bBlur, eventdata, handles);
    handles.bBlur.Value = 1;
end
hObject.UserData = 'NO';


function hide_all(handles)
handles.popMedian.Visible = 'Off';
handles.bEmask.Visible = 'Off';
handles.lblDiff.Visible = 'Off';
handles.popFSize.Visible = 'Off';
handles.popLap.Visible = 'Off';
handles.popMask.Visible = 'Off';
handles.pFilt.Visible = 'Off';   
handles.pSpe.Visible = 'Off';   
handles.pBlur.Visible = 'Off';   
handles.lblMsize.Visible = 'Off';
handles.Mask.Visible = 'Off';
handles.bMCancel.Visible = 'Off';
handles.bMReset.Visible = 'Off';
handles.bMApply.Visible = 'Off';
handles.bEmask.String = 'Edit Mask';
handles.bSedit.String = 'Edit Mask';
handles.bEmaskS.String = 'Edit Mask';
handles.lblMori.Visible = 'Off';
handles.popMori.Visible = 'Off';
handles.cKeep.Visible = 'Off';
handles.lblMfilt.Visible = 'Off';

function diff_filtMask(handles)
Msiz = handles.popFSize.Value*2+1;
handles.Mask.Data = zeros(Msiz);
if handles.popMori.Value == 3 || handles.popMori.Value == 7
    a = zeros(Msiz);
    for i=1:Msiz
        if i<(Msiz+1)/2
            a(i,i)=1;
        elseif i>(Msiz+1)/2
            a(i,i)=-1;
        end
    end
elseif handles.popMori.Value == 5 || handles.popMori.Value == 1
    a = zeros(Msiz);
    for i=1:Msiz
        if i<(Msiz+1)/2
            a(i,Msiz+1-i)=1;
        elseif i>(Msiz+1)/2
            a(i,Msiz+1-i)=-1;
        end
    end
end

switch handles.popMori.Value
    case 2
        handles.Mask.Data(:,(Msiz+1)/2) = [ones(Msiz-(Msiz+1)/2,1); 0; -1*ones(Msiz-(Msiz+1)/2,1)];
        Ori=' Upper.';
    case 3
         handles.Mask.Data = a;
         Ori=' Upper-Left.';
    case 4
        handles.Mask.Data(:,(Msiz+1)/2) = [ones(Msiz-(Msiz+1)/2,1); 0; -1*ones(Msiz-(Msiz+1)/2,1)];
        handles.Mask.Data = handles.Mask.Data';
        Ori=' Left.';
    case 5
         handles.Mask.Data = -a;
         Ori=' Lower-Left.';
    case 6
        handles.Mask.Data(:,(Msiz+1)/2) = [ones(Msiz-(Msiz+1)/2,1); 0; -1*ones(Msiz-(Msiz+1)/2,1)]*-1;
        Ori=' Lower.';
    case 7
         handles.Mask.Data = -a;
         Ori=' Lower-Right.';
    case 8
        handles.Mask.Data(:,(Msiz+1)/2) = [ones(Msiz-(Msiz+1)/2,1); 0; -1*ones(Msiz-(Msiz+1)/2,1)]*-1;
        handles.Mask.Data = handles.Mask.Data';
        Ori=' Right.';
    case 1
         handles.Mask.Data = a;
         Ori=' Upper-Right.';
end
handles.lblMfilt.String = ['Difference Filter - ' num2str(Msiz) 'x' num2str(Msiz) Ori];
handles.Mask.Position(3) = 105+36*(Msiz-2);
handles.Mask.Position(4) = 60+18*(Msiz-2);

function spe_filtMask(handles)
Msiz = handles.popSsiz.Value*2+1;
if handles.popStyp.Value == 1       %edit LPF masks
    handles.Mask.Data = ones(Msiz);
    handles.lblMfilt.String = ['LPF Filter - ' num2str(Msiz) 'x' num2str(Msiz)];
        
elseif handles.popStyp.Value == 2       %edit HPF masks       
    handles.Mask.Data = ones(Msiz)*-1;
    handles.Mask.Data((Msiz+1)/2,(Msiz+1)/2)=Msiz*Msiz;
    handles.lblMfilt.String = ['HPF Filter - ' num2str(Msiz) 'x' num2str(Msiz)];

elseif handles.popStyp.Value == 3       %edit Center Weighted masks       
    handles.Mask.Data = ones(Msiz);
    handles.Mask.Data((Msiz+1)/2,(Msiz+1)/2)=Msiz*Msiz;
    handles.lblMfilt.String = ['Center Weighted - ' num2str(Msiz) 'x' num2str(Msiz)];
    
else                                    %edit Gauss masks
    gFilter = zeros(Msiz);
    switch Msiz                 %adjust Gaussian parameters for each size
        case 3
            x0=2;
            y0=2;
            w=1.4427;
        case 5
            x0=3;
            y0=3;
            w=2.23255;
        case 7
            x0=4;
            y0=4;
            w=3.114;
        case 9
            x0=5;
            y0=5;
            w=4.01107;
        case 11
            x0=6;
            y0=6;
            w=4.914;
    end
    
    for col = 1 : Msiz
      for row = 1 : Msiz
        gFilter(row, col) = exp(-((col-x0)^2+(row-y0)^2)/w);
      end
    end
    gFilter = power(Msiz,2)*gFilter;
    handles.Mask.Data = gFilter;
    handles.lblMfilt.String = ['Gaussian - ' num2str(Msiz) 'x' num2str(Msiz)];
    
end
ColW = cell(1,13);
if handles.popStyp.Value == 4
    for i=1:13
        ColW{i} = 45;
    end
    handles.Mask.ColumnWidth = ColW;
    handles.Mask.Position(3) = 35+45*Msiz;
    handles.Mask.Position(4) = 60+18*(Msiz-2);
else
    for i=1:13
        ColW{i} = 35;
    end
    handles.Mask.ColumnWidth = ColW;
    handles.Mask.Position(3) = 105+36*(Msiz-2);
    handles.Mask.Position(4) = 60+18*(Msiz-2);
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
CVIPToolbox('fOpen_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function fSave_Callback(hObject, eventdata, handles)
% hObject    handle to fSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('fSave_Callback',hObject,eventdata,guidata(hObject))


% --------------------------------------------------------------------
function uiSaveIma_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiSaveIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('fSave_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function uiOpenIma_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiOpenIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('fOpen_Callback',hObject,eventdata,guidata(hObject))


% --- Executes on selection change in popStyp.
function popStyp_Callback(hObject, eventdata, handles)
% hObject    handle to popStyp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popStyp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popStyp
spe_filtMask(handles)

% --- Executes during object creation, after setting all properties.
function popStyp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popStyp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popSsiz.
function popSsiz_Callback(hObject, eventdata, handles)
% hObject    handle to popSsiz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popSsiz contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSsiz
%size for Specify bilter mask
handles.cKeep.Value = 0;
spe_filtMask(handles)

% --- Executes during object creation, after setting all properties.
function popSsiz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popSsiz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popMWid.
function popMWid_Callback(hObject, eventdata, handles)
% hObject    handle to popMWid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMWid contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMWid


% --- Executes during object creation, after setting all properties.
function popMWid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMWid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popMHei.
function popMHei_Callback(hObject, eventdata, handles)
% hObject    handle to popMHei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMHei contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMHei


% --- Executes during object creation, after setting all properties.
function popMHei_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMHei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popBSha.
function popBSha_Callback(hObject, eventdata, handles)
% hObject    handle to popBSha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popBSha contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popBSha


% --- Executes during object creation, after setting all properties.
function popBSha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popBSha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in cSnorm.
function cSnorm_Callback(hObject, eventdata, handles)
% hObject    handle to cSnorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cSnorm



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bSedit.
function bSedit_Callback(hObject, eventdata, handles)
% hObject    handle to bSedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc             %Edit Mask for Specify Filter
handles.cKeep.Value = 0;
if strcmp(hObject.String,'Edit Mask')
    hObject.String = 'Hide Mask';
    handles.cKeep.Visible = 'On';
    handles.lblMfilt.Visible = 'On';
    spe_filtMask(handles);
    handles.Mask.Visible = 'On';
    handles.bMCancel.Visible = 'On';
    handles.bMReset.Visible = 'On';
    handles.bMApply.Visible = 'On';

else
    handles.Mask.Visible = 'Off';
    handles.bMCancel.Visible = 'Off';
    handles.bMReset.Visible = 'Off';
    handles.bMApply.Visible = 'Off';
    handles.edit17.Visible = 'Off';
    hObject.String = 'Edit Mask';
    handles.cKeep.Visible = 'Off';
    handles.lblMfilt.Visible = 'Off';
    
end

% --- Executes on selection change in popFSize.
function popFSize_Callback(hObject, eventdata, handles)
% hObject    handle to popFSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popFSize contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popFSize
handles.cKeep.Value = 0;
diff_filtMask(handles);
Msiz = hObject.Value*2+1;
handles.Mask.Position(3) = 105+36*(Msiz-2);
handles.Mask.Position(4) = 60+18*(Msiz-2);

% --- Executes during object creation, after setting all properties.
function popFSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popFSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bEmask.
function bEmask_Callback(hObject, eventdata, handles)
% hObject    handle to bEmask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
handles.cKeep.Value = 0;
if strcmp(hObject.String,'Edit Mask')
    hObject.String = 'Hide Mask';
    handles.cKeep.Visible = 'On';
    handles.lblMfilt.Visible = 'On';
%    handles.Filt.Position(4) = 33;
    if handles.bLap.Value           %edit Laplacian masks
        switch handles.popLap.Value     %handles.Mask.Data = [{0.00},{-1.00},{0.00};{-1.00},{4.00},{-1.00};{0.00},{-1.00},{0.00}]; %{[0.00,-1.00,0.00;-1.00,4.00,-1.00;0.00,-1.00,0.00]};
            case 1
                handles.Mask.Data = [0.00,-1.00,0.00;-1.00,4.00,-1.00;0.00,-1.00,0.00];
                handles.lblMfilt.String = 'Laplacian Filter - Type 1';
            case 2
                handles.Mask.Data = [-1.00,-1.00,-1.00;-1.00,8.00,-1.00;-1.00,-1.00,-1.00];
                handles.lblMfilt.String = 'Laplacian Filter - Type 2';
            case 3
                handles.Mask.Data = [-2.00,1.00,-2.00;1.00,4.00,1.00;-2.00,1.00,-2.00];
                handles.lblMfilt.String = 'Laplacian Filter - Type 3';
        end
        handles.Mask.Position(3) = 105+36*(1);
        handles.Mask.Position(4) = 60+18*(1);
        
    else                        %edit differential filter masks
        handles.lblMori.Visible = 'On';
        handles.popMori.Visible = 'On';
        diff_filtMask(handles);
        
    end

    handles.Mask.Visible = 'On';
    handles.bMCancel.Visible = 'On';
    handles.bMReset.Visible = 'On';
    handles.bMApply.Visible = 'On';

else
    handles.Mask.Visible = 'Off';
    handles.bMCancel.Visible = 'Off';
    handles.bMReset.Visible = 'Off';
    handles.bMApply.Visible = 'Off';
    handles.edit17.Visible = 'Off';
    hObject.String = 'Edit Mask';
    handles.cKeep.Visible = 'Off';
    handles.lblMfilt.Visible = 'Off';

end

% --- Executes on selection change in popMedian.
function popMedian_Callback(hObject, eventdata, handles)
% hObject    handle to popMedian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMedian contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMedian

% --- Executes during object creation, after setting all properties.
function popMedian_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMedian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popBMet.
function popBMet_Callback(hObject, eventdata, handles)
% hObject    handle to popBMet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popBMet contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popBMet


% --- Executes during object creation, after setting all properties.
function popBMet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popBMet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popMWei.
function popMWei_Callback(hObject, eventdata, handles)
% hObject    handle to popMWei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMWei contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMWei


% --- Executes during object creation, after setting all properties.
function popMWei_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMWei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bEmaskS.
function bEmaskS_Callback(hObject, eventdata, handles)
% hObject    handle to bEmaskS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
handles.cKeep.Value = 0;
if strcmp(hObject.String,'Edit Mask')
    hObject.String = 'Hide Mask';
    handles.cKeep.Visible = 'On';
    handles.lblMfilt.Visible = 'On';
    if handles.popStyp.Value == 1       %edit LPF masks
        handles.Mask.Data = ones(handles.popSsiz.Value);
        
        
% %         switch handles.popSsiz.Value	%according to filter size
% %             case 1
% %                 handles.Mask.Data = [0.00,-1.00,0.00;-1.00,4.00,-1.00;0.00,-1.00,0.00];
% %                 handles.lblMfilt.String = 'Laplacian Filter - Type 1';
% %             case 2
% %                 handles.Mask.Data = [-1.00,-1.00,-1.00;-1.00,8.00,-1.00;-1.00,-1.00,-1.00];
% %                 handles.lblMfilt.String = 'Laplacian Filter - Type 2';
% %             case 3
% %                 handles.Mask.Data = [-2.00,1.00,-2.00;1.00,4.00,1.00;-2.00,1.00,-2.00];
% %                 handles.lblMfilt.String = 'Laplacian Filter - Type 3';
% %         end
        handles.lblMfilt.String = ['LPF Filter - ' num2str(handles.popSsiz.Value)];
        
    else                        %edit differential filter masks
%         Msiz = handles.popFSize.Value*2+1;
%         handles.lblMori.Visible = 'On';
%         handles.popMori.Visible = 'On';
%         handles.Mask.Position(3) = 105+36*(Msiz-2);
%         handles.Mask.Position(4) = 60+18*(Msiz-2);
%         diff_filtMask(handles);
    end

    handles.Mask.Visible = 'On';
    handles.bMCancel.Visible = 'On';
    handles.bMReset.Visible = 'On';
    handles.bMApply.Visible = 'On';

else
    handles.Mask.Visible = 'Off';
    handles.bMCancel.Visible = 'Off';
    handles.bMReset.Visible = 'Off';
    handles.bMApply.Visible = 'Off';
    handles.edit17.Visible = 'Off';
    hObject.String = 'Edit Mask';
    handles.cKeep.Visible = 'Off';
    handles.lblMfilt.Visible = 'Off';
    %handles.Filt.Position(4) = 22.5;
    %handles.mFilt.Position(2) = 4;
end


function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bMCancel.
function bMCancel_Callback(hObject, eventdata, handles)
% hObject    handle to bMCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bMReset.
function bMReset_Callback(hObject, eventdata, handles)
% hObject    handle to bMReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bMApply.
function bMApply_Callback(hObject, eventdata, handles)
% hObject    handle to bMApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popSha.
function popSha_Callback(hObject, eventdata, handles)
% hObject    handle to popSha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popSha contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSha


% --- Executes during object creation, after setting all properties.
function popSha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popSha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popMhei.
function popMhei_Callback(hObject, eventdata, handles)
% hObject    handle to popMhei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMhei contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMhei


% --- Executes during object creation, after setting all properties.
function popMhei_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMhei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popMwid.
function popMwid_Callback(hObject, eventdata, handles)
% hObject    handle to popMwid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMwid contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMwid


% --- Executes during object creation, after setting all properties.
function popMwid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMwid (see GCBO)
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


% --- Executes on selection change in popWeig.
function popWeig_Callback(hObject, eventdata, handles)
% hObject    handle to popWeig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popWeig contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popWeig


% --- Executes during object creation, after setting all properties.
function popWeig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popWeig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cKeep.
function cKeep_Callback(hObject, eventdata, handles)
% hObject    handle to cKeep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cKeep
siza = size(handles.Mask.Data);
center = handles.Mask.Data((siza(1)+1)/2,(siza(2)+1)/2);

if hObject.Value
    center = center + 1;
else
    center = center - 1;
end
handles.Mask.Data((siza(1)+1)/2,(siza(2)+1)/2) = center;


% --- Executes on selection change in popMori.
function popMori_Callback(hObject, eventdata, handles)
% hObject    handle to popMori (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMori contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMori
diff_filtMask(handles);

% --- Executes during object creation, after setting all properties.
function popMori_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMori (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
