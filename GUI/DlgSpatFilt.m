function varargout = DlgSpatFilt(varargin)
% DLGSPATFILT MATLAB code for DlgSpatFilt.fig
%      DLGSPATFILT, by itself, creates a new DLGSPATFILT or raises the existing
%      singleton*.
%
%      H = DLGSPATFILT returns the handle to a new DLGSPATFILT or the handle to
%      the existing singleton*.
%
%      DLGSPATFILT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DLGSPATFILT.M with the given input arguments.
%
%      DLGSPATFILT('Property','Value',...) creates a new DLGSPATFILT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgSpatFilt_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgSpatFilt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DlgSpatFilt

% Last Modified by GUIDE v2.5 08-Oct-2019 00:16:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgSpatFilt_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgSpatFilt_OutputFcn, ...
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


% --- Executes just before DlgSpatFilt is made visible.
function DlgSpatFilt_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DlgSpatFilt (see VARARGIN)

% Choose default command line output for DlgSpatFilt
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DlgSpatFilt wait for user response (see UIRESUME)
% uiwait(handles.DlgSpatFilt);
%call menu creation function
menu_add_cvip(hObject);

handles.tAlpha.Visible = 'Off';
handles.eAlpha.Visible = 'Off';
handles.bArith.Value = 0;
handles.popMMask.Visible = 'Off';
handles.tMMask.Visible = 'Off';
handles.popFOrd.Visible = 'Off';
handles.tFOrd.Visible = 'Off';
handles.bMMSE.Value = 0;
handles.bStand.Visible = 'Off';
handles.bPara.Visible = 'Off';
handles.popVar.Visible = 'Off';
handles.tVar.Visible = 'Off';
handles.popThresh.Visible = 'Off';
handles.tThresh.Visible = 'Off';
handles.popKern.Visible = 'Off';
handles.tKern.Visible = 'Off';
handles.popGMin.Visible = 'Off';
handles.tGMin.Visible = 'Off';
handles.popGMax.Visible = 'Off';
handles.tGMax.Visible = 'Off';
handles.bgOption.Visible = 'Off';


function mVsaveHis_Callback(hObject, eventdata, handles)
% hObject    handle to mVsaveHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('Hola Magola, This is working!!!  :)');
hObject.Checked = 'On';


% --- Outputs from this function are returned to the command line.
function varargout = DlgSpatFilt_OutputFcn(hObject, eventdata, handles) 
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
    errordlg('Please select the image to Process', 'Filter Error', 'modal');
else
Ima=hNfig.UserData;             %Get image information
InIma = Ima.cvipIma;            %read image data
file = get(hNfig,'Name');       %get image name
histo = 0; OutIma = 0;          %initial vbles values

%IMAGE OPERATIONS
%median filter
if handles.bMed.Value
    mask_size = str2double(handles.popOMask.String(handles.popOMask.Value));
    OutIma = median_filter_cvip(InIma,mask_size);
    Name = [file,'< Median Filter(',num2str(mask_size),'x',num2str(mask_size),')'];
%minimum filter
elseif handles.bMin.Value
    mask_size = str2double(handles.popOMask.String(handles.popOMask.Value));
    OutIma = minimum_filter_cvip(InIma,mask_size);
    Name = [file,'< Minimum Filter(',num2str(mask_size),'x',num2str(mask_size),')'];
%midpoint filter
elseif handles.bMid.Value
    mask_size = str2double(handles.popOMask.String(handles.popOMask.Value));
    OutIma = midpoint_filter_cvip(InIma,mask_size);
    Name = [file,'< Midpoint Filter(',num2str(mask_size),'x',num2str(mask_size),')'];
%maximum filter
elseif handles.bMax.Value
    mask_size = str2double(handles.popOMask.String(handles.popOMask.Value));
    OutIma = maximum_filter_cvip(InIma,mask_size);
    Name = [file,'< Maximum Filter(',num2str(mask_size),'x',num2str(mask_size),')'];
%alpha trimmed mean filter
elseif handles.bAlpha.Value
    mask_size = str2double(handles.popOMask.String(handles.popOMask.Value));
    T = str2double(handles.eAlpha.String);
    OutIma = alpha_filter_cvip(InIma,mask_size,T);
    Name = [file,'< AlphaTrimmedMean Filter(',num2str(mask_size),'x',num2str(mask_size),', T=',num2str(T),')'];
