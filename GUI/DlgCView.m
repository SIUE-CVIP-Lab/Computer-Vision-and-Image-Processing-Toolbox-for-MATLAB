function varargout = DlgCView(varargin)
% DLGCVIEW MATLAB code for DlgCView.fig
%      DLGCVIEW, by itself, creates a new DLGCVIEW or raises the existing
%      singleton*.
%
%      H = DLGCVIEW returns the handle to a new DLGCVIEW or the handle to
%      the existing singleton*.
%
%      DLGCVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DLGCVIEW.M with the given input arguments.
%
%      DLGCVIEW('Property','Value',...) creates a new DLGCVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgCView_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgCView_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DlgCView

% Last Modified by GUIDE v2.5 11-Feb-2019 10:00:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgCView_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgCView_OutputFcn, ...
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


% --- Executes just before DlgCView is made visible.
function DlgCView_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DlgCView (see VARARGIN)

% Choose default command line output for DlgCView
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';%hide Analysis menu

% --- Outputs from this function are returned to the command line.
function varargout = DlgCView_OutputFcn(hObject, eventdata, handles) 
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
 close(handles.CView)


% --- Executes on button press in bReset.
function bReset_Callback(hObject, eventdata, handles)
% hObject    handle to bReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bApply.
function bApply_Callback(hObject, eventdata, handles)
% hObject    handle to bApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc

%changing pointer arrow to watch on cursor
figure_set = findall(groot,'Type','Figure');
set(figure_set,'pointer','watch');

%open file selection dialog box to input image
[filename, pathname, index] = uiputfile({'*.csv','Comma delimited(*.csv)';...
    '*.xls','Excel 97-2003 Workbook (*.xls)'}, ...
    'Save Features as','Features'); %mulitple file selection option is OFF, single image file only 

