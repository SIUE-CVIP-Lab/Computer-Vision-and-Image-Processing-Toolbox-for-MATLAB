function varargout = DlgFeat(varargin)
% DLGFEAT MATLAB code for DlgFeat.fig
%      DLGFEAT, by itself, creates a new DLGFEAT or raises the existing
%      singleton*.
%
%      H = DLGFEAT returns the handle to a new DLGFEAT or the handle to
%      the existing singleton*.
%
%      DLGFEAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DLGFEAT.M with the given input arguments.
%
%      DLGFEAT('Property','Value',...) creates a new DLGFEAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgFeat_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgFeat_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DlgFeat

% Last Modified by GUIDE v2.5 18-Dec-2018 19:43:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgFeat_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgFeat_OutputFcn, ...
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
 % Revision 1.5  05/25/2019  14:48:15  jucuell
 % including the icons to extract the histogram, R, G and B band from the
 % selected image. Saving and displaying labeling process information
%
 % Revision 1.4  02/10/2019  13:15:13  jucuell
 % using a new feature file format that includes a sumary of used features
 % with its parameters and using the writetable function
%
 % Revision 1.3  12/17/2018  10:24:15  jucuell
 % start adding revision history and deleting old commented code. 
 % Updating menu creation programmatically, callbacks to Main figure and
 % the use of the utilities menus in the Main figure.
%
 % Revision 1.2  04/03/2018  16:09:55  jucuell
 % including operations for bReset_Callback 
%
 % Revision 1.1  11/21/2017  15:23:31  jucuell
 % Initial coding and testing.
 % 
%

% --- Executes just before DlgFeat is made visible.
function DlgFeat_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DlgFeat (see VARARGIN)

% Choose default command line output for DlgFeat
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);

% --- Outputs from this function are returned to the command line.
function varargout = DlgFeat_OutputFcn(hObject, eventdata, handles) 
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
 close(handles.Feat)


% --- Executes on button press in bReset.
function bReset_Callback(hObject, eventdata, handles)
% hObject    handle to bReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc                         %clear screen
%reset main header
handles.txtFFile.String = '';
handles.txtRow.String = 1;
handles.txtCol.String = 1;
handles.cFeatIma.Value = 0;
handles.cAssi.Value = 0;
%reset check Feature Images
cFeatIma_Callback(handles.cFeatIma, eventdata, handles)
cAssi_Callback(handles.cAssi, eventdata, handles)
%reset binary features
handles.bBFsall.String = 'Deselect All';
handles.txtNwidth.String = 10;      %Binary Features Normalizing width
handles.txtNheight.String = 10;     %Binary Features Normalizing height
bBFsall_Callback(handles.bBFsall, eventdata, handles)
%reset RST-invariant
handles.bRSTsall.String = 'Deselect All';
bRSTsall_Callback(handles.bRSTsall, eventdata, handles)
%reset Histogram
handles.bHFsall.String = 'Deselect All';
bHFsall_Callback(handles.bHFsall, eventdata, handles)
%reset Texture
handles.popTFDis.Value = 1;
handles.TFQlev.String = '1 (None)';
handles.bTFsall.String = 'Deselect All';
bTFsall_Callback(handles.bTFsall, eventdata, handles)
%reset Spectral
handles.cSF.Value = 0;
cSF_Callback(handles.cSF, eventdata, handles)

% --- Executes on button press in bApply.
function bApply_Callback(hObject, eventdata, handles)
% hObject    handle to bApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc

%changing pointer arrow to watch on cursor
figure_set = findall(groot,'Type','Figure');
set(figure_set,'pointer','watch');

hMain = findobj('Tag','Main');      %get the handle of Main figure
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = handles.bIm1.UserData;     	%get image handle
hNfig2 = handles.bIm2.UserData;     %get image handle

%initialize feature vectors
bin_feat = zeros(1,8);
his_feat = zeros(1,5);
rst_feat = zeros(1,7);
tex_feat = zeros(1,20);
sta_type = zeros(1,3);

