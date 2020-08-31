function varargout = DlgGeom(varargin)
% DLGGEOM MATLAB code for DlgGeom.fig
%      DLGGEOM, by itself, creates a new DLGGEOM or raises the existing
%      singleton*.
%
%      H = DLGGEOM returns the handle to a new DLGGEOM or the handle to
%      the existing singleton*.
%
%      DLGGEOM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DLGGEOM.M with the given input arguments.
%
%      DLGGEOM('Property','Value',...) creates a new DLGGEOM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgGeom_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgGeom_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DlgGeom

% Last Modified by GUIDE v2.5 26-Oct-2018 22:02:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgGeom_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgGeom_OutputFcn, ...
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
%           Initial coding date:    10/10/2017
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     05/24/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.5  05/24/2019  13:32:15  jucuell
 % including the icons to extract the histogram, R, G and B band from the
 % selected image. Include the image selection check-up when resizing an
 % image
%
 % Revision 1.4  12/12/2018  15:21:14  jucuell
 % updating menu creation programmatically, callbacks to Main figure and
 % the use of the utilities menus in the Main figure.
%
 % Revision 1.3  09/05/2018  14:07:20  jucuell
 % updating save and open functions, adding function to let user type
 % values pop_add_cvip
%
 % Revision 1.2  08/30/2018  14:12:48  jucuell
 % start adding revision history. replace old calling to image handle hMain
 % updating: calling to show_guIma, bIma1, bIma2
%
 % Revision 1.1  10/10/2017  15:23:31  jucuell
 % Initial Coding and testing.
%

% --- Executes just before DlgGeom is made visible.
function DlgGeom_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DlgGeom (see VARARGIN)

% Choose default command line output for DlgGeom
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';%hide Analysis menu
handles.mComp.Visible = 'Off';%hide Compression menu
handles.mView.Visible = 'Off';%hide View menu

% uiTool = findobj('tag', 'uitoolbar1');
% uiOrder = allchild(uiTool);
% tool = uiOrder(1);
% uiOrder(1:5) = uiOrder(2:6);
% uiOrder(7) = tool;
% uiTool.Children = uiOrder;
% uiTool.Children(7) = tool;

% --- Outputs from this function are returned to the command line.
function varargout = DlgGeom_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% CODE CALLBACKS ORDER:
% - Buttons (bApply, bCancel, bReset, ...)
% - Radio Buttons (Options, choices)
% - Pop-up Menús, checkBoxes
% - Figure Callbacks (Resize, Click, ...)
% - Main Menus (fOpen, fSave)
% - Ui Main Menus (uiOpen, uiSave)
% - Menus (Others: View, Analysis, Compression...)


% --- Executes on button press in bApply.
function bApply_Callback(hObject, eventdata, handles)
% hObject    handle to bApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc                                 %clear screen

%changing pointer arrow to watch on cursor
figure_set = findall(groot,'Type','Figure');
set(figure_set,'pointer','watch');

hMain = findobj('Tag','Main');      %get the handle of Main figure
hSHisto = findobj('Tag','mVsaveHis');%get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = hMain.UserData;             %get image handle
%check for Image to process
if hNfig ~= 0 && isfield(hNfig.UserData,'cvipIma') 
    Ima=hNfig.UserData;             %get image information
    InIma = Ima.cvipIma;            %read image data
    file=get(hNfig,'Name');         %get image name

