function varargout = mUStats(varargin)
% MUSTATS MATLAB code for mUStats.fig
%      MUSTATS, by itself, creates a new MUSTATS or raises the existing
%      singleton*.
%
%      H = MUSTATS returns the handle to a new MUSTATS or the handle to
%      the existing singleton*.
%
%      MUSTATS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MUSTATS.M with the given input arguments.
%
%      MUSTATS('Property','Value',...) creates a new MUSTATS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mUStats_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs areapply passed to mUStats_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mUStats

% Last Modified by GUIDE v2.5 19-Dec-2018 16:03:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mUStats_OpeningFcn, ...
                   'gui_OutputFcn',  @mUStats_OutputFcn, ...
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
%           Initial coding date:    08/21/2018
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     12/19/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
 % Revision 1.3  12/19/2018  17:45:50  jucuell
 % updating menu creation programmatically, callbacks to Main figure and
 % the use of the utilities menus in the Main figure. Include new image
 % checkup. W OK
%
 % Revision 1.2  04/03/2018  16:09:55  jucuell
 %  
 % 
%
 % Revision 1.1  11/21/2017  15:23:31  jucuell
 % Initial revision:
 % 
%


% --- Executes just before mUStats is made visible.
function mUStats_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mUStats (see VARARGIN)

% Choose default command line output for mUStats
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mUStats wait for user response (see UIRESUME)
% uiwait(handles.Stats);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';%hide Analysis menu
hUtil = findobj('Tag','mUshos');
% hUtil(1).MenuSelectedFcn=@(hObject,eventdata)CVIPToolbox('mUshow_Callback',...
%     hObject,'Stats',guidata(hObject));
hUtil(1).Callback=@(hObject,eventdata)CVIPToolbox('mUshow_Callback',...
    hObject,'Stats',guidata(hObject));

% --- Outputs from this function are returned to the command line.
function varargout = mUStats_OutputFcn(hObject, eventdata, handles) 
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
 close(handles.Stats)


% --- Executes on button press in bReset.
function bReset_Callback(hObject, eventdata, handles)
% hObject    handle to bReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bRang_Callback(handles.bRang, eventdata, handles);
handles.bRang.Value = 1;

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
hNfig = hMain.UserData;         %get image handle
if hNfig ~= 0 && isfield(hNfig.UserData,'cvipIma')  %check for Image to save
    %file=get(hNfig,'Name');         %get image name
    InIma = hNfig.UserData.cvipIma;    %read image info
    [row, col, band] = size(InIma); %get image size

