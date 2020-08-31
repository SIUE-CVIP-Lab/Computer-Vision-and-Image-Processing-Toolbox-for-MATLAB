function varargout = DlgSmooth(varargin)
% DLGSMOOTH MATLAB code for DlgSmooth.fig
%      DLGSMOOTH, by itself, creates a new DLGSMOOTH or raises the existing
%      singleton*.
%
%      H = DLGSMOOTH returns the handle to a new DLGSMOOTH or the handle to
%      the existing singleton*.
%
%      DLGSMOOTH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DLGSMOOTH.M with the given input arguments.
%
%      DLGSMOOTH('Property','Value',...) creates a new DLGSMOOTH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgSmooth_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgSmooth_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DlgSmooth

% Last Modified by GUIDE v2.5 05-Jul-2020 21:49:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgSmooth_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgSmooth_OutputFcn, ...
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
%           Initial coding date:    10/13/2019
%           Updated by:             Joey Olden
%           Latest update date:     11/09/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% --- Executes just before DlgSmooth is made visible.
function DlgSmooth_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DlgSmooth (see VARARGIN)

% Choose default command line output for DlgSmooth
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DlgSmooth wait for user response (see UIRESUME)
% uiwait(handles.DlgSmooth);
%call menu creation function
menu_add_cvip(hObject);

handles.t1.Visible = 'On';
handles.t1.String = 'Mask Size:';
handles.p1.Visible = 'On';
handles.p1.String = {'3';'5';'7';'9';'11'};
handles.t2.Visible = 'Off';
handles.p2.Visible = 'Off';
handles.t3.Visible = 'Off';
handles.p3.Visible = 'Off';
handles.tb.Visible = 'Off';
handles.b1.Visible = 'Off';
handles.b2.Visible = 'Off';
handles.bFFT.Value = 0;


function mVsaveHis_Callback(hObject, eventdata, handles)
% hObject    handle to mVsaveHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('Hola Magola, This is working!!!  :)');
hObject.Checked = 'On';


% --- Outputs from this function are returned to the command line.
function varargout = DlgSmooth_OutputFcn(hObject, eventdata, handles) 
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
%mean filter
if handles.bMean.Value
    mask_size = str2double(handles.p1.String(handles.p1.Value));
    OutIma = arithmetic_mean_cvip(InIma,mask_size);
    Name = strcat(file, ' > Mean(',num2str(mask_size),'x',num2str(mask_size));
%guassian filter
elseif handles.bGauss.Value
    mask_size = str2double(handles.p1.String(handles.p1.Value));
    Mask = gaussmask_cvip(mask_size);
    OutIma = convolve_filter_cvip(InIma,Mask);
    Name = strcat(file, ' > Guassian(',num2str(mask_size),'x',num2str(mask_size));
%midpoint filter
elseif handles.bMid.Value
    mask_size = str2double(handles.p1.String(handles.p1.Value));
    OutIma = midpoint_filter_cvip(InIma,mask_size);
    Name = strcat(file, ' > Midpoint(',num2str(mask_size),'x',num2str(mask_size));
%contra-harmonic filter
elseif handles.bContra.Value
    mask_size = str2double(handles.p1.String(handles.p1.Value));
    order = str2double(handles.p2.String(handles.p2.Value));
    OutIma = contra_mean_cvip(InIma,mask_size,order);
    Name = strcat(file, ' > Contra-Harmonic(',num2str(mask_size),'x',num2str(mask_size),'Order:',num2str(order));
%median filter
elseif handles.bMed.Value
    mask_size = str2double(handles.p1.String(handles.p1.Value));
    if handles.b1.Value       
        OutIma = median_filter_cvip(InIma,mask_size);
        type = 'Stand';
    elseif handles.b2.Value
        OutIma = adapt_median_filter_cvip(InIma,mask_size);
        type = 'Adapt';
    end
    Name = strcat(file, ' > ',type,'Median(',num2str(mask_size),'x',num2str(mask_size));
%yp filter
elseif handles.bYp.Value
    mask_size = str2double(handles.p1.String(handles.p1.Value));
    order = str2double(handles.p2.String(handles.p2.Value));
    OutIma = yp_mean_cvip(InIma,mask_size,order);
    Name = strcat(file, ' > Yp(',num2str(mask_size),'x',num2str(mask_size),'Order;',num2str(order));
%kuwahara filter
elseif handles.bKuw.Value
    mask_size = str2double(handles.p1.String(handles.p1.Value));
    OutIma = kuwahara_filter_cvip(InIma,mask_size);
    Name = strcat(file, ' > Kuwahara(',num2str(mask_size),'x',num2str(mask_size));
%AD filter
elseif handles.bAD.Value
    iter = str2double(handles.p1.String(handles.p1.Value));
    lambda = str2double(handles.p2.String(handles.p2.Value));
    K = str2double(handles.p3.String(handles.p3.Value));
    if handles.b1.Value
        option = 1;
        type = 'Stand';
    elseif handles.b2.Value
        option = 2;
        type = 'Para';
    end
    OutIma = ad_filter_cvip(InIma,iter,lambda,K,option);
    Name = strcat(file, ' > ',type,'AD(Iter:',num2str(iter),'Lambda:',num2str(lambda),'Thresh:',num2str(K));
