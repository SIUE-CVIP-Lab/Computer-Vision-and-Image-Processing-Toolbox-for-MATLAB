function varargout = DlgSharp(varargin)
% DLGSHARP MATLAB code for DlgSharp.fig
%      DLGSHARP, by itself, creates a new DLGSHARP or raises the existing
%      singleton*.
%
%      H = DLGSHARP returns the handle to a new DLGSHARP or the handle to
%      the existing singleton*.
%
%      DLGSHARP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DLGSHARP.M with the given input arguments.
%
%      DLGSHARP('Property','Value',...) creates a new DLGSHARP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgSharp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgSharp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DlgSharp

% Last Modified by GUIDE v2.5 29-Oct-2019 17:13:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgSharp_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgSharp_OutputFcn, ...
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
%           Initial coding date:    10/22/2019
%           Updated by:             Hridoy Biswas
%           Latest update date:     7/5/2020
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% --- Executes just before DlgSharp is made visible.
function DlgSharp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DlgSharp (see VARARGIN)

% Choose default command line output for DlgSharp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DlgSharp wait for user response (see UIRESUME)
% uiwait(handles.DlgSharp);
%call menu creation function
menu_add_cvip(hObject);

%handles for Spatial
handles.tMask.Visible = 'On';
handles.tMask.String = 'Kernel Size of Sobel:';
handles.pMask.Visible = 'On';
handles.pMask.String = [3 5 7];
handles.t2.Visible = 'On';
handles.t2.String = 'Low Clip Percentage:';
handles.p2.Visible = 'On';
handles.p2.String = {'0.00';'0.005';'0.01';'0.015';'0.02'};
handles.p2.Value = 2;
handles.t3.Visible = 'On';
handles.t3.String = 'High Clip Percentage:';
handles.p3.Visible = 'On';
handles.p3.String = {'0.00';'0.005';'0.01';'0.015';'0.02'};
handles.p3.Value = 2;
handles.t4.Visible = 'Off';
handles.p4.Visible = 'Off';
handles.tb.Visible = 'On';
handles.tb.String = 'Laplacian:';
handles.b1.Visible = 'On';
handles.b2.Visible = 'On';
handles.c1.Visible = 'On';
handles.c1.String = 'Intermediate Image Remapping';
handles.c1.Value = 1;
handles.c2.Visible = 'On';
handles.c2.String = 'Add to Original Image';
handles.c2.Value = 1;
%handles for Frequency
handles.bFFTSharp.Value = 0;


function mVsaveHis_Callback(hObject, eventdata, handles)
% hObject    handle to mVsaveHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('Hola Magola, This is working!!!  :)');
hObject.Checked = 'On';


% --- Outputs from this function are returned to the command line.
function varargout = DlgSharp_OutputFcn(hObject, eventdata, handles) 
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
%Sharpening Alg I
if handles.bSharpI.Value
    mask_size = str2double(handles.pMask.String(handles.pMask.Value));
    low = str2double(handles.p2.String(handles.p2.Value));
    high = str2double(handles.p3.String(handles.p3.Value));
    IIR = handles.c1.Value;
    ATOI = handles.c2.Value;
    if handles.b1.Value
        OutIma = sharp_i_cvip(InIma,1,mask_size,low,high,IIR,ATOI);
    elseif handles.b2.Value
        OutIma = sharp_i_cvip(InIma,2,mask_size,low,high,IIR,ATOI);
    end
    Name = strcat(file,' > SharpI');
%Sharpening Alg II
elseif handles.bSharpII.Value
    ATOI = handles.c2.Value;
    OutIma = sharp_ii_cvip(InIma,ATOI);
    Name = strcat(file,' > SharpII');
%High Pass Alg
elseif handles.bHighP.Value
    OutIma = convolve_filter_cvip(InIma,[0 -1 0;-1 4 -1;0 -1 0]);
    if handles.c2.Value
        OutIma = uint8(OutIma) + InIma;
    end
    Name = strcat(file,' > HighPass');
