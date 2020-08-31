function varargout = DlgNoise(varargin)
% DLGNOISE MATLAB code for DlgNoise.fig
%      DLGNOISE, by itself, creates a new DLGNOISE or raises the existing
%      singleton*.
%
%      H = DLGNOISE returns the handle to a new DLGNOISE or the handle to
%      the existing singleton*.
%
%      DLGNOISE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DLGNOISE.M with the given input arguments.
%
%      DLGNOISE('Property','Value',...) creates a new DLGNOISE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgNoise_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgNoise_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DlgNoise

% Last Modified by GUIDE v2.5 17-Apr-2020 20:25:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgNoise_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgNoise_OutputFcn, ...
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
%           Author:                 Hridoy Biswas(GUIDE)
%           Initial coding date:    10/05/2019
%           Updated by:             
%           Latest update date:     10/09/2019 
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% --- Executes just before DlgNoise is made visible.
function DlgNoise_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DlgNoise (see VARARGIN)

% Choose default command line output for DlgNoise
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DlgNoise wait for user response (see UIRESUME)
% uiwait(handles.DlgNoise);
%call menu creation function
menu_add_cvip(hObject);

hide_all(handles);
handles.textvariance.Visible = 'On';
handles.varianceval.Visible = 'On';


function mVsaveHis_Callback(hObject, eventdata, handles)
% hObject    handle to mVsaveHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('Hola Magola, This is working!!!  :)');
hObject.Checked = 'On';



% --- Outputs from this function are returned to the command line.
function varargout = DlgNoise_OutputFcn(hObject, eventdata, handles) 
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
if handles.bNegExp.Value
    if handles.current_image.Value %perform negative exponential
        noise_parameter = str2double(handles.varianceval.String(handles.varianceval.Value));
        k = neg_exp_noise_cvip(InIma,noise_parameter);
        OutIma =remap_cvip(k,[]);
        Name = [file,' > NegExp(' num2str(noise_parameter) ',)'];
        histo = [076 noise_parameter ];
                  %Negative exponential noise image
    elseif handles.black_image.Value
        noise_parameter = str2double(handles.varianceval.String(handles.varianceval.Value));
        height = str2double(handles.heightval.String(handles.heightval.Value));
        width  = str2double(handles.widthval.String(handles.widthval.Value));
        image_size = [height width]; %size of the image
        k = neg_exp_noise_cvip([],noise_parameter, image_size);
        OutIma = remap_cvip(k,[]);
        Name = [file,' > NegExp(' num2str(noise_parameter) ',)'];
        histo = [076 noise_parameter ];
    end
elseif handles.rayleigh.Value
    if handles.current_image.Value
        noise_parameter = str2double(handles.varianceval.String(handles.varianceval.Value));
        k = rayleigh_noise_cvip(InIma,noise_parameter);%Emplementation of rayleigh image
        OutIma =remap_cvip(k,[]);
        Name = [file,' > Rayleigh(' num2str(noise_parameter) ',)'];
        histo = [076 noise_parameter ];
    elseif handles.black_image.Value
        noise_parameter = str2double(handles.varianceval.String(handles.varianceval.Value));
        height = str2double(handles.heightval.String(handles.heightval.Value));
        width  = str2double(handles.widthval.String(handles.widthval.Value));
        image_size = [height width]; %size of the image
        k = rayleigh_noise_cvip([],noise_parameter, image_size);
        OutIma = remap_cvip(k,[]);
        Name = [file,' > Rayleigh(' num2str(noise_parameter) ',)'];
        histo = [076 noise_parameter ];
    end   
elseif handles.gaussian.Value
    if handles.current_image.Value
       k = str2double(handles.varianceval.String(handles.varianceval.Value));%get the variance value
       l = str2double(handles.meanval.String(handles.meanval.Value));%get the mean value
       noise_parameter = [l k];
       m = gaussian_noise_cvip(InIma,noise_parameter);% implementation of gaussian
       OutIma =remap_cvip(m,[]);
       Name = [file,' > Guassian(' num2str(noise_parameter) ',)'];
       histo = [076 noise_parameter ];
    elseif handles.black_image.Value
        k = str2double(handles.varianceval.String(handles.varianceval.Value));%get the variance value
        l = str2double(handles.meanval.String(handles.meanval.Value));%get the mean value
        noise_parameter = [l k];
        height = str2double(handles.heightval.String(handles.heightval.Value));
        width  = str2double(handles.widthval.String(handles.widthval.Value));
        image_size = [height width]; %size of the image
        m= gaussian_noise_cvip([],noise_parameter, image_size);
        OutIma = remap_cvip(m,[]);
        Name = [file,' > Gaussian(' num2str(noise_parameter) ',)'];
        histo = [076 noise_parameter ];
    end      