%perform image operations
[row,col,band]=size(InIma);         %size of input image
if handles.bCrop.Value==1           %perform Crop function
    %get Row, Col, Height and Width parameters
    cHeight=str2double(handles.hCrop.String(handles.hCrop.Value));
    cWidth=str2double(handles.wCrop.String(handles.wCrop.Value));
    cRow=str2double(handles.rCrop.String(handles.rCrop.Value));
    cCol=str2double(handles.cCrop.String(handles.cCrop.Value));
    if cCol > col || cRow > row
       errordlg('Selected Row and Column are beyond Image size', ...
           'Geometry Error', 'modal');
    elseif cCol+cWidth > col || cRow+cHeight > row
       Ans = questdlg(['Width or Height are bigger than image size. ' ...
           'Do you want to continue?'],'Geometry Warning','Continue', ...
           'Cancel','Cancel');
       if strcmp(Ans,'Continue')
            %call crop function
            OutIma = crop_cvip(InIma, [cHeight cWidth], [cRow cCol]);
       end
       
    else
        %call crop function
        OutIma = crop_cvip(InIma, [cHeight cWidth], [cRow cCol]);
    end
    %name and show image
    Name = strcat(file,' > Crop (',num2str(cCol),',',num2str(cRow),')(',...
        num2str(cWidth),'-',num2str(cHeight),')');
    %update image history
    histo = [062 cHeight cWidth cRow cCol];     %update image history
    
elseif handles.bPast.Value==1       %perform Copy_Paste 
    %returns selected item from Col
    Col=str2double(handles.cpCol.String(handles.cpCol.Value));  
    %returns selected item from Row
    Row=str2double(handles.cpRow.String(handles.cpRow.Value));  
    InIma1=handles.cpBIma1.UserData.cvipIma;    %get Image1
    file=handles.cpIma1.String;                	%get file name1
    InIma2=handles.cpBIma2.UserData.cvipIma;   	%get Image2
    file2=handles.cpIma2.String;               	%get file name2
    [row,col,~]=size(InIma1);                  	%Get output image size
    OutIma=copy_paste_cvip(InIma1, InIma2, [1 1], [row col], [Row Col], ...
        handles.cpTrans.Value);
    Name=strcat(' > Paste (',file,',',file2,')');%create image name
    %update image history
    histo = [061 1 1 row col Row Col handles.cpTrans.Value];
        
elseif handles.bResz.Value==1   %perform Resize
    %returns resize width
    Col=str2double(handles.wRsz.String(handles.wRsz.Value)); 
    %returns returns Height
    Row=str2double(handles.hRsz.String(handles.hRsz.Value)); 
    Met=handles.popRed.Value;           %returns returns Height
    if (Row <= row) && (Col <= col)  	%Reduce image with spatial quant
        %call spatial quant function
        OutIma=spatial_quant_cvip(InIma, Row, Col, Met);
        %update image history
        histo = [066 Row Col Met];              %update image history
        switch Met
            case 1
                Name=strcat(file,' > Resize - Spa.Quan.(Avg)');
            case 2
                Name=strcat(file,' > Resize - Spa.Quan.(Med)');
            case 3
                Name=strcat(file,' > Resize - Spa.Quan.(Dec)');
            case 4
                Name=strcat(file,' > Resize - Spa.Quan.(Max)');
            case 5
                Name=strcat(file,' > Resize - Spa.Quan.(Min)');
        end
    elseif (Row >= row) && (Col >= col)     %Enlarge image  
        OutIma=enlarge_cvip(InIma, Row, Col);%call enlarge function
        Name=strcat(file,' > Resize - Enl.');    
        %update image history
        histo = [063 Row Col 0];
        
    else   
        Val = max([Row row Col col]);     	%get the max parameter to enlarge
        OutIma=enlarge_cvip(InIma, Val, Val);%call enlarge function
        %call spatial quant function
        OutIma=spatial_quant_cvip(OutIma, Row, Col, 1);
        %update image history
        histo = [063 Val Val 0; 066 Row Col 1];
        Name=strcat(file,' > Resize - Enl.&Red.');
    end
    if band == 3
        OutIma = remap_cvip(OutIma,[0 255]);%call remap function
        %update image history
        histo = historyupdate_cvip(histo,[081 0 255]);
    end 
    