if handles.bRang.Value          %perform Image Data Range 
    if band == 1
        maxR = max(max(real(InIma)));
        minR = min(min(real(InIma)));
        maxI = max(max(imag(InIma)));
        minI = min(min(imag(InIma)));
        if handles.cHold.Value == 0
            for i = 6:30     %for loop to clear all values
                eval(strcat('handles.lblB0V',num2str(i),'.String='''';'));
            end
            handles.lblB0V1.ForegroundColor = [0 0 0];
            handles.lblB0V2.ForegroundColor = [0 0 0];
            handles.lblB0V3.ForegroundColor = [0 0 0];
            handles.lblB0V4.ForegroundColor = [0 0 0];
            handles.lblB0V1.String = minR;
            handles.lblB0V2.String = maxR;
            handles.lblB0V3.String = minI;
            handles.lblB0V4.String = maxI;
        else
            for i = 16:20     %for loop to clear all values
                eval(strcat('handles.lblB0V',num2str(i),'.String='''';'));
            end
            for i = 26:30     %for loop to clear all values
                eval(strcat('handles.lblB0V',num2str(i),'.String='''';'));
            end
            handles.lblB0V6.ForegroundColor = [0 0 0];
            handles.lblB0V7.ForegroundColor = [0 0 0];
            handles.lblB0V8.ForegroundColor = [0 0 0];
            handles.lblB0V9.ForegroundColor = [0 0 0];
            handles.lblB0V6.String = minR;
            handles.lblB0V7.String = maxR;
            handles.lblB0V8.String = minI;
            handles.lblB0V9.String = maxI;
        end
    else
        maxRR = max(max(real(InIma(:,:,1))));
        minRR = min(min(real(InIma(:,:,1))));
        maxIR = max(max(imag(InIma(:,:,1))));
        minIR = min(min(imag(InIma(:,:,1))));
        maxRG = max(max(real(InIma(:,:,2))));
        minRG = min(min(real(InIma(:,:,2))));
        maxIG = max(max(imag(InIma(:,:,2))));
        minIG = min(min(imag(InIma(:,:,2))));
        maxRB = max(max(real(InIma(:,:,3))));
        minRB = min(min(real(InIma(:,:,3))));
        maxIB = max(max(imag(InIma(:,:,3))));
        minIB = min(min(imag(InIma(:,:,3))));
        if handles.cHold.Value == 0
            handles.lblB0V1.ForegroundColor = [1 0 0];
            handles.lblB0V2.ForegroundColor = [1 0 0];
            handles.lblB0V3.ForegroundColor = [1 0 0];
            handles.lblB0V4.ForegroundColor = [1 0 0];
            handles.lblB0V1.String = minRR;
            handles.lblB0V2.String = maxRR;
            handles.lblB0V3.String = minIR;
            handles.lblB0V4.String = maxIR;
            handles.lblB0V6.String = '';
            handles.lblB0V7.String = '';
            handles.lblB0V8.String = '';
            handles.lblB0V9.String = '';
            handles.lblB0V11.String = minRG;
            handles.lblB0V12.String = maxRG;
            handles.lblB0V13.String = minIG;
            handles.lblB0V14.String = maxIG;
            handles.lblB0V16.String = '';
            handles.lblB0V17.String = '';
            handles.lblB0V18.String = '';
            handles.lblB0V19.String = '';
            handles.lblB0V21.String = minRB;
            handles.lblB0V22.String = maxRB;
            handles.lblB0V23.String = minIB;
            handles.lblB0V24.String = maxIB;
            handles.lblB0V26.String = '';
            handles.lblB0V27.String = '';
            handles.lblB0V28.String = '';
            handles.lblB0V29.String = '';
        else
            handles.lblB0V6.ForegroundColor = [1 0 0];
            handles.lblB0V7.ForegroundColor = [1 0 0];
            handles.lblB0V8.ForegroundColor = [1 0 0];
            handles.lblB0V9.ForegroundColor = [1 0 0];
            handles.lblB0V6.String = minRR;
            handles.lblB0V7.String = maxRR;
            handles.lblB0V8.String = minIR;
            handles.lblB0V9.String = maxIR;
            handles.lblB0V16.String = minRG;
            handles.lblB0V17.String = maxRG;
            handles.lblB0V18.String = minIG;
            handles.lblB0V19.String = maxIG;
            handles.lblB0V26.String = minRB;
            handles.lblB0V27.String = maxRB;
            handles.lblB0V28.String = minIB;
            handles.lblB0V29.String = maxIB;
        end
    end
    
elseif handles.bStats.Value      %perform Image Stats
    segmen = ones(row, col);
    histfeats = hist_feature_cvip(int8(real(InIma)), segmen, 1, []);
    if band == 1
        if handles.cHold.Value == 0
            for i = 6:30     %for loop to clear all values
                eval(strcat('handles.lblB0V',num2str(i),'.String='''';'));
            end
            handles.lblB0V1.ForegroundColor = [0 0 0];
            handles.lblB0V2.ForegroundColor = [0 0 0];
            handles.lblB0V3.ForegroundColor = [0 0 0];
            handles.lblB0V4.ForegroundColor = [0 0 0];
            handles.lblB0V5.ForegroundColor = [0 0 0];
            handles.lblB0V1.String = histfeats{2,2};
            handles.lblB0V2.String = histfeats{2,3};
            handles.lblB0V3.String = histfeats{2,4};
            handles.lblB0V4.String = histfeats{2,5};
            handles.lblB0V5.String = histfeats{2,6};
        else
            for i = 16:20     %for loop to clear all values
                eval(strcat('handles.lblB0V',num2str(i),'.String='''';'));
            end
            for i = 26:30     %for loop to clear all values
                eval(strcat('handles.lblB0V',num2str(i),'.String='''';'));
            end
            handles.lblB0V6.ForegroundColor = [0 0 0];
            handles.lblB0V7.ForegroundColor = [0 0 0];
            handles.lblB0V8.ForegroundColor = [0 0 0];
            handles.lblB0V9.ForegroundColor = [0 0 0];
            handles.lblB0V10.ForegroundColor = [0 0 0];
            handles.lblB0V6.String = histfeats{2,2};
            handles.lblB0V7.String = histfeats{2,3};
            handles.lblB0V8.String = histfeats{2,4};
            handles.lblB0V9.String = histfeats{2,5};
            handles.lblB0V10.String = histfeats{2,6};
        end
    else
        if handles.cHold.Value == 0
            handles.lblB0V1.ForegroundColor = [1 0 0];
            handles.lblB0V2.ForegroundColor = [1 0 0];
            handles.lblB0V3.ForegroundColor = [1 0 0];
            handles.lblB0V4.ForegroundColor = [1 0 0];
            handles.lblB0V5.ForegroundColor = [1 0 0];
            handles.lblB0V1.String = histfeats{2,2};
            handles.lblB0V2.String = histfeats{2,5};
            handles.lblB0V3.String = histfeats{2,8};
            handles.lblB0V4.String = histfeats{2,11};
            handles.lblB0V5.String = histfeats{2,14};
            handles.lblB0V6.String = '';
            handles.lblB0V7.String = '';
            handles.lblB0V8.String = '';
            handles.lblB0V9.String = '';
            handles.lblB0V10.String = '';
            handles.lblB0V11.String = histfeats{2,3};
            handles.lblB0V12.String = histfeats{2,6};
            handles.lblB0V13.String = histfeats{2,9};
            handles.lblB0V14.String = histfeats{2,12};
            handles.lblB0V15.String = histfeats{2,15};
            handles.lblB0V16.String = '';
            handles.lblB0V17.String = '';
            handles.lblB0V18.String = '';
            handles.lblB0V19.String = '';
            handles.lblB0V20.String = '';
            handles.lblB0V21.String = histfeats{2,4};
            handles.lblB0V22.String = histfeats{2,7};
            handles.lblB0V23.String = histfeats{2,10};
            handles.lblB0V24.String = histfeats{2,13};
            handles.lblB0V25.String = histfeats{2,16};
            handles.lblB0V26.String = '';
            handles.lblB0V27.String = '';
            handles.lblB0V28.String = '';
            handles.lblB0V29.String = '';
            handles.lblB0V30.String = '';
        else
            handles.lblB0V6.ForegroundColor = [1 0 0];
            handles.lblB0V7.ForegroundColor = [1 0 0];
            handles.lblB0V8.ForegroundColor = [1 0 0];
            handles.lblB0V9.ForegroundColor = [1 0 0];
            handles.lblB0V6.String = histfeats{2,2};
            handles.lblB0V7.String = histfeats{2,5};
            handles.lblB0V8.String = histfeats{2,8};
            handles.lblB0V9.String = histfeats{2,11};
            handles.lblB0V10.String = histfeats{2,14};
            handles.lblB0V16.String = histfeats{2,3};
            handles.lblB0V17.String = histfeats{2,6};
            handles.lblB0V18.String = histfeats{2,9};
            handles.lblB0V19.String = histfeats{2,12};
            handles.lblB0V20.String = histfeats{2,15};
            handles.lblB0V26.String = histfeats{2,4};
            handles.lblB0V27.String = histfeats{2,7};
            handles.lblB0V28.String = histfeats{2,10};
            handles.lblB0V29.String = histfeats{2,13};
            handles.lblB0V30.String = histfeats{2,16};
        end
    end
    