elseif handles.uniform.Value
    if handles.current_image.Value
       k = str2double(handles.varianceval.String(handles.varianceval.Value));%get the variance value
       l = str2double(handles.meanval.String(handles.meanval.Value));%get the mean value
       noise_parameter = [l k];
       m = uniform_noise_cvip(InIma,noise_parameter);% implementation of uniform
       OutIma =remap_cvip(m,[]);
       Name = [file,' >Uniform(' num2str(noise_parameter) ',)'];
       histo = [076 noise_parameter ];
    elseif handles.black_image.Value
        k = str2double(handles.varianceval.String(handles.varianceval.Value));%get the variance value
        l = str2double(handles.meanval.String(handles.meanval.Value));%get the mean value
        noise_parameter = [l k];
        height = str2double(handles.heightval.String(handles.heightval.Value));
        width  = str2double(handles.widthval.String(handles.widthval.Value));
        image_size = [height width]; %size of the image
        m = uniform_noise_cvip([],noise_parameter, image_size);
        OutIma = remap_cvip(m);
        Name = [file,' > Uniform(' num2str(noise_parameter) ',)'];
        histo = [076 noise_parameter ];
    end
elseif handles.gamma.Value
    if handles.current_image.Value
        k = str2double(handles.varianceval.String(handles.varianceval.Value));%get the variance value
        l = str2double(handles.alphaval.String(handles.alphaval.Value));%get the alpha value
        noise_parameter = [l k];
        OutIma= gamma_noise_cvip(InIma,noise_parameter);% implementation of gamma
        %OutIma =remap_cvip(m,[]);
        Name = [file,' >Gamma(' num2str(noise_parameter) ',)'];
        histo = [076 noise_parameter ];
    elseif handles.black_image.Value
        k = str2double(handles.varianceval.String(handles.varianceval.Value));%get the variance value
        l = str2double(handles.alphaval.String(handles.alphaval.Value));%get the alpha value
        noise_parameter = [l k];
        height = str2double(handles.heightval.String(handles.heightval.Value));
        width  = str2double(handles.widthval.String(handles.widthval.Value));
        image_size = [height width]; %size of the image
        m= gamma_noise_cvip([],noise_parameter, image_size);
        OutIma = remap_cvip(m,[]);
        Name = [file,' > Gamma(' num2str(noise_parameter) ',)'];
        histo = [076 noise_parameter ];
    end
elseif handles.salt_pepper.Value
       if handles.current_image.Value
           k = str2double(handles.saltval.String(handles.saltval.Value));%get the salt value
           l = str2double(handles.pepperval.String(handles.pepperval.Value));%get the pepper value
           noise_parameter = [k l];
           m = salt_pepper_noise_cvip(InIma,noise_parameter);% implementation of salt_pepper
           OutIma =remap_cvip(m,[]);
           Name = [file,' >Salt_Pepper(' num2str(noise_parameter) ',)'];
           histo = [076 noise_parameter ];
       elseif handles.black_image.Value
           k = str2double(handles.saltval.String(handles.saltval.Value));%get the salt value
           l = str2double(handles.pepperval.String(handles.pepperval.Value));%get the pepper value
           noise_parameter = [k l];
           height = str2double(handles.heightval.String(handles.heightval.Value));
           width  = str2double(handles.widthval.String(handles.widthval.Value));
           image_size = [height width]; %size of the image
           m =salt_pepper_noise_cvip(ones(image_size)*255,noise_parameter);%salt
           n = salt_pepper_noise_cvip([],noise_parameter, image_size);%pepper image
           add = add_cvip(m,n);%adding both salt and pepper
           OutIma = remap_cvip(add,[]);
           Name = [file,' > Salt_Pepper(' num2str(noise_parameter) ',)'];
           histo = [076 noise_parameter ];
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
 close(handles.RNoise)


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
function RNoise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DlgNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in varianceval.
function varianceval_Callback(hObject, eventdata, handles)
% hObject    handle to varianceval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hints: contents = cellstr(get(hObject,'String')) returns varianceval contents as cell array
%        contents{get(hObject,'Value')} returns selected item from varianceval


% --- Executes during object creation, after setting all properties.
function varianceval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to varianceval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in meanval.
function meanval_Callback(hObject, eventdata, handles)
% hObject    handle to meanval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns meanval contents as cell array
%        contents{get(hObject,'Value')} returns selected item from meanval