elseif handles.bRota.Value==1
    %get function parameters
    Deg=str2double(handles.rDeg.String(handles.rDeg.Value));%rotate degrees
    OutIma = rotate_cvip(InIma, Deg);  	%call rotate function
    %update image history
    histo =[064 Deg];
    if band == 3
        OutIma = remap_cvip(OutIma,[0 255]);
        %update image history
        histo = historyupdate_cvip(histo,[081 0 255]);
    end
    Name = strcat(file,' > Rotate (',num2str(Deg),')');    
    
elseif handles.bTrans.Value==1
    %get function parameters
    Right=str2double(handles.tRight.String(handles.tRight.Value));  
    Down=str2double(handles.tDown.String(handles.tDown.Value));     
    if handles.TranFill.Value       %wrap with gray value
        Gray=str2double(handles.tGray.String(handles.tGray.Value));
    else
        Gray='Not';
    end
    OutIma = translate_cvip( InIma, [Down Right], Gray);%call translate fn
    %update image history
    histo = [067 Down Right sum(Gray)];
    Name = strcat(file,' > Translate(',num2str(Right),',',num2str(Down),...
        ',',num2str(Gray),')');
    
elseif handles.bZoom.Value==1
    %get function parameters
    zoom=str2double(handles.zBy.String(handles.zBy.Value));
    Meth=handles.zUse.Value-1;
    Way=handles.bZoom.UserData;
    [Zoom, Shi] = rat(zoom);
    if strcmp(Way,'def')
        %get function parameters
        Col=str2double(handles.zAcol.String(handles.zAcol.Value));
        Row=str2double(handles.zArow.String(handles.zArow.Value)); 
        Width=str2double(handles.zAwidth.String(handles.zAwidth.Value)); 
        Height=str2double(handles.zAheight.String(handles.zAheight.Value)); 
        %call Zoom function
        OutIma = zoom_cvip(InIma,'def',Zoom, Meth, [Row  Col], [Height Width]);
        %update image history
        histo = [068 0 Zoom Meth Row Col Height Width];
    else
        OutIma = zoom_cvip(InIma,Way,Zoom, Meth);%call Zoom function
        switch Way
            case 'ul'
                zone = 1;
            case 'ur'
                zone = 2;
            case 'll'
                zone = 3;
            case 'lr'
                zone = 4;
            case 'all'
                zone = 5;
        end
        %update image history
        histo = [068 zone Zoom Meth];
    end
    if Shi > 1                  %peform image shrinking
        OutIma = shrink_cvip( OutIma, 1/Shi);
        %update image history
        histo = historyupdate_cvip(histo,[065 1/Shi]);
    end
    Name = strcat(file,' > Zoom (',Way,',',num2str(zoom),',',num2str(Meth),')');
end

%check if need to save history
if strcmp(hSHisto(1).Checked,'on')	%save new image history
    Ima.fInfo.history_info = historyupdate_cvip(Ima.fInfo.history_info,histo);  
end
%check if need to show function information
if strcmp(hVfinfo(1).Checked,'on')
    hIlist = findobj('Tag','txtIlist');%get handle of text element
    hIlist.String(end+1,1)=' ';   	%print an empty line
    txtInfo = 	(histo);     
    hIlist.String(end+1,1:size(file,2)+1)=[file ':']; 
    for i=1:size(txtInfo)
        sInfo = txtInfo{i};     	%exract row to print
        sInfo = sprintf(sInfo);
        [~,rr] = size(sInfo);
        hIlist.String(end+1,1:rr) = sInfo;
    end
    hIlist.Value = size(hIlist.String,1);%goto last line
    figure(hMain);
end
[row,col,band]=size(OutIma);      	%get new image size
%update image information
Ima.fInfo.no_of_bands=band;             
Ima.fInfo.no_of_cols=col;              
Ima.fInfo.no_of_rows=row;
%update image structure
Ima.cvipIma = OutIma;               %read image data
showgui_cvip(Ima, Name);            %show image in viewer
else                                %display error message
    errordlg(['There is nothing to process. Please select an Image and'...
        ' try again.'],'Geometry Error','modal');
end

