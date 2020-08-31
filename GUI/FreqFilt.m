%%Put this code in CVIPToolbox.m under mRFreqF_Callback function
% clc;                             %clear screen
% hFreq=findobj('Tag','FreqFilt'); %check if was previously opened
% if isempty(hFreq)
%     hFreq=FreqFilt;           %call Analysis-Geometry Form
%     set(gcf,'Name','Frequency Filters','NumberTitle','off')
%     updatemenus();          %cheked for View information and save history
%     group = setfigdocked('GroupName','CVIPTools MatLab V.1.5','Figure',hFreq);
% end
% figure(hFreq);

%Also need FreqFiltMask.m for the mask editor

function varargout = FreqFilt(varargin)
% FREQFILT MATLAB code for FreqFilt.fig
%      FREQFILT, by itself, creates a new FREQFILT or raises the existing
%      singleton*.
%
%      H = FREQFILT returns the handle to a new FREQFILT or the handle to
%      the existing singleton*.
%
%      FREQFILT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FREQFILT.M with the given input arguments.
%
%      FREQFILT('Property','Value',...) creates a new FREQFILT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FreqFilt_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FreqFilt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FreqFilt

% Last Modified by GUIDE v2.5 13-Jul-2020 15:07:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FreqFilt_OpeningFcn, ...
                   'gui_OutputFcn',  @FreqFilt_OutputFcn, ...
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
%           Author:                 
%           Initial coding date:    
%           Updated by:             Hridoy Biswas
%           Latest update date:     6/28/2020
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% --- Executes just before FreqFilt is made visible.
function FreqFilt_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FreqFilt (see VARARGIN)

% Choose default command line output for FreqFilt
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FreqFilt wait for user response (see UIRESUME)
% uiwait(handles.FreqFilt);
%hObject=figure('menubar','none');

cpath = mfilename( 'fullpath' );
cpath = cpath(1:end-8);
a = imread([cpath 'Resources\GenRestEq.png']);
b = imread([cpath 'Resources\PractWienerK.png']);

axes(handles.axes1);
imshow(a,'InitialMagnification','fit'); %%Rev
handles.axes1.Visible = 'Off';
handles.axes1.UserData = 'SI';

axes(handles.axes2);
imshow(b,'InitialMagnification','fit'); %Rev
handles.axes2.Visible = 'Off';
handles.axes2.UserData = 'SI';

%Alpha/Gamma text on left
handles.text40.Visible = 'on';
handles.text40.String = 'Alpha=0, Gamma=0';

%Top degredation function box
handles.radiobutton22.Visible = 'on';
handles.radiobutton23.Visible = 'on';
handles.text50.Visible = 'off';
handles.pushbutton16.Visible = 'off';
handles.uipanel6.Visible = 'on';

%Below degredation function box
handles.text34.Visible = 'off'; %Noise Image
handles.text48.Visible = 'off';
handles.pushbutton14.Visible = 'off';
handles.text37.Visible = 'off'; %Original Image
handles.text49.Visible = 'off';
handles.pushbutton15.Visible = 'off';
handles.text35.Visible = 'off'; %Gamma
handles.popupmenu49.Visible = 'off';
handles.text38.Visible = 'off'; %Smoothness
handles.popupmenu52.Visible = 'off';
handles.text36.Visible = 'off'; %Alpha
handles.popupmenu50.Visible = 'off';
handles.text39.Visible = 'off'; %K
handles.popupmenu53.Visible = 'off';

%Cutoff Freq etc.
handles.text30.Visible = 'on';
handles.popupmenu42.Visible = 'on';
handles.text31.Visible = 'on';
handles.popupmenu43.Visible = 'on';
handles.text33.Visible = 'on';

%Notch Filter Stuff
handles.text41.Visible = 'off';
handles.pushbutton9.Visible = 'off';
handles.pushbutton10.Visible = 'off';
handles.text42.Visible = 'off';
handles.popupmenu54.Visible = 'off';
handles.text43.Visible = 'off';
handles.popupmenu55.Visible = 'off';
handles.text44.Visible = 'off';
handles.edit11.Visible = 'off';
handles.text45.Visible = 'off';
handles.text46.Visible = 'off';
handles.edit12.Visible = 'off';
handles.popupmenu58.Visible = 'off';

set(handles.radiobutton21, 'Value', 0);

%K Image on left
axesHandlesToChildObjects = findobj(handles.axes2, 'Type', 'image');
if ~isempty(axesHandlesToChildObjects)
    delete(axesHandlesToChildObjects);
end

r = str2num(cell2mat(handles.popupmenu40.String(handles.popupmenu40.Value)));
c = str2num(cell2mat(handles.popupmenu40.String(handles.popupmenu37.Value)));
d = ones(r,c);
setappdata(0,'objhandle',hObject);
setappdata(0,'maskRows',r);
setappdata(0,'maskCols',c);
setappdata(0,'maskData',d);
setappdata(0,'notchCount',0);
setappdata(0,'notchString','(new)');
setappdata(0,'notchX',0);
setappdata(0,'notchY',0);
setappdata(0,'notchSize',0);
setappdata(0, 'zone', 0);