end

else
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Save Error','modal');
end

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


% --- Executes on button press in cHold.
function cHold_Callback(hObject, eventdata, handles)
% hObject    handle to cHold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cHold
%capture the name of the image to be hold
if hObject.Value
    hMain = findobj('Tag','Main');  %get the handle of Main form
    hNfig = hMain.UserData;         %get image handle
    file=get(hNfig,'Name');         %get image name
	hObject.String = [hObject.String ' (' file ')'];
else
    hObject.String = 'Hold Current Image Data';
end

% --- Executes on button press in bRang.
function bRang_Callback(hObject, eventdata, handles)
% hObject    handle to bRang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Rang_Pos = [35.4 56.0 76.6 98.2]; %vector with labels positions
handles.lblRange.Visible = 'On';
handles.lblStats.Visible = 'Off';
handles.cHold.Value = 0;
handles.cHold.String = 'Hold Current Image Data';

for i = 1:4     %for loops to positioning display labels
    eval(strcat('handles.lblB0V',num2str(i),'.Position(1)=Rang_Pos(', ...
        num2str(i),');')); 
end
for i = 6:9
    eval(strcat('handles.lblB0V',num2str(i),'.Position(1)=Rang_Pos(', ...
        num2str(i-5),');')); 
end
for i = 11:14
    eval(strcat('handles.lblB0V',num2str(i),'.Position(1)=Rang_Pos(', ...
        num2str(i-10),');')); 
