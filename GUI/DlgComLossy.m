function varargout = DlgComLossy(varargin)
% DLGCOMLOSSY MATLAB code for DlgComLossy.fig
%      DLGCOMLOSSY, by itself, creates a new DLGCOMLOSSY or raises the existing
%      singleton*.
%
%      H = DLGCOMLOSSY returns the handle to a new DLGCOMLOSSY or the handle to
%      the existing singleton*.
%
%      DLGCOMLOSSY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DLGCOMLOSSY.M with the given input arguments.
%
%      DLGCOMLOSSY('Property','Value',...) creates a new DLGCOMLOSSY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgComLossy_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgComLossy_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DlgComLossy

% Last Modified by GUIDE v2.5 18-Jun-2020 15:31:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgComLossy_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgComLossy_OutputFcn, ...
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
%           Updated by:             Julian Rene Cuellar Buritica
%           1st update date:        12/17/2018
%           Last Updated by:        Hridoy Biswas
%           Last update date:       06/15/2020
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.6  12/17/2018  11:28:50  jucuell
 % Updating menu creation programmatically, callbacks to Main figure and
 % the use of the utilities menus in the Main figure.
%
 % Revision 1.5  12/10/2018  20:24:14  jucuell
 % vble funName included to visualize the name of the function used to
 % perform the btc operation, including function name in figure
%
 % Revision 1.4  11/26/2018  16:22:23  jucuell
 % BTC implementation pop-up menu with display time check box
%
 % Revision 1.3  09/06/2018  13:01:48  jucuell
 % gauss filt was added, updating save
 % and open functions
%
 % Revision 1.2  09/04/2018  08:12:05  jucuell
 % adding functions for pre and post - processing, check hist equ for shapes
 % in color, te function has bad example, check remap, need Gauss mask,
 % check image used as input after processed (Ima structure)
%
 % Revision 1.1  09/03/2018  10:05:15  jucuell
 % Initial revision: Creating figure and initial coding
 % 
%

% --- Executes just before DlgComLossy is made visible.
function DlgComLossy_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DlgComLossy (see VARARGIN)

% Choose default command line output for DlgComLossy
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DlgComLossy wait for user response (see UIRESUME)
% uiwait(handles.CLossy);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';%hide Analysis menu
handles.mComp.Visible = 'Off';%hide Compression menu
handles.mView.Visible = 'Off';%hide View menu
handles.box_k.Visible = 'Off';
handles.Level.Visible = 'Off';
handles.popLevel.Visible ='Off';
handles.uipanel5.Visible = 'Off'; 


% --- Outputs from this function are returned to the command line.
function varargout = DlgComLossy_OutputFcn(hObject, eventdata, handles) 
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
function bApply_Callback(hObject, ~, handles)
% hObject    handle to bApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc                                 %clear screen
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
if handles.bBTC.Value               %perform BTC
    %get block size
    Blk=str2double(handles.popBlk.String(handles.popBlk.Value));
    switch handles.popImple.Value
        case 1
            [fData, OutIma, t] = btcenco2_cvip(InIma, Blk);%call function
            funName = 'btcenco_cvip';
            Func = 'BTCenco';
        case 2
            [fData, OutIma, t] = btcencol_cvip(InIma, Blk);%call function
            funName = 'btcencol_cvip';
            Func = 'BTCenCol';
        case 3
            [fData, OutIma, t] = btcevec_cvip(InIma, Blk);%call function
            funName = 'btcevec_cvip';
            Func = 'BTCeVec';
    end
    %update image history
    histo = [262 Blk];
    Name=strcat(file,' > ',Func,'(',num2str(Blk),')');
    %update compression format
    Ima.fInfo.cmpr_format = 'btc';
    Osize = size(InIma,1)*size(InIma,2)*size(InIma,3);
    Nsize = size(fData,1);
    ratio = Osize/Nsize;
    txtInfo = [{['Performing "' funName ]};
        {['Original file "' file '" size is:' num2str(Osize) ' Bytes']};
        {['Compressed file "' Name '" size is:' num2str(Nsize) ' Bytes']};
        {['The compression ratio is 1:' num2str(ratio)]}];
    if handles.cDTime.Value             %display processing time
        txtInfo = [txtInfo; {['Processing Time: ' num2str(t) ' Seconds.']}];
    end
   