menu_add_cvip(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = FreqFilt_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function mVsaveHis_Callback(hObject, eventdata, handles)
% hObject    handle to mVsaveHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('Hola Magola, This is working!!!  :)');
hObject.Checked = 'On';

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
clc

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
handles.text47.String = file;
data = struct('Name',file,'Image',InIma);
end

%Image Operations

histo = 0; OutIma = 0;

but13Data = findobj('Tag', 'pushbutton13');

if(but13Data == 0 || isempty(but13Data) || ~isfield(but13Data.UserData,'Name'))
    errordlg('Please Select Degraded Image');
    
else
    degradedImgData = but13Data.UserData; %Fields of Name and Image
    
    Mask = double(getappdata(0,'maskData')); %Mask
    cutFreq = str2double(cell2mat(handles.popupmenu42.String(handles.popupmenu42.Value)));
    limGain = str2double(cell2mat(handles.popupmenu43.String(handles.popupmenu43.Value)));
    gamma = str2double(cell2mat(handles.popupmenu49.String(handles.popupmenu49.Value)));
    alpha = str2double(cell2mat(handles.popupmenu50.String(handles.popupmenu50.Value)));
    smoothConstFunc = handles.popupmenu52.Value;
    K = str2double(cell2mat(handles.popupmenu53.String(handles.popupmenu53.Value)));
    handles.radiobutton14;
    handles.radiobutton15;
    if(handles.radiobutton14.Value == 1.0)
        %Inverse
        OutIma = inverse_xformfilter_cvip(degradedImgData.Image,Mask,cutFreq,limGain);
        Name = [but13Data.UserData.Name '_inverse'];
        
    elseif(handles.radiobutton15.Value == 1.0)
        %Geometric Mean
        but14Data = findobj('Tag','pushbutton14');
        but15Data = findobj('Tag','pushbutton15');
        if(but14Data == 0 || isempty(but14Data) || ~isfield(but14Data.UserData,'Name'))
            errordlg('Please Select Noise Image');
        elseif(but15Data == 0 || isempty(but15Data) || ~isfield(but15Data.UserData,'Name'))
            errordlg('Please Select Original Image');
        else
            origImgData = but15Data.UserData; %Fields of Name and Image
            noiseImgData = but14Data.UserData; %Fields of Name and Image
            OutIma = geometric_mean_xformfilter_cvip(degradedImgData.Image,Mask,cutFreq,limGain,noiseImgData.Image,origImgData.Image,alpha,gamma);
        end
        Name = [but13Data.UserData.Name '_geometricmean'];
        
    elseif(handles.radiobutton16.Value == 1.0)
        %Power Spectrum Equalization
        but14Data = findobj('Tag','pushbutton14');
        but15Data = findobj('Tag','pushbutton15');
        if(but14Data == 0 || isempty(but14Data) || ~isfield(but14Data.UserData,'Name'))
            errordlg('Please Select Noise Image');
        elseif(but15Data == 0 || isempty(but15Data) || ~isfield(but15Data.UserData,'Name'))
            errordlg('Please Select Original Image');
        else
            origImgData = but15Data.UserData; %Fields of Name and Image
            noiseImgData = but14Data.UserData; %Fields of Name and Image
            OutIma = power_spect_eq_filter_cvip(degradedImgData.Image,Mask,cutFreq,limGain,noiseImgData.Image,origImgData.Image);
        end
        Name = [but13Data.UserData.Name '_powerspectrumequalization'];
        
    elseif(handles.radiobutton17.Value == 1.0)
        %Constrained Least Squares
        OutIma = least_squares_filter_cvip(degradedImgData.Image,Mask,cutFreq,limGain,smoothConstFunc,gamma);
        Name = [but13Data.UserData.Name '_constrainedleastsquares'];
        
    elseif(handles.radiobutton18.Value == 1.0)
        %Wiener
        but14Data = findobj('Tag','pushbutton14');
        but15Data = findobj('Tag','pushbutton15');
        if(but14Data == 0 || isempty(but14Data) || ~isfield(but14Data.UserData,'Name'))
            errordlg('Please Select Noise Image');
        elseif(but15Data == 0 || isempty(but15Data) || ~isfield(but15Data.UserData,'Name'))
            errordlg('Please Select Original Image');
        else
            origImgData = but15Data.UserData; %Fields of Name and Image
            noiseImgData = but14Data.UserData; %Fields of Name and Image
            OutIma = wiener_filter_cvip(degradedImgData.Image,Mask,cutFreq,limGain,noiseImgData.Image,origImgData.Image);
        end
        Name = [but13Data.UserData.Name '_wiener'];
        
    elseif(handles.radiobutton19.Value == 1.0)
        %Pratical Wiener
         but14Data = findobj('Tag','pushbutton14');
        but15Data = findobj('Tag','pushbutton15');
        if(but14Data == 0 || isempty(but14Data) || ~isfield(but14Data.UserData,'Name'))
            errordlg('Please Select Noise Image');
        elseif(but15Data == 0 || isempty(but15Data) || ~isfield(but15Data.UserData,'Name'))
            errordlg('Please Select Original Image');
        else
            origImgData = but15Data.UserData; %Fields of Name and Image
            noiseImgData = but14Data.UserData; %Fields of Name and Image
             OutIma = simple_wiener_filter_cvip(degradedImgData.Image,Mask,cutFreq,limGain,noiseImgData.Image,origImgData.Image,K);
        end
       
        Name = [but13Data.UserData.Name '_practicalwiener'];
        
    elseif(handles.radiobutton20.Value == 1.0)
        %Parametric Wiener
        but14Data = findobj('Tag','pushbutton14');
        but15Data = findobj('Tag','pushbutton15');
        if(but14Data == 0 || isempty(but14Data) || ~isfield(but14Data.UserData,'Name'))
            errordlg('Please Select Noise Image');
        elseif(but15Data == 0 || isempty(but15Data) || ~isfield(but15Data.UserData,'Name'))
            errordlg('Please Select Original Image');
        else
            origImgData = but15Data.UserData; %Fields of Name and Image
            noiseImgData = but14Data.UserData; %Fields of Name and Image
            OutIma = parametric_wiener_filter_cvip(degradedImgData.Image,Mask,cutFreq,limGain,noiseImgData.Image,origImgData.Image,gamma);            
        end
        Name = [but13Data.UserData.Name '_parametricwiener'];
        
    elseif(handles.radiobutton21.Value == 1.0)
        %Notch Filter
        [row,col,~] = size(but13Data.UserData.Image);
        zone = getappdata(0, 'notchZone');
        number = length(zone.X);
        for i = length(zone.X)
            if zone.X(i)+(zone.R(i)/2) > col
                errordlg(['Point ' num2str(i) ' extends beyond image']);
                return;
            elseif zone.X(i)-(zone.R(i)/2) < 1
                errordlg(['Point ' num2str(i) ' extends beyond image']);
                return;
            elseif zone.Y(i)+(zone.R(i)/2) > row
                errordlg(['Point ' num2str(i) ' extends beyond image']);
                return;
            elseif zone.Y(i)-(zone.R(i)/2) < 1
                errordlg(['Point ' num2str(i) ' extends beyond image']);
                return;
            end
        end
        transformType = handles.popupmenu54.Value;
        if transformType == 1
            %FFT
            spect = fft_cvip(but13Data.UserData.Image, []);
            notchImg = notch_filter_cvip(spect,zone,number,0);
            OutIma = ifft_cvip(notchImg,[]);
            Name = [but13Data.UserData.Name '_notch'];
        elseif transformType == 2
            %DCT
            spect = dct_cvip(but13Data.UserData.Image, [])
            notchImg = notch_filter_cvip(spect,zone,number,0);
            OutIma = idct_cvip(notchImg,[]);
            
        elseif transformType == 3
            %Haar
            spect = haar_cvip(but13Data.UserData.Image, []);
            notchImg = notch_filter_cvip(spect,zone,number,0);
            OutIma = ihaar_cvip(notchImg,[]);
            
            
        elseif transformType == 4
            %Walsh
            spect = walhad_cvip(but13Data.UserData.Image, [])
            notchImg = notch_filter_cvip(spect,zone,number,0);
            OutIma = iwalhad_cvip(notchImg,[]);
            
        elseif transformType == 5
            %Hadamard
            spect = walhad_cvip(but13Data.UserData.Image, [])
            notchImg = notch_filter_cvip(spect,zone,number,0);
            OutIma = iwalhad_cvip(notchImg,[]);
        
        end
        Name = [but13Data.UserData.Name '_notch'];
        
    end
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

%changing pointer watch back to arrow on cursor
set(figure_set,'pointer','arrow');


% --- Executes on button press in bCancel.
function bCancel_Callback(hObject, eventdata, handles)
% hObject    handle to bCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Prepare to close application window
 close(handles.FreqFilt)

% --- Executes on button press in bReset.
function bReset_Callback(hObject, eventdata, handles)
% hObject    handle to bReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Alpha/Gamma text on left
handles.text40.Visible = 'on';
handles.text40.String = 'Alpha=0, Gamma=0';

%Top degredation function box
handles.radiobutton22.Visible = 'on';
handles.radiobutton23.Visible = 'on';
handles.text50.Visible = 'off';
handles.pushbutton16.Visible = 'off';
handles.uipanel6.Visible = 'on';

%Below degredation function box
handles.text34.Visible = 'off'; %Noise Image
handles.text48.Visible = 'off';
handles.pushbutton14.Visible = 'off';
handles.text37.Visible = 'off'; %Original Image
handles.text49.Visible = 'off';
handles.pushbutton15.Visible = 'off';
handles.text35.Visible = 'off'; %Gamma
handles.popupmenu49.Visible = 'off';
handles.text38.Visible = 'off'; %Smoothness
handles.popupmenu52.Visible = 'off';
handles.text36.Visible = 'off'; %Alpha
handles.popupmenu50.Visible = 'off';
handles.text39.Visible = 'off'; %K
handles.popupmenu53.Visible = 'off';

%Cutoff Freq etc.
handles.text30.Visible = 'on';
handles.popupmenu42.Visible = 'on';
handles.text31.Visible = 'on';
handles.popupmenu43.Visible = 'on';
handles.text33.Visible = 'on';

%Notch Filter Stuff
handles.text41.Visible = 'off';
handles.pushbutton9.Visible = 'off';
handles.pushbutton10.Visible = 'off';
handles.text42.Visible = 'off';
handles.popupmenu54.Visible = 'off';
handles.text43.Visible = 'off';
handles.popupmenu55.Visible = 'off';
handles.text44.Visible = 'off';
handles.edit11.Visible = 'off';
handles.text45.Visible = 'off';
handles.text46.Visible = 'off';
handles.edit12.Visible = 'off';
handles.popupmenu58.Visible = 'off';

set(handles.radiobutton21, 'Value', 0);

r = str2num(cell2mat(handles.popupmenu40.String(handles.popupmenu40.Value)));
c = str2num(cell2mat(handles.popupmenu40.String(handles.popupmenu37.Value)));
d = ones(r,c);
setappdata(0,'objhandle',hObject);
setappdata(0,'maskRows',r);
setappdata(0,'maskCols',c);
setappdata(0,'maskData',d);
setappdata(0,'notchCount',0);
setappdata(0,'notchString','(new)');
setappdata(0,'notchX',0);
setappdata(0,'notchY',0);
setappdata(0,'notchSize',0);
setappdata(0,'notchSizeVal',0);
setappdata(0, 'notchZone', 0);
handles.edit11.String = '';
handles.edit12.String = '';
handles.popupmenu55.Value = 1;
handles.popupmenu55.String = '(new)';
handles.popupmenu54.Value = 1;
handles.popupmenu58.Value = 6;

handles.text47.String = '';
handles.text50.String = '';
handles.text48.String = '';
handles.text49.String = '';

handles.popupmenu37.Value = 4;
handles.popupmenu40.Value = 4;
handles.popupmenu38.Value = 2;
handles.popupmenu39.Value = 1;
handles.popupmenu41.Value = 3;

handles.popupmenu42.Value = 5;
handles.popupmenu43.Value = 5;

handles.popupmenu49.Value = 2;
handles.popupmenu50.Value = 1;
handles.popupmenu52.Value = 1;
handles.popupmenu53.Value = 8;

handles.radiobutton14.Value = 1;
handles.radiobutton15.Value = 0;
handles.radiobutton16.Value = 0;
handles.radiobutton17.Value = 0;
handles.radiobutton18.Value = 0;
handles.radiobutton19.Value = 0;
handles.radiobutton20.Value = 0;
handles.radiobutton21.Value = 0;
handles.radiobutton22.Value = 1;
handles.radiobutton23.Value = 0;

handles.pushbutton13.UserData = 0;
handles.pushbutton14.UserData = 0;
handles.pushbutton16.UserData = 0;
handles.pushbutton15.UserData = 0;

%K Image on left
axesHandlesToChildObjects = findobj(handles.axes2, 'Type', 'image');
if ~isempty(axesHandlesToChildObjects)
    delete(axesHandlesToChildObjects);
end

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

% --- Executes during object creation, after setting all properties.
function FreqFilt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FreqFilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function bHist_CreateFcn(hObject, eventdata, handles) %???????

% --- Executes on selection change in popupmenu45.
function popupmenu45_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu45 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu45

% --- Executes during object creation, after setting all properties.
function popupmenu45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu46.
function popupmenu46_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu46 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu46

% --- Executes during object creation, after setting all properties.
function popupmenu46_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu47.
function popupmenu47_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu47 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu47


% --- Executes during object creation, after setting all properties.function popupmenu47_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu42.
function popupmenu42_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu42 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu42

% --- Executes during object creation, after setting all properties.
function popupmenu42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu43.
function popupmenu43_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu43 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu43

% --- Executes during object creation, after setting all properties.
function popupmenu43_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu37.
function popupmenu37_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu37 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu37
generateMask(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu37_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu38.
function popupmenu38_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu38 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu38
generateMask(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu38_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu39.
function popupmenu39_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu39 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu39
generateMask(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu39_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu40.
function popupmenu40_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu40 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu40
generateMask(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu40_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu41.
function popupmenu41_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu41 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu41
generateMask(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes1

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

% --- Executes during object creation, after setting all properties.
function text29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on selection change in popupmenu48.
function popupmenu48_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu48 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu48

% --- Executes during object creation, after setting all properties.
function popupmenu48_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu49.
function popupmenu49_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu49 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu49

% --- Executes during object creation, after setting all properties.
function popupmenu49_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu50.
function popupmenu50_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu50 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu50

% --- Executes during object creation, after setting all properties.
function popupmenu50_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu51.
function popupmenu51_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu51 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu51

% --- Executes during object creation, after setting all properties.
function popupmenu51_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu52.
function popupmenu52_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu52 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu52

% --- Executes during object creation, after setting all properties.
function popupmenu52_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu53.
function popupmenu53_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu53 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu53

% --- Executes during object creation, after setting all properties.
function popupmenu53_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)   
figure(FreqFiltMask);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(0, 'notchZone', 0);
setappdata(0, 'notchX', 0);
setappdata(0, 'notchY', 0);
setappdata(0, 'notchSize', 0);
setappdata(0, 'notchSizeVal', 0);
setappdata(0, 'notchCount', 0);
setappdata(0, 'notchString', '(new');
handles.edit11.String = '';
handles.edit12.String = '';
handles.popupmenu55.Value = 1;
handles.popupmenu55.String = '(new)';
handles.popupmenu58.Value = 6;

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
i = getappdata(0, 'notchCount');
a = getappdata(0, 'notchString');
x = getappdata(0, 'notchX');
y = getappdata(0, 'notchY');
b = getappdata(0, 'notchSize');
sizeVal = getappdata(0, 'notchSizeVal');
size = str2num(cell2mat(handles.popupmenu58.String(handles.popupmenu58.Value)));
sizeVal2 = handles.popupmenu58.Value;
point = handles.popupmenu55.Value - 1;
c = str2num(handles.edit11.String);
r = str2num(handles.edit12.String);
if isempty(c) || isempty(r)
    errordlg('Col or Row is invalid');
    return;
end

if point == 0
    i = i + 1;
    setappdata(0, 'notchCount', i);
    a = strcat(a, [char(10) num2str(i)]);
    setappdata(0, 'notchString', a);
    handles.popupmenu55.String = a;
    
    x(i) =  c;
    y(i) =  r;
    b(i) = size;
    sizeVal(i) = sizeVal2;
    setappdata(0, 'notchX', x);
    setappdata(0, 'notchY', y);
    setappdata(0, 'notchSize', b);
    setappdata(0, 'notchSizeVal', sizeVal);
    zone = struct('X',{x},'Y',{y},'R',{b});
    setappdata(0, 'notchZone', zone);
    handles.edit11.String = '';
    handles.edit12.String = '';
    handles.popupmenu58.Value = 6;
    
else
    x(point) =  c;
    y(point) =  r;
    b(point) = size;
    sizeVal(i) = sizeVal2;
    
    setappdata(0, 'notchX', x);
    setappdata(0, 'notchY', y);
    setappdata(0, 'notchSize', b);
    setappdata(0, 'notchSizeVal', sizeVal);
    zone = struct('X',{x},'Y',{y},'R',{b});
    setappdata(0, 'notchZone', zone);
    handles.edit11.String = '';
    handles.edit12.String = '';
    handles.popupmenu55.Value = 1;
    handles.popupmenu58.Value = 6;

end

% --- Executes on selection change in popupmenu54.
function popupmenu54_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu54 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu54

% --- Executes during object creation, after setting all properties.
function popupmenu54_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu55.
function popupmenu55_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu55 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu55
val = handles.popupmenu55.Value - 1;

if val == 0
    handles.edit11.String = '';
    handles.edit12.String = '';
    handles.popupmenu58.Value = 6;
else
    notchX = getappdata(0, 'notchX');
    notchY = getappdata(0, 'notchY');
    notchSizeVal = getappdata(0, 'notchSizeVal');
    handles.edit11.String = num2str(notchX(val));
    handles.edit12.String = num2str(notchY(val));
    handles.popupmenu58.Value = notchSizeVal(val);
end


% --- Executes during object creation, after setting all properties.
function popupmenu55_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu58.
function popupmenu58_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu58 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu58

% --- Executes during object creation, after setting all properties.
function popupmenu58_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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

function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double

% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in radiobutton14.
function radiobutton14_Callback(hObject, eventdata, handles) %Inverse
% hObject    handle to radiobutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton14
%Alpha/Gamma text on left
handles.text40.Visible = 'on';
handles.text40.String = 'Alpha=0, Gamma=0';

%Top degredation function box
handles.radiobutton22.Visible = 'on';
handles.radiobutton23.Visible = 'on';
if handles.radiobutton22.Value == 1
    handles.uipanel6.Visible = 'on';
else
    handles.uipanel6.Visible = 'off';
    handles.text50.Visible = 'on';
    handles.pushbutton16.Visible = 'on';
end

%Below degredation function box
handles.text34.Visible = 'off'; %Noise Image
handles.text48.Visible = 'off';
handles.pushbutton14.Visible = 'off';
handles.text37.Visible = 'off'; %Original Image
handles.text49.Visible = 'off';
handles.pushbutton15.Visible = 'off';
handles.text35.Visible = 'off'; %Gamma
handles.popupmenu49.Visible = 'off';
handles.text38.Visible = 'off'; %Smoothness
handles.popupmenu52.Visible = 'off';
handles.text36.Visible = 'off'; %Alpha
handles.popupmenu50.Visible = 'off';
handles.text39.Visible = 'off'; %K
handles.popupmenu53.Visible = 'off';

%Cutoff Freq etc.
handles.text30.Visible = 'on';
handles.popupmenu42.Visible = 'on';
handles.text31.Visible = 'on';
handles.popupmenu43.Visible = 'on';
handles.text33.Visible = 'on';

%Notch Filter Stuff
handles.text41.Visible = 'off';
handles.pushbutton9.Visible = 'off';
handles.pushbutton10.Visible = 'off';
handles.text42.Visible = 'off';
handles.popupmenu54.Visible = 'off';
handles.text43.Visible = 'off';
handles.popupmenu55.Visible = 'off';
handles.text44.Visible = 'off';
handles.edit11.Visible = 'off';
handles.text45.Visible = 'off';
handles.text46.Visible = 'off';
handles.edit12.Visible = 'off';
handles.popupmenu58.Visible = 'off';

set(handles.radiobutton21, 'Value', 0);

%K Image on left
axesHandlesToChildObjects = findobj(handles.axes2, 'Type', 'image');
if ~isempty(axesHandlesToChildObjects)
    delete(axesHandlesToChildObjects);
end

% --- Executes on button press in radiobutton15.
function radiobutton15_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton15
handles.text40.Visible = 'on';
handles.text40.String = '';

%Top degredation function box
handles.radiobutton22.Visible = 'on';
handles.radiobutton23.Visible = 'on';
if handles.radiobutton22.Value == 1
    handles.uipanel6.Visible = 'on';
else
    handles.uipanel6.Visible = 'off';
    handles.text50.Visible = 'on';
    handles.pushbutton16.Visible = 'on';
end

%Below degredation function box
handles.text34.Visible = 'on'; %Noise Image
handles.text48.Visible = 'on';
handles.pushbutton14.Visible = 'on';
handles.text37.Visible = 'on'; %Original Image
handles.text49.Visible = 'on';
handles.pushbutton15.Visible = 'on';
handles.text35.Visible = 'on'; %Gamma
handles.popupmenu49.Visible = 'on';
handles.text38.Visible = 'off'; %Smoothness
handles.popupmenu52.Visible = 'off';
handles.text36.Visible = 'on'; %Alpha
handles.popupmenu50.Visible = 'on';
handles.text39.Visible = 'off'; %K
handles.popupmenu53.Visible = 'off';

%Cutoff Freq etc.
handles.text30.Visible = 'on';
handles.popupmenu42.Visible = 'on';
handles.text31.Visible = 'on';
handles.popupmenu43.Visible = 'on';
handles.text33.Visible = 'on';

%Notch Filter Stuff
handles.text41.Visible = 'off';
handles.pushbutton9.Visible = 'off';
handles.pushbutton10.Visible = 'off';
handles.text42.Visible = 'off';
handles.popupmenu54.Visible = 'off';
handles.text43.Visible = 'off';
handles.popupmenu55.Visible = 'off';
handles.text44.Visible = 'off';
handles.edit11.Visible = 'off';
handles.text45.Visible = 'off';
handles.text46.Visible = 'off';
handles.edit12.Visible = 'off';
handles.popupmenu58.Visible = 'off';

set(handles.radiobutton21, 'Value', 0);

%K Image on left
axesHandlesToChildObjects = findobj(handles.axes2, 'Type', 'image');
if ~isempty(axesHandlesToChildObjects)
    delete(axesHandlesToChildObjects);
end

% --- Executes on button press in radiobutton16.
function radiobutton16_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton16
handles.text40.Visible = 'on';
handles.text40.String = 'Alpha=0.5, Gamma=1';

%Top degredation function box
handles.radiobutton22.Visible = 'on';
handles.radiobutton23.Visible = 'on';
if handles.radiobutton22.Value == 1
    handles.uipanel6.Visible = 'on';
else
    handles.uipanel6.Visible = 'off';
    handles.text50.Visible = 'on';
    handles.pushbutton16.Visible = 'on';
end

%Below degredation function box
handles.text34.Visible = 'on'; %Noise Image
handles.text48.Visible = 'on';
handles.pushbutton14.Visible = 'on';
handles.text37.Visible = 'on'; %Original Image
handles.text49.Visible = 'on';
handles.pushbutton15.Visible = 'on';
handles.text35.Visible = 'off'; %Gamma
handles.popupmenu49.Visible = 'off';
handles.text38.Visible = 'off'; %Smoothness
handles.popupmenu52.Visible = 'off';
handles.text36.Visible = 'off'; %Alpha
handles.popupmenu50.Visible = 'off';
handles.text39.Visible = 'off'; %K
handles.popupmenu53.Visible = 'off';

%Notch Filter Stuff
handles.text41.Visible = 'off';
handles.pushbutton9.Visible = 'off';
handles.pushbutton10.Visible = 'off';
handles.text42.Visible = 'off';
handles.popupmenu54.Visible = 'off';
handles.text43.Visible = 'off';
handles.popupmenu55.Visible = 'off';
handles.text44.Visible = 'off';
handles.edit11.Visible = 'off';
handles.text45.Visible = 'off';
handles.text46.Visible = 'off';
handles.edit12.Visible = 'off';
handles.popupmenu58.Visible = 'off';

%Cutoff Freq etc.
handles.text30.Visible = 'on';
handles.popupmenu42.Visible = 'on';
handles.text31.Visible = 'on';
handles.popupmenu43.Visible = 'on';
handles.text33.Visible = 'on';

set(handles.radiobutton21, 'Value', 0);

%K Image on left
axesHandlesToChildObjects = findobj(handles.axes2, 'Type', 'image');
if ~isempty(axesHandlesToChildObjects)
    delete(axesHandlesToChildObjects);
end

% --- Executes on button press in radiobutton17.
function radiobutton17_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton17
handles.text40.Visible = 'on';
handles.text40.String = 'Alpha=0';

%Top degredation function box
handles.radiobutton22.Visible = 'on';
handles.radiobutton23.Visible = 'on';
if handles.radiobutton22.Value == 1
    handles.uipanel6.Visible = 'on';
else
    handles.uipanel6.Visible = 'off';
    handles.text50.Visible = 'on';
    handles.pushbutton16.Visible = 'on';
end

%Below degredation function box
handles.text34.Visible = 'off'; %Noise Image
handles.text48.Visible = 'off';
handles.pushbutton14.Visible = 'off';
handles.text37.Visible = 'off'; %Original Image
handles.text49.Visible = 'off';
handles.pushbutton15.Visible = 'off';
handles.text35.Visible = 'on'; %Gamma
handles.popupmenu49.Visible = 'on';
handles.text38.Visible = 'on'; %Smoothness
handles.popupmenu52.Visible = 'on';
handles.text36.Visible = 'off'; %Alpha
handles.popupmenu50.Visible = 'off';
handles.text39.Visible = 'off'; %K
handles.popupmenu53.Visible = 'off';

%Cutoff Freq etc.
handles.text30.Visible = 'on';
handles.popupmenu42.Visible = 'on';
handles.text31.Visible = 'on';
handles.popupmenu43.Visible = 'on';
handles.text33.Visible = 'on';

%Notch Filter Stuff
handles.text41.Visible = 'off';
handles.pushbutton9.Visible = 'off';
handles.pushbutton10.Visible = 'off';
handles.text42.Visible = 'off';
handles.popupmenu54.Visible = 'off';
handles.text43.Visible = 'off';
handles.popupmenu55.Visible = 'off';
handles.text44.Visible = 'off';
handles.edit11.Visible = 'off';
handles.text45.Visible = 'off';
handles.text46.Visible = 'off';
handles.edit12.Visible = 'off';
handles.popupmenu58.Visible = 'off';

set(handles.radiobutton21, 'Value', 0);

%K Image on left
axesHandlesToChildObjects = findobj(handles.axes2, 'Type', 'image');
if ~isempty(axesHandlesToChildObjects)
    delete(axesHandlesToChildObjects);
end

% --- Executes on button press in radiobutton18.
function radiobutton18_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton18
handles.text40.Visible = 'on';
handles.text40.String = 'Alpha=0, Gamma=1';

%Top degredation function box
handles.radiobutton22.Visible = 'on';
handles.radiobutton23.Visible = 'on';
if handles.radiobutton22.Value == 1
    handles.uipanel6.Visible = 'on';
else
    handles.uipanel6.Visible = 'off';
    handles.text50.Visible = 'on';
    handles.pushbutton16.Visible = 'on';
end
%Below degredation function box
handles.text34.Visible = 'on'; %Noise Image
handles.text48.Visible = 'on';
handles.pushbutton14.Visible = 'on';
handles.text37.Visible = 'on'; %Original Image
handles.text49.Visible = 'on';
handles.pushbutton15.Visible = 'on';
handles.text35.Visible = 'off'; %Gamma
handles.popupmenu49.Visible = 'off';
handles.text38.Visible = 'off'; %Smoothness
handles.popupmenu52.Visible = 'off';
handles.text36.Visible = 'off'; %Alpha
handles.popupmenu50.Visible = 'off';
handles.text39.Visible = 'off'; %K
handles.popupmenu53.Visible = 'off';

%Cutoff Freq etc.
handles.text30.Visible = 'on';
handles.popupmenu42.Visible = 'on';
handles.text31.Visible = 'on';
handles.popupmenu43.Visible = 'on';
handles.text33.Visible = 'on';

%Notch Filter Stuff
handles.text41.Visible = 'off';
handles.pushbutton9.Visible = 'off';
handles.pushbutton10.Visible = 'off';
handles.text42.Visible = 'off';
handles.popupmenu54.Visible = 'off';
handles.text43.Visible = 'off';
handles.popupmenu55.Visible = 'off';
handles.text44.Visible = 'off';
handles.edit11.Visible = 'off';
handles.text45.Visible = 'off';
handles.text46.Visible = 'off';
handles.edit12.Visible = 'off';
handles.popupmenu58.Visible = 'off';

set(handles.radiobutton21, 'Value', 0);

%K Image on left
axesHandlesToChildObjects = findobj(handles.axes2, 'Type', 'image');
if ~isempty(axesHandlesToChildObjects)
    delete(axesHandlesToChildObjects);
end

% --- Executes on button press in radiobutton19.
function radiobutton19_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton19
handles.text40.Visible = 'on';
handles.text40.String = 'Alpha=0,       K=';

%Top degredation function box
handles.radiobutton22.Visible = 'on';
handles.radiobutton23.Visible = 'on';
if handles.radiobutton22.Value == 1
    handles.uipanel6.Visible = 'on';
else
    handles.uipanel6.Visible = 'off';
    handles.text50.Visible = 'on';
    handles.pushbutton16.Visible = 'on';
end

%Below degredation function box
handles.text34.Visible = 'off'; %Noise Image
handles.text48.Visible = 'off';
handles.pushbutton14.Visible = 'off';
handles.text37.Visible = 'off'; %Original Image
handles.text49Visible = 'off';
handles.pushbutton15.Visible = 'off';
handles.text35.Visible = 'off'; %Gamma
handles.popupmenu49.Visible = 'off';
handles.text38.Visible = 'off'; %Smoothness
handles.popupmenu52.Visible = 'off';
handles.text36.Visible = 'off'; %Alpha
handles.popupmenu50.Visible = 'off';
handles.text39.Visible = 'on'; %K
handles.popupmenu53.Visible = 'on';

%Cutoff Freq etc.
handles.text30.Visible = 'off';
handles.popupmenu42.Visible = 'off';
handles.text31.Visible = 'off';
handles.popupmenu43.Visible = 'off';
handles.text33.Visible = 'off';

%Notch Filter Stuff
handles.text41.Visible = 'off';
handles.pushbutton9.Visible = 'off';
handles.pushbutton10.Visible = 'off';
handles.text42.Visible = 'off';
handles.popupmenu54.Visible = 'off';
handles.text43.Visible = 'off';
handles.popupmenu55.Visible = 'off';
handles.text44.Visible = 'off';
handles.edit11.Visible = 'off';
handles.text45.Visible = 'off';
handles.text46.Visible = 'off';
handles.edit12.Visible = 'off';
handles.popupmenu58.Visible = 'off';

set(handles.radiobutton21, 'Value', 0);

%K Image on left
cpath = mfilename( 'fullpath' );
cpath = cpath(1:end-8);
a = imread([cpath 'Resources\PractWienerK.png']);

axes(handles.axes2);
imshow(a,'InitialMagnification','fit'); %%Rev
handles.axes2.Visible = 'Off';
handles.axes2.UserData = 'SI';

% --- Executes on button press in radiobutton20.
function radiobutton20_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton20
handles.text40.Visible = 'on';
handles.text40.String = 'Alpha=0';

%Top degredation function box
handles.radiobutton22.Visible = 'on';
handles.radiobutton23.Visible = 'on';
if handles.radiobutton22.Value == 1
    handles.uipanel6.Visible = 'on';
else
    handles.uipanel6.Visible = 'off';
    handles.text50.Visible = 'on';
    handles.pushbutton16.Visible = 'on';
end

%Below degredation function box
handles.text34.Visible = 'on'; %Noise Image
handles.text48.Visible = 'on';
handles.pushbutton14.Visible = 'on';
handles.text37.Visible = 'on'; %Original Image
handles.text49.Visible = 'on';
handles.pushbutton15.Visible = 'on';
handles.text35.Visible = 'on'; %Gamma
handles.popupmenu49.Visible = 'on';
handles.text38.Visible = 'off'; %Smoothness
handles.popupmenu52.Visible = 'off';
handles.text36.Visible = 'off'; %Alpha
handles.popupmenu50.Visible = 'off';
handles.text39.Visible = 'off'; %K
handles.popupmenu53.Visible = 'off';

%Cutoff Freq etc.
handles.text30.Visible = 'on';
handles.popupmenu42.Visible = 'on';
handles.text31.Visible = 'on';
handles.popupmenu43.Visible = 'on';
handles.text33.Visible = 'on';

%Notch Filter Stuff
handles.text41.Visible = 'off';
handles.pushbutton9.Visible = 'off';
handles.pushbutton10.Visible = 'off';
handles.text42.Visible = 'off';
handles.popupmenu54.Visible = 'off';
handles.text43.Visible = 'off';
handles.popupmenu55.Visible = 'off';
handles.text44.Visible = 'off';
handles.edit11.Visible = 'off';
handles.text45.Visible = 'off';
handles.text46.Visible = 'off';
handles.edit12.Visible = 'off';
handles.popupmenu58.Visible = 'off';

set(handles.radiobutton21, 'Value', 0);

%K Image on left
axesHandlesToChildObjects = findobj(handles.axes2, 'Type', 'image');
if ~isempty(axesHandlesToChildObjects)
    delete(axesHandlesToChildObjects);
end

% --- Executes on button press in radiobutton21.
function radiobutton21_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton21
handles.text40.Visible = 'on';
handles.text40.String = '';

%Top degredation function box
handles.radiobutton22.Visible = 'off';
handles.radiobutton23.Visible = 'off';
handles.text50.Visible = 'off';
handles.pushbutton16.Visible = 'off';
handles.uipanel6.Visible = 'off';

%Below degredation function box
handles.text34.Visible = 'off'; %Noise Image
handles.text48.Visible = 'off';
handles.pushbutton14.Visible = 'off';
handles.text37.Visible = 'off'; %Original Image
handles.text49.Visible = 'off';
handles.pushbutton15.Visible = 'off';
handles.text35.Visible = 'off'; %Gamma
handles.popupmenu49.Visible = 'off';
handles.text38.Visible = 'off'; %Smoothness
handles.popupmenu52.Visible = 'off';
handles.text36.Visible = 'off'; %Alpha
handles.popupmenu50.Visible = 'off';
handles.text39.Visible = 'off'; %K
handles.popupmenu53.Visible = 'off';

%Cutoff Freq etc.
handles.text30.Visible = 'off';
handles.popupmenu42.Visible = 'off';
handles.text31.Visible = 'off';
handles.popupmenu43.Visible = 'off';
handles.text33.Visible = 'off';

%Notch Filter Stuff
handles.text41.Visible = 'on';
handles.pushbutton9.Visible = 'on';
handles.pushbutton10.Visible = 'on';
handles.text42.Visible = 'on';
handles.popupmenu54.Visible = 'on';
handles.text43.Visible = 'on';
handles.popupmenu55.Visible = 'on';
handles.text44.Visible = 'on';
handles.edit11.Visible = 'on';
handles.text45.Visible = 'on';
handles.text46.Visible = 'on';
handles.edit12.Visible = 'on';
handles.popupmenu58.Visible = 'on';

set(handles.radiobutton14, 'Value', 0);
set(handles.radiobutton15, 'Value', 0);
set(handles.radiobutton16, 'Value', 0);
set(handles.radiobutton17, 'Value', 0);
set(handles.radiobutton18, 'Value', 0);
set(handles.radiobutton19, 'Value', 0);
set(handles.radiobutton20, 'Value', 0);

%K Image on left
axesHandlesToChildObjects = findobj(handles.axes2, 'Type', 'image');
if ~isempty(axesHandlesToChildObjects)
    delete(axesHandlesToChildObjects);
end

% --- Executes when user attempts to close FreqFilt.
function FreqFilt_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to FreqFilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% stop(getappdata(hObject, 'timer_obj')); % stops the timer 
% delete(getappdata(hObject, 'timer_obj'));  % delete the timer object
delete(hObject);


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc                             %clear screen
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
handles.text47.String = file;
data = struct('Name',file,'Image',InIma);
handles.pushbutton13.UserData = data;
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc                             %clear screen
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
handles.text48.String = file;
data = struct('Name',file,'Image',InIma);
handles.pushbutton14.UserData = data;
end


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc                             %clear screen
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
handles.text49.String = file;
data = struct('Name',file,'Image',InIma);
handles.pushbutton15.UserData = data;
end

function generateMask(hObject, handles)
r = str2num(cell2mat(handles.popupmenu40.String(handles.popupmenu40.Value)));
c = str2num(cell2mat(handles.popupmenu37.String(handles.popupmenu37.Value)));
setappdata(0,'maskRows',str2num(cell2mat(handles.popupmenu40.String(handles.popupmenu40.Value))));
setappdata(0,'maskCols',str2num(cell2mat(handles.popupmenu37.String(handles.popupmenu37.Value))));
bShape = handles.popupmenu38.Value;
bMethod = handles.popupmenu39.Value;
weight = str2num(cell2mat(handles.popupmenu41.String(handles.popupmenu41.Value)));

d = zeros(r, c);

if bShape == 1
    %Circle
    if r <= c
        radius = r/2;
    else
        radius = c/2;
    end
    centerR = (r+1)/2;
    centerC = (c+1)/2;
    for i = 1:r
        for i2 = 1:c
            if sqrt((i-centerR)^2 + (i2-centerC)^2)<= radius-.5
                d(i,i2) = 1;
            end
        end
    end
        
elseif bShape == 2
    %Rectangle
    d = ones(r,c);       
        
elseif bShape == 3
    %Horiz Line
    for i = 1:c
        d((r+1)/2,i) = 1;
    end
    
elseif bShape == 4
    %Vert Line
    for i = 1:r
        d(i,(c+1)/2) = 1;
    end
elseif bShape == 5
    %Slash
    for i = 1:r
        for i2 = 1:c
            if round(-1*(r/c)*i2 + r+(r/c)) == i
                d(i,i2) = 1;
            end
        end
    end
elseif bShape == 6
    %Backslash
    for i = 1:r
        for i2 = 1:c
            if round((r/c)*i2) == i
                d(i,i2) = 1;
            end
        end
    end
end

if bMethod == 1;
    %do nothing
    
elseif bMethod == 2
    centerR = (r+1)/2;
    centerC = (c+1)/2;
    d(centerR, centerC) = r*c;
    
elseif bMethod == 3
    %Gaussian
    %Idea is to generate a normpdf that extends to the longer mask
    %dimension extended to the corner(45 degrees) since this will be the
    %farthest point needed to be reached if the mask is symmetric,
    %otherwise the farthes point will always be less than this
    %Multiply the resulting normalized curve value at the corresponding
    %distance of the point by the point value*r*c
    if r >= c
        lim = sqrt(2 * ((r+1)/2)^2);
    else
        lim = sqrt(2 * ((c+1)/2)^2);
    end
    x = [-(lim+1)/2:.1:(lim+1)/2];
    y = normpdf(x,0,1);
    y = y/max(y);
    y2 = y((((length(y)-1)/2)+1):length(y));

    centerR = (r+1)/2;
    centerC = (c+1)/2;
    for i = 1:r
        for i2 = 1:c
            dist = sqrt((i-centerR)^2 + (i2-centerC)^2);
            gfactor = round((length(y2)-1)*(dist/lim));
            d(i,i2) = d(i,i2)*(y2(gfactor+1))*r*c;
        end
    end
end

d = d*weight;
setappdata(0,'maskData',d);

% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc                             %clear screen
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
handles.text49.String = file;
data = struct('Name',file,'Image',InIma);
handles.pushbutton15.UserData = data;
handles.text50.String = data.Name;
d = InIma;
setappdata(0,'maskData',d);
[rows,cols,bands] = size(d);
setappdata(0,'maskRows',rows);
setappdata(0,'maskCols',cols);
end

% --- Executes on button press in radiobutton23.
function radiobutton23_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton23
handles.uipanel6.Visible = 'off';
handles.text50.Visible = 'on';
handles.pushbutton16.Visible = 'on';


% --- Executes on button press in radiobutton22.
function radiobutton22_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton22
handles.uipanel6.Visible = 'on';
handles.text50.Visible = 'off';
handles.pushbutton16.Visible = 'off';
handles.text50.String = '';


% --- Executes during object creation, after setting all properties.
function uipanel6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