%arithmetic mean filter
elseif handles.bArith.Value
    mask_size = str2double(handles.popMMask.String(handles.popMMask.Value));
    OutIma = arithmetic_mean_cvip(InIma,mask_size);
    Name = [file,'< ArithmeticMean Filter(',num2str(mask_size),'x',num2str(mask_size),')'];
%geometric mean filter
elseif handles.bGeo.Value
    mask_size = str2double(handles.popMMask.String(handles.popMMask.Value));
    OutIma = geometric_mean_cvip(InIma,mask_size);
    Name = [file,'< GeometricMean Filter(',num2str(mask_size),'x',num2str(mask_size),')'];
%harmonic mean filter
elseif handles.bHarm.Value
    mask_size = str2double(handles.popMMask.String(handles.popMMask.Value));
    OutIma = harmonic_mean_cvip(InIma,mask_size);
    Name = [file,'< HarmonicMean Filter(',num2str(mask_size),'x',num2str(mask_size),')'];
%contra_harmonic mean filter
elseif handles.bCont.Value
    mask_size = str2double(handles.popMMask.String(handles.popMMask.Value));
    filter_order = str2double(handles.popFOrd.String(handles.popFOrd.Value));
    OutIma = contra_mean_cvip(InIma,mask_size,filter_order);
    Name = [file,'< Contra-Harmonic Filter(',num2str(mask_size),'x',num2str(mask_size),')'];
%Yp filter
elseif handles.bYp.Value
    mask_size = str2double(handles.popMMask.String(handles.popMMask.Value));
    P = str2double(handles.popFOrd.String(handles.popFOrd.Value));
    OutIma = yp_mean_cvip(InIma,mask_size,P);
    Name = [file,'< Yp Filter(',num2str(mask_size),'x',num2str(mask_size),')'];
%MMSE filter
elseif handles.bMMSE.Value
    noise_var = str2double(handles.popVar.String(handles.popVar.Value));
    kernel_size = str2double(handles.popKern.String(handles.popKern.Value));
    if handles.bStand.Value
        OutIma =uint8( mmse_filter_cvip(InIma,noise_var,kernel_size));
        
        
        Name = [file,'< MMSE_Standard Filter(',num2str(kernel_size),'x',num2str(kernel_size),...
               ', NV=',num2str(noise_var),')'];
           
    elseif handles.bPara.Value
        threshval = str2double(handles.popThresh.String(handles.popThresh.Value));
        OutIma = uint8(improved_mmse_filter_cvip(InIma,noise_var,kernel_size,threshval));
        Name = [file,'< MMSE_Improved Filter(',num2str(kernel_size),'x',num2str(kernel_size),...
               ', NV=',num2str(noise_var),'Threshval=',num2str(threshval),')'];
    end
%Adaptive Median filter
elseif handles.bAdMed.Value
    mask_size = str2double(handles.popVar.String(handles.popVar.Value));
    OutIma = adapt_median_filter_cvip(InIma,mask_size);
    Name = [file,'< AdaptiveMedian Filter(',num2str(mask_size),'x',num2str(mask_size),')'];
%kuwahara filter
elseif handles.bKuw.Value
    mask_size = str2double(handles.popVar.String(handles.popVar.Value));
    OutIma = kuwahara_filter_cvip(InIma,mask_size);
    Name = [file,'< Kuwahara Filter(',num2str(mask_size),'x',num2str(mask_size),')'];
%adaptive contrast filter
elseif handles.bAdCon.Value
 
    lgf = str2double(handles.popVar.String(handles.popVar.Value));
    lmf = str2double(handles.popThresh.String(handles.popThresh.Value));
    kernel_size = str2double(handles.popKern.String(handles.popKern.Value));
    lgmin = str2double(handles.popGMin.String(handles.popGMin.Value));
    lgmax = str2double(handles.popGMax.String(handles.popGMax.Value));
    OutIma = adaptive_contrast_cvip(InIma,kernel_size,lgf,lmf,lgmin,lgmax);
    Name = [file,'< AdaptiveContrast Filter(',num2str(kernel_size),'x',num2str(kernel_size),...
           ', k1=',num2str(lgf),'k2=',num2str(lmf),'min=',num2str(lgmin),'max=',num2str(lgmax),')'];