%get feature vector values
for i = 1:20
   tex_feat(i) = eval(strcat('handles.TF',num2str(i),'.Value')); 
   if i < 4         %get texture stats types
       sta_type(i) = eval(strcat('handles.STs',num2str(i),'.Value')); 
   end
   
   if i < 6         %get histogram features
       his_feat(i) = eval(strcat('handles.HF',num2str(i),'.Value')); 
   end
   
   if i < 8         %get histogram features
       rst_feat(i) = eval(strcat('handles.crst',num2str(i),'.Value')); 
   end
   
   if i < 9         %get histogram features
       bin_feat(i) = eval(strcat('handles.BF',num2str(i),'.Value')); 
   end
end


%check for Image to process
if (isempty(hNfig) || ~isfield(hNfig,'cvipIma')) && ~handles.cFeatIma.Value
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Feature Error','modal'); 

elseif (~isfield(hNfig2,'cvipIma') || isempty(hNfig2)) && ~handles.cFeatIma.Value
    errordlg(['This operation requires 2 Images. Select a 2nd'...
                ' Image and try again!'],'Feature Error','modal');
            
elseif handles.cFeatIma.Value && strcmp(handles.txtOIma.String,'')
    errordlg(['Select a folder were the images to be procesed are located'...
                ' with its correspondant mask images!'],'Feature Error','modal');
%check for image directory
elseif handles.cFeatIma.Value && handles.cAssi.Value && strcmp(handles.txtClass.String,'')
    errordlg(['There is not a Class Name to be assigned to selected images,'...
                ' Please type a Class Name.'],'Feature Error','modal');
%check for class name
elseif sum([sum(bin_feat(:)), sum(rst_feat(:)), sum(his_feat(:)), ...
        sum(tex_feat(:)), handles.cSF.Value]) == 0
    errordlg(['There is not any feature selected to be extracted,'...
                ' Please Select features.'],'Feature Error','modal');
else
%extract features
outFile = handles.txtFFile.String;      %output filename
Class = handles.txtClass.String;        %class name

if handles.cSF.Value %get Spectral Features
    SFnR = str2double(handles.SFnR.String); %Spectral Features number Rings
    SFnS = str2double(handles.SFnS.String); %Spectral Features number Sectors
else
    SFnR = 0;
    SFnS = 0;
end

%get Texture Features distance pixels
texdist = str2double(handles.popTFDis.String(handles.popTFDis.Value));
quantlvl = str2num(handles.TFQlev.String);%Texture Features Quant. levels
histo = 0;                      %default history value
if isempty(quantlvl)
    quantlvl = -1;              %default quantization level value
end
%get binary normalizations for projections
normwidth = str2double(handles.txtNwidth.String);%Binary Features Normalizing width
normheight = str2double(handles.txtNheight.String);%Binary Features Normalizing heigh
%counting of Selected Features
FeatNum = [bin_feat, his_feat, rst_feat,  tex_feat, [SFnR SFnS], texdist, ...
    quantlvl, sta_type, normwidth, normheight handles.cAssi.Value];
eventdata = 0;

%check for changes in feature vector
if ~isempty(handles.txtNwidth.UserData)
    if ~isequal(FeatNum, handles.txtNwidth.UserData) || ...
            ~strcmp(handles.bVFile.UserData{1,end}, 'Class') && handles.cAssi.Value || ...
            ~strcmp(handles.txtFFile.UserData, outFile)% || ...
           % ~strcmp(handles.txtClass.UserData, Class)
        Rta = questdlg('Feature vector changed. Do you want to create a new one?', ...
                 'Feature Warning', 'Cancel', 'Continue', 'Continue');
        if strcmp(Rta, 'Continue')
            handles.bVFile.UserData = 'NO';%new feature vector
            Run = 1;
        else
            Run = 0;
        end
    else
        Run = 1;
    end
else
    Run = 1;
end
handles.txtFFile.UserData = outFile;    %save last filename
handles.txtClass.UserData = Class;      %save last class name

if Run          %check for extraction flag
    