%High Boost Alg
elseif handles.bHighB.Value
    Mask_size = str2double(handles.pMask.String(handles.pMask.Value));
    center_value = str2double(handles.p2.String(handles.p2.Value));
    M = -1.*ones(Mask_size);
    M(ceil(Mask_size/2),ceil(Mask_size/2)) = center_value;
    OutIma = convolve_filter_cvip(InIma,M);
    if handles.c2.Value
        OutIma = OutIma + double(InIma);
    end
    Name = strcat(file,' > HighBoost');
%Unsharp Alg
elseif handles.bUnsharp.Value
    low_shrink = str2double(handles.pMask.String(handles.pMask.Value));
    high_shrink = str2double(handles.p2.String(handles.p2.Value));
    low_clip = str2double(handles.p3.String(handles.p3.Value));
    high_clip = str2double(handles.p4.String(handles.p4.Value));
    Low_pass_image = convolve_filter_cvip(InIma,ones(3));
    Shrunk_image = hist_shrink_cvip(Low_pass_image,low_shrink,high_shrink);
    OutIma = InIma - Shrunk_image;
    OutIma = hist_stretch_cvip(OutIma,0,255,low_clip,high_clip);
    Name = strcat(file,' > Unsharp');
%FFt Sharp
elseif handles.bFFTSharp.Value
    fc = str2double(handles.pMask.String(handles.pMask.Value));
    order = str2double(handles.p2.String(handles.p2.Value));
    spect = fft_cvip(InIma,[]);
    high_pass = butterworth_high_cvip(spect,[],'fft',0,order,fc);
    OutIma = ifft_cvip(high_pass,[]);
    if handles.c2.Value
        OutIma = OutIma + double(InIma);
    end
    OutIma = hist_stretch_cvip(OutIma,0,255,0.025,0.025);
    Name = strcat(file,' > FFTSharp');
%DCT Sharp
elseif handles.bDCTSharp.Value
    fc = str2double(handles.pMask.String(handles.pMask.Value));
    order = str2double(handles.p2.String(handles.p2.Value));
    spect = dct_cvip(InIma,[]);
    high_pass = butterworth_high_cvip(spect,[],'non-fft',0,order,fc);
    OutIma = idct_cvip(high_pass,[]);
    if handles.c2.Value
        OutIma = OutIma + double(InIma);
    end
    OutIma = hist_stretch_cvip(OutIma,0,255,0.025,0.025);
    Name = strcat(file,' > DCTSharp');
%High Frequency Emphasis
elseif handles.bHighF.Value
    filter_type = string(handles.pMask.String(handles.pMask.Value));
    fc = str2double(handles.p2.String(handles.p2.Value));
    order = str2double(handles.p3.String(handles.p3.Value));
    offset = str2double(handles.p4.String(handles.p4.Value));
    keep_DC = handles.c1.Value;
    OutIma = highfreqemphasis_cvip(InIma,filter_type,[],fc,offset,keep_DC,order);
    Name = strcat(file,' > HighFreqEmph');
%Homomorphic Sharpening
elseif handles.bHomo.Value
    fc = str2double(handles.pMask.String(handles.pMask.Value));
    low_gain = str2double(handles.p2.String(handles.p2.Value));   
    high_gain = str2double(handles.p3.String(handles.p3.Value));
    OutIma = homomorphic_cvip(InIma,high_gain,low_gain,fc);
    if handles.c2.Value
        OutIma = OutIma + double(InIma);
    end
    Name = strcat(file,' > HomoSharp');
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
 close(handles.Sharp)


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
function Sharp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DlgSharp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in bSharpI.
function bSharpI_Callback(hObject, eventdata, handles)
% hObject    handle to bSharpI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bSharpI
%handles for Spatial