%changing pointer watch back to arrow on cursor
set(figure_set,'pointer','arrow');


% --- Executes on button press in bCancel.
function bCancel_Callback(hObject, eventdata, handles)
% hObject    handle to bCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Prepare to close application window
 close(handles.Geom)


% --- Executes on button press in bReset.
function bReset_Callback(hObject, eventdata, handles)
% hObject    handle to bReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cpBIma1.
function cpBIma1_Callback(hObject, eventdata, handles)
% hObject    handle to cpBIma1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMain = findobj('Tag','Main');      %get the handle of Main form
hNfig = hMain.UserData;             %get image handle
file=get(hNfig,'Name');             %get image name
hObject.UserData=hNfig.UserData;   %save image info into object
handles.cpIma1.String = file;       %show ima info

% --- Executes on button press in cpBIma2.
function cpBIma2_Callback(hObject, eventdata, handles)
% hObject    handle to cpBIma2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMain = findobj('Tag','Main');      %get the handle of Main form
hNfig = hMain.UserData;             %get image handle
file=get(hNfig,'Name');             %get image name
hObject.UserData=hNfig.UserData;   %save image info into object
handles.cpIma2.String = file;       %show ima info


% --- Executes on button press in bCrop.
function bCrop_Callback(hObject, eventdata, handles)
% hObject    handle to bCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bCrop


