function varargout = NewFig(varargin)
% NEWFIG MATLAB code for NewFig.fig
%      NEWFIG, by itself, creates a new NEWFIG or raises the existing
%      singleton*.
%
%      H = NEWFIG returns the handle to a new NEWFIG or the handle to
%      the existing singleton*.
%
%      NEWFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEWFIG.M with the given input arguments.
%
%      NEWFIG('Property','Value',...) creates a new NEWFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NewFig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NewFig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NewFig

% Last Modified by GUIDE v2.5 07-Jul-2019 14:23:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NewFig_OpeningFcn, ...
                   'gui_OutputFcn',  @NewFig_OutputFcn, ...
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
%           Latest update date:     01/25/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
% 
 % Revision 1.6  05/03/2019  17:45:13  jucuell 
 % adding view histogram, extract red, green and blue bands functions and
 % toolbar icons. 
%
 % Revision 1.5  01/25/2019  16:23:39  jucuell
 % detection of figure DlgTrans to detect selected image size and calculate
 % the high power of 2 value for the block size
% 
 % Revision 1.4  01/12/2019  16:23:21  jucuell
 % image data type is obtained directly from InIma data
% 
 % Revision 1.3  12/12/2018  15:21:14  jucuell
 % updating menu creation programmatically, callbacks to Main figure and
 % the use of the utilities menus in the Main figure.
%
 % Revision 1.2  04/03/2018  16:09:55  jucuell
 %  
 % 
%
 % Revision 1.1  11/21/2017  15:23:31  jucuell
 % Initial coding and testing.
 % 
%

% --- Executes just before NewFig is made visible.
function NewFig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NewFig (see VARARGIN)

% Choose default command line output for NewFig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% create figure menus linked to menu functions in CVIPToolbox figure
menus = menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';   %hide Analysis menu
handles.mView.Visible = 'Off';  %hide View menu
menus(1).Visible = 'Off';      %hide histogram button
menus(2).Visible = 'Off';      %hide Red button
menus(3).Visible = 'Off';      %hide Green button
menus(4).Visible = 'Off';      %hide Blue button


% --- Outputs from this function are returned to the command line.
function varargout = NewFig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function NewFig_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to NewFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get the handle of Gui1
 hMain = findobj('Tag','Main');
 % if exists (not empty)
 if ~isempty(hMain)
    % get handles and other user-defined data associated to Gui1
    %g1data = guidata(h);
    % maybe you want to set the text in Gui2 with that from Gui1
    set(hMain,'UserData',hObject);
    % maybe you want to get some data that was saved to the Gui1 app
%     x = getappdata(h,'x');
    %check if DlgTrans is open to parse blocksize
    hTrans = findobj('Tag','Trans');
    if ~isempty(hTrans)
        [r, c, ~] = size(hObject.UserData.cvipIma);
        siz = max(2.^nextpow2([r c]));% find the next power of 2
        gdata = guidata(hTrans);    %get GUI data
        if siz < 1000
            gdata.popBlock.Value = log2(siz);
        else
            gdata.popBlock.String(10) = {siz};
            gdata.popBlock.Value = 10;
        end
    end
    %check if DlgFeat is open to parse image coordinates
    hFeat = findobj('Tag','Feat');
    if ~isempty(hFeat)
        gdata = guidata(hFeat);     %get GUI data
        if gdata.cAssi.Value        %capture coordinates
            [x,y] = ginput(1);      %get 1 point from screen
%             dcm_obj = datacursormode(hObject);
%             set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex',...
%                 'on','Enable','on');
%             c_info = getCursorInfo(dcm_obj);
%             if isempty(c_info)
%                 
%             else
%                 gdata.txtCol.String = c_info.Position(1);
%                 gdata.txtRow.String = c_info.Position(2);
%             end
%             datacursormode(hObject,'off');
%             delete(findall(hObject,'Type','hggroup'));
              gdata.txtCol.String = round(x);
              gdata.txtRow.String = round(y);
        end

    end
 end

 function NewFig_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to NewFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function uifOpen_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uifOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMain = findobj('Tag','Main');              %get the handle of Main form
% get handles and other user-defined data associated to Gui1
g1data = guidata(hMain);
if ~isempty(hMain)
    CVIPToolbox('fOpen_Callback',g1data.fOpen,eventdata,guidata(g1data.fOpen))