%check if user has successfuly made the file selection
if ~isequal(filename,0)
    % save image according to file type
    if index == 1       %save .csv format
        outFile = [pwd '\Features\' filename];
        if ~strcmp(outFile(end-3:end), '.csv')    % the extension should be .csv
            outFile = [outFile '.csv'];     % so we append it to out_file_name if it does not end with '.csv'.
        end
        fid = fopen(outFile, 'w') ;
        fprintf(fid, '%s,', handles.TabCres.ColumnName{1:end-1,1});
        fprintf(fid, '%s\n', handles.TabCres.ColumnName{end,1});
        rows = size(handles.TabCres.Data,1);
        for i=1:rows
            fprintf(fid, '%d,', handles.TabCres.Data{i,1:end-1});
            if strcmp(handles.TabCres.ColumnName{end,1},'Class')
                fprintf(fid, '%s\n', handles.TabCres.Data{i,end});
            else
                fprintf(fid, '%d\n', handles.TabCres.Data{i,end});
            end
        end
        fclose(fid) ;
    else                %save .xls format
        outFile = [pwd '\Features\' filename];
        if ~strcmp(outFile(end-3:end), '.xls')    % the extension should be .csv
            outFile = [outFile '.xls'];     % so we append it to out_file_name if it does not end with '.xls'.
        end
        fid = fopen(outFile, 'w') ;
        fprintf(fid, '%s,', handles.TabCres.ColumnName{1,1:end-1}) ;
        fprintf(fid, '%s\n', handles.TabCres.ColumnName{1,end}) ;
        rows = size(handles.TabCres.Data,1);
        for i=2:rows
            fprintf(fid, '%d,', handles.TabCres.Data{i,1:end-1}) ;
            fprintf(fid, '%d\n', handles.TabCres.Data{i,end}) ;
        end
        fclose(fid) ;
    end
end

%changing pointer watch back to arrow on cursor
set(figure_set,'pointer','arrow');


% --- Executes when CView is resized.
function CView_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to CView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~strcmp(handles.CView.UserData,'NO')
    Titles = handles.CView.UserData.Titles;
    Titles = Titles(2:end-1);
    siza = size(Titles,2);%number of features
    
    %populate Features Table
    n = floor(siza/6);
    l = 6-mod(siza,6);
    Titles(end+1:end+l)={char(1,l)};
    FData = reshape(Titles,n+1,6);
    handles.TabFeat.Data = FData;
    handles.TabFeat.ColumnWidth = [{83},{83},{83},{83},{83},{83}];
    
    %populate Classification Parameters
    handles.listInfo.String = {''};
    for i=1:size(handles.CView.UserData.ClaPar,1)
        if i==1
            handles.listInfo.String(i) = {[handles.CView.UserData.ClaPar{2,1}...
            '  ' handles.CView.UserData.ClaPar{2,2}]};
        elseif i==2
            handles.listInfo.String(i)={' '};
        else
            handles.listInfo.String(i) = {[handles.CView.UserData.ClaPar{i,1}...
            '  ' handles.CView.UserData.ClaPar{i,2}]};
        end
    end
    handles.listInfo.Value = 2;
    siza = size(handles.listInfo.String,1);
    for i=siza+1:siza+size(handles.CView.UserData.FeatIn,1)
        handles.listInfo.String(i) = {[handles.CView.UserData.FeatIn{i-siza,1}...
        '  ' num2str(handles.CView.UserData.FeatIn{i-siza,2})]};
    end
    
    %populate Classification Results
    handles.TabCres.Data = handles.CView.UserData.ClaRes(2:end,3:end);
    handles.TabCres.ColumnName = handles.CView.UserData.ClaRes(1,3:end);
    handles.TabCres.RowName = handles.CView.UserData.ClaRes(2:end,2);
    
    %populate Table Test Set Info
    handles.TabCInfo.Data = handles.CView.UserData.ClaInf(3:end,:);
    handles.TabCInfo.ColumnWidth = [{200},{90},{90},{105}];
    handles.TabCInfo.ColumnName = handles.CView.UserData.ClaInf(2,:);
    
%adjust Tables position
%Test Set Info Table
siza = size(handles.TabCInfo.Data,1);
if siza > 10
    height = 17;
else
    height = siza*1.5+1.3;
end
handles.TabCInfo.Position = [5 5 110 height];
pos = handles.TabCInfo.Position;
po2 = handles.lblTest.Position;
handles.lblTest.Position = [pos(1)+18 pos(2)+height po2(3) po2(4)];

%Features Info Table
siza = size(handles.TabFeat.Data,1);
if siza > 10
    height = 16;
else
    height = siza*1.65+1.8;
end
handles.TabFeat.Position = [5 pos(2)+pos(4)+2 110 height];
pos = handles.TabFeat.Position;
po2 = handles.lblFeat.Position;
handles.lblFeat.Position = [pos(1)+18 pos(2)+height po2(3) po2(4)];

%Classification Info Parameters
handles.listInfo.Position = [5 pos(2)+pos(4)+2 110 13];
pos = handles.listInfo.Position;

%Classification Results Table
siza = size(handles.TabCres.Data);
height = (siza(1)+1)*1.5;
width = (siza(2)+1)*16;
handles.TabCres.Position = [15 pos(2)+pos(4)+2 width height];
pos = handles.TabCres.Position;
handles.lblClas.Position = [23 pos(2)+pos(4) 50 1.5];
po2 = handles.lblCtest.Position;
handles.lblCtest.Position = [2.5 pos(2)+0.6 po2(3) po2(4)];    
    
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
function uifOPen_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uifOPen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('fOpen_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function uifSave_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uifSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('fSave_Callback',hObject,eventdata,guidata(hObject))


% --- Executes on selection change in listInfo.
function listInfo_Callback(hObject, eventdata, handles)
% hObject    handle to listInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listInfo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listInfo


% --- Executes during object creation, after setting all properties.
function listInfo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
