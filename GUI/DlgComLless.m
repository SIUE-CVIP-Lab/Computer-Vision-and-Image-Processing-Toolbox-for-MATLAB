function varargout = DlgComLless(varargin)
% CLLESS MATLAB code for CLless.fig
%      CLLESS, by itself, creates a new CLLESS or raises the existing
%      singleton*.
%
%      H = CLLESS returns the handle to a new CLLESS or the handle to
%      the existing singleton*.
%
%      CLLESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLLESS.M with the given input arguments.
%
%      CLLESS('Property','Value',...) creates a new CLLESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgComLless_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgComLless_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CLless

% Last Modified by GUIDE v2.5 19-Dec-2018 16:40:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgComLless_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgComLless_OutputFcn, ...
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
%           Initial coding date:    09/03/2018
%           Updated by:             Hridoy Biswas
%           Latest update date:     7/18/2020
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
 % Revision 1.3  12/17/2018  10:42:11  jucuell
 % Updating menu creation programmatically, callbacks to Main figure and
 % the use of the utilities menus in the Main figure.
%
 % Revision 1.2  09/04/2018  08:12:05  jucuell
 % 
%
 % Revision 1.1  09/03/2018  10:05:15  jucuell
 % Initial revision: Creating figure and initial coding
 % 
%

% --- Executes just before CLless is made visible.
function DlgComLless_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CLless (see VARARGIN)

% Choose default command line output for CLless
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CLless wait for user response (see UIRESUME)
% uiwait(handles.CLless);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';%hide Analysis menu
handles.mComp.Visible = 'Off';%hide Analysis menu
handles.mView.Visible = 'Off';%hide Analysis menu



% --- Outputs from this function are returned to the command line.
function varargout = DlgComLless_OutputFcn(hObject, eventdata, handles) 
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
clc%clear screen

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
if handles.bHuff.Value           
    %get block size
    
    
elseif handles.bZiv.Value              %perform 

    
elseif handles.bJPEG.Value           %perform 
      
    
elseif handles.bBRLC.Value      % perform bit-plane run length coding
       bit = 255;
       fData =bRLCenco_cvip(InIma,bit);
   
   
       OutIma =bRLCdeco_cvip(fData);
    
    %update image history
    histo = [262 bit];
    Func = 'brlc';
    Name=strcat(file,' > ',Func,'(',num2str(255),')');
    %update compression format
    Ima.fInfo.cmpr_format = 'btc';
    Osize = size(InIma,1)*size(InIma,2)*size(InIma,3);
    Nsize = size(fData,1);
    ratio = Osize/Nsize;
    txtInfo = [{['Performing "bRLC_cvip" with block size: ' num2str(bit)]};
        {['Original file "' file '" size is:' num2str(Osize) ' Bytes']};
        {['Compressed file "' Name '" size is:' num2str(Nsize) ' Bytes']};
        {['The compression ratio is 1:' num2str(ratio)]}];
end

%check if need to save history
if strcmp(hSHisto(1).Checked,'on')	%save new image history
    Ima.fInfo.history_info = updatehistory_cvip(Ima.fInfo.history_info,histo);  
end
%check if need to show function information
if strcmp(hVfinfo(1).Checked,'on')
    hIlist = findobj('Tag','txtIlist');%get handle of text element
    hIlist.String(end+1,1)=' ';    	%print an empty line
    %txtInfo = decohisto_cvip(histo);
    for i=1:size(txtInfo)
        sInfo = txtInfo{i};        	%extract row to print
        hIlist.String(end+1:end+size(sInfo,1),1:size(sInfo,2)) = sInfo;
    end
    hIlist.Value = size(hIlist.String,1);%goto last line
    figure(hMain);                  %foucs on Main figure