%FFT smoothing
elseif handles.bFFT.Value
    fc = str2double(handles.p1.String(handles.p1.Value));
    spect = fft_cvip(InIma,[]);
    low_pass = butterworth_low_cvip(spect,[],'fft','y',1,fc);
    OutIma = ifft_cvip(low_pass,[]);
    Name = strcat(file,' > FFTSmooth');
%DCT Smoothing
elseif handles.bDCT.Value
    fc = str2double(handles.p1.String(handles.p1.Value));
    spect = dct_cvip(InIma,[]);
    low_pass = butterworth_low_cvip(spect,[],'non-fft','y',1,fc);
    OutIma = idct_cvip(low_pass,[]);
    Name = strcat(file,' > DCTSmooth');
end
%END OF IMAGE OPERATIONS

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
 close(handles.Smooth)


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
function Smooth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DlgSmooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in bMean.
function bMean_Callback(hObject, eventdata, handles)
% hObject    handle to bMean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bMean
handles.t1.Visible = 'On';
handles.t1.String = 'Mask Size:';
handles.p1.Visible = 'On';
handles.p1.String = {'3';'5';'7';'9';'11'};
handles.t2.Visible = 'Off';
handles.p2.Visible = 'Off';
handles.t3.Visible = 'Off';
handles.p3.Visible = 'Off';
handles.tb.Visible = 'Off';
handles.b1.Visible = 'Off';
handles.b2.Visible = 'Off';
%handles for Frequency 
handles.bFFT.Value = 0;
handles.bDCT.Value = 0;


% --- Executes on button press in bGauss.
function bGauss_Callback(hObject, eventdata, handles)
% hObject    handle to bGauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bGauss
handles.t1.Visible = 'On';
handles.t1.String = 'Mask Size:';
handles.p1.Visible = 'On';
handles.p1.String = {'3';'5';'7';'9';'11'};
handles.t2.Visible = 'Off';
handles.p2.Visible = 'Off';
handles.t3.Visible = 'Off';
handles.p3.Visible = 'Off';
handles.tb.Visible = 'Off';
handles.b1.Visible = 'Off';
handles.b2.Visible = 'Off';
%handles for Frequency 
handles.bFFT.Value = 0;
handles.bDCT.Value = 0;


% --- Executes on button press in bMid.
function bMid_Callback(hObject, eventdata, handles)
% hObject    handle to bMid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bMid
handles.t1.Visible = 'On';
handles.t1.String = 'Mask Size:';
handles.p1.Visible = 'On';
handles.p1.String = {'3';'5';'7';'9';'11'};
handles.t2.Visible = 'Off';
handles.p2.Visible = 'Off';
handles.t3.Visible = 'Off';
handles.p3.Visible = 'Off';
handles.tb.Visible = 'Off';
handles.b1.Visible = 'Off';
handles.b2.Visible = 'Off';
%handles for Frequency 
handles.bFFT.Value = 0;
handles.bDCT.Value = 0;


% --- Executes on button press in bContra.
function bContra_Callback(hObject, eventdata, handles)
% hObject    handle to bContra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bContra
handles.t1.Visible = 'On';
handles.t1.String = 'Mask Size:';
handles.p1.Visible = 'On';
handles.p1.String = {'3';'5';'7';'9';'11'};
handles.t2.Visible = 'On';
handles.t2.String = 'Order:';
handles.p2.Visible = 'On';
handles.p2.String = {'-5';'-4';'-3';'-2';'-1';'0';'1';'2';'3';'4';'5'};
handles.t3.Visible = 'Off';
handles.p3.Visible = 'Off';
handles.tb.Visible = 'Off';
handles.b1.Visible = 'Off';
handles.b2.Visible = 'Off';
%handles for Frequency 
handles.bFFT.Value = 0;
handles.bDCT.Value = 0;


% --- Executes on button press in bYp.
function bYp_Callback(hObject, eventdata, handles)
% hObject    handle to bYp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bYp
handles.t1.Visible = 'On';
handles.t1.String = 'Mask Size:';
handles.p1.Visible = 'On';
handles.p1.String = {'3';'5';'7';'9';'11'};
handles.t2.Visible = 'On';
handles.t2.String = 'Order:';
handles.p2.Visible = 'On';
handles.p2.String = {'-5';'-4';'-3';'-2';'-1';'0';'1';'2';'3';'4';'5'};
handles.t3.Visible = 'Off';
handles.p3.Visible = 'Off';
handles.tb.Visible = 'Off';
handles.b1.Visible = 'Off';
handles.b2.Visible = 'Off';
%handles for Frequency 
handles.bFFT.Value = 0;
handles.bDCT.Value = 0;