if handles.cFeatIma.Value       %perform Feature Images 
    folder = handles.txtOIma.String;%image folder path
    %extract features for all images in folder
    Feats = feature_images_cvip(folder, [], bin_feat, ...
        his_feat, rst_feat, tex_feat, [SFnR SFnS], 'texdist', texdist, ...
        'quantlvl', quantlvl, 'statstype', sta_type, 'normwidth', ...
        normwidth, 'normheight', normheight);
    if handles.cAssi.Value      %add class name
        siza = size(Feats);
        Feats(1,siza(2)+1) = {'Class'};%add class
        for i=2:siza(1)
            Feats(i,siza(2)+1) = {Class}; 
        end
    else
        handles.bVFile.UserData = 'NO';%new feature vector
    end
    
else                                %perform Feature Object
    InIma = hNfig.cvipIma;          %get original image info   
    SegIma = hNfig2.cvipIma;       	%get segmented image info

    MaskIma = label_cvip(SegIma); 	%labeled image
    %Get coordinates or labels
    if ~handles.cAssi.Value
        objLabel = 1:max(MaskIma(:));%get label vector
        objLabel = objLabel';   	%traspose vector
        %extract features for all objects on segmented image
        Feats = feature_objects_cvip(InIma, MaskIma, objLabel, outFile, ...
            bin_feat, his_feat, rst_feat, tex_feat, [SFnR SFnS], 'texdist', ...
            texdist, 'quantlvl', quantlvl, 'statstype', sta_type, ...
            'normwidth', normwidth, 'normheight', normheight);
        handles.bVFile.UserData = 'NO';%new feature vector
        
    else
        row = str2double(handles.txtRow.String);
        col = str2double(handles.txtCol.String);
        objLabel = [row col];
        %extract features for selected object
        Feats = feature_objects_cvip(InIma, MaskIma, objLabel, outFile, ...
            bin_feat, his_feat, rst_feat, tex_feat, [SFnR SFnS], 'texdist', ...
            texdist, 'quantlvl', quantlvl, 'statstype', sta_type, 'normwidth', ...
            normwidth, 'normheight', normheight);
        
        if handles.cAssi.Value      %add class name
            siza = size(Feats);
            Feats(1,siza(2)+1) = {'Class'};%add class
            Feats(siza(1),siza(2)+1) = {Class}; 
        end
    end
end

%save feature file and display feature viewer
if strcmp(handles.bVFile.UserData,'NO')   
    handles.bVFile.UserData = Feats;    %store first set of features to be shown
    
else                                    %add new row info
    eventdata = 1;
    siza = size(handles.bVFile.UserData);
    sizb = size(Feats);
    %add feat to file
    handles.bVFile.UserData(siza(1)+1:siza(1)+sizb(1)-1,:) = Feats(2:end,:);

end