end
[row,col,band]=size(OutIma);       	%get new image size
%update image information
Ima.fInfo.no_of_bands=band;             
Ima.fInfo.no_of_cols=col;              
Ima.fInfo.no_of_rows=row;
%update image structure
Ima.cvipIma = OutIma;               %read image data
Ima.fInfo.cmpr = fData;             %save compressed info in image structure
showgui_cvip(Ima, Name);            %show image in viewer
else                                %display error message
    errordlg(['There is nothing to process. Please select an Image and'...
        ' try again.'],'Compression Error','modal');

%changing pointer watch back to arrow on cursor
set(figure_set,'pointer','arrow');

end

% --- Executes on button press in bCancel.
function bCancel_Callback(hObject, eventdata, handles)
% hObject    handle to bCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Prepare to close application window
 close(handles.CLless)


% --- Executes on button press in bReset.
function bReset_Callback(hObject, eventdata, handles)
% hObject    handle to bReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
reset(gcf);

% --- Executes on button press in bScom. (Save Compressed Data)
function bScom_Callback(hObject, eventdata, handles)
% hObject    handle to bScom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%check if there is compressed data to save
hMain = findobj('Tag','Main');              %get the handle of Main form
figu = hMain.UserData;                      %get figure handle
if isfield(figu.UserData.fInfo,'cmpr')      %check for compressed info
    cmprData = figu.UserData.fInfo.cmpr;
else
    cmprData=[];