handles.tMask.Visible = 'On';
handles.tMask.String = 'Kernel Size of Sobel';
handles.pMask.Visible = 'On';
handles.pMask.String = [3 5 7];
handles.t2.Visible = 'On';
handles.t2.String = 'Low Clip Percentage';
handles.p2.Visible = 'On';
handles.p2.String = {'0.00';'0.005';'0.01';'0.015';'0.02'};
handles.t3.Visible = 'On';
handles.t3.String = 'High Clip Percentage';
handles.p3.Visible = 'On';
handles.p3.String = {'0.00';'0.005';'0.01';'0.015';'0.02'};
handles.t4.Visible = 'Off';
handles.p4.Visible = 'Off';
handles.tb.Visible = 'On';
handles.tb.String = 'Laplacian:';
handles.b1.Visible = 'On';
handles.b2.Visible = 'On';
handles.c1.Visible = 'On';
handles.c1.String = 'Intermediate Image Remapping';
handles.c2.Visible = 'On';
handles.c2.String = 'Add to Original Image';
%handles for Frequency
handles.bFFTSharp.Value = 0;
handles.bDCTSharp.Value = 0;
handles.bHighF.Value = 0;
handles.bHomo.Value = 0;


% --- Executes on button press in bSharpII.
function bSharpII_Callback(hObject, eventdata, handles)
% hObject    handle to bSharpII (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bSharpII
handles.tMask.Visible = 'Off';
handles.pMask.Visible = 'Off';
handles.t2.Visible = 'Off';
handles.p2.Visible = 'Off';
handles.t3.Visible = 'Off';
handles.p3.Visible = 'Off';
handles.t4.Visible = 'Off';
handles.p4.Visible = 'Off';
handles.tb.Visible = 'Off';
handles.b1.Visible = 'Off';
handles.b2.Visible = 'Off';
handles.c1.Visible = 'Off';
handles.c2.Visible = 'On';
handles.c2.String = 'Add to Original Image';
%handles for Frequency
handles.bFFTSharp.Value = 0;
handles.bDCTSharp.Value = 0;
handles.bHighF.Value = 0;
handles.bHomo.Value = 0;


% --- Executes on button press in bHighP.
function bHighP_Callback(hObject, eventdata, handles)
% hObject    handle to bHighP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bHighP
handles.tMask.Visible = 'Off';
handles.pMask.Visible = 'Off';
handles.t2.Visible = 'Off';
handles.p2.Visible = 'Off';
handles.t3.Visible = 'Off';
handles.p3.Visible = 'Off';
handles.t4.Visible = 'Off';
handles.p4.Visible = 'Off';
handles.tb.Visible = 'Off';
handles.b1.Visible = 'Off';
handles.b2.Visible = 'Off';
handles.c1.Visible = 'Off';
handles.c2.Visible = 'On';
handles.c2.String = 'Add to Original Image';
%handles for Frequency
handles.bFFTSharp.Value = 0;
handles.bDCTSharp.Value = 0;
handles.bHighF.Value = 0;
handles.bHomo.Value = 0;


% --- Executes on button press in bHighB.
function bHighB_Callback(hObject, eventdata, handles)
% hObject    handle to bHighB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bHighB
handles.tMask.Visible = 'On';
handles.tMask.String = 'Mask Size:';
handles.pMask.Visible = 'On';
handles.pMask.String = {'3';'5';'7';'9';'11';'13'};
handles.t2.Visible = 'On';
handles.t2.String = 'Center Value:';
handles.p2.Visible = 'On';
handles.p2.String = {'5';'7';'8';'9';'25';'49';'81';'121';'169'};
handles.p2.Value = 4;
handles.t3.Visible = 'Off';
handles.p3.Visible = 'Off';
handles.t4.Visible = 'Off';
handles.p4.Visible = 'Off';
handles.tb.Visible = 'Off';
handles.b1.Visible = 'Off';
handles.b2.Visible = 'Off';
handles.c1.Visible = 'Off';
handles.c2.Visible = 'On';
handles.c2.String = 'Add to Original Image';
%handles for Frequency
handles.bFFTSharp.Value = 0;
handles.bDCTSharp.Value = 0;
handles.bHighF.Value = 0;
handles.bHomo.Value = 0;


% --- Executes on button press in bUnsharp.
function bUnsharp_Callback(hObject, eventdata, handles)
% hObject    handle to bUnsharp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bUnsharp
handles.tMask.Visible = 'On';
handles.tMask.String = 'Low Limit:';
handles.pMask.Visible = 'On';
handles.pMask.String = {'0';'10';'30';'50';'70';'80';'100'};
handles.pMask.Value = 1;
handles.t2.Visible = 'On';
handles.t2.String = 'Upper Limit:';
handles.p2.Visible = 'On';
handles.p2.String = {'100';'120';'150';'170';'200';'220';'255'};
handles.p2.Value = 1;
handles.t3.Visible = 'On';
handles.t3.String = 'Low Clip Percentage:';
handles.p3.Visible = 'On';
handles.p3.String = {'0.01';'0.02';'0.03';'0.04';'0.05';'0.075';'0.1';'0.15'};
handles.p3.Value = 1;
handles.t4.Visible = 'On';
handles.t4.String = 'High Clip Percentage:';
handles.p4.Visible = 'On';
handles.p4.String = {'0.01';'0.02';'0.03';'0.04';'0.05';'0.075';'0.1';'0.15'};
handles.p4.Value = 1;
handles.tb.Visible = 'Off';
handles.b1.Visible = 'Off';
handles.b2.Visible = 'Off';
handles.c1.Visible = 'Off';
handles.c2.Visible = 'Off';
%handles for Frequency
handles.bFFTSharp.Value = 0;
handles.bDCTSharp.Value = 0;
handles.bHighF.Value = 0;
handles.bHomo.Value = 0;


% --- Executes on button press in bFFTSharp.
function bFFTSharp_Callback(hObject, eventdata, handles)
% hObject    handle to bFFTSharp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bFFTSharp
%handles for Spatial
handles.bSharpI.Value = 0;
handles.bSharpII.Value = 0;
handles.bHighP.Value = 0;
handles.bHighB.Value = 0;
handles.bUnsharp.Value = 0;
%handles for Frequency
handles.tMask.Visible = 'On';
handles.tMask.String = 'Cutoff Frequency:';
handles.pMask.Visible = 'On';
handles.pMask.String = {'16';'24';'32';'40';'48';'56';'64'};
handles.pMask.Value = 7;
handles.t2.Visible = 'On';
handles.t2.String = 'Butterworth Order:';
handles.p2.Visible = 'On';
handles.p2.String = {'1';'2';'3';'4';'5';'6';'7';'8'};
handles.p2.Value = 3;
handles.t3.Visible = 'Off';
handles.p3.Visible = 'Off';
handles.t4.Visible = 'Off';
handles.p4.Visible = 'Off';
handles.tb.Visible = 'Off';
handles.b1.Visible = 'Off';
handles.b2.Visible = 'Off';
handles.c1.Visible = 'Off';
handles.c2.Visible = 'On';
handles.c2.String = 'Add to Original Image';


% --- Executes on button press in bDCTSharp.
function bDCTSharp_Callback(hObject, eventdata, handles)
% hObject    handle to bDCTSharp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bDCTSharp
%handles for Spatial
handles.bSharpI.Value = 0;
handles.bSharpII.Value = 0;
handles.bHighP.Value = 0;
handles.bHighB.Value = 0;
handles.bUnsharp.Value = 0;
%handles for Frequency
handles.tMask.Visible = 'On';
handles.tMask.String = 'Cutoff Frequency:';
handles.pMask.Visible = 'On';
handles.pMask.String = {'16';'24';'32';'40';'48';'56';'64'};
handles.pMask.Value = 7;
handles.t2.Visible = 'On';
handles.t2.String = 'Butterworth Order:';
handles.p2.Visible = 'On';
handles.p2.String = {'1';'2';'3';'4';'5';'6';'7';'8'};
handles.p2.Value = 3;
handles.t3.Visible = 'Off';
handles.p3.Visible = 'Off';
handles.t4.Visible = 'Off';
handles.p4.Visible = 'Off';
handles.tb.Visible = 'Off';
handles.b1.Visible = 'Off';
handles.b2.Visible = 'Off';
handles.c1.Visible = 'Off';
handles.c2.Visible = 'On';
handles.c2.String = 'Add to Original Image';


% --- Executes on button press in bHighF.
function bHighF_Callback(hObject, eventdata, handles)
% hObject    handle to bHighF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bHighF
%handles for Spatial
handles.bSharpI.Value = 0;
handles.bSharpII.Value = 0;
handles.bHighP.Value = 0;
handles.bHighB.Value = 0;
handles.bUnsharp.Value = 0;
%handles for Frequency
handles.tMask.Visible = 'On';
handles.tMask.String = 'Transform:';
handles.pMask.Visible = 'On';
handles.pMask.String = {'FFT';'DCT';'Walsh-Hadamard';'Haar'};
handles.pMask.Value = 1;
handles.t2.Visible = 'On';
handles.t2.String = 'Cutoff Frequency:';
handles.p2.Visible = 'On';
handles.p2.String = {'16';'24';'32';'40';'48';'56';'64'};
handles.p2.Value = 3;
handles.t3.Visible = 'On';
handles.t3.String = 'Filter Order:';
handles.p3.Visible = 'On';
handles.p3.String = {'1';'2';'3';'4';'5';'6';'7';'8'};
handles.p3.Value = 3;
handles.t4.Visible = 'On';
handles.t4.String = 'Emphasis Offset:';
handles.p4.Visible = 'On';
handles.p4.String = {'0.5';'1.2';'1.3';'1.5';'1.7';'1.9';'2.0';'2.5'};
handles.p4.Value = 1;
handles.tb.Visible = 'Off';
handles.b1.Visible = 'Off';
handles.b2.Visible = 'Off';
handles.c1.Visible = 'On';
handles.c1.Value = 0;
handles.c1.String = 'Keep DC';
handles.c2.Visible = 'Off';


% --- Executes on button press in bHomo.
function bHomo_Callback(hObject, eventdata, handles)
% hObject    handle to bHomo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bHomo
%handles for Spatial
handles.bSharpI.Value = 0;
handles.bSharpII.Value = 0;
handles.bHighP.Value = 0;
handles.bHighB.Value = 0;
handles.bUnsharp.Value = 0;
%handles for Frequency
handles.tMask.Visible = 'On';
handles.tMask.String = 'Cutoff Frequency:';
handles.pMask.Visible = 'On';
handles.pMask.String = {'0';'16';'32';'40';'48';'56';'64';'80';'128'};
handles.pMask.Value = 7;
handles.t2.Visible = 'On';
handles.t2.String = 'Lower Frequency Gain:';
handles.p2.Visible = 'On';
handles.p2.String = {'0.2';'0.4';'0.6';'0.7';'0.8';'0.85';'0.9';'0.95'};
handles.p2.Value = 7;
handles.t3.Visible = 'On';
handles.t3.String = 'Higher Frequency Gain:';
handles.p3.Visible = 'On';
handles.p3.String = {'1.1';'1.2';'1.3';'1.4';'1.5';'1.8';'2.0';'2.5'};
handles.p3.Value = 3;
handles.t4.Visible = 'Off';
handles.p4.Visible = 'Off';
handles.tb.Visible = 'Off';
handles.b1.Visible = 'Off';
handles.b2.Visible = 'Off';
handles.c1.Visible = 'Off';
handles.c2.Visible = 'On';
handles.c2.Value = 1;
handles.c2.String = 'Add to Original Image';


% --- Executes on selection change in pMask.
function pMask_Callback(hObject, eventdata, handles)
% hObject    handle to pMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pMask contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pMask


% --- Executes during object creation, after setting all properties.
function pMask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMask (see GCBO)
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


% --- Executes on selection change in p4.
function p4_Callback(hObject, eventdata, handles)
% hObject    handle to p4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns p4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from p4


% --- Executes during object creation, after setting all properties.
function p4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in c1.
function c1_Callback(hObject, eventdata, handles)
% hObject    handle to c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c1


% --- Executes on button press in c2.
function c2_Callback(hObject, eventdata, handles)
% hObject    handle to c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c2


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
