function varargout = DlgFView(varargin)
% DLGFVIEW MATLAB code for DlgFView.fig
%      DLGFVIEW, by itself, creates a new DLGFVIEW or raises the existing
%      singleton*.
%
%      H = DLGFVIEW returns the handle to a new DLGFVIEW or the handle to
%      the existing singleton*.
%
%      DLGFVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DLGFVIEW.M with the given input arguments.
%
%      DLGFVIEW('Property','Value',...) creates a new DLGFVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgFView_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgFView_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DlgFView

% Last Modified by GUIDE v2.5 18-Jun-2018 10:30:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgFView_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgFView_OutputFcn, ...
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


% --- Executes just before DlgFView is made visible.
function DlgFView_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DlgFView (see VARARGIN)

% Choose default command line output for DlgFView
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);

% --- Outputs from this function are returned to the command line.
function varargout = DlgFView_OutputFcn(hObject, eventdata, handles) 
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
 close(handles.FView)


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
        fprintf(fid, '%s,', handles.TabFeat.ColumnName{1:end-1,1});
        fprintf(fid, '%s\n', handles.TabFeat.ColumnName{end,1});
        rows = size(handles.TabFeat.Data,1);
        for i=1:rows
            fprintf(fid, '%d,', handles.TabFeat.Data{i,1:end-1});
            if strcmp(handles.TabFeat.ColumnName{end,1},'Class')
                fprintf(fid, '%s\n', handles.TabFeat.Data{i,end});
            else
                fprintf(fid, '%d\n', handles.TabFeat.Data{i,end});
            end
        end
        fclose(fid) ;
    else                %save .xls format
        outFile = [pwd '\Features\' filename];
        if ~strcmp(outFile(end-3:end), '.xls')    % the extension should be .csv
            outFile = [outFile '.xls'];     % so we append it to out_file_name if it does not end with '.xls'.
        end
        fid = fopen(outFile, 'w') ;
        fprintf(fid, '%s,', handles.TabFeat.ColumnName{1,1:end-1}) ;
        fprintf(fid, '%s\n', handles.TabFeat.ColumnName{1,end}) ;
        rows = size(handles.TabFeat.Data,1);
        for i=2:rows
            fprintf(fid, '%d,', handles.TabFeat.Data{i,1:end-1}) ;
            fprintf(fid, '%d\n', handles.TabFeat.Data{i,end}) ;
        end
        fclose(fid) ;
    end
end

%changing pointer watch back to arrow on cursor
set(figure_set,'pointer','arrow');


% Data = handles.FView.UserData(2:end,2:end); 
%         titles=handles.FView.UserData(1,2:end);
%         handles.TabFeat.RowName = handles.FView.UserData(2:end,1);
%         %change format to text to see 5 decimal points
%         for i=1:siza(1)-1
%             for j=1:siza(1)-1
%                 Data{i,j}=sprintf('%.5f',Data{i,j});
%                 Data{i,j}=sprintf('%+9s',Data{i,j});
%             end
%         end
%     else
%         Data = handles.FView.UserData(2:siza(1),:);
%     end
%     handles.TabFeat.Data = Data;
%     handles.TabFeat.ColumnName = titles;
    
    
 


% --- Executes when FView is resized.
function FView_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to FView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~strcmp(handles.FView.UserData,'NO')
    %warndlg('There is not Feature File Information to show','Features Warning','modal');
    siza = size(handles.FView.UserData);
    titles=handles.FView.UserData(1,:);
    if isa(handles.FView.UserData, 'table')
        Data = cell(siza);
        for i=1:siza(1)
            for j=1:siza(2)
                if j==siza(2)
                    Data{i,j} = handles.FView.UserData{i,j}{1,1};
                elseif j==1
                    Data{i,j} = handles.FView.UserData{i,j}{1,1};
                else
                    Data{i,j} = handles.FView.UserData{i,j};
                end
            end
        end
        titles = handles.FView.UserData.Properties.VariableNames;
    else
        if strcmp(titles{2}, 'Train FV.1')      %distance/similarity metric
            Data = handles.FView.UserData(2:end,2:end); 
            titles=handles.FView.UserData(1,2:end);
            handles.TabFeat.RowName = handles.FView.UserData(2:end,1);
            %change format to text to see 5 decimal points
            for i=1:siza(1)-1
                for j=1:siza(1)-1
                    Data{i,j}=sprintf('%.5f',Data{i,j});
                    Data{i,j}=sprintf('%+9s',Data{i,j});
                end
            end
        else
            Data = handles.FView.UserData(2:siza(1),:);
        end
    end
    handles.TabFeat.Data = Data;
    handles.TabFeat.ColumnName = titles;
    handles.FView.UserData = [{'NO'},{'NO'}];

end
pos = handles.FView.Position;
height = 1.7;

cols=size(handles.TabFeat.ColumnName,1);
ColW = cell(1,cols);
sum=0;
%%STRORE ALL RESULTS AS CELLS/... : FEATURE OBJECTS LABELED
if ~strcmp(handles.TabFeat.Data(1,1),'')
    stats = cell(2,cols);
    for i=1:cols
        if strcmp(class(handles.TabFeat.Data{1,i}),'double') && i~=1
            d = max(cell2mat(handles.TabFeat.Data(:,i)));
            d = max(size(num2str(d)))+3;
            %compute stats
            Dmean = mean(cell2mat(handles.TabFeat.Data(:,i)));
            Dstd = std(cell2mat(handles.TabFeat.Data(:,i)));
            d1 = max(size(num2str(Dmean),2)+3,size(num2str(Dstd),2)+3);
            d = max(d, d1);
            stats{1,i} = Dmean;
            stats{2,i} = Dstd;
        else
            d=max(cellfun('prodofsize',handles.TabFeat.Data(:,i)));  %size data
        end
        t=max(cellfun('prodofsize',handles.TabFeat.ColumnName(i,:))); %size title
        maxcol = max([d t]);
        sum=sum+maxcol;
        ColW{i} = maxcol*6.5;
    end
    handles.TabFeat.ColumnWidth = ColW;
    stats{1,1} = 'Mean';
    stats{2,1} = 'Std';
    handles.cStats.UserData = stats;
end
width = sum*1.45;           %adjust size distance/similarity
siza=size(handles.TabFeat.Data,1);
if siza == 1
    height = height + 1.6;               %first table height
else
    height =  height + 1.4*(siza);
end
if height > (pos(4)-6) && width > (pos(3)-10)
    height = pos(4)-6;
    width = pos(3)-10;    
elseif height > (pos(4)-6)
    height = pos(4)-6;
elseif width > (pos(3)-10)
    width = pos(3)-10;
    if siza==1
        height = 4.4;
    else
        height = height + 1.7;
    end
end

handles.TabFeat.Position = [5 5 width+5 height];
% if strcmp(handles.TabFeat.ColumnName(1), 'Train FV.1')      
%     ColW = cell(1,siza(1));
%     for i=1:siza(1)
%         ColW{i} = 67;
%     end
%     handles.TabFeat.ColumnWidth = ColW;
%     width = 15+15*siza(2);           %adjust size distance/similarity
%     if width > (pos(3)-10)
%         width = pos(3)-10;
%         height = 2.3;
%     end
%     if siza(1) == 2
%         height = height + 4.5;               %first table height
%     else
%         height =  height + 2.3 + 1.8*(siza(1)-1);
%     end
%     if height > (pos(4)-6)
%         height = pos(4)-6;
%     end
% 
%     handles.TabFeat.Position = [5 5 width height];
% else
%     width = 16.5*siza(2);
%     if width > (pos(3)-10)
%         width = pos(3)-10;
%         height = 2.3;
%     end
%     if siza(1) == 2
%         height = height + 4.5;               %first table height
%     else
%         height =  2.3 + 1.8*(siza(1));
%     end
%     if height > (pos(4)-6)
%         height = pos(4)-6;
%     end
% 
%     handles.TabFeat.Position = [5 5 width height];
% end

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


% --- Executes on button press in cStats.
function cStats_Callback(hObject, eventdata, handles)
% hObject    handle to cStats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cStats
[rows, cols] = size(handles.TabFeat.Data);
if hObject.Value
    handles.TabFeat.Data(rows+2:rows+3,:) = hObject.UserData;
else
    if strcmp(handles.TabFeat.Data{rows,1},'Std')
        handles.TabFeat.Data = handles.TabFeat.Data(1:rows-3,:);
        %handles.TabFeat.Data(rows-1:rows,:) = cell(2,cols);
    end
end
FView_SizeChangedFcn(hObject, eventdata, handles);