elseif handles.bMbtc.Value
       tic
       Block =str2double(handles.popBlk.String(handles.popBlk.Value)); 
       Level = str2double(handles.popLevel.String(handles.popLevel.Value));
       fData = mBTCenco_cvip(InIma,Block,Level);
   
       OutIma =mBTCdeco_cvip(fData);
       t=toc;
       histo = [262 Block];
       funName = 'mBTC_cvip';
       Func = 'mBTC';
    Name=strcat(file,' > ',Func,'(',num2str(Block),')');
    %update compression format
    Ima.fInfo.cmpr_format = 'mbtc';
    Osize = size(InIma,1)*size(InIma,2)*size(InIma,3);
    %Nsize = strlength(fdata);
    Nsize = size(fData,1);
    ratio = Osize/Nsize;
    txtInfo = [{['Performing "' funName ]};
        {['Original file "' file '" size is:' num2str(Osize) ' Bytes']};
        {['Compressed file "' Name '" size is:' num2str(Nsize) ' Bytes']};
        {['The compression ratio is 1:' num2str(ratio)]}];
       
       if handles.cDTime.Value             %display processing time
        txtInfo = [txtInfo; {['Processing Time: ' num2str(t) ' Seconds.']}];
       end%perform 

    
elseif handles.bDPC.Value           %perform 

    

elseif handles.bBRLC.Value
    tic
           bitcount=0;
         if handles.one.Value 
             bitcount=bitcount+1;
         end
         if  handles.two.Value 
             bitcount=bitcount+2;
         end
         if handles.three.Value 
             bitcount=bitcount+4;
         end
          if  handles.four.Value 
             bitcount=bitcount+8;
          end
          if  handles.five.Value 
             bitcount=bitcount+16;
          end
          if  handles.six.Value 
             bitcount=bitcount+32;
          end
          if  handles.seven.Value 
             bitcount=bitcount+64;
          end
          if  handles.eight.Value 
             bitcount=bitcount+128;
         end
     
       fData =bRLCenco_cvip(InIma,bitcount);
   
   
       OutIma =bRLCdeco_cvip(fData);
       t=toc;
       histo = [262 bitcount];
       funName = 'mBRLC_cvip';
       Func = 'mBRLC';
    Name=strcat(file,' > ',Func,'(',num2str(bitcount),')');
    %update compression format
    Ima.fInfo.cmpr_format = 'brlc';
    Osize = size(InIma,1)*size(InIma,2)*size(InIma,3);
    Nsize = size(fData,1);
    ratio = Osize/Nsize;
    txtInfo = [{['Performing "' funName ]};
        {['Original file "' file '" size is:' num2str(Osize) ' Bytes']};
        {['Compressed file "' Name '" size is:' num2str(Nsize) ' Bytes']};
        {['The compression ratio is 1:' num2str(ratio)]}];
       
       if handles.cDTime.Value             %display processing time
        txtInfo = [txtInfo; {['Processing Time: ' num2str(t) ' Seconds.']}];
       end%perform %perform 
       
elseif handles.K_mean.Value  
    K = str2double(handles.K_pop_1.String(handles.K_pop_1.Value));
    max_iters = str2double(handles.max_iter.String(handles.max_iter.Value));
    funName = 'K-mean_cvip';
    Func = 'K-means';
    Name=strcat(file,' > ',Func,'(',num2str(K),')');
    
    
    [OutIma,ratio, ~,size1,~,time,fData] = kmeans_Cvip(InIma,K, max_iters);
    histo = [262 K];
    
     Ima.fInfo.cmpr_format = 'K-means';
    
    Osize = size(InIma,1)*size(InIma,2)*size(InIma,3);
    txtInfo = [{['Performing "' funName '" with cluster size: ' num2str(K)]};
        {['Original file "' file '" size is:' num2str(Osize) ' Bytes']};
        {['Compressed file "' Name '" size is:' num2str(size1) ' Bytes']};
        {['The compression ratio is 1:' num2str(ratio)]}];
    if handles.cDTime.Value             %display processing time
        txtInfo = [txtInfo; {['Processing Time: ' num2str(time) ' Seconds.']}];
    end
       
 