end


% --------------------------------------------------------------------
function mFile_Callback(hObject, eventdata, handles)
% hObject    handle to mFile (see GCBO)
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


% --- Executes when user attempts to close NewFig.
function NewFig_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to NewFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hMain = findobj('Tag','Main');              %get the handle of Main form
if ~isempty(hMain)
    set(hMain,'UserData',0);          %get last image handle
end
% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes when NewFig is resized.
function NewFig_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to NewFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%check if image was previously drawn to show image info
if strcmp(handles.axes1.UserData, 'NO') || isempty(handles.axes1.UserData)
    InIma = handles.axes1.Children; % before we used: getimage(hObject);
    if ~isempty(InIma)
        InIma = InIma.CData;
        if isfield(hObject.UserData,'cvipIma')
            InIma = hObject.UserData.cvipIma;
        end
        %get and show image information
        [row, col, band] = size(InIma);
        
        if strcmp(hObject.UserData.fInfo.color_format,'rgb')
            handles.txtCfto.String = 'RGB';
        else
            handles.txtCfto.String = 'GRAY';
        end
        handles.txtIfto.String = upper(hObject.UserData.fInfo.image_format);
        handles.txtDfto.String = upper(hObject.UserData.fInfo.data_format);
        if strcmp(handles.txtDfto.String,'COMPLEX')
            imin = min(min(real(InIma(:))),min(imag(InIma(:))));
            imax = max(max(real(InIma(:))),max(imag(InIma(:))));
        else
            imin = min(InIma(:));
            imax = max(InIma(:));
        end
        
        Type = class(InIma);        %get image data type
        switch Type
            case 'uint8'
                Txt = 'BYTE';
            case 'uint16'
                Txt = 'SHORT';
            case 'int64'
                Txt = 'INTEGER';
            case 'single'
                Txt = 'FLOAT';
            case 'double'
                Txt = 'DOUBLE';
            case 'logical'
                Txt = 'LOGICAL';
        end
        handles.txtDtyp.String = Txt;
        handles.txtDrMin.String = num2str(imin,'%8.2f');
        handles.txtDrMax.String = num2str(imax,'%8.2f');
        handles.txtRows.String = row;
        handles.txtCols.String = col;
        handles.txtBands.String = band;

        set(handles.axes1, 'UserData', 'YES');
    else
        set(handles.axes1, 'UserData', 'NO');
    end
end
Pos = handles.NewFig.Position;
handles.axes1.Position = [3 3 Pos(3)-6 Pos(4)-3];


% --- Executes during object creation, after setting all properties.
function NewFig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NewFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function txtCfto_Callback(hObject, eventdata, handles)
% hObject    handle to txtCfto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtCfto as text
%        str2double(get(hObject,'String')) returns contents of txtCfto as a double


% --- Executes during object creation, after setting all properties.
function txtCfto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtCfto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txtIfto_Callback(hObject, eventdata, handles)
% hObject    handle to txtIfto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtIfto as text
%        str2double(get(hObject,'String')) returns contents of txtIfto as a double


% --- Executes during object creation, after setting all properties.
function txtIfto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtIfto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txtDfto_Callback(hObject, eventdata, handles)
% hObject    handle to txtDfto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtDfto as text
%        str2double(get(hObject,'String')) returns contents of txtDfto as a double


% --- Executes during object creation, after setting all properties.
function txtDfto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtDfto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txtDtyp_Callback(hObject, eventdata, handles)
% hObject    handle to txtDtyp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtDtyp as text
%        str2double(get(hObject,'String')) returns contents of txtDtyp as a double


% --- Executes during object creation, after setting all properties.
function txtDtyp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtDtyp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txtDrMin_Callback(hObject, eventdata, handles)
% hObject    handle to txtDrMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtDrMin as text
%        str2double(get(hObject,'String')) returns contents of txtDrMin as a double


% --- Executes during object creation, after setting all properties.
function txtDrMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtDrMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txtDrMax_Callback(hObject, eventdata, handles)
% hObject    handle to txtDrMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtDrMax as text
%        str2double(get(hObject,'String')) returns contents of txtDrMax as a double


% --- Executes during object creation, after setting all properties.
function txtDrMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtDrMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txtRows_Callback(hObject, eventdata, handles)
% hObject    handle to txtRows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtRows as text
%        str2double(get(hObject,'String')) returns contents of txtRows as a double