%anisotropic diffusion filter
elseif handles.bAnDif.Value
    iter = str2double(handles.popVar.String(handles.popVar.Value));
    lambda = str2double(handles.popThresh.String(handles.popThresh.Value));
    K = str2double(handles.popKern.String(handles.popKern.Value));
    if handles.bStand.Value
        OutIma = ad_filter_cvip(InIma,iter,lambda,K,1);
        Name = [file,'< AD_Standard Filter(Iter=',num2str(iter),'lambda=',num2str(lambda),'K=',num2str(K),')'];
    elseif handles.bPara.Value
        OutIma = ad_filter_cvip(InIMa,iter,lambda,K,2);
        Name = [file,'< AD_Parametric Filter(Iter=',num2str(iter),'lambda=',num2str(lambda),'K=',num2str(K),')'];
    end   
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
    showgui_cvip(Ima, Name); 
    %show image in viewer
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
 close(handles.SpatFilt)


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
function SpatFilt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DlgSpatFilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in bMed.
function bMed_Callback(hObject, eventdata, handles)
% hObject    handle to bMed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bMed
%handles for Order Filters
handles.popOMask.Visible = 'On';
handles.tOMask.Visible = 'On';
handles.tAlpha.Visible = 'Off';
handles.eAlpha.Visible = 'Off';
%handles for Mean Filters
handles.bArith.Value = 0;
handles.bGeo.Value = 0;
handles.bHarm.Value = 0;
handles.bCont.Value = 0;
handles.bYp.Value = 0;
handles.popMMask.Visible = 'Off';
handles.tMMask.Visible = 'Off';
handles.popFOrd.Visible = 'Off';
handles.tFOrd.Visible = 'Off';
%handles for Adaptive Filters
handles.bMMSE.Value = 0;
handles.bAdMed.Value = 0;
handles.bKuw.Value = 0;
handles.bAdCon.Value = 0;
handles.bAnDif.Value = 0;
handles.bStand.Visible = 'Off';
handles.bPara.Visible = 'Off';
handles.popVar.Visible = 'Off';
handles.tVar.Visible = 'Off';
handles.popThresh.Visible = 'Off';
handles.tThresh.Visible = 'Off';
handles.popKern.Visible = 'Off';
handles.tKern.Visible = 'Off';
handles.popGMin.Visible = 'Off';
handles.tGMin.Visible = 'Off';
handles.popGMax.Visible = 'Off';
handles.tGMax.Visible = 'Off';
handles.bgOption.Visible = 'Off';

% --- Executes on button press in bMin.
function bMin_Callback(hObject, eventdata, handles)
% hObject    handle to bMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bMin
%handles for Order Filters
handles.popOMask.Visible = 'On';
handles.tOMask.Visible = 'On';
handles.tAlpha.Visible = 'Off';
handles.eAlpha.Visible = 'Off';
%handles for Mean Filters
handles.bArith.Value = 0;
handles.bGeo.Value = 0;
handles.bHarm.Value = 0;
handles.bCont.Value = 0;
handles.bYp.Value = 0;
handles.popMMask.Visible = 'Off';
handles.tMMask.Visible = 'Off';
handles.popFOrd.Visible = 'Off';
handles.tFOrd.Visible = 'Off';
%handles for Adaptive Filters
handles.bMMSE.Value = 0;
handles.bAdMed.Value = 0;
handles.bKuw.Value = 0;
handles.bAdCon.Value = 0;
handles.bAnDif.Value = 0;
handles.bStand.Visible = 'Off';
handles.bPara.Visible = 'Off';
handles.popVar.Visible = 'Off';
handles.tVar.Visible = 'Off';
handles.popThresh.Visible = 'Off';
handles.tThresh.Visible = 'Off';
handles.popKern.Visible = 'Off';
handles.tKern.Visible = 'Off';
handles.popGMin.Visible = 'Off';
handles.tGMin.Visible = 'Off';
handles.popGMax.Visible = 'Off';
handles.tGMax.Visible = 'Off';
handles.bgOption.Visible = 'Off';


% --- Executes on button press in bMid.
function bMid_Callback(hObject, eventdata, handles)
% hObject    handle to bMid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bMid
%handles for Order Filters
handles.popOMask.Visible = 'On';
handles.tOMask.Visible = 'On';
handles.tAlpha.Visible = 'Off';
handles.eAlpha.Visible = 'Off';
%handles for Mean Filters
handles.bArith.Value = 0;
handles.bGeo.Value = 0;
handles.bHarm.Value = 0;
handles.bCont.Value = 0;
handles.bYp.Value = 0;
handles.popMMask.Visible = 'Off';
handles.tMMask.Visible = 'Off';
handles.popFOrd.Visible = 'Off';
handles.tFOrd.Visible = 'Off';
%handles for Adaptive Filters
handles.bMMSE.Value = 0;
handles.bAdMed.Value = 0;
handles.bKuw.Value = 0;
handles.bAdCon.Value = 0;
handles.bAnDif.Value = 0;
handles.bStand.Visible = 'Off';
handles.bPara.Visible = 'Off';
handles.popVar.Visible = 'Off';
handles.tVar.Visible = 'Off';
handles.popThresh.Visible = 'Off';
handles.tThresh.Visible = 'Off';
handles.popKern.Visible = 'Off';
handles.tKern.Visible = 'Off';
handles.popGMin.Visible = 'Off';
handles.tGMin.Visible = 'Off';
handles.popGMax.Visible = 'Off';
handles.tGMax.Visible = 'Off';
handles.bgOption.Visible = 'Off';