elseif handles.K_mean_plus.Value  %perform 
    
   
    K =str2double(handles.K_pop_1.String(handles.K_pop_1.Value)); % No. of clusters required (#colors here)

    max_iters = str2double(handles.max_iter.String(handles.max_iter.Value));% No. of iteration;
    funName = 'K-mean_plus_cvip';
    Func = 'K-means ++';
    Name=strcat(file,' > ',Func,'(',num2str(K),')');
      histo = [262 K];
    
     Ima.fInfo.cmpr_format = 'K-means_plus';
    
    
    [OutIma,ratio, ~,size1,~,time,fData] = kmeans_plus_cvip(InIma,K, max_iters);
    
    Osize = size(InIma,1)*size(InIma,2)*size(InIma,3);
    txtInfo = [{['Performing "' funName '" with cluster number: ' num2str(K)]};
        {['Original file "' file '" size is:' num2str(Osize) ' Bytes']};
        {['Compressed file "' Name '" size is:' num2str(size1) ' Bytes']};
        {['The compression ratio is 1:' num2str(ratio)]}];
    if handles.cDTime.Value             %display processing time
        txtInfo = [txtInfo; {['Processing Time: ' num2str(time) ' Seconds.']}];
    end
end

%check if need to save history
if strcmp(hSHisto(1).Checked,'on')	%save new image history
    Ima.fInfo.history_info = historyupdate_cvip(Ima.fInfo.history_info,histo);  
end
%check if need to show function information
if strcmp(hVfinfo(1).Checked,'on')
    hIlist = findobj('Tag','txtIlist');%get handle of text element
    hIlist.String(end+1,1)=' ';    	%print an empty line
    %txtInfo = historydeco_cvip(histo);
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
end

% --- Executes on button press in bCancel.
function bCancel_Callback(hObject, eventdata, handles)
% hObject    handle to bCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Prepare to close application window
 close(handles.CLossy)


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
if figu ~= 0 && isfield(figu.UserData.fInfo,'cmpr')%check for compressed info
    cmprData = figu.UserData.fInfo.cmpr;
else
    cmprData=[];
end
if ~isempty(cmprData) && ~strcmp(figu.UserData.fInfo.cmpr_format,'none')
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


% --- Executes on button press in K_mean_plus.
function bBTC_Callback(hObject, eventdata, handles)
% hObject    handle to K_mean_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of K_mean_plus
hide_all(handles);                      % hide all parameters panels
handles.bBlock.Visible = 'On';
handles.Level.Visible = 'Off';
handles.popLevel.Visible ='Off';
handles.lblImple.Visible = 'On';
handles.popImple.Visible = 'On' ;

% --- Executes on button press in bMbtc.
function bMbtc_Callback(hObject, eventdata, handles)
% hObject    handle to bMbtc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bMbtc
hide_all(handles); 
handles.bBlock.Visible = 'On';
handles.lblImple.Visible = 'Off';
handles.popImple.Visible = 'Off' ;
handles.Level.Visible = 'On';
handles.popLevel.Visible ='On';

% hide all parameters panels


% --- Executes on button press in bBRLC.
function bBRLC_Callback(hObject, eventdata, handles)
% hObject    handle to bBRLC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bBRLC
hide_all(handles);                      % hide all parameters panels
handles.bBlock.Visible = 'Off';
handles.uipanel5.Visible = 'On';

% --- Executes on button press in bDPC.
function bDPC_Callback(hObject, eventdata, handles)
% hObject    handle to bDPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bDPC
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
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data
% hObject    handle to popBlk (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case


% --- Executes on selection change in popImple.
function popImple_Callback(hObject, eventdata, handles)
% hObject    handle to popImple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popImple contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popImple


% --- Executes during object creation, after setting all properties.
function popImple_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popImple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cDTime.
function cDTime_Callback(hObject, eventdata, handles)
% hObject    handle to cDTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cDTime

function hide_all(handles)
% hide all parameters panels
handles.bBlock.Visible = 'Off';
handles.box_k.Visible = 'Off';
handles.uipanel5.Visible = 'Off';
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
CVIPToolbox('mVsLall_Callback',g1data.mVsLall,eventdata,guidata(hMain))


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
CVIPToolbox('mCless_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mClossy_Callback(hObject, eventdata, handles)
% hObject    handle to mClossy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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



function box_K_Callback(hObject, eventdata, handles)
% hObject    handle to box_K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_K as text
%        str2double(get(hObject,'String')) returns contents of box_K as a double


% --- Executes during object creation, after setting all properties.
function box_K_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in K_pop_1.
function K_pop_1_Callback(hObject, eventdata, handles)
% hObject    handle to K_pop_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns K_pop_1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from K_pop_1


% --- Executes during object creation, after setting all properties.
function K_pop_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K_pop_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in max_iter.
function max_iter_Callback(hObject, eventdata, handles)
% hObject    handle to max_iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns max_iter contents as cell array
%        contents{get(hObject,'Value')} returns selected item from max_iter


% --- Executes during object creation, after setting all properties.
function max_iter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function bBlock_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bBlock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in K_mean.
function K_mean_Callback(hObject, eventdata, handles)
% hObject    handle to K_mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hide_all(handles);                      % hide all parameters panels
handles.box_k.Visible = 'On';

% Hint: get(hObject,'Value') returns toggle state of K_mean


% --- Executes on button press in K_mean_plus.
function K_mean_plus_Callback(hObject, eventdata, handles)
% hObject    handle to K_mean_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hide_all(handles);                      % hide all parameters panels

handles.box_k.Visible = 'On';


% Hint: get(hObject,'Value') returns toggle state of K_mean_plus


% --- Executes during object creation, after setting all properties.
function box_k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function lblBlk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lblBlk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in popLevel.
function popLevel_Callback(hObject, eventdata, handles)
% hObject    handle to popLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popLevel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popLevel


% --- Executes during object creation, after setting all properties.
function popLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Level_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function lblImple_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lblImple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function retrun_CreateFcn(hObject, eventdata, handles)
% hObject    handle to retrun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in checkbox17.
function checkbox17_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox17


% --- Executes on button press in checkbox18.
function checkbox18_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox18


% --- Executes on button press in checkbox19.
function checkbox19_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox19


% --- Executes on button press in checkbox20.
function checkbox20_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox20


% --- Executes on button press in checkbox21.
function checkbox21_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox21


% --- Executes on button press in checkbox22.
function checkbox22_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox22


% --- Executes on button press in checkbox23.
function checkbox23_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox23


% --- Executes on button press in checkbox24.
function checkbox24_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox24


% --- Executes during object creation, after setting all properties.
function uipanel5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in one.
function one_Callback(hObject, eventdata, handles)
% hObject    handle to one (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of one


% --- Executes on button press in three.
function three_Callback(hObject, eventdata, handles)
% hObject    handle to three (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of three


% --- Executes on button press in four.
function four_Callback(hObject, eventdata, handles)
% hObject    handle to four (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of four


% --- Executes on button press in two.
function two_Callback(hObject, eventdata, handles)
% hObject    handle to two (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of two


% --- Executes on button press in five.
function five_Callback(hObject, eventdata, handles)
% hObject    handle to five (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of five


% --- Executes on button press in six.
function six_Callback(hObject, eventdata, handles)
% hObject    handle to six (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of six


% --- Executes on button press in seven.
function seven_Callback(hObject, eventdata, handles)
% hObject    handle to seven (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of seven


% --- Executes on button press in eight.
function eight_Callback(hObject, eventdata, handles)
% hObject    handle to eight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of eight
