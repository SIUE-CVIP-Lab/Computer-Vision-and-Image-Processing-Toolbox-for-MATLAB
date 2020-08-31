function varargout = DlgHelp(varargin)
% DLGHELP MATLAB code for DlgHelp.fig
%      DLGHELP, by itself, creates a new DLGHELP or raises the existing
%      singleton*.
%
%      H = DLGHELP returns the handle to a new DLGHELP or the handle to
%      the existing singleton*.
%
%      DLGHELP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DLGHELP.M with the given input arguments.
%
%      DLGHELP('Property','Value',...) creates a new DLGHELP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgHelp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgHelp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DlgHelp

% Last Modified by GUIDE v2.5 27-Jun-2019 13:02:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgHelp_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgHelp_OutputFcn, ...
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
%           Initial coding date:    05/03/2019
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     05/03/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.2  05/03/2019  18:09:55  jucuell
 %  
 % 
%
 % Revision 1.1  05/03/2019  17:46:15  jucuell
 % Initial coding and testing.
 % 
%

% --- Executes just before DlgHelp is made visible.
function DlgHelp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DlgHelp (see VARARGIN)

% Choose default command line output for DlgHelp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DlgHelp wait for user response (see UIRESUME)
% uiwait(handles.dlgHelp);


% --- Outputs from this function are returned to the command line.
function varargout = DlgHelp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if hObject.UserData
    handles.edit1.Visible = 'On';
    hObject.UserData = 0;
else
    handles.edit1.Visible = 'Off';
    hObject.UserData = 1;
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 close(handles.dlgHelp)


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uipanel1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
web('https://cviptools.siue.edu/')