end
for i = 16:19
    eval(strcat('handles.lblB0V',num2str(i),'.Position(1)=Rang_Pos(', ...
        num2str(i-15),');')); 
end
for i = 21:24
    eval(strcat('handles.lblB0V',num2str(i),'.Position(1)=Rang_Pos(', ...
        num2str(i-20),');')); 
end
for i = 26:29
    eval(strcat('handles.lblB0V',num2str(i),'.Position(1)=Rang_Pos(', ...
        num2str(i-25),');')); 
end

for i = 1:30     %for loop to clear all values
    eval(strcat('handles.lblB0V',num2str(i),'.String='''';'));    %,num2str(i),')')); 
    eval(strcat('handles.lblB0V',num2str(i),'.Position(3)=19;')); 
end
% Hint: get(hObject,'Value') returns toggle state of bRang
%lblB0V1 = 35.4  56.0    76.6    98.2 width 19
%lblB0V1 = 34.8  51.2    67.6    84.0   100.4    width 17
%to improve this:
%https://www.mathworks.com/matlabcentral/answers/17841-using-eval-function-with-string-inside-it


% --- Executes when Stats is resized.
function Stats_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to Stats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(hObject.UserData, 'Range')
    bRang_Callback(handles.bRang, eventdata, handles);
    handles.bRang.Value = 1;
    handles.cHold.Value = 0;
    handles.cHold.String = 'Hold Current Image Data';
elseif strcmp(hObject.UserData, 'Stats')
    bStats_Callback(handles.bStats, eventdata, handles);
    handles.bStats.Value = 1;
end
hObject.UserData = 'NO';


% --- Executes on button press in bStats.
function bStats_Callback(hObject, eventdata, handles)
% hObject    handle to bStats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bStats
Rang_Pos = [34.8 51.2 67.6 84.0 100.4]; %vector with labels positions
handles.lblRange.Visible = 'Off';
handles.lblStats.Visible = 'On';
handles.cHold.Value = 0;
handles.cHold.String = 'Hold Current Image Data';

j=0;
for i = 1:30     %for loops to positioning display labels
    eval(strcat('handles.lblB0V',num2str(i),'.Position(1)=Rang_Pos(', ...
        num2str(i-j*5),');')); 
    if rem(i,5) == 0
        j=j+1;
    end
end

for i = 1:30     %for loop to clear all values
    eval(strcat('handles.lblB0V',num2str(i),'.String='''';'));    %,num2str(i),')')); 
    eval(strcat('handles.lblB0V',num2str(i),'.Position(3)=17;')); 
end