end
if ~strcmp(figu.UserData.fInfo.cmpr_format,'none') && ~isempty(cmprData)
    %call ui for name and directory
    file=get(figu,'Name');         %get image name
    %open file selection dialog box to input image
    [file, path] = uiputfile({'*.vipm','CVIPTools VIP (*.vipm)'}, ...
    'Save Image as',[pwd '\Ima\' file]); %mulitple file selection option is OFF, single image file only 
    
    %check if user has successfuly made the file selection
    if ~isequal(file,0)
        hInfo = figu.UserData.fInfo;
        %if history = 'none' change to empty
        if strcmp(hInfo.history_info,'none')
            hInfo.history_info = [];
        end
        [flg,Info] = vipmwrite2_cvip(cmprData,[path file],...
            {hInfo.image_format,hInfo.color_format,hInfo.cmpr_format,...
            'le',hInfo.cvip_type,hInfo.no_of_bands,hInfo.no_of_cols,...
            hInfo.no_of_rows},hInfo.history_info);
        if flg == 1     %write process successful
            if ~isa(Info.history_info,'char')
                histo = ['yes size= ' num2str(Info.history_info(2)/10)];
            else
                histo = 'none';
            end
            hIlist = findobj('Tag','txtIlist');     %get handle of text element
            txtInfo = [{'Saving Image:'};{[Info.filename]};...
                {'Image Information:'};{['Mod. Date: ' datestr(Info.file_mod_date)]};...
                {['Image Format: ' num2str(Info.image_format) ', Color Format: ' ...
                num2str(Info.color_format)]};{['Data Type: ' num2str(Info.cvip_type) ...
                ', Data Format: ' num2str(Info.data_format)]};{['Compression: ' ...
                num2str(Info.cmpr_format) ', Rows: ' num2str(Info.no_of_rows)...
                ', Cols: ' num2str(Info.no_of_cols) ', Bands: ' ...
                num2str(Info.no_of_bands)]}; {['File Size: ' ...
                num2str(Info.file_size)]}; {['History: ' histo]}];
            hIlist.String(end+1,1)=' ';             %print an empty line
            for i=1:size(txtInfo)
                sInfo = txtInfo{i};                 %exract row to print
                hIlist.String(end+1:end+size(sInfo,1),1:size(sInfo,2)) = sInfo;
            end
            hIlist.Value = size(hIlist.String,1);   %goto last line
            figure(hMain);
        end
    end
else
    warndlg('There is not compressed information to save on selected Image', ...
        'Compression Warning', 'modal');
end


% --- Executes on button press in bHuff.
function bHuff_Callback(hObject, eventdata, handles)
% hObject    handle to bHuff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bHuff
hide_all(handles);                      % hide all parameters panels
handles.bBlock.Visible = 'On';

% --- Executes on button press in bZiv.
function bZiv_Callback(hObject, eventdata, handles)
% hObject    handle to bZiv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bZiv
hide_all(handles);                      % hide all parameters panels


% --- Executes on button press in bBRLC.
function bBRLC_Callback(hObject, eventdata, handles)
% hObject    handle to bBRLC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bBRLC
hide_all(handles);                      % hide all parameters panels
handles.bBlock.Visible = 'Off';

% --- Executes on button press in bJPEG.
function bJPEG_Callback(hObject, eventdata, handles)
% hObject    handle to bJPEG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bJPEG
hide_all(handles);                      % hide all parameters panels
handles.bBlock.Visible = 'Off';

% --- Executes on selection change in popBlk.
function popBlk_Callback(hObject, eventdata, handles)
% hObject    handle to popBlk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popBlk contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popBlk


% --- Executes during object creation, after setting all properties.
function popBlk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popBlk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on popBlk and none of its controls.
function popBlk_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popBlk (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data


function hide_all(handles)
% hide all parameters panels
handles.bBlock.Visible = 'Off';
% handles.bHstre.Visible = 'Off';
% handles.bEquBand.Visible = 'Off';

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
function mVhisto_Callback(hObject, eventdata, handles)
% hObject    handle to mVhisto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mVSpec_Callback(hObject, eventdata, handles)
% hObject    handle to mVSpec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mVBand_Callback(hObject, eventdata, handles)
% hObject    handle to mVBand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mVBred_Callback(hObject, eventdata, handles)
% hObject    handle to mVBred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mVBgre_Callback(hObject, eventdata, handles)
% hObject    handle to mVBgre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mVBlue_Callback(hObject, eventdata, handles)
% hObject    handle to mVBlue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mVsfftp_Callback(hObject, eventdata, handles)
% hObject    handle to mVsfftp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mVsfftm_Callback(hObject, eventdata, handles)
% hObject    handle to mVsfftm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mVsLog_Callback(hObject, eventdata, handles)
% hObject    handle to mVsLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mVsLall_Callback(hObject, eventdata, handles)
% hObject    handle to mVsLall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMain = findobj('Tag','Main');              %get the handle of Main form
% get handles and other user-defined data associated to Gui1
g1data = guidata(hMain);
if ~isempty(hMain)
    CVIPToolbox('mVsLall_Callback',g1data.mVsLall,eventdata,guidata(hMain))
end

% --------------------------------------------------------------------
function mVsLred_Callback(hObject, eventdata, handles)
% hObject    handle to mVsLred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mVsLgre_Callback(hObject, eventdata, handles)
% hObject    handle to mVsLgre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mVsLblu_Callback(hObject, eventdata, handles)
% hObject    handle to mVsLblu (see GCBO)
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
function mComp_Callback(hObject, eventdata, handles)
% hObject    handle to mComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mCless_Callback(hObject, eventdata, handles)
% hObject    handle to mCless (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mClossy_Callback(hObject, eventdata, handles)
% hObject    handle to mClossy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mClossy_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mCpre_Callback(hObject, eventdata, handles)
% hObject    handle to mCpre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mCpre_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mCpost_Callback(hObject, eventdata, handles)
% hObject    handle to mCpost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mCpost_Callback',hObject,eventdata,guidata(hObject))


function fLossy_Callback(hObject, eventdata, handles)
% hObject    handle to fLossy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fLossy as text
%        str2double(get(hObject,'String')) returns contents of fLossy as a double


% --- Executes during object creation, after setting all properties.
function fLossy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fLossy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fParam_Callback(hObject, eventdata, handles)
% hObject    handle to fParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fParam as text
%        str2double(get(hObject,'String')) returns contents of fParam as a double


% --- Executes during object creation, after setting all properties.
function fParam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Div02_Callback(hObject, eventdata, handles)
% hObject    handle to Div02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Div02 as text
%        str2double(get(hObject,'String')) returns contents of Div02 as a double


% --- Executes during object creation, after setting all properties.
function Div02_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Div02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