%write feature file
if ~isempty(outFile)      
    %add features directory
    cpath = mfilename( 'fullpath' );
    outFile = [cpath(1:end-7) 'Features\' outFile];
    
    if ~strcmp(outFile(end-3:end), '.csv')% the extension should be .csv
        outFile = [outFile '.csv'];     % so we append it to out_file_name if it does not end with '.csv'.
    end
    
    %create feature information
    siza = size(handles.bVFile.UserData(2:end,:));
    infoTxt = [{'Binary:'} {sum(bin_feat(:))}; {'Projections W:'} {normwidth}; ...
        {'Projections H:'} {normheight}; {'RST-Invariant:'} {sum(rst_feat(:))}; ...
        {'Histogram:'} {sum(his_feat(:))}; {'Texture:'} {sum(tex_feat(:))}; ...
        {'Tex. Distance:'} {texdist}; {'Quant. Level:'} {quantlvl}; {'Stats(Avg Rang Var):'} ...
        {sta_type(1)*100+sta_type(2)*10+sta_type(3)}; {'Spectral:'} {SFnR+SFnS};...
        {'Rings:'} {SFnR}; {'Sectors:'} {SFnS}; {'Images:'} {siza(1)}];
    tbl = cell(siza(1)+13, 1);
    for i=1:size(tbl,1)
        tbl(i) = {0};
    end
    tbl = repmat(tbl, 1,siza(2));
    %convert data to table
    tbl(1:siza,:) = handles.bVFile.UserData(2:end,:);
    tbl(siza+1:siza+13,1:2) = infoTxt;
    tbl = cell2table(tbl);
    tbl.Properties.VariableNames = handles.bVFile.UserData(1,:);
    writetable(tbl, outFile);

end

end
DlgFeat('bVFile_Callback',handles.bVFile,eventdata,handles)    %Show or update Feature viewer
%store last mumber of projections
handles.txtNwidth.UserData = FeatNum;
if sum(histo) ~= 0
%check if need to save history
if strcmp(hSHisto(1).Checked,'on')              %save new image history
    Ima.fInfo.history_info = historyupdate_cvip(Ima.fInfo.history_info,histo);  
end
%check if need to show function information
if strcmp(hVfinfo(1).Checked,'on')
    hIlist = findobj('Tag','txtIlist');         %get handle of text element
    hIlist.String(end+1,1)=' {';                 %print an empty line
    txtInfo = historydeco_cvip(histo);     
    hIlist.String(end+1,1:size(file,2)+1)=[file ':']; 
    for i=1:size(txtInfo)
        sInfo = txtInfo{i};                     %extract row to print
        %hIlist.String(end+1:end+size(sInfo,1),1:size(sInfo,2)) = sInfo;
        %sInfo = ['Performing "enlarge_cvip" to get an Image \nwith ' num2str(rr) ' rows \nand 256 cols.\n'];
        sInfo = sprintf(sInfo);
        [~,rr] = size(sInfo);
        hIlist.String(end+1,1:rr) = sInfo;
    end
    hIlist.Value = size(hIlist.String,1);       %goto last line
    figure(hMain);
end
end
end

%changing pointer watch back to arrow on cursor
set(figure_set,'pointer','arrow');


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cSF.
function cSF_Callback(hObject, eventdata, handles)
% hObject    handle to cSF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cSF
if hObject.Value
    handles.SFnR.Enable = 'On';
    handles.SFnS.Enable = 'On';
    handles.bSFsall.String = 'Deselect';
else
    handles.SFnR.Enable = 'Off';
    handles.SFnS.Enable = 'Off';
    handles.bSFsall.String = 'Select';
    handles.SFnS.String = 3;
    handles.SFnR.String = 3;
end


function SFnR_Callback(hObject, eventdata, handles)
% hObject    handle to SFnR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SFnR as text
%        str2double(get(hObject,'String')) returns contents of SFnR as a double


% --- Executes during object creation, after setting all properties.
function SFnR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SFnR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SFnS_Callback(hObject, eventdata, handles)
% hObject    handle to SFnS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SFnS as text
%        str2double(get(hObject,'String')) returns contents of SFnS as a double


% --- Executes during object creation, after setting all properties.
function SFnS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SFnS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in HF1.
function HF1_Callback(hObject, eventdata, handles)
% hObject    handle to HF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HF1


% --- Executes on button press in HF2.
function HF2_Callback(hObject, eventdata, handles)
% hObject    handle to HF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HF2


% --- Executes on button press in HF3.
function HF3_Callback(hObject, eventdata, handles)
% hObject    handle to HF3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HF3


% --- Executes on button press in HF4.
function HF4_Callback(hObject, eventdata, handles)
% hObject    handle to HF4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HF4


% --- Executes on button press in HF5.
function HF5_Callback(hObject, eventdata, handles)
% hObject    handle to HF5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HF5


% --- Executes on button press in bHFsall.
function bHFsall_Callback(hObject, eventdata, handles)
% hObject    handle to bHFsall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(hObject.String,'Select All')  %select all bnary features
    for i = 1:5
        eval(strcat('handles.HF',num2str(i),'.Value = 1;'));
    end
    hObject.String = 'Deselect All';
else
    for i = 1:5
        eval(strcat('handles.HF',num2str(i),'.Value = 0;'));
    end
    hObject.String = 'Select All';
end


function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in TF2.
function TF2_Callback(hObject, eventdata, handles)
% hObject    handle to TF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF2


% --- Executes on button press in TF3.
function TF3_Callback(hObject, eventdata, handles)
% hObject    handle to TF3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF3


% --- Executes on button press in TF4.
function TF4_Callback(hObject, eventdata, handles)
% hObject    handle to TF4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF4


% --- Executes on button press in TF1.
function TF1_Callback(hObject, eventdata, handles)
% hObject    handle to TF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF1


% --- Executes on button press in TF5.
function TF5_Callback(hObject, eventdata, handles)
% hObject    handle to TF5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF5


% --- Executes on button press in bTFsall.
function bTFsall_Callback(hObject, eventdata, handles)
% hObject    handle to bTFsall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(hObject.String,'Select All')  %select all bnary features
    for i = 1:20
        eval(strcat('handles.TF',num2str(i),'.Value = 1;'));
    end
    handles.STs1.Value = 1;
    handles.STs2.Value = 1;
    handles.STs3.Value = 1;
    hObject.String = 'Deselect All';
else
    for i = 1:20
        eval(strcat('handles.TF',num2str(i),'.Value = 0;'));
    end
    handles.STs1.Value = 1;
    handles.STs2.Value = 0;
    handles.STs3.Value = 0;
    hObject.String = 'Select All';
end

% --- Executes on selection change in popTFDis.
function popTFDis_Callback(hObject, eventdata, handles)
% hObject    handle to popTFDis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popTFDis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popTFDis


% --- Executes during object creation, after setting all properties.
function popTFDis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popTFDis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on button press in crst1.
function crst1_Callback(hObject, eventdata, handles)
% hObject    handle to crst1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of crst1


% --- Executes on button press in crst2.
function crst2_Callback(hObject, eventdata, handles)
% hObject    handle to crst2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of crst2


% --- Executes on button press in crst3.
function crst3_Callback(hObject, eventdata, handles)
% hObject    handle to crst3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of crst3


% --- Executes on button press in crst4.
function crst4_Callback(hObject, eventdata, handles)
% hObject    handle to crst4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of crst4


% --- Executes on button press in crst5.
function crst5_Callback(hObject, eventdata, handles)
% hObject    handle to crst5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of crst5


% --- Executes on button press in bRSTsall.
function bRSTsall_Callback(hObject, eventdata, handles)
% hObject    handle to bRSTsall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(hObject.String,'Select All')  %select all bnary features
    for i = 1:7
        eval(strcat('handles.crst',num2str(i),'.Value = 1;'));
    end
    hObject.String = 'Deselect All';
else
    for i = 1:7
        eval(strcat('handles.crst',num2str(i),'.Value = 0;'));
    end
    hObject.String = 'Select All';
end

% --- Executes on button press in crst6.
function crst6_Callback(hObject, eventdata, handles)
% hObject    handle to crst6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of crst6


% --- Executes on button press in crst7.
function crst7_Callback(hObject, eventdata, handles)
% hObject    handle to crst7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of crst7


% --- Executes on button press in bSFsall.
function bSFsall_Callback(hObject, eventdata, handles)
% hObject    handle to bSFsall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(hObject.String,'Select')  %select all bnary features
    handles.cSF.Value = 1;
    handles.SFnR.Enable = 'On';
    handles.SFnS.Enable = 'On';
    hObject.String = 'Deselect';
else
    handles.cSF.Value = 0;
    handles.SFnR.Enable = 'Off';
    handles.SFnS.Enable = 'Off';
    hObject.String = 'Select';
end

function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bBFsall.
function bBFsall_Callback(hObject, eventdata, handles)
% hObject    handle to bBFsall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(hObject.String,'Select All')  %select all bnary features
    for i = 1:8
        eval(strcat('handles.BF',num2str(i),'.Value = 1;'));
    end
    hObject.String = 'Deselect All';
else
    for i = 1:8
        eval(strcat('handles.BF',num2str(i),'.Value = 0;'));
    end
    hObject.String = 'Select All';
end

% --- Executes on button press in BF8.
function BF3_Callback(hObject, eventdata, handles)
% hObject    handle to BF8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BF8


% --- Executes on button press in BF5.
function BF5_Callback(hObject, eventdata, handles)
% hObject    handle to BF5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BF5


% --- Executes on button press in BF5.
function BF6_Callback(hObject, eventdata, handles)
% hObject    handle to BF5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BF5


% --- Executes on button press in BF1.
function BF1_Callback(hObject, eventdata, handles)
% hObject    handle to BF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BF1


% --- Executes on button press in BF8.
function BF7_Callback(hObject, eventdata, handles)
% hObject    handle to BF8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BF8


% --- Executes on button press in BF8.
function BF8_Callback(hObject, eventdata, handles)
% hObject    handle to BF8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BF8


% --- Executes on button press in BF8.
function BF2_Callback(hObject, eventdata, handles)
% hObject    handle to BF8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BF8


% --- Executes on button press in BF5.
function BF4_Callback(hObject, eventdata, handles)
% hObject    handle to BF5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BF5



function txtNwidth_Callback(hObject, eventdata, handles)
% hObject    handle to txtNwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtNwidth as text
%        str2double(get(hObject,'String')) returns contents of txtNwidth as a double


% --- Executes during object creation, after setting all properties.
function txtNwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtNwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtNheight_Callback(hObject, eventdata, handles)
% hObject    handle to txtNheight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtNheight as text
%        str2double(get(hObject,'String')) returns contents of txtNheight as a double


% --- Executes during object creation, after setting all properties.
function txtNheight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtNheight (see GCBO)
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



function txtCol_Callback(hObject, eventdata, handles)
% hObject    handle to txtCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtCol as text
%        str2double(get(hObject,'String')) returns contents of txtCol as a double


% --- Executes during object creation, after setting all properties.
function txtCol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtRow_Callback(hObject, eventdata, handles)
% hObject    handle to txtRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtRow as text
%        str2double(get(hObject,'String')) returns contents of txtRow as a double


% --- Executes during object creation, after setting all properties.
function txtRow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in bVFile.
function bVFile_Callback(hObject, eventdata, handles)
% hObject    handle to bVFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
if strcmp(hObject.UserData,'NO')
    warndlg('There is not Feature File Information to show','Features Warning','modal');
else
    if isa(eventdata,'double')
        if eventdata
            hGeo = findobj('Tag','FView');              %get the handle of Main form
            hGeo = hGeo(1);
            hGeo.UserData = hObject.UserData;
            DlgFView('FView_SizeChangedFcn',hObject,eventdata,guidata(hGeo))
        else
           hGeo = DlgFView;
            hGeo.UserData = hObject.UserData;
            set(gcf,'Name','Feature Viewer','NumberTitle','off') %name figure
            group = setfigdocked('GroupName','CVIP Toolbox V.3.5','Figure',hGeo); %Add figure to group
            DlgFView('FView_SizeChangedFcn',hObject,eventdata,guidata(hGeo)) 
        end
    else    %show features
        hGeo = findobj('Tag','FView');              %get the handle of Main form
        if isempty(hGeo)
            hGeo = DlgFView;
            hGeo.UserData = hObject.UserData;
            set(gcf,'Name','Feature Viewer','NumberTitle','off') %name figure
            group = setfigdocked('GroupName','CVIP Toolbox V.3.5','Figure',hGeo); %Add figure to group
            DlgFView('FView_SizeChangedFcn',hObject,eventdata,guidata(hGeo)) 
        else
            hGeo =hGeo(1);
        end
    end
    figure(hGeo);
end


% --- Executes on button press in bVLab.
function bVLab_Callback(hObject, eventdata, handles)
% hObject    handle to bVLab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
hMain = findobj('Tag','Main');      %get the handle of Main figure
hSHisto = findobj('Tag','mVsaveHis');%get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = handles.bIm2.UserData;      %get segmented image info
if isempty(hNfig) || ~isfield(hNfig,'cvipIma')%check for Image to save
    errordlg(['There is no Image to be labeled. Please select '...
        'a Segmented Image and try again.'],'Feature Error','modal'); 
else
    Ima = hNfig.cvipIma;
    file = handles.txtSIma.String;

    MaskIma = label_cvip(Ima);      %label image
    histo = 151;                    %update history
    Name = [file,' > Labeled'];  	%image name
    
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

    [row,col,band]=size(MaskIma); 	%get new image size
    %update image information
    hNfig.fInfo.no_of_bands=band;             
    hNfig.fInfo.no_of_cols=col;              
    hNfig.fInfo.no_of_rows=row;
    %update image structure
    hNfig.cvipIma = MaskIma;       	%read image data
    showgui_cvip(hNfig, Name);      	%show image in viewer

end

function txtFFile_Callback(hObject, eventdata, handles)
% hObject    handle to txtFFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtFFile as text
%        str2double(get(hObject,'String')) returns contents of txtFFile as a double


% --- Executes during object creation, after setting all properties.
function txtFFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtFFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bSave.
function bSave_Callback(hObject, eventdata, handles)
% hObject    handle to bSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function txtClass_Callback(hObject, eventdata, handles)
% hObject    handle to txtClass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtClass as text
%        str2double(get(hObject,'String')) returns contents of txtClass as a double


% --- Executes during object creation, after setting all properties.
function txtClass_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtClass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtSIma_Callback(hObject, eventdata, handles)
% hObject    handle to txtSIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtSIma as text
%        str2double(get(hObject,'String')) returns contents of txtSIma as a double


% --- Executes during object creation, after setting all properties.
function txtSIma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtOIma_Callback(hObject, eventdata, handles)
% hObject    handle to txtOIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtOIma as text
%        str2double(get(hObject,'String')) returns contents of txtOIma as a double


% --- Executes during object creation, after setting all properties.
function txtOIma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtOIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cFeatIma.
function cFeatIma_Callback(hObject, eventdata, handles)
% hObject    handle to cFeatIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cFeatIma
%Show info to get images in folder
if hObject.Value                        %show control for features images
    handles.lblImaFol.Visible = 'On';
    handles.txtSIma.String = '';
    handles.txtOIma.String = '';
    handles.txtSIma.Enable = 'Off';
    handles.bIm2.Enable = 'Off'; 
    handles.text18.Enable = 'Off';
    handles.cAssi.Enable = 'On';
else                                    %show control for features object
    handles.lblImaFol.Visible = 'Off';
    handles.txtSIma.String = '';
    handles.txtOIma.String = '';
    handles.txtSIma.Enable = 'On';
    handles.bIm2.Enable = 'On';
    handles.text18.Enable = 'On';
    handles.cAssi.Enable = 'On';
end

% --- Executes on button press in TF7.
function TF7_Callback(hObject, eventdata, handles)
% hObject    handle to TF7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF7


% --- Executes on button press in TF8.
function TF8_Callback(hObject, eventdata, handles)
% hObject    handle to TF8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF8


% --- Executes on button press in TF11.
function TF11_Callback(hObject, eventdata, handles)
% hObject    handle to TF11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF11


% --- Executes on button press in TF6.
function TF6_Callback(hObject, eventdata, handles)
% hObject    handle to TF6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF6


% --- Executes on button press in TF10.
function TF10_Callback(hObject, eventdata, handles)
% hObject    handle to TF10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF10


% --- Executes on button press in TF12.
function TF12_Callback(hObject, eventdata, handles)
% hObject    handle to TF12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF12


% --- Executes on button press in TF13.
function TF13_Callback(hObject, eventdata, handles)
% hObject    handle to TF13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF13


% --- Executes on button press in TF14.
function TF14_Callback(hObject, eventdata, handles)
% hObject    handle to TF14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF14


% --- Executes on button press in TF9.
function TF9_Callback(hObject, eventdata, handles)
% hObject    handle to TF9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF9


% --- Executes on button press in TF15.
function TF15_Callback(hObject, eventdata, handles)
% hObject    handle to TF15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF15


% --- Executes on button press in TF17.
function TF17_Callback(hObject, eventdata, handles)
% hObject    handle to TF17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF17


% --- Executes on button press in TF18.
function TF18_Callback(hObject, eventdata, handles)
% hObject    handle to TF18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF18


% --- Executes on button press in TF19.
function TF19_Callback(hObject, eventdata, handles)
% hObject    handle to TF19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF19


% --- Executes on button press in TF16.
function TF16_Callback(hObject, eventdata, handles)
% hObject    handle to TF16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF16


% --- Executes on button press in TF20.
function TF20_Callback(hObject, eventdata, handles)
% hObject    handle to TF20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TF20



function TFQlev_Callback(hObject, eventdata, handles)
% hObject    handle to TFQlev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TFQlev as text
%        str2double(get(hObject,'String')) returns contents of TFQlev as a double


% --- Executes during object creation, after setting all properties.
function TFQlev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TFQlev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in STs1.
function STs1_Callback(hObject, eventdata, handles)
% hObject    handle to STs1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of STs1


% --- Executes on button press in STs2.
function STs2_Callback(hObject, eventdata, handles)
% hObject    handle to STs2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of STs2


% --- Executes on button press in STs3.
function STs3_Callback(hObject, eventdata, handles)
% hObject    handle to STs3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of STs3


% --- Executes on button press in bIm1.
function bIm1_Callback(hObject, eventdata, handles)
% hObject    handle to bIm1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc                             %clear screen
if handles.cFeatIma.Value       %set Orig Images directory
    try                         %try last directory
        handles.txtOIma.String = uigetdir(hObject.UserData);
    catch                       %use app directory
        handles.txtOIma.String = uigetdir(pwd);
    end
    hObject.UserData = handles.txtOIma.String;
else
    hMain = findobj('Tag','Main');  %get the handle of Main form
    hNfig = hMain.UserData;         %get image handle
    if hNfig ~= 0 && isfield(hNfig.UserData,'cvipIma')%check for Image to save
        file=get(hNfig,'Name');    	%get image name
        hObject.UserData = hNfig.UserData;%read image info
        handles.txtOIma.String = file;  %show image name
    end
end

% --- Executes on button press in bIm2.
function bIm2_Callback(hObject, eventdata, handles)
% hObject    handle to bIm2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc                             %clear screen
hMain = findobj('Tag','Main');  %get the handle of Main form
hNfig = hMain.UserData;         %get image handle
if hNfig ~= 0 && isfield(hNfig.UserData,'cvipIma')%check for Image to save
    file=get(hNfig,'Name');    	%get image name
    hObject.UserData = hNfig.UserData;%read image info
    handles.txtSIma.String = file;%Show ima info
end


% --- Executes on button press in bGet.
function bGet_Callback(hObject, eventdata, handles)
% hObject    handle to bGet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMain = findobj('Tag','Main');  %get the handle of Main form
hNfig = hMain.UserData;         %get image handle
dcm_obj = datacursormode(hNfig);
set(dcm_obj,'DisplayStyle','datatip',...
'SnapToDataVertex','off','Enable','on')
c_info = getCursorInfo(dcm_obj);
if isempty(c_info)
    warndlg('Please select one point on the image', 'Feature Warning'); 
else
    handles.txtCol.String = c_info.Position(1);
    handles.txtRow.String = c_info.Position(2);
    hObject.UserData = 'ON';
end

% --- Executes on button press in cAssi.
function cAssi_Callback(hObject, eventdata, handles)
% hObject    handle to cAssi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cAssi
clc
hMain = findobj('Tag','Main');  %get the handle of Main form
hNfig = hMain.UserData;         %get image handle

if hObject.Value
    handles.text21.Enable = 'On';
    handles.txtClass.Enable = 'On';
    handles.txtClass.String = '';
    if ~handles.cFeatIma.Value
        handles.bGet.Enable = 'On';
        handles.txtCol.Enable = 'On';
        handles.txtRow.Enable = 'On';
        handles.txtCol.String = '1';
        handles.txtRow.String = '1';
    end
%     dcm_obj = datacursormode(hNfig);
%     set(dcm_obj,'DisplayStyle','datatip',...
%     'SnapToDataVertex','off','Enable','on');
else
    handles.bGet.Enable = 'Off';
    handles.text21.Enable = 'Off';
    handles.txtClass.Enable = 'Off';
    handles.txtCol.Enable = 'Off';
    handles.txtRow.Enable = 'Off';
    if strcmp(handles.bGet.UserData,'ON')
        datacursormode(hNfig,'off');
        delete(findall(hNfig,'Type','hggroup'));
        handles.txtClass.String = '';
        handles.bGet.UserData = 'OFF';
    end
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


% --- Executes on button press in bLaunc.
function bLaunc_Callback(hObject, eventdata, handles)
% hObject    handle to bLaunc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc; DlgFtAna