% --- Executes on button press in bMax.
function bMax_Callback(hObject, eventdata, handles)
% hObject    handle to bMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bMax
%handles for Order Filters
handles.popOMask.Visible = 'On';
handles.tOMask.Visible = 'On';
handles.tAlpha.Visible = 'Off';
handles.eAlpha.Visible = 'Off';
%handle for Mean Filters
handles.bArith.Value = 0;
handles.bGeo.Value = 0;
handles.bHarm.Value = 0;
handles.bCont.Value = 0;
handles.bYp.Value = 0;
handles.popMMask.Visible = 'Off';
handles.tMMask.Visible = 'Off';
handles.popFOrd.Visible = 'Off';
handles.tFOrd.Visible = 'Off';
%handles for Adaptive Filters
handles.bMMSE.Value = 0;
handles.bAdMed.Value = 0;
handles.bKuw.Value = 0;
handles.bAdCon.Value = 0;
handles.bAnDif.Value = 0;
handles.bStand.Visible = 'Off';
handles.bPara.Visible = 'Off';
handles.popVar.Visible = 'Off';
handles.tVar.Visible = 'Off';
handles.popThresh.Visible = 'Off';
handles.tThresh.Visible = 'Off';
handles.popKern.Visible = 'Off';
handles.tKern.Visible = 'Off';
handles.popGMin.Visible = 'Off';
handles.tGMin.Visible = 'Off';
handles.popGMax.Visible = 'Off';
handles.tGMax.Visible = 'Off';
handles.bgOption.Visible = 'Off';


% --- Executes on button press in bAlpha.
function bAlpha_Callback(hObject, eventdata, handles)
% hObject    handle to bAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bAlpha
%handles for Order Filters
handles.popOMask.Visible = 'On';
handles.tOMask.Visible = 'On';
handles.tAlpha.Visible = 'On';
handles.eAlpha.Visible = 'On';
%handles for Mean Filters
handles.bArith.Value = 0;
handles.bGeo.Value = 0;
handles.bHarm.Value = 0;
handles.bCont.Value = 0;
handles.bYp.Value = 0;
handles.popMMask.Visible = 'Off';
handles.tMMask.Visible = 'Off';
handles.popFOrd.Visible = 'Off';
handles.tFOrd.Visible = 'Off';
%handles for Adaptive Filters
handles.bMMSE.Value = 0;
handles.bAdMed.Value = 0;
handles.bKuw.Value = 0;
handles.bAdCon.Value = 0;
handles.bAnDif.Value = 0;
handles.bStand.Visible = 'Off';
handles.bPara.Visible = 'Off';
handles.popVar.Visible = 'Off';
handles.tVar.Visible = 'Off';
handles.popThresh.Visible = 'Off';
handles.tThresh.Visible = 'Off';
handles.popKern.Visible = 'Off';
handles.tKern.Visible = 'Off';
handles.popGMin.Visible = 'Off';
handles.tGMin.Visible = 'Off';
handles.popGMax.Visible = 'Off';
handles.tGMax.Visible = 'Off';
handles.bgOption.Visible = 'Off';


% --- Executes on selection change in popOMask.
function popOMask_Callback(hObject, eventdata, handles)
% hObject    handle to popOMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popOMask contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popOMask


% --- Executes during object creation, after setting all properties.
function popOMask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popOMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function eAlpha_Callback(hObject, eventdata, handles)
% hObject    handle to eAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eAlpha as text
%        str2double(get(hObject,'String')) returns contents of eAlpha as a double