% --- Executes during object creation, after setting all properties.
function txtRows_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtRows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txtCols_Callback(hObject, eventdata, handles)
% hObject    handle to txtCols (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtCols as text
%        str2double(get(hObject,'String')) returns contents of txtCols as a double


% --- Executes during object creation, after setting all properties.
function txtCols_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtCols (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txtBands_Callback(hObject, eventdata, handles)
% hObject    handle to txtBands (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBands as text
%        str2double(get(hObject,'String')) returns contents of txtBands as a double


% --- Executes during object creation, after setting all properties.
function txtBands_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBands (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function mView_Callback(hObject, eventdata, handles)
% hObject    handle to mView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mVfi_Callback(hObject, eventdata, handles)
% hObject    handle to mVfi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hVfun = findobj('Tag','mVfi');
hIlist = findobj('Tag','txtIlist');
if strcmp(hObject.Checked,'off')
    for i=1:size(hVfun,1)
        hVfun(i).Checked = 'on';
    end
    hIlist.Visible = 'On';
else
    for i=1:size(hVfun,1)
        hVfun(i).Checked = 'off';
    end
    hIlist.Visible = 'Off';
end

% --------------------------------------------------------------------
function mViHis_Callback(hObject, eventdata, handles)
% hObject    handle to mViHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mVvimaHis_Callback(hObject, eventdata, handles)
% hObject    handle to mVvimaHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMain = findobj('Tag','Main');              %get the handle of Main form
% get handles and other user-defined data associated to Gui1
g1data = guidata(hMain);
if ~isempty(hMain)
    CVIPToolbox('mVvimaHis_Callback',g1data.mVvimaHis,eventdata,guidata(hMain))
end

% --------------------------------------------------------------------
function mVsaveHis_Callback(hObject, eventdata, handles)
% hObject    handle to mVsaveHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hShist = findobj('Tag','mVsaveHis');
if strcmp(hObject.Checked,'off')
    for i=1:size(hShist,1)
        hShist(i).Checked = 'on';
    end
else
    for i=1:size(hShist,1)
        hShist(i).Checked = 'off';
    end
end


% --------------------------------------------------------------------
function uivData_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uivData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(hObject.State, 'on')
    h = datacursormode(handles.NewFig);
    h.UpdateFcn = {@myupdatefcn, handles.NewFig.UserData.cvipIma};
    h.SnapToDataVertex = 'on';
    h.Enable = 'on';
else
    datacursormode(handles.NewFig,'off');
    delete(findall(handles.NewFig,'Type','hggroup'));
end


function [txt] = myupdatefcn(~,event_obj, cvipIma)
% Display 'Time' and 'Amplitude'
pos = event_obj.Position;
bands = size(event_obj.Target.CData,3);
if bands == 1
    txt = {['Col: ',num2str(pos(1)) ', Row: ',num2str(pos(2))],...
        ['GrayLevel: ' num2str(event_obj.Target.CData(pos(2),pos(1),1))],...
        ['Value: ' num2str(cvipIma(pos(2),pos(1),1))]};
else
    txt = {['Col: ',num2str(pos(1)) ', Row: ',num2str(pos(2))],...
        ['R: ' num2str(event_obj.Target.CData(pos(2),pos(1),1))...
        ', G: ' num2str(event_obj.Target.CData(pos(2),pos(1),2))...
        ', B: ' num2str(event_obj.Target.CData(pos(2),pos(1),3))],...
        ['Rv: ' num2str(cvipIma(pos(2),pos(1),1))...
        ', Gv: ' num2str(cvipIma(pos(2),pos(1),2))...
        ', Bv: ' num2str(cvipIma(pos(2),pos(1),3))]};
end


% --------------------------------------------------------------------
function mFigData_Callback(hObject, eventdata, handles)
% hObject    handle to mFigData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.uivData.State = 'On';
%hObject.Checked = 'On';
uivData_ClickedCallback(handles.uivData, eventdata, handles)

% --------------------------------------------------------------------
function mFigInfo_Callback(hObject, eventdata, handles)
% hObject    handle to mFigInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mFigHisto_Callback(hObject, eventdata, handles)
% hObject    handle to mFigHisto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mFig_Callback(hObject, eventdata, handles)
% hObject    handle to mFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