% --- Executes on button press in bMed.
function bMed_Callback(hObject, eventdata, handles)
% hObject    handle to bMed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bMed
handles.t1.Visible = 'On';
handles.t1.String = 'Mask Size:';
handles.p1.Visible = 'On';
handles.p1.String = {'3';'5';'7';'9';'11'};
handles.t2.Visible = 'Off';
handles.p2.Visible = 'Off';
handles.t3.Visible = 'Off';
handles.p3.Visible = 'Off';
handles.tb.Visible = 'On';
handles.tb.String = 'Type:';
handles.b1.Visible = 'On';
handles.b1.String = 'Standard';
handles.b2.Visible = 'On';
handles.b2.String = 'Adaptive';
%handles for Frequency 
handles.bFFT.Value = 0;
handles.bDCT.Value = 0;


% --- Executes on button press in bKuw.
function bKuw_Callback(hObject, eventdata, handles)
% hObject    handle to bKuw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bKuw
handles.t1.Visible = 'On';
handles.t1.String = 'Mask Size:';
handles.p1.Visible = 'On';
handles.p1.String = {'3';'5';'7';'9';'11'};
handles.t2.Visible = 'Off';
handles.p2.Visible = 'Off';
handles.t3.Visible = 'Off';
handles.p3.Visible = 'Off';
handles.tb.Visible = 'Off';
handles.b1.Visible = 'Off';
handles.b2.Visible = 'Off';
%handles for Frequency 
handles.bFFT.Value = 0;
handles.bDCT.Value = 0;


% --- Executes on button press in bAD.
function bAD_Callback(hObject, eventdata, handles)
% hObject    handle to bAD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bAD
handles.t1.Visible = 'On';
handles.t1.String = '# of Iterations:';
handles.p1.Visible = 'On';
handles.p1.String = {'10';'20';'50';'100';'500'};
handles.t2.Visible = 'On';
handles.t2.String = 'Smoothing per Iteration:';
handles.p2.Visible = 'On';
handles.p2.String = {'1';'2';'3';'4';'5'};
handles.t3.Visible = 'On';
handles.t3.String = 'Edge Threshold:';
handles.p3.Visible = 'On';
handles.p3.String = {'1';'5';'15';'20'};
handles.tb.Visible = 'On';
handles.tb.String = 'Type:';
handles.b1.Visible = 'On';
handles.b1.String = 'Standard';
handles.b2.Visible = 'On';
handles.b2.String = 'Parametric';
%handles for Frequency 
handles.bFFT.Value = 0;
handles.bDCT.Value = 0;


% --- Executes on button press in bFFT.
function bFFT_Callback(hObject, eventdata, handles)
% hObject    handle to bFFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bFFT
handles.t1.Visible = 'On';
handles.t1.String = 'Cutoff Frequency:';
handles.p1.Visible = 'On';
handles.p1.String = {'16';'24';'32';'40';'48';'56';'64'};
handles.p1.Value = 2;
handles.t2.Visible = 'Off';
handles.p2.Visible = 'Off';
handles.t3.Visible = 'Off';
handles.p3.Visible = 'Off';
handles.tb.Visible = 'Off';
handles.b1.Visible = 'Off';
handles.b2.Visible = 'Off';
%handles for Spatial
handles.bMean.Value = 0;
handles.bGauss.Value = 0;
handles.bMid.Value = 0;
handles.bContra.Value = 0;
handles.bYp.Value = 0;
handles.bMed.Value = 0;
handles.bKuw.Value = 0;
handles.bAD.Value = 0;


% --- Executes on button press in bDCT.
function bDCT_Callback(hObject, eventdata, handles)
% hObject    handle to bDCT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bDCT
handles.t1.Visible = 'On';
handles.t1.String = 'Cutoff Frequency:';
handles.p1.Visible = 'On';
handles.p1.String = {'16';'24';'32';'40';'48';'56';'64'};
handles.p2.Value = 2;
handles.t2.Visible = 'Off';
handles.p2.Visible = 'Off';
handles.t3.Visible = 'Off';
handles.p3.Visible = 'Off';
handles.tb.Visible = 'Off';
handles.b1.Visible = 'Off';
handles.b2.Visible = 'Off';
%handles for Spatial
handles.bMean.Value = 0;
handles.bGauss.Value = 0;
handles.bMid.Value = 0;
handles.bContra.Value = 0;
handles.bYp.Value = 0;
handles.bMed.Value = 0;
handles.bKuw.Value = 0;
handles.bAD.Value = 0;


% --- Executes on selection change in p1.
function p1_Callback(hObject, eventdata, handles)
% hObject    handle to p1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns p1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from p1


% --- Executes during object creation, after setting all properties.
function p1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in p2.
function p2_Callback(hObject, eventdata, handles)
% hObject    handle to p2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns p2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from p2


% --- Executes during object creation, after setting all properties.
function p2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in p3.
function p3_Callback(hObject, eventdata, handles)
% hObject    handle to p3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns p3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from p3


% --- Executes during object creation, after setting all properties.
function p3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in b1.
function b1_Callback(hObject, eventdata, handles)
% hObject    handle to b1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of b1


% --- Executes on button press in b2.
function b2_Callback(hObject, eventdata, handles)
% hObject    handle to b2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of b2