% --- Executes during object creation, after setting all properties.
function eAlpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function tAlpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in bArith.
function bArith_Callback(hObject, eventdata, handles)
% hObject    handle to bArith (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bArith
%handles for Order Filters
handles.bMed.Value = 0;
handles.bMin.Value = 0;
handles.bMid.Value = 0;
handles.bMax.Value = 0;
handles.bAlpha.Value = 0;
handles.popOMask.Visible = 'Off';
handles.tOMask.Visible = 'Off';
handles.tAlpha.Visible = 'Off';
handles.eAlpha.Visible = 'Off';
%handles for Mean Filters
handles.popMMask.Visible = 'On';
handles.tMMask.Visible = 'On';
handles.popFOrd.Visible = 'Off';
handles.tFOrd.Visible = 'Off';
%handles for Adaptive Filters
handles.bMMSE.Value = 0;
handles.bAdMed.Value = 0;
handles.bKuw.Value = 0;
handles.bAdCon.Value = 0;
handles.bAnDif.Value = 0;
handles.bStand.Visible = 'Off';
handles.bPara.Visible = 'Off';
handles.popVar.Visible = 'Off';
handles.tVar.Visible = 'Off';
handles.popThresh.Visible = 'Off';
handles.tThresh.Visible = 'Off';
handles.popKern.Visible = 'Off';
handles.tKern.Visible = 'Off';
handles.popGMin.Visible = 'Off';
handles.tGMin.Visible = 'Off';
handles.popGMax.Visible = 'Off';
handles.tGMax.Visible = 'Off';
handles.bgOption.Visible = 'Off';


% --- Executes on button press in bGeo.
function bGeo_Callback(hObject, eventdata, handles)
% hObject    handle to bGeo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bGeo
%handles for Order Filters
handles.bMed.Value = 0;
handles.bMin.Value = 0;
handles.bMid.Value = 0;
handles.bMax.Value = 0;
handles.bAlpha.Value = 0;
handles.popOMask.Visible = 'Off';
handles.tOMask.Visible = 'Off';
handles.tAlpha.Visible = 'Off';
handles.eAlpha.Visible = 'Off';
%handles for Mean Filters
handles.popMMask.Visible = 'On';
handles.tMMask.Visible = 'On';
handles.popFOrd.Visible = 'Off';
handles.tFOrd.Visible = 'Off';
%handles for Adaptive Filters
handles.bMMSE.Value = 0;
handles.bAdMed.Value = 0;
handles.bKuw.Value = 0;
handles.bAdCon.Value = 0;
handles.bAnDif.Value = 0;
handles.bStand.Visible = 'Off';
handles.bPara.Visible = 'Off';
handles.popVar.Visible = 'Off';
handles.tVar.Visible = 'Off';
handles.popThresh.Visible = 'Off';
handles.tThresh.Visible = 'Off';
handles.popKern.Visible = 'Off';
handles.tKern.Visible = 'Off';
handles.popGMin.Visible = 'Off';
handles.tGMin.Visible = 'Off';
handles.popGMax.Visible = 'Off';
handles.tGMax.Visible = 'Off';
handles.bgOption.Visible = 'Off';


% --- Executes on button press in bHarm.
function bHarm_Callback(hObject, eventdata, handles)
% hObject    handle to bHarm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bHarm
%handles for Order Filters
handles.bMed.Value = 0;
handles.bMin.Value = 0;
handles.bMid.Value = 0;
handles.bMax.Value = 0;
handles.bAlpha.Value = 0;
handles.popOMask.Visible = 'Off';
handles.tOMask.Visible = 'Off';
handles.tAlpha.Visible = 'Off';
handles.eAlpha.Visible = 'Off';
%handles for Mean Filters
handles.popMMask.Visible = 'On';
handles.tMMask.Visible = 'On';
handles.popFOrd.Visible = 'Off';
handles.tFOrd.Visible = 'Off';
%handles for Adaptive Filters
handles.bMMSE.Value = 0;
handles.bAdMed.Value = 0;
handles.bKuw.Value = 0;
handles.bAdCon.Value = 0;
handles.bAnDif.Value = 0;
handles.bStand.Visible = 'Off';
handles.bPara.Visible = 'Off';
handles.popVar.Visible = 'Off';
handles.tVar.Visible = 'Off';
handles.popThresh.Visible = 'Off';
handles.tThresh.Visible = 'Off';
handles.popKern.Visible = 'Off';
handles.tKern.Visible = 'Off';
handles.popGMin.Visible = 'Off';
handles.tGMin.Visible = 'Off';
handles.popGMax.Visible = 'Off';
handles.tGMax.Visible = 'Off';
handles.bgOption.Visible = 'Off';


% --- Executes on button press in bCont.
function bCont_Callback(hObject, eventdata, handles)
% hObject    handle to bCont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bCont
%handles for Order Filters
handles.bMed.Value = 0;
handles.bMin.Value = 0;
handles.bMid.Value = 0;
handles.bMax.Value = 0;
handles.bAlpha.Value = 0;
handles.popOMask.Visible = 'Off';
handles.tOMask.Visible = 'Off';
handles.tAlpha.Visible = 'Off';
handles.eAlpha.Visible = 'Off';
%handles for Mean Filters
handles.popMMask.Visible = 'On';
handles.tMMask.Visible = 'On';
handles.popFOrd.Visible = 'On';
handles.tFOrd.Visible = 'On';
%handles for Adaptive Filters
handles.bMMSE.Value = 0;
handles.bAdMed.Value = 0;
handles.bKuw.Value = 0;
handles.bAdCon.Value = 0;
handles.bAnDif.Value = 0;
handles.bStand.Visible = 'Off';
handles.bPara.Visible = 'Off';
handles.popVar.Visible = 'Off';
handles.tVar.Visible = 'Off';
handles.popThresh.Visible = 'Off';
handles.tThresh.Visible = 'Off';
handles.popKern.Visible = 'Off';
handles.tKern.Visible = 'Off';
handles.popGMin.Visible = 'Off';
handles.tGMin.Visible = 'Off';
handles.popGMax.Visible = 'Off';
handles.tGMax.Visible = 'Off';
handles.bgOption.Visible = 'Off';


% --- Executes on button press in bYp.
function bYp_Callback(hObject, eventdata, handles)
% hObject    handle to bYp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bYp
%handles for Order Filters
handles.bMed.Value = 0;
handles.bMin.Value = 0;
handles.bMid.Value = 0;
handles.bMax.Value = 0;
handles.bAlpha.Value = 0;
handles.popOMask.Visible = 'Off';
handles.tOMask.Visible = 'Off';
handles.tAlpha.Visible = 'Off';
handles.eAlpha.Visible = 'Off';
%handles for Mean Filters
handles.popMMask.Visible = 'On';
handles.tMMask.Visible = 'On';
handles.popFOrd.Visible = 'On';
handles.tFOrd.Visible = 'On';
%handles for Adaptive Filters
handles.bMMSE.Value = 0;
handles.bAdMed.Value = 0;
handles.bKuw.Value = 0;
handles.bAdCon.Value = 0;
handles.bAnDif.Value = 0;
handles.bStand.Visible = 'Off';
handles.bPara.Visible = 'Off';
handles.popVar.Visible = 'Off';
handles.tVar.Visible = 'Off';
handles.popThresh.Visible = 'Off';
handles.tThresh.Visible = 'Off';
handles.popKern.Visible = 'Off';
handles.tKern.Visible = 'Off';
handles.popGMin.Visible = 'Off';
handles.tGMin.Visible = 'Off';
handles.popGMax.Visible = 'Off';
handles.tGMax.Visible = 'Off';
handles.bgOption.Visible = 'Off';


% --- Executes on selection change in popMMask.
function popMMask_Callback(hObject, eventdata, handles)
% hObject    handle to popMMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMMask contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMMask


% --- Executes during object creation, after setting all properties.
function popMMask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bMMSE.
function bMMSE_Callback(hObject, eventdata, handles)
% hObject    handle to bMMSE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bMMSE
%handles for Order Filters
handles.bMed.Value = 0;
handles.bMin.Value = 0;
handles.bMid.Value = 0;
handles.bMax.Value = 0;
handles.bAlpha.Value = 0;
handles.popOMask.Visible = 'Off';
handles.tOMask.Visible = 'Off';
handles.tAlpha.Visible = 'Off';
handles.eAlpha.Visible = 'Off';
%handles for Mean Filters
handles.bArith.Value = 0;
handles.bGeo.Value = 0;
handles.bHarm.Value = 0;
handles.bCont.Value = 0;
handles.bYp.Value = 0;
handles.popMMask.Visible = 'Off';
handles.tMMask.Visible = 'Off';
handles.popFOrd.Visible = 'Off';
handles.tFOrd.Visible = 'Off';
%handles for Adaptive Filters
handles.popVar.Visible = 'On';
handles.popVar.String ={100;200;300;400;500;600;700;800.00};
handles.tVar.Visible = 'On';
handles.tVar.String = 'Noise Variance:';
handles.popThresh.Visible = 'On';
handles.popThresh.String = {0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9;1.0};
handles.tThresh.Visible = 'On';
handles.tThresh.String = 'Threshold:';
handles.popKern.Visible = 'On';
handles.popKern.String = {3;5;7;9;11;13;15};
handles.tKern.Visible = 'On';
handles.tKern.String = 'Kernel Size:';
handles.popGMin.Visible = 'Off';
handles.tGMin.Visible = 'Off';
handles.popGMax.Visible = 'Off';
handles.tGMax.Visible = 'Off';
handles.bgOption.Visible = 'On';
handles.bStand.Visible = 'On';
handles.bStand.Value = 1;
handles.bPara.Visible = 'On';
handles.bPara.String = 'Improved';


% --- Executes on button press in bAdMed.
function bAdMed_Callback(hObject, eventdata, handles)
% hObject    handle to bAdMed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bAdMed
%handles for Order Filters
handles.bMed.Value = 0;
handles.bMin.Value = 0;
handles.bMid.Value = 0;
handles.bMax.Value = 0;
handles.bAlpha.Value = 0;
handles.popOMask.Visible = 'Off';
handles.tOMask.Visible = 'Off';
handles.tAlpha.Visible = 'Off';
handles.eAlpha.Visible = 'Off';
%handles for Mean Filters
handles.bArith.Value = 0;
handles.bGeo.Value = 0;
handles.bHarm.Value = 0;
handles.bCont.Value = 0;
handles.bYp.Value = 0;
handles.popMMask.Visible = 'Off';
handles.tMMask.Visible = 'Off';
handles.popFOrd.Visible = 'Off';
handles.tFOrd.Visible = 'Off';
%handles for Adaptive Filters
handles.popVar.Visible = 'On';
handles.popVar.String = {3;5;7;9;11;13};
handles.tVar.Visible = 'On';
handles.tVar.String = 'Mask Size:';
handles.popThresh.Visible = 'Off';
handles.tThresh.Visible = 'Off';
handles.popKern.Visible = 'Off';
handles.tKern.Visible = 'Off';
handles.popGMin.Visible = 'Off';
handles.tGMin.Visible = 'Off';
handles.popGMax.Visible = 'Off';
handles.tGMax.Visible = 'Off';
handles.bgOption.Visible = 'Off';


% --- Executes on button press in bKuw.
function bKuw_Callback(hObject, eventdata, handles)
% hObject    handle to bKuw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bKuw
%handles for Order Filters
handles.bMed.Value = 0;
handles.bMin.Value = 0;
handles.bMid.Value = 0;
handles.bMax.Value = 0;
handles.bAlpha.Value = 0;
handles.popOMask.Visible = 'Off';
handles.tOMask.Visible = 'Off';
handles.tAlpha.Visible = 'Off';
handles.eAlpha.Visible = 'Off';
%handles for Mean Filters
handles.bArith.Value = 0;
handles.bGeo.Value = 0;
handles.bHarm.Value = 0;
handles.bCont.Value = 0;
handles.bYp.Value = 0;
handles.popMMask.Visible = 'Off';
handles.tMMask.Visible = 'Off';
handles.popFOrd.Visible = 'Off';
handles.tFOrd.Visible = 'Off';
%handles for Adaptive Filters
handles.popVar.Visible = 'On';
handles.popVar.String = {3;5;7;9;11;13};
handles.tVar.Visible = 'On';
handles.tVar.String = 'Mask Size:';
handles.popThresh.Visible = 'Off';
handles.tThresh.Visible = 'Off';
handles.popKern.Visible = 'Off';
handles.tKern.Visible = 'Off';
handles.popGMin.Visible = 'Off';
handles.tGMin.Visible = 'Off';
handles.popGMax.Visible = 'Off';
handles.tGMax.Visible = 'Off';
handles.bgOption.Visible = 'Off';


% --- Executes on button press in bAdCon.
function bAdCon_Callback(hObject, eventdata, handles)
% hObject    handle to bAdCon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bAdCon
%handles for Order Filters
handles.bMed.Value = 0;
handles.bMin.Value = 0;
handles.bMid.Value = 0;
handles.bMax.Value = 0;
handles.bAlpha.Value = 0;
handles.popOMask.Visible = 'Off';
handles.tOMask.Visible = 'Off';
handles.tAlpha.Visible = 'Off';
handles.eAlpha.Visible = 'Off';
%handles for Mean Filters
handles.bArith.Value = 0;
handles.bGeo.Value = 0;
handles.bHarm.Value = 0;
handles.bCont.Value = 0;
handles.bYp.Value = 0;
handles.popMMask.Visible = 'Off';
handles.tMMask.Visible = 'Off';
handles.popFOrd.Visible = 'Off';
handles.tFOrd.Visible = 'Off';
%handles for Adaptive Filters
handles.popVar.Visible = 'On';
handles.popVar.String = {0.2;0.5;0.6;0.8;0.9};

handles.tVar.Visible = 'On';
handles.tVar.String = 'Local Gain Factor:';
handles.popThresh.Visible = 'On';
handles.popThresh.String = {0.5;0.6;0.7;0.8;0.9;1.0};
handles.tThresh.Visible = 'On';
handles.tThresh.String = 'Local Mean Factor:';
handles.popKern.Visible = 'On';
handles.popKern.String = {11;13;15;17;19;21};
handles.tKern.Visible = 'On';
handles.tKern.String = 'Kernel Size:';
handles.popGMin.Visible = 'On';
handles.tGMin.Visible = 'On';
handles.popGMax.Visible = 'On';
handles.tGMax.Visible = 'On';
handles.bgOption.Visible = 'Off';


% --- Executes on button press in bAnDif.
function bAnDif_Callback(hObject, eventdata, handles)
% hObject    handle to bAnDif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bAnDif
%handles for Order Filters
handles.bMed.Value = 0;
handles.bMin.Value = 0;
handles.bMid.Value = 0;
handles.bMax.Value = 0;
handles.bAlpha.Value = 0;
handles.popOMask.Visible = 'Off';
handles.tOMask.Visible = 'Off';
handles.tAlpha.Visible = 'Off';
handles.eAlpha.Visible = 'Off';
%handles for Mean Filters
handles.bArith.Value = 0;
handles.bGeo.Value = 0;
handles.bHarm.Value = 0;
handles.bCont.Value = 0;
handles.bYp.Value = 0;
handles.popMMask.Visible = 'Off';
handles.tMMask.Visible = 'Off';
handles.popFOrd.Visible = 'Off';
handles.tFOrd.Visible = 'Off';
%handles for Adaptive Filters
handles.popVar.Visible = 'On';
handles.popVar.String = {10;20;50;100;200};
handles.tVar.Visible = 'On';
handles.tVar.String = '# of Iterations:';
handles.popThresh.Visible = 'On';
handles.popThresh.String = {1;2;3;4;5};
handles.tThresh.Visible = 'On';
handles.tThresh.String = 'Smoothing/Iteration:';
handles.popKern.Visible = 'On';
handles.popKern.String = {1;5;10;15;20};
handles.tKern.Visible = 'On';
handles.tKern.String = 'Edge Threshold:';
handles.popGMin.Visible = 'Off';
handles.tGMin.Visible = 'Off';
handles.popGMax.Visible = 'Off';
handles.tGMax.Visible = 'Off';
handles.bgOption.Visible = 'On';
handles.bStand.Visible = 'On';
handles.bStand.Value = 1;
handles.bPara.Visible = 'On';
handles.bPara.String = 'Parametric';


% --- Executes on button press in bStand.
function bStand_Callback(hObject, eventdata, handles)
% hObject    handle to bStand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bStand


% --- Executes on button press in bPara.
function bPara_Callback(hObject, eventdata, handles)
% hObject    handle to bPara (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bPara


% --- Executes on selection change in popVar.
function popVar_Callback(hObject, eventdata, handles)
% hObject    handle to popVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popVar contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popVar


% --- Executes during object creation, after setting all properties.
function popVar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popThresh.
function popThresh_Callback(hObject, eventdata, handles)
% hObject    handle to popThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popThresh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popThresh


% --- Executes during object creation, after setting all properties.
function popThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popKern.
function popKern_Callback(hObject, eventdata, handles)
% hObject    handle to popKern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popKern contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popKern


% --- Executes during object creation, after setting all properties.
function popKern_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popKern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popGMin.
function popGMin_Callback(hObject, eventdata, handles)
% hObject    handle to popGMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popGMin contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popGMin


% --- Executes during object creation, after setting all properties.
function popGMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popGMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popGMax.
function popGMax_Callback(hObject, eventdata, handles)
% hObject    handle to popGMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popGMax contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popGMax


% --- Executes during object creation, after setting all properties.
function popGMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popGMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popFOrd.
function popFOrd_Callback(hObject, eventdata, handles)
% hObject    handle to popFOrd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popFOrd contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popFOrd


% --- Executes during object creation, after setting all properties.
function popFOrd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popFOrd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
