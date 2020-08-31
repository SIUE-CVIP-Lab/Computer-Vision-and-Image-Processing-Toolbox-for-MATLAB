function varargout = DlgPatt(varargin)
% DLGPATT MATLAB code for DlgPatt.fig
%      DLGPATT, by itself, creates a new DLGPATT or raises the existing
%      singleton*.
%
%      H = DLGPATT returns the handle to a new DLGPATT or the handle to
%      the existing singleton*.
%
%      DLGPATT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DLGPATT.M with the given input arguments.
%
%      DLGPATT('Property','Value',...) creates a new DLGPATT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgPatt_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgPatt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above lblTest to modify the response to help DlgPatt

% Last Modified by GUIDE v2.5 10-Feb-2019 19:37:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgPatt_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgPatt_OutputFcn, ...
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
%           Initial coding date:    11/21/2017
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     05/24/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.4  05/24/2019  14:48:15  jucuell
 % including the icons to extract the histogram, R, G and B band from the
 % selected image.
%
 % Revision 1.3  02/27/2018  10:38:30  jucuell
 % Include operations and calculations to create the Classification results
 % file and show the results into the classification viewer. The output
 % file will include the success rates for each class at the begining of
 % the file by using the variable Names.
%
 % Revision 1.2  12/17/2018  10:29:53  jucuell
 % updating menu creation programmatically, callbacks to Main figure and
 % the use of the utilities menus in the Main figure.
%
 % Revision 1.1  11/21/2017  15:23:31  jucuell
 % Initial coding and testing.
 % 
%

% --- Executes just before DlgPatt is made visible.
function DlgPatt_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DlgPatt (see VARARGIN)

% Choose default command line output for DlgPatt
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DlgPatt wait for user response (see UIRESUME)
% uiwait(handles.Patt);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = DlgPatt_OutputFcn(hObject, eventdata, handles) 
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
 close(handles.Patt)


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

file_tt = handles.txtTest.String;
file_tr = handles.txtTrain.String;
file_out = handles.txtOut.String;
%check if leave out has a file out name
if isempty(file_out) && handles.bLeave.Value
    errordlg(['This Operation requires and Output File name, please especify'...
                ' a Output File name.'],'Pattern Error','modal');
else