% --- Executes on button press in bRota.
function bRota_Callback(hObject, eventdata, handles)
% hObject    handle to bRota (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bRota


% --- Executes on button press in bTrans.
function bTrans_Callback(hObject, eventdata, handles)
% hObject    handle to bTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of 


% --- Executes on button press in bZoom.
function bZoom_Callback(hObject, eventdata, handles)
% hObject    handle to bZoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bZoom


% --- Executes on button press in bResz.
function bResz_Callback(hObject, eventdata, handles)
% hObject    handle to bResz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bResz


% --- Executes on selection change in wCrop.
function wCrop_Callback(hObject, eventdata, handles)
% hObject    handle to wCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns wCrop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from wCrop


% --- Executes during object creation, after setting all properties.
function wCrop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in rCrop.
function rCrop_Callback(hObject, eventdata, handles)
% hObject    handle to rCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns rCrop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rCrop

% --- Executes during object creation, after setting all properties.
function rCrop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in hCrop.
function hCrop_Callback(hObject, eventdata, handles)
% hObject    handle to hCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns hCrop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from hCrop

% --- Executes during object creation, after setting all properties.
function hCrop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in wRsz.
function wRsz_Callback(hObject, eventdata, handles)
% hObject    handle to wRsz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns wRsz contents as cell array
%        contents{get(hObject,'Value')} returns selected item from wRsz
clc;
hMain = findobj('Tag','Main');  %get the handle of Main form
hNfig = hMain.UserData;         %get image handle

%check for Image to process
if hNfig ~= 0 && isfield(hNfig.UserData,'cvipIma') 
Ima=hNfig.UserData;          %read image info
InIma = Ima.cvipIma;   %read image data

[row,col,band]=size(InIma);      %size of input image
Col=str2double(handles.wRsz.String(handles.wRsz.Value)); %returns resize width
Row=str2double(handles.hRsz.String(handles.hRsz.Value)); %returns returns Height

if Col < col && Row < row
    handles.lblRed.Visible = 'On';
    handles.popRed.Visible = 'On';
else
    handles.lblRed.Visible = 'Off';
    handles.popRed.Visible = 'Off';
end

else                                %display error message
    errordlg(['There is nothing to process. Please select an Image and'...
        ' try again.'],'Geometry Error','modal');
end

% --- Executes during object creation, after setting all properties.
function wRsz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wRsz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in hRsz.
function hRsz_Callback(hObject, eventdata, handles)
% hObject    handle to hRsz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns hRsz contents as cell array
%        contents{get(hObject,'Value')} returns selected item from hRsz
clc;
hMain = findobj('Tag','Main');  %get the handle of Main form
hNfig = hMain.UserData;         %get image handle

%check for Image to process
if hNfig ~= 0 && isfield(hNfig.UserData,'cvipIma') 
Ima=hNfig.UserData;          %read image info
InIma = Ima.cvipIma;   %read image data
[row,col,~]=size(InIma);      %size of input image
Col=str2double(handles.wRsz.String(handles.wRsz.Value)); %returns resize width
Row=str2double(handles.hRsz.String(handles.hRsz.Value)); %returns returns Height

if Col < col && Row < row
    handles.lblRed.Visible = 'On';
    handles.popRed.Visible = 'On';
else
    handles.lblRed.Visible = 'Off';
    handles.popRed.Visible = 'Off';
end

else                                %display error message
    errordlg(['There is nothing to process. Please select an Image and'...
        ' try again.'],'Geometry Error','modal');
end

% --- Executes during object creation, after setting all properties.
function hRsz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hRsz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in rDeg.
function rDeg_Callback(hObject, eventdata, handles)
% hObject    handle to rDeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns rDeg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rDeg

% --- Executes during object creation, after setting all properties.
function rDeg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rDeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tGray.
function tGray_Callback(hObject, eventdata, handles)
% hObject    handle to tGray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tGray contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tGray

% --- Executes during object creation, after setting all properties.
function tGray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tGray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tRight.
function tRight_Callback(hObject, eventdata, handles)
% hObject    handle to tRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tRight contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tRight

% --- Executes during object creation, after setting all properties.
function tRight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tDown.
function tDown_Callback(hObject, eventdata, handles)
% hObject    handle to tDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tDown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tDown

% --- Executes during object creation, after setting all properties.
function tDown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in zBy.
function zBy_Callback(hObject, eventdata, handles)
% hObject    handle to zBy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns zBy contents as cell array
%        contents{get(hObject,'Value')} returns selected item from zBy

% --- Executes during object creation, after setting all properties.
function zBy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zBy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in zUse.
function zUse_Callback(hObject, eventdata, handles)
% hObject    handle to zUse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns zUse contents as cell array
%        contents{get(hObject,'Value')} returns selected item from zUse


% --- Executes during object creation, after setting all properties.
function zUse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zUse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in zAcol.
function zAcol_Callback(hObject, eventdata, handles)
% hObject    handle to zAcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns zAcol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from zAcol

% --- Executes during object creation, after setting all properties.
function zAcol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zAcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in zArow.
function zArow_Callback(hObject, eventdata, handles)
% hObject    handle to zArow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns zArow contents as cell array
%        contents{get(hObject,'Value')} returns selected item from zArow

% --- Executes during object creation, after setting all properties.
function zArow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zArow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in zAwidth.
function zAwidth_Callback(hObject, eventdata, handles)
% hObject    handle to zAwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns zAwidth contents as cell array
%        contents{get(hObject,'Value')} returns selected item from zAwidth

% --- Executes during object creation, after setting all properties.
function zAwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zAwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in zAheight.
function zAheight_Callback(hObject, eventdata, handles)
% hObject    handle to zAheight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns zAheight contents as cell array
%        contents{get(hObject,'Value')} returns selected item from zAheight

% --- Executes during object creation, after setting all properties.
function zAheight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zAheight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in zUL.
function zUL_Callback(hObject, eventdata, handles)
% hObject    handle to zUL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zUL
handles.bZoom.UserData = 'ul';


% --- Executes on button press in zUR.
function zUR_Callback(hObject, eventdata, handles)
% hObject    handle to zUR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zUR
handles.bZoom.UserData = 'ur';

% --- Executes on button press in zLL.
function zLL_Callback(hObject, eventdata, handles)
% hObject    handle to zLL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zLL
handles.bZoom.UserData = 'll';

% --- Executes on button press in zLR.
function zLR_Callback(hObject, eventdata, handles)
% hObject    handle to zLR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zLR
handles.bZoom.UserData = 'lr';

% --- Executes on button press in bZArea.
function bZArea_Callback(hObject, eventdata, handles)
% hObject    handle to bZArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bZArea
handles.bZoom.UserData = 'def';

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over zUL.
function zUL_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to zUL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in zAll.
function zAll_Callback(hObject, eventdata, handles)
% hObject    handle to zAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zAll
handles.bZoom.UserData = 'all';

% --- Executes on selection change in popRed.
function popRed_Callback(hObject, eventdata, handles)
% hObject    handle to popRed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popRed contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popRed


% --- Executes during object creation, after setting all properties.
function popRed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popRed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in cCrop.
function cCrop_Callback(hObject, eventdata, handles)
% hObject    handle to cCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cCrop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cCrop


% --- Executes during object creation, after setting all properties.
function cCrop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function cpIma1_Callback(hObject, eventdata, handles)
% hObject    handle to cpIma1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cpIma1 as text
%        str2double(get(hObject,'String')) returns contents of cpIma1 as a double


% --- Executes during object creation, after setting all properties.
function cpIma1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cpIma1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cpIma2_Callback(hObject, eventdata, handles)
% hObject    handle to cpIma2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cpIma2 as text
%        str2double(get(hObject,'String')) returns contents of cpIma2 as a double


% --- Executes during object creation, after setting all properties.
function cpIma2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cpIma2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cpTrans.
function cpTrans_Callback(hObject, eventdata, handles)
% hObject    handle to cpTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cpTrans


% --- Executes on selection change in cpCol.
function cpCol_Callback(hObject, eventdata, handles)
% hObject    handle to cpCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cpCol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cpCol


% --- Executes during object creation, after setting all properties.
function cpCol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cpCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cpRow.
function cpRow_Callback(hObject, eventdata, handles)
% hObject    handle to cpRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cpRow contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cpRow


% --- Executes during object creation, after setting all properties.
function cpRow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cpRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in TranFill.
function TranFill_Callback(hObject, eventdata, handles)
% hObject    handle to TranFill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TranFill
if hObject.Value
    handles.tGray.Enable = 'on';
else
    handles.tGray.Enable = 'off';
end


% --- Executes on key press with focus on cCrop and none of its controls.
function cCrop_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to cCrop (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data


% --- Executes on key press with focus on rCrop and none of its controls.
function rCrop_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to rCrop (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data


% --- Executes on key press with focus on wCrop and none of its controls.
function wCrop_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to wCrop (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on hCrop and none of its controls.
function hCrop_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to hCrop (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on cpCol and none of its controls.
function cpCol_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to cpCol (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on cpRow and none of its controls.
function cpRow_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to cpRow (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on wRsz and none of its controls.
function wRsz_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to wRsz (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on hRsz and none of its controls.
function hRsz_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to hRsz (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on rDeg and none of its controls.
function rDeg_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to rDeg (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on tRight and none of its controls.
function tRight_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to tRight (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on tDown and none of its controls.
function tDown_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to tDown (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on zAcol and none of its controls.
function zAcol_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to zAcol (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on zArow and none of its controls.
function zArow_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to zArow (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on zAwidth and none of its controls.
function zAwidth_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to zAwidth (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on zAheight and none of its controls.
function zAheight_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to zAheight (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on zBy and none of its controls.
function zBy_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to zBy (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data


% --- Executes on key press with focus on tGray and none of its controls.
function tGray_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to tGray (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

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
function uifOPen_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uifOPen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMain = findobj('Tag','Main');              %get the handle of Main form
% get handles and other user-defined data associated to Gui1
g1data = guidata(hMain);
if ~isempty(hMain)
    CVIPToolbox('fOpen_Callback',g1data.fOpen,eventdata,guidata(g1data.fOpen))
end

% --------------------------------------------------------------------
function uifSave_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uifSave (see GCBO)
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