% --- Executes during object creation, after setting all properties.
function meanval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meanval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in alphaval.
function alphaval_Callback(hObject, eventdata, handles)
% hObject    handle to alphaval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns alphaval contents as cell array
%        contents{get(hObject,'Value')} returns selected item from alphaval


% --- Executes during object creation, after setting all properties.
function alphaval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphaval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pepperval.
function pepperval_Callback(hObject, eventdata, handles)
% hObject    handle to pepperval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pepperval contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pepperval


% --- Executes during object creation, after setting all properties.
function pepperval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pepperval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in saltval.
function saltval_Callback(hObject, eventdata, handles)
% hObject    handle to saltval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns saltval contents as cell array
%        contents{get(hObject,'Value')} returns selected item from saltval


% --- Executes during object creation, after setting all properties.
function saltval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to saltval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function hide_all(handles)

handles.textvariance.Visible = 'Off';
handles.textmean.Visible = 'Off';
handles.textalpha.Visible = 'Off';
handles.textpepper.Visible = 'Off';
handles.textsalt.Visible = 'Off';
handles.textheight.Visible = 'Off';
handles.textwidth.Visible = 'Off';

handles.varianceval.Visible = 'Off';
handles.meanval.Visible = 'Off';
handles.alphaval.Visible = 'Off';
handles.pepperval.Visible = 'Off';
handles.saltval.Visible = 'Off';
handles.heightval.Visible = 'Off';
handles.widthval.Visible = 'Off';


% --- Executes on selection change in heightval.
function heightval_Callback(hObject, eventdata, handles)
% hObject    handle to heightval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns heightval contents as cell array
%        contents{get(hObject,'Value')} returns selected item from heightval


% --- Executes during object creation, after setting all properties.
function heightval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to heightval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in widthval.
function widthval_Callback(hObject, eventdata, handles)
% hObject    handle to widthval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns widthval contents as cell array
%        contents{get(hObject,'Value')} returns selected item from widthval


% --- Executes during object creation, after setting all properties.
function widthval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to widthval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bNegExp.
function bNegExp_Callback(hObject, eventdata, handles)
% hObject    handle to bNegExp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bNegExp

hide_all(handles);
handles.textvariance.Visible = 'On';
handles.varianceval.Visible = 'On';


% --- Executes on button press in rayleigh.
function rayleigh_Callback(hObject, eventdata, handles)
% hObject    handle to rayleigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rayleigh

hide_all(handles);
handles.textvariance.Visible = 'On';
handles.varianceval.Visible = 'On';


% --- Executes on button press in gaussian.
function gaussian_Callback(hObject, eventdata, handles)
% hObject    handle to gaussian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gaussian

hide_all(handles);
handles.textvariance.Visible = 'On';
handles.varianceval.Visible = 'On';
handles.textmean.Visible = 'On';
handles.meanval.Visible = 'On';


% --- Executes on button press in uniform.
function uniform_Callback(hObject, eventdata, handles)
% hObject    handle to uniform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of uniform

hide_all(handles);
handles.textvariance.Visible = 'On';
handles.varianceval.Visible = 'On';
handles.textmean.Visible = 'On';
handles.meanval.Visible = 'On';
handles.meanval.Value = 3;


% --- Executes on button press in gamma.
function gamma_Callback(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gamma

hide_all(handles);
handles.textvariance.Visible = 'On';
handles.varianceval.Visible = 'On';
handles.textalpha.Visible = 'On';
handles.alphaval.Visible = 'On';


% --- Executes on button press in salt_pepper.
function salt_pepper_Callback(hObject, eventdata, handles)
% hObject    handle to salt_pepper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of salt_pepper

hide_all(handles);
handles.textpepper.Visible = 'On';
handles.pepperval.Visible = 'On';
handles.textsalt.Visible = 'On';
handles.saltval.Visible = 'On';


% --- Executes on button press in current_image.
function current_image_Callback(hObject, eventdata, handles)
% hObject    handle to current_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of current_image]
handles.textwidth.Visible = 'Off';
handles.widthval.Visible = 'Off';
handles.textheight.Visible = 'Off';
handles.heightval.Visible = 'Off';


% --- Executes on button press in black_image.
function black_image_Callback(hObject, eventdata, handles)
% hObject    handle to black_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of black_image
handles.textheight.Visible = 'On';
handles.heightval.Visible = 'On';
handles.textwidth.Visible = 'On';
handles.widthval.Visible = 'On';