if handles.cVector.Value            %perform distance measure operations
    if handles.bDSeuc.Value         %computes Euclidean distance
        distV = pattern_euclidean_cvip(file_tt, file_tr);
        name = '-Euclidean';

    elseif handles.bDScit.Value     %computes City Block distance
        distV = pattern_city_block_cvip(file_tt, file_tr);
        name = '-CityBlock';

    elseif handles.bDSmax.Value     %computes Maximum distance
        distV = pattern_maximum_cvip(file_tt, file_tr);
        name = '-Maximum';

    elseif handles.bDSmin.Value     %computes Minkowski distance
        r = str2double(handles.popDmin.String(handles.popDmin.Value));
        distV = pattern_minkowski_cvip(file_tt, file_tr, r);
        name = ['-Minkowski(' num2str(r) ')'];

    elseif handles.bDSnor.Value    %computes Nvip similarity
        distV = pattern_vector_inner_product_cvip(file_tt, file_tr);
        name = '-Normalized Vector Inner Product';
        
    elseif handles.bDStan.Value    %computes Tanimoto
        distV = pattern_tanimoto_cvip(file_tt, file_tr);
        name = '-Tanimoto';
    
    end
    
    siza = size(distV,1)+1;
    distVT = cell(siza);    %create an empty matrix
    for i=1:siza-1
        distVT{1,i+1} = ['Train FV.' num2str(i)];
        distVT{i+1,1} = ['Test FV.' num2str(i)];
    end
    for i=2:siza
        for j=2:siza
            distVT{i,j} = distV(i-1,j-1);
        end
    end
    
    if ~isempty(file_out)      
        %add features directory
        file_out = [pwd '\Pattern\' file_out];
        if ~strcmp(file_out(end-3:end), '.csv')    % the extension should be .csv
            file_out = [file_out '.csv'];     % so we append it to out_file_name if it does not end with '.csv'.
        end
         fid = fopen(file_out, 'w');
         fprintf(fid, '%s,', distVT{1,1:end-1});
         fprintf(fid, '%s\n', distVT{1,end});
         for i=2:siza
             fprintf(fid, '%s,', distVT{i,1});
             fprintf(fid, '%d,', distVT{i,2:end-1});
             fprintf(fid, '%d\n', distVT{i,end});
         end
         fclose(fid);           %close file
         
    end
    hGeo = DlgFView;       %call viewer
    hGeo.UserData = distVT; %store dist/sim values
    set(gcf,'Name',['Distance/Similarity Viewer' name],'NumberTitle','off') %name figure
    group = setfigdocked('GroupName','CVIP Toolbox V.3.5','Figure',hGeo); %Add figure to group
    DlgFView('FView_SizeChangedFcn',hObject,eventdata,guidata(hGeo))
    figure(hGeo);
else                        %perform pattern classification

    k = str2double(handles.popKner.String(handles.popKner.Value));
    norm_data = handles.bDN.SelectedObject.UserData;
    dist_data = handles.bDis.SelectedObject.UserData;
    opt_clas = [handles.bCA.SelectedObject.UserData k];
    
    if handles.bLeave.Value         %use leave one out for algorithm testing
        load handel.mat;            %C:\MATLAB\R2017b\toolbox\matlab\audiovideo tic
        
        [Result, Dist] = leave_one_out_cvip(file_tr, file_out, ...
                    norm_data, dist_data, opt_clas);
        sound(y,Fs); %display time and play sound elapTime(toc), 
        test_set = readtable(file_tr);
        AlgTes = [{'Algorithm Testing:           '} {'Leave One Out'}; ...
            {'Feature File:                     '} {file_tr}];
    else                            %use Train/Test sets for algorithm testing
        features = readtable(file_tr);%extract Train set feature infrmation
        if strcmp(features.obj_id{end},'Images:')%new feature vector
            n_feat = features{end,2};
            features = features(1:n_feat,:);%get features
            cpath = mfilename( 'fullpath' );
            file_train = [cpath(1:end-11) 'Temp\file_train_tmp.csv'];
            writetable(features, file_train);
        else
            file_train = file_tr;
        end
        features = readtable(file_tt);%extract Test set feature infrmation
        if strcmp(features.obj_id{end},'Images:')%new feature vector
            n_feat = features{end,2};
            features = features(1:n_feat,:);%get features
            cpath = mfilename( 'fullpath' );
            file_test = [cpath(1:end-11) 'Temp\file_test_tmp.csv'];
            writetable(features, file_test);
        else
            file_test = file_tt;
        end
        [Result, Dist] = train_test_cvip(file_test, file_train, file_out, ...
                    norm_data, dist_data, opt_clas);
        test_set = readtable(file_tt);
        AlgTes = [{'Algorithm Testing:           '} {'Training/Test Set'};...
            {'Train Set:                           '} {file_tr}; ...
            {'Test Set:                            '} {file_tt}];
    end
    %Save and show results
    if ~isempty(file_out)      
        
        Images = Result{1:size(Dist,1),1};%get image names
        FClass = Result{1:size(Dist,1),end};%get Classification (Final) classes
        OClass = test_set{1:size(Dist,1),end};%get Original classes
        tblCinfo = cell(size(Dist,1),4);
        tblCinfo(:,1) = Images; tblCinfo(:,2) = OClass;
        tblCinfo(:,3) = FClass; 
        for i=1:size(Dist,1)
            tblCinfo(i,4) = {Dist(i)};
        end
        tblCinfo = [{''} {''} {''} {''}; {'Image/Object'},{'True Class from Test Set'},...
                {'Classification Result'},{'Distance/Similarity'}; tblCinfo];
 
        %get class names and show row and Column names
        Class = sort(unique(OClass));%class names
        ColumnNames = [Class' {'% Correct'}];
        nClass = size(Class,1);     %number of classes
        TClas = zeros(1,nClass);    %total for each class
        CRes = cell(nClass);       %classification results
        for i=1:nClass              %compute % correct
            CPos = find(strcmp(OClass, Class{i}));%position of features class i
            TClas(i) = sum(strcmp(OClass, Class{i}));%total each class
            for j=1:nClass
                CRes(i,j) = {sum(strcmp(FClass(CPos), Class{j}))};
            end
            CRes(i,nClass+1) = {CRes{i,i}*100/TClas(i)};%cumpute success
        end
        Class = [{''}; Class];      %class in test set
        CRes = [ColumnNames; CRes]; %classification results and titles
        %tblClass = cell2table([Class CRes]);%table Classification
        tblClass = [Class CRes];%table Classification
        tblClas = cell(size(tblClass,1),1);
        tblClas(1:3,1) = [{'Class'}; {'in Test'}; {'Set'}];
        tblClass = [tblClas tblClass];
        
        %classification information
        Norm = [{'No Normalization'} {'Range Normalize'} ...
            {'Unit Vector'} {'Standard Normal Density'} {['Min-Max s_min='...
            num2str(norm_data(2)) ' s_max=' num2str(norm_data(3))]} ...
            {['Soft Max Scaling r=' num2str(norm_data(2))]}];
        DisSim = [{'Euclidean'} {'City Block'} {'Maximum'} {['Minkowski r='...
            num2str(dist_data(2))]} {'NVIP'} {'Tanimoto'}];
        ClaAlg = [{'Nearest Neighbor'} {['k-Nearest Neighbor K=' num2str(k)]} ...
            {'Nearest Centroid'}];
        
        tblClaIn = [{''} {''}; {'CLASSIFICATION PARAMETERS:'} {''}; ...
            {'Normalization:                  '} Norm(norm_data(1)+1); ...
            {'Distance/Similarity:         '} DisSim(dist_data(1)); ...
            {'Classification Algorithm:'} ClaAlg(opt_clas(1)); AlgTes];
        
        %feature file information
        tblfInfo = [{''} {''}; {'FEATURES INFORMATION'} {''}; ...
            table2cell(test_set(size(Dist,1)+1:end,1:2))];
        
        %features list
        Titles = Result.Properties.VariableNames(2:end-1);
        %populate Features Table
        siza = size(Titles,2);%number of features
        n = floor(siza/6);
        l = 6-mod(siza,6);
        Titles(end+1:end+l)={char(1,l)};
        tblFeats = [{''} {''} {''} {''} {''} {''}; {'FEATURES LIST:'} {''}...
            {''} {''} {''} {''}; reshape(Titles,n+1,6)];
        
        %populate final table
        sizes = [size(tblClass); size(tblClaIn); size(tblfInfo); ...
            size(tblFeats); size(tblCinfo)];
        %create final table with size according to data
        tblFinal = cell(sum(sizes(:,1)),max(sizes(:,2)));
        %insert Classification Results
        tblFinal(1:sizes(1,1),1:sizes(1,2)) = tblClass;
        %insert Classification Parameters
        tblFinal(sizes(1,1)+1:sizes(1,1)+sizes(2,1),1:2) = tblClaIn;
        tblFinal(sizes(1,1)+sizes(2,1)+1:sizes(1,1)+sizes(2,1)+sizes(3,1),...
            1:2) = tblfInfo;        %insert Feature Information
        tblFinal(sizes(1,1)+sizes(2,1)+sizes(3,1)+1:sizes(1,1)+sizes(2,1)+...
            +sizes(3,1)+sizes(4,1),1:6) = tblFeats;%insert Features list
        %insert Classification Information
        tblFinal(sizes(1,1)+sizes(2,1)+sizes(3,1)+sizes(4,1)+1:end,1:4) = tblCinfo;
        
        tblFinal = cell2table(tblFinal);    %convert to table
%         finalT = cell(1, size(tblFinal,2)); %variable for titles
%         for i=1:size(tblFinal,2)
%             finalT(i) = {['C' num2str(i)]};
%         end
%         tblFinal.Properties.VariableNames = finalT;
        Name = '';
        for i=2:size(CRes,1)
            Name = [Name num2str(round(CRes{i,end})) '-'];
        end
        %add features directory
        cpath = mfilename( 'fullpath' );
        file_out = [cpath(1:end-7) 'Pattern\' [Name file_out]];
        if ~strcmp(file_out(end-3:end), '.csv')% the extension should be .csv
            file_out = [file_out '.csv'];% so we append it to out_file_name if it does not end with '.csv'.
        end
        
        writetable(tblFinal,file_out,'WriteVariableNames',0);%save data
         
    end
%     hGeo = DlgFView;                %call viewer
%     hGeo.UserData = Result;         %store dist/sim values
%     set(gcf,'Name',['Classification Viewer' name],'NumberTitle','off') %name figure
%     group = setfigdocked('GroupName','CVIP Toolbox V.3.5','Figure',hGeo); %Add figure to group
%     DlgFView('FView_SizeChangedFcn',hObject,eventdata,guidata(hGeo))
%     figure(hGeo);
    
    CResult.Titles = Result.Properties.VariableNames;
    CResult.ClaRes = tblClass;
    CResult.ClaPar = tblClaIn;
    CResult.FeatIn = tblfInfo;
    CResult.ClaInf = tblCinfo;
    
    hGeo = DlgCView;                %call Classification Results viewer
    hGeo.UserData = CResult;        %classification info
    set(gcf,'Name',['Classification Results Viewer'],'NumberTitle','off') %name figure
    group = setfigdocked('GroupName','CVIP Toolbox V.3.5','Figure',hGeo); %Add figure to group
    DlgCView('CView_SizeChangedFcn',hObject,eventdata,guidata(hGeo))
    figure(hGeo);
    
end
end

%changing pointer watch back to arrow on cursor
set(figure_set,'pointer','arrow');


function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as lblTest
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



function txtTrain_Callback(hObject, eventdata, handles)
% hObject    handle to txtTrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtTrain as lblTest
%        str2double(get(hObject,'String')) returns contents of txtTrain as a double


% --- Executes during object creation, after setting all properties.
function txtTrain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bTran.
function bTrain_Callback(hObject, eventdata, handles)
% hObject    handle to bTran (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
cpath = mfilename( 'fullpath' );
cpath = [cpath(1:end-7) 'Features\'];
[file, path] = uigetfile({'*.csv','csv file (*.csv)'; '*.*', ...
    'All Files (*.*)'}, 'Select Feature File...','MultiSelect', 'off',...
    cpath);
if file ~= 0    %user select a file?
    handles.txtTrain.String = strcat(path, file);
    hObject.UserData = struct('file', file, 'path', path);
end

function txtTest_Callback(hObject, eventdata, handles)
% hObject    handle to txtTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtTest as lblTest
%        str2double(get(hObject,'String')) returns contents of txtTest as a double


% --- Executes during object creation, after setting all properties.
function txtTest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bTest.
function bTest_Callback(hObject, eventdata, handles)
% hObject    handle to bTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
cpath = mfilename( 'fullpath' );
cpath = [cpath(1:end-7) 'Features\'];
[file, path] = uigetfile({'*.csv','csv file (*.csv)'; '*.*', ...
    'All Files (*.*)'}, 'Select Feature File...','MultiSelect', 'off',...
    cpath);
if file ~= 0    %user select a file?
    handles.txtTest.String = strcat(path, file);
    hObject.UserData = struct('file', file, 'path', path);
end

function txtOut_Callback(hObject, eventdata, handles)
% hObject    handle to txtOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtOut as lblTest
%        str2double(get(hObject,'String')) returns contents of txtOut as a double


% --- Executes during object creation, after setting all properties.
function txtOut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bOut.
function bOut_Callback(hObject, eventdata, handles)
% hObject    handle to bOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [file, path] = uigetfile({'*.csv','csv file (*.csv)'; '*.*', 'All Files (*.*)'}, 'MultiSelect', 'off');
% handles.txtOut.String = strcat(path, file);
clc;
cpath = mfilename( 'fullpath' );
cpath = [cpath(1:end-7) 'Pattern\'];
[file] = uiputfile({'*.csv','csv file (*.csv)'; '*.*', ...
    'All Files (*.*)'}, 'Save Output File...', cpath);

if file ~= 0    %user select a file?
    handles.txtOut.String = file;
    hObject.UserData = handles.txtOut.String;
end


function txtSmin_Callback(hObject, eventdata, handles)
% hObject    handle to txtSmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtSmin as lblTest
%        str2double(get(hObject,'String')) returns contents of txtSmin as a double


% --- Executes during object creation, after setting all properties.
function txtSmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtSmax_Callback(hObject, eventdata, handles)
% hObject    handle to txtSmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtSmax as lblTest
%        str2double(get(hObject,'String')) returns contents of txtSmax as a double


% --- Executes during object creation, after setting all properties.
function txtSmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtSoft_Callback(hObject, eventdata, handles)
% hObject    handle to txtSoft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtSoft as lblTest
%        str2double(get(hObject,'String')) returns contents of txtSoft as a double


% --- Executes during object creation, after setting all properties.
function txtSoft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSoft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popKner.
function popKner_Callback(hObject, eventdata, handles)
% hObject    handle to popKner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popKner contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popKner


% --- Executes during object creation, after setting all properties.
function popKner_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popKner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popDmin.
function popDmin_Callback(hObject, eventdata, handles)
% hObject    handle to popDmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popDmin contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popDmin


% --- Executes during object creation, after setting all properties.
function popDmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popDmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bDNsoft.
function bDNsoft_Callback(hObject, eventdata, handles)
% hObject    handle to bDNsoft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bDNsoft
%show and hide controls
handles.lblSoft.Visible = 'On';
handles.txtSoft.Visible = 'On';
handles.lblSmin.Visible = 'Off';
handles.txtSmin.Visible = 'Off';
handles.txtSmax.Visible = 'Off';


% --- Executes on button press in bDNmin.
function bDNmin_Callback(hObject, eventdata, handles)
% hObject    handle to bDNmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bDNmin
%show and hide controls
handles.lblSoft.Visible = 'Off';
handles.txtSoft.Visible = 'Off';
handles.lblSmin.Visible = 'On';
handles.txtSmin.Visible = 'On';
handles.txtSmax.Visible = 'On';


% --- Executes on button press in bDNstd.
function bDNstd_Callback(hObject, eventdata, handles)
% hObject    handle to bDNstd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%show and hide controls
handles.lblSoft.Visible = 'Off';
handles.txtSoft.Visible = 'Off';
handles.lblSmin.Visible = 'Off';
handles.txtSmin.Visible = 'Off';
handles.txtSmax.Visible = 'Off';


% --- Executes on button press in bDScit.
function bDScit_Callback(hObject, eventdata, handles)
% hObject    handle to bDScit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bDScit
%show and hide controls
handles.lblDmin.Visible = 'Off';
handles.popDmin.Visible = 'Off';


% --- Executes on button press in bDSmax.
function bDSmax_Callback(hObject, eventdata, handles)
% hObject    handle to bDSmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bDSmax
%show and hide controls
handles.lblDmin.Visible = 'Off';
handles.popDmin.Visible = 'Off';


% --- Executes on button press in bDSmin.
function bDSmin_Callback(hObject, eventdata, handles)
% hObject    handle to bDSmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bDSmin
%show and hide controls
handles.lblDmin.Visible = 'On';
handles.popDmin.Visible = 'On';


% --- Executes on button press in bCAkne.
function bCAkne_Callback(hObject, eventdata, handles)
% hObject    handle to bCAkne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bCAkne
%show and hide controls
handles.lblKner.Visible = 'On';
handles.popKner.Visible = 'On';

% --- Executes on button press in bCAnea.
function bCAnea_Callback(hObject, eventdata, handles)
% hObject    handle to bCAnea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bCAnea
%show and hide controls
handles.lblKner.Visible = 'Off';
handles.popKner.Visible = 'Off';

% --- Executes on button press in bCAncen.
function bCAncen_Callback(hObject, eventdata, handles)
% hObject    handle to bCAncen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bCAncen
%show and hide controls
handles.lblKner.Visible = 'Off';
handles.popKner.Visible = 'Off';


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
function mSge_Callback(hObject, eventdata, handles)
% hObject    handle to mSge (see GCBO)
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
function uifSave_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uifSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('fSave_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function uifOPen_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uifOPen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('fOpen_Callback',hObject,eventdata,guidata(hObject))


% --- Executes on button press in cVector.
function cVector_Callback(hObject, eventdata, handles)
% hObject    handle to cVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cVector
if hObject.Value
    handles.lblTrain.String = 'Feat. Vec. 1:';
    handles.lblTest.String = 'Feat. Vec. 2:';
else
    handles.lblTrain.String = 'Training Set:';
    handles.lblTest.String = 'Test Set:';
end


% --- Executes on button press in bLaunch.
function bLaunch_Callback(hObject, eventdata, handles)
% hObject    handle to bLaunch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc; DlgFtAna


% --- Executes on button press in bLeave.
function bLeave_Callback(hObject, eventdata, handles)
% hObject    handle to bLeave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bLeave
%hide test set controls
handles.lblTest.Visible = 'Off';
handles.txtTest.Visible = 'Off';
handles.bTest.Visible = 'Off';
handles.lblTrain.String = 'Feature File';


% --- Executes on button press in bTran.
function bTran_Callback(hObject, eventdata, handles)
% hObject    handle to bTran (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bTran
%hide test set controls
handles.lblTest.Visible = 'On';
handles.txtTest.Visible = 'On';
handles.bTest.Visible = 'On';
handles.lblTrain.String = 'Training Set';
