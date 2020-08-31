function varargout = CVIPToolbox(varargin)
% CVIPTOOLBOX MATLAB code for CVIPToolbox.fig
%      CVIPTOOLBOX, by itself, creates a new CVIPTOOLBOX or raises the existing
%      singleton*.
%
%      H = CVIPTOOLBOX returns the handle to a new CVIPTOOLBOX or the handle to
%      the existing singleton*.
%
%      CVIPTOOLBOX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CVIPTOOLBOX.M with the given input arguments.
%
%      CVIPTOOLBOX('Property','Value',...) creates a new CVIPTOOLBOX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CVIPToolbox_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CVIPToolbox_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CVIPToolbox

% Last Modified by GUIDE v2.5 07-Jul-2019 14:50:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CVIPToolbox_OpeningFcn, ...
                   'gui_OutputFcn',  @CVIPToolbox_OutputFcn, ...
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
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications 
% with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Julian Rene Cuellar Buritica
%           Initial coding date:    09/08/2017
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     05/25/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.8  06/19/2019  19:29:44  jucuell 
 % function for saving image was modified in in order to save the remaped
 % image instead of the real data...  OJOJOJO con vipm file
%
 % Revision 1.7  05/25/2019  13:54:16  jucuell 
 % including the function updatemenus() in this code and adding icon to the
 % message box when trying to copy the content of the function information
%
 % Revision 1.6  05/04/2019  12:39:13  jucuell 
 % adding view histogram, extract red, green and blue bands functions and
 % toolbar icons. The dialog Help About was added. Adding functions for Log
 % remap all bands, R, G and B bands.
%
 % Revision 1.5  12/19/2018  17:45:13  jucuell 
 % fixing menu Utilities behavior by including a submenu, a menu position
 % change and the menu checked option. 
%
 % Revision 1.4  12/08/2018  19:15:36  jucuell
 % opening of multiple images by incorporating the multiselect on the
 % select image window.
% 
 % Revision 1.3  09/25/2018  15:55:35  jucuell
 % incorporation of open_image, imastruct, btcenco n btcdeco, update menu
 % for compression figures calling, save image updating
%
 % Revision 1.2  09/23/2018  13:14:08  jucuell REV
 % change name from btc_cvip to btcenco_cvip and change order of output
 % parameters the file data (fData) will be first, help info update
%
 % Revision 1.1  09/08/2018  17:48:03  jucuell REV
 % Initial revision: Function creation and initial testing
 % 
%

% --- Executes just before CVIPToolbox is made visible.
function CVIPToolbox_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CVIPToolbox (see VARARGIN)

% Choose default command line output for CVIPToolbox
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CVIPToolbox wait for user response (see UIRESUME)
% uiwait(handles.Main);
%save initial path
handles.Main.UserData = 0;
%change default icon
% warning ('off','all');
% javaFrame = get(hObject,'JavaFrame');
% javaFrame.setFigureIcon(javax.swing.ImageIcon([pwd '\Resources\icon_48.PNG']));


% --- Outputs from this function are returned to the command line.
function varargout = CVIPToolbox_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% CODE CALLBACKS ORDER:
% - Buttons (bApply, bCancel, bReset, ...)
% - Radio Buttons (Options, choices)
% - Pop-up Menús
% - Figure Callbacks (Resize, Click, ...)
% - Main Menus (fOpen, fSave)
% - Ui Main Menus (uiOpen, uiSave)
% - Menus (Others: View, Analysis, Compression...)

% --- Executes during object creation, after setting all properties.
function Main_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when Main is resized.
function Main_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to Main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Pos = hObject.Position;
handles.txtIlist.Position = [5 2.5 Pos(3)-10 Pos(4)-5];


% --------------------------------------------------------------------
function fOpen_Callback(hObject, eventdata, handles)
% hObject    handle to fOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
cpath = handles.fOpen.UserData;                   %recover image path
if cpath == 0
    cpath = mfilename( 'fullpath' );
    cpath = [cpath(1:end-15) 'Images'];
elseif isempty(cpath)
    cpath = mfilename( 'fullpath' );
    cpath = [cpath(1:end-15) 'Images'];
end

% [InIma, file, cpath] = open_image(cpath);   %open image file
%open file selection dialog box to input image
[file, cpath] = uigetfile({'*.*', 'All Files (*.*)';...
    '*.vipm','CVIPTools VIPM (*.vipm)';'*.bmp','Windows Bitmap (*.bmp)';...
    '*.tif','Tagged Image File (*.tif)'; '*.gif','Graphic Interchange (*.gif)'; ... 
     '*.jpg', 'JPEG/JPEG2000 (*.jpg)'; ...
    '*.png','Portable Network Graphics (*.png)'; '*.pbm ; *.ppm;*.pgm; *.pnm',...
    'Portable Image File (*.pbm,*.ppm,*.pgm, *.pnm)'}, ...
    'Select an input image file', 'MultiSelect','on',cpath); %mulitple file

%check if user has successfuly made the file selection
if ~isequal(file,0)
    if strcmp(class(file),'char')       %just one file selected
        showImages(handles, cpath, file);
    else
        for i=1:size(file,2)
            fileN = file{i};
            showImages(handles, cpath, fileN);
        end
    end
end

if cpath ~= 0
    handles.fOpen.UserData = cpath;                   %save new image path
end


% --------------------------------------------------------------------
function fSave_Callback(hObject, eventdata, handles)
% hObject    handle to fSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hNfig = handles.Main.UserData;         %get image handle
if hNfig ~= 0 && isfield(hNfig.UserData,'cvipIma')  %check for Image to save
    file=get(hNfig,'Name');         %get image name

    ppath = pwd;                    %save project path
    cpath = handles.fSave.UserData; %recover image path
    if cpath == 0
        cpath = mfilename( 'fullpath' );
        cpath = [cpath(1:end-15) 'Images'];
    end
    if isempty(cpath)
        cpath = mfilename( 'fullpath' );
        cpath = [cpath(1:end-15) 'Images'];
    end
    %save image file
%     [filename, cpath] = save_image(InIma, file, cpath);         
    %open file selection dialog box to input image
    [filename, cpath, index] = uiputfile({'*.vipm','CVIPTools VIPM (*.vipm)';...
    '*.bmp','Windows Bitmap (*.bmp)';'*.tif','Tagged Image File (*.tif)';  ... 
    '*.gif','Graphic Interchange (*.gif)'; '*.jpg', 'JPEG/JPEG2000 (*.jpg)'; ...
    '*.png','Portable Network Graphics (*.png)'; '*.pbm ; *.ppm;*.pgm; *.pnm',...
    'Portable Image File (*.pbm,*.ppm,*.pgm, *.pnm)';...
    }, 'Save Image as',[cpath '\' file]); 

    %check if user has successfuly made the file selection
    if ~isequal(filename,0)
        
        hInfo = hNfig.UserData.fInfo;
        %if history = 'none' change to empty
        if strcmp(hInfo.history_info,'none')
            hInfo.history_info = [];
        end
        % save image according to file type
        if index == 1       %save CVIP format
            InIma = hNfig.UserData.cvipIma;  %  this is original image info
            %change compress format for compressed images
            if ~strcmp(hInfo.cmpr_format,'none')
                hInfo.cmpr_format = 'none';
            end
            [flg,Info] = vipmwrite2_cvip(InIma,[cpath filename],...
            {hInfo.image_format,hInfo.color_format,hInfo.cmpr_format,...
            'le',hInfo.cvip_type,hInfo.no_of_bands,hInfo.no_of_cols,...
            hInfo.no_of_rows},hInfo.history_info);
        else
            hh=guidata(hNfig);         %read remaped image info
            InIma = hh.axes1.Children; % before we used: getimage(hObject);
            if ~isempty(InIma)
                InIma = InIma.CData;
            end
            if ~isempty(hInfo.history_info)
%                 trans = hInfo.history_info(:,1);    %get operations list
                trans = hInfo.history_info(end,1);    %get operations list
%                 if sum(trans == 212) > 0   %info trans 212 FFT
                if trans == 212   %info trans 212 FFT
                    InIma = remap_cvip(abs(InIma),[0 255]);    %log remap tranform info
%                 elseif sum(trans == 211) > 0   %info trans 211
                elseif trans == 211 %info trans 211
                    InIma = remap_cvip(InIma,[0 255]); 
                end
            end
            if max(max(InIma(:))) <= 1   %check if image is double between 0 and 1
                imwrite(InIma, [cpath filename]);
            else
                imwrite(uint8(InIma), [cpath filename]);
            end
            flg = 1;        %setup info flag
            Info = imastruc_cvip([cpath filename]);
            Info = Info.fInfo;
        end
        set(hNfig,'Name',filename);
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
            figure(handles.Main);
        end
    else
        cpath = ppath;
    end

    handles.fSave.UserData = cpath; %save new image path

else
    errordlg('There is nothing to save. Please select an Image and try again','Save Error','modal');
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
clc;                             %clear screen
hMain = findobj('Tag','Main');
hVfun = findobj('Tag','mVfi');
hIlist = findobj('Tag','txtIlist');
if strcmp(hObject.Checked,'off')
    %hObject.Checked = 'On';
    for i=1:size(hVfun,1)
        hVfun(i).Checked = 'on';
    end
    hIlist.Visible = 'On';
else
    %hObject.Checked='Off';
    for i=1:size(hVfun,1)
        hVfun(i).Checked = 'off';
    end
    hIlist.Visible = 'Off';
end
figure(hMain)

% --------------------------------------------------------------------
function mViHis_Callback(hObject, eventdata, handles)
% hObject    handle to mViHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mVhisto_Callback(hObject, eventdata, handles)
% hObject    handle to mVhisto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
%show histogram of selected image
hMain = findobj('Tag','Main');      %get the handle of Main figure
% hSHisto = findobj('Tag','mVsaveHis');%get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = hMain.UserData;             %get image handle
if hNfig == 0 || isempty(hNfig) || ~isfield(hNfig.UserData,'cvipIma')
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Histogram Error','modal'); 
else
    InIma = hNfig.UserData.cvipIma;          %read image data
    file = get(hNfig,'Name');       %get image name
    histo = 71;                     %update history information
    
%check if need to show function information
if strcmp(hVfinfo(1).Checked,'on')
    hIlist = findobj('Tag','txtIlist');%get handle of text element
    hIlist.String(end+1,1)=' ';   	%print an empty line
    txtInfo = historydeco_cvip(histo);
    hIlist.String(end+1,1:size(file,2)+1)=[file ':']; 
    for i=1:size(txtInfo)
        sInfo = txtInfo{i};       	%extract row to print
        sInfo = sprintf(sInfo);
        [~,rr] = size(sInfo);
        hIlist.String(end+1,1:rr) = sInfo;
    end
    hIlist.Value = size(hIlist.String,1);%goto last line
    figure(hMain);
end

%display image
hFig = figure;                    	%call new figure
hFig.WindowStyle = 'normal';      	%set initial window style
get_hist_image_cvip(InIma);         %call histogram function
set(gcf,'Name',[file ' > Histogram '],'NumberTitle','off')%figure name
figure(hNfig);                      %focus to last image
%Add figure to group
group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hFig); 
figure(hFig);   
    
end


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
clc;                             %clear screen
%extract red band from image
hMain = findobj('Tag','Main');      %get the handle of Main figure
hSHisto = findobj('Tag','mVsaveHis');%get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = hMain.UserData;             %get image handle

if hNfig == 0 || isempty(hNfig) || ~isfield(hNfig.UserData,'cvipIma')
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Extract Band Error','modal'); 
elseif size(hNfig.UserData.cvipIma,3) == 1
    errordlg(['Selected image is not a Color Image. Please select a Color '...
        'Image and try again.'],'Extract Band Error','modal'); 
else
    Ima = hNfig.UserData;          	%get image structure
    InIma = Ima.cvipIma;           	%read image data
    file = get(hNfig,'Name');       %get image name
    Name = [file ' > Red Band'];    %image name
    OutIma = uint8(zeros(size(InIma)));%empty 3 band image
    OutIma(:,:,1) = extract_band_cvip(InIma, 1);%extract Red band
    histo = [10 1];              	%update history information

%check if need to save history
if strcmp(hSHisto(1).Checked,'on')	%save new image history
    Ima.fInfo.history_info = historyupdate_cvip(Ima.fInfo.history_info,histo);  
end

%check if need to show function information
if strcmp(hVfinfo(1).Checked,'on')
    hIlist = findobj('Tag','txtIlist');%get handle of text element
    hIlist.String(end+1,1)=' ';   	%print an empty line
    txtInfo = historydeco_cvip(histo);
    hIlist.String(end+1,1:size(file,2)+1)=[file ':']; 
    for i=1:size(txtInfo)
        sInfo = txtInfo{i};       	%extract row to print
        sInfo = sprintf(sInfo);
        [~,rr] = size(sInfo);
        hIlist.String(end+1,1:rr) = sInfo;
    end
    hIlist.Value = size(hIlist.String,1);%goto last line
    figure(hMain);
end

%display image
if size(OutIma,1) > 3
    [row,col,band]=size(OutIma);  	%get new image size
    %update image information
    Ima.fInfo.no_of_bands=band;             
    Ima.fInfo.no_of_cols=col;              
    Ima.fInfo.no_of_rows=row;
    %update image structure
    Ima.cvipIma = OutIma;        	%read image data
    showgui_cvip(Ima, Name);       	%show image in viewer
end
    
end

% --------------------------------------------------------------------
function mVBgre_Callback(hObject, eventdata, handles)
% hObject    handle to mVBgre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
%extract green band from image
hMain = findobj('Tag','Main');      %get the handle of Main figure
hSHisto = findobj('Tag','mVsaveHis');%get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = hMain.UserData;             %get image handle

if hNfig == 0 || isempty(hNfig) || ~isfield(hNfig.UserData,'cvipIma')
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Extract Band Error','modal'); 
elseif size(hNfig.UserData.cvipIma,3) == 1
    errordlg(['Selected image is not a Color Image. Please select a Color '...
        'Image and try again.'],'Extract Band Error','modal'); 
else
    Ima = hNfig.UserData;          	%get image structure
    InIma = Ima.cvipIma;           	%read image data
    file = get(hNfig,'Name');       %get image name
    Name = [file ' > Green Band'];	%image name
    OutIma = uint8(zeros(size(InIma)));%empty 3 band image
    OutIma(:,:,2) = extract_band_cvip(InIma, 2);%extract Red band
    histo = [10 2];              	%update history information

%check if need to save history
if strcmp(hSHisto(1).Checked,'on')	%save new image history
    Ima.fInfo.history_info = historyupdate_cvip(Ima.fInfo.history_info,histo);  
end

%check if need to show function information
if strcmp(hVfinfo(1).Checked,'on')
    hIlist = findobj('Tag','txtIlist');%get handle of text element
    hIlist.String(end+1,1)=' ';   	%print an empty line
    txtInfo = historydeco_cvip(histo);
    hIlist.String(end+1,1:size(file,2)+1)=[file ':']; 
    for i=1:size(txtInfo)
        sInfo = txtInfo{i};       	%extract row to print
        sInfo = sprintf(sInfo);
        [~,rr] = size(sInfo);
        hIlist.String(end+1,1:rr) = sInfo;
    end
    hIlist.Value = size(hIlist.String,1);%goto last line
    figure(hMain);
end

%display image
if size(OutIma,1) > 3
    [row,col,band]=size(OutIma);  	%get new image size
    %update image information
    Ima.fInfo.no_of_bands=band;             
    Ima.fInfo.no_of_cols=col;              
    Ima.fInfo.no_of_rows=row;
    %update image structure
    Ima.cvipIma = OutIma;        	%read image data
    showgui_cvip(Ima, Name);       	%show image in viewer
end
    
end

% --------------------------------------------------------------------
function mVBlue_Callback(hObject, eventdata, handles)
% hObject    handle to mVBlue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
%extract blue band from image
hMain = findobj('Tag','Main');      %get the handle of Main figure
hSHisto = findobj('Tag','mVsaveHis');%get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = hMain.UserData;             %get image handle

if hNfig == 0 || isempty(hNfig) || ~isfield(hNfig.UserData,'cvipIma')
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Extract Band Error','modal'); 
elseif size(hNfig.UserData.cvipIma,3) == 1
    errordlg(['Selected image is not a Color Image. Please select a Color '...
        'Image and try again.'],'Extract Band Error','modal'); 
else
    Ima = hNfig.UserData;          	%get image structure
    InIma = Ima.cvipIma;           	%read image data
    file = get(hNfig,'Name');       %get image name
    Name = [file ' > Blue Band'];    %image name
    OutIma = uint8(zeros(size(InIma)));%empty 3 band image
    OutIma(:,:,3) = extract_band_cvip(InIma, 3);%extract Red band
    histo = [10 3];              	%update history information

%check if need to save history
if strcmp(hSHisto(1).Checked,'on')	%save new image history
    Ima.fInfo.history_info = historyupdate_cvip(Ima.fInfo.history_info,histo);  
end

%check if need to show function information
if strcmp(hVfinfo(1).Checked,'on')
    hIlist = findobj('Tag','txtIlist');%get handle of text element
    hIlist.String(end+1,1)=' ';   	%print an empty line
    txtInfo = historydeco_cvip(histo);
    hIlist.String(end+1,1:size(file,2)+1)=[file ':']; 
    for i=1:size(txtInfo)
        sInfo = txtInfo{i};       	%extract row to print
        sInfo = sprintf(sInfo);
        [~,rr] = size(sInfo);
        hIlist.String(end+1,1:rr) = sInfo;
    end
    hIlist.Value = size(hIlist.String,1);%goto last line
    figure(hMain);
end

%display image
if size(OutIma,1) > 3
    [row,col,band]=size(OutIma);  	%get new image size
    %update image information
    Ima.fInfo.no_of_bands=band;             
    Ima.fInfo.no_of_cols=col;              
    Ima.fInfo.no_of_rows=row;
    %update image structure
    Ima.cvipIma = OutIma;        	%read image data
    showgui_cvip(Ima, Name);       	%show image in viewer
end
    
end

function mDeleteAll_Callback(hObject,eventdata,handles)
%hObject    handle to mDeleteAll (see GCBO)
%eventdata  reserved - to be defined in a future version of MATLAB
%handles    structure with handles and user data see (GUIDATA)
clc;
%determine how many image figures are open
Image_Figures = findall(groot,'Type','Figure','Tag','NewFig');
close(Image_Figures);


% --------------------------------------------------------------------
function mVsfftp_Callback(hObject, eventdata, handles)
% hObject    handle to mVsfftp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
%extract FFT phase information
hMain = findobj('Tag','Main');      %get the handle of Main figure
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = hMain.UserData;             %get image handle

if hNfig == 0 || isempty(hNfig) || ~isfield(hNfig.UserData,'cvipIma')
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Extract FFT Phase Error','modal'); 
else
    Ima = hNfig.UserData;          	%get image structure
    InIma = Ima.cvipIma;           	%read image data
    file = get(hNfig,'Name');       %get image name
    %ask for spectral FFT info
    [ro,co]=find(Ima.fInfo.history_info==212);
    if ~isempty(ro) %info trans 212
        block = Ima.fInfo.history_info(ro,co+1);%get used Block size
        oIma = ifft_cvip(InIma, block);%call iFFT function
        histo = [220 block];        %update history information
        Ima.fInfo.data_format = 'REAL';%update image data format
        Spect = fft_phase_cvip(oIma, block);%call FFT phase function
        histo = historyupdate_cvip(histo,[214 block]);
        Name = strcat(file,' > FFT (Phase)');  
  
    else                                    %apply inverse transformation
        %show Error info
        errordlg('Selected image does not contain FFT transform information.', ...
            'Extract FFT Phase Error', 'modal');
        histo = 0;
    end

if histo(1) ~= 0 
    %save history
    Ima.fInfo.history_info = historyupdate_cvip(Ima.fInfo.history_info,histo);  
    %check if need to show function information
    if strcmp(hVfinfo(1).Checked,'on') 
        hIlist = findobj('Tag','txtIlist');     %get handle of text element
        hIlist.String(end+1,1)=' ';             %print an empty line
        txtInfo = historydeco_cvip(histo);
        hIlist.String(end+1,1:size(file,2)+1)=[file ':']; 
        for i=1:size(txtInfo)
            sInfo = txtInfo{i};                 %exract row to print
            sInfo = sprintf(sInfo);
            [~,rr] = size(sInfo);
            hIlist.String(end+1,1:rr) = sInfo;
        end
        hIlist.Value = size(hIlist.String,1);   %goto last line
        figure(hMain);
    end
    [row,col,band]=size(Spect);                 %get new image size
    %update image information
    Ima.fInfo.no_of_bands=band;             
    Ima.fInfo.no_of_cols=col;              
    Ima.fInfo.no_of_rows=row;
    %update image structure
    Ima.cvipIma = Spect;                        %store image data
    Ima.fInfo.cvip_type = 'cvip_double';        %update image data format
    showgui_cvip(Ima, Name);                    %display image
end
    
end

% --------------------------------------------------------------------
function mVsfftm_Callback(hObject, eventdata, handles)
% hObject    handle to mVsfftm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
%extract FFT magnitude information
hMain = findobj('Tag','Main');      %get the handle of Main figure
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = hMain.UserData;             %get image handle

if hNfig == 0 || isempty(hNfig) || ~isfield(hNfig.UserData,'cvipIma')
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Extract FFT Magnitude Error','modal'); 
else
    Ima = hNfig.UserData;          	%get image structure
    InIma = Ima.cvipIma;           	%read image data
    file = get(hNfig,'Name');       %get image name
    %ask for spectral FFT info
    [ro,co]=find(Ima.fInfo.history_info==212);
    if ~isempty(ro) %info trans 212
        block = Ima.fInfo.history_info(ro,co+1);%get used Block size
        oIma = ifft_cvip(InIma, block);%call iFFT function
        histo = [220 block];        %update history information
        Ima.fInfo.data_format = 'REAL';%update image data format
        Spect = fft_mag_cvip(oIma, block);%call FFT phase function
        histo = historyupdate_cvip(histo,[213 block]);
        Name = strcat(file,' > FFT (Mag.)');  
  
    else                                    %apply inverse transformation
        %show Error info
        errordlg('Selected image does not contain FFT transform information.', ...
            'Extract FFT Magnitude Error', 'modal');
        histo = 0;
    end

if histo(1) ~= 0 
    %save history
    Ima.fInfo.history_info = historyupdate_cvip(Ima.fInfo.history_info,histo);  
    %check if need to show function information
    if strcmp(hVfinfo(1).Checked,'on') 
        hIlist = findobj('Tag','txtIlist');     %get handle of text element
        hIlist.String(end+1,1)=' ';             %print an empty line
        txtInfo = historydeco_cvip(histo);
        hIlist.String(end+1,1:size(file,2)+1)=[file ':']; 
        for i=1:size(txtInfo)
            sInfo = txtInfo{i};                 %exract row to print
            sInfo = sprintf(sInfo);
            [~,rr] = size(sInfo);
            hIlist.String(end+1,1:rr) = sInfo;
        end
        hIlist.Value = size(hIlist.String,1);   %goto last line
        figure(hMain);
    end
    [row,col,band]=size(Spect);                 %get new image size
    %update image information
    Ima.fInfo.no_of_bands=band;             
    Ima.fInfo.no_of_cols=col;              
    Ima.fInfo.no_of_rows=row;
    %update image structure
    Ima.cvipIma = Spect;                        %store image data
    Ima.fInfo.cvip_type = 'cvip_double';        %update image data format
    showgui_cvip(Ima, Name);                    %display image
end
    
end

% --------------------------------------------------------------------
function mVsLog_Callback(hObject, eventdata, handles)
% hObject    handle to mVsLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mVvimaHis_Callback(hObject, eventdata, handles)
% hObject    handle to mVvimaHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%show viewer of image history
clc;                             %clear screen
%display image history
hMain = findobj('Tag','Main');
hNfig = hMain.UserData;         %get image handle
if hNfig == 0 || isempty(hNfig) || ~isfield(hNfig.UserData,'cvipIma')
    warndlg('Select an Image to see its History!!!','History Warning','modal');
else
    Ima=hNfig.UserData;         %Get image name
    fInfo = Ima.fInfo;   %read image information
    file=get(hNfig,'Name');         %get image name

    %call figure
    hVhist = findobj('Tag','DlgIView'); %check if was previously opened
    if isempty(hVhist)
        figure(hMain);
        hVhist=DlgIView;                %call History viewer Form
        hVhist.UserData = 'vHisto';        %indicate selected option
        updatemenus();
        set(gcf,'Name','View - History','NumberTitle','off')
        group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hVhist);
    end
    htxtList = findobj('Tag','txtLst'); %get handle of Save history menu
    htxtList.String(end+1,1) = ' ';       %print empty line
    if isempty(fInfo.history_info) || strcmp(fInfo.history_info,'none')
        htxtList.String(end+1,1:27+size(file,2))=['There is no history for: "' file '"'];
    else
        htxtList.String(end+1,1:27+size(file,2))=['This is the history for: "' file '"'];
        histo=historydeco_cvip(fInfo.history_info);
        for i=1:size(histo)
            sInfo = histo{i};                 %exract row to print
            sInfo = sprintf(sInfo);
            [~,rr] = size(sInfo);
            htxtList.String(end+1,1:rr) = sInfo;
        end
    end
    htxtList.Value = size(htxtList.String,1);   %goto last line
    figure(hVhist);
end

% --------------------------------------------------------------------
function mVsaveHis_Callback(hObject, eventdata, handles)
% hObject    handle to mVsaveHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
%start/stop saving history
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
function mVsLall_Callback(hObject, eventdata, handles)
% hObject    handle to mVsLall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
%Log remap all bands
hMain = findobj('Tag','Main');      %get the handle of Main figure
hSHisto = findobj('Tag','mVsaveHis');%get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = hMain.UserData;             %get image handle

if hNfig == 0 || isempty(hNfig) || ~isfield(hNfig.UserData,'cvipIma')
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Extract FFT Magnitude Error','modal'); 
else
    Ima = hNfig.UserData;          	%get image structure
    InIma = Ima.cvipIma;           	%read image data
    file = get(hNfig,'Name');       %get image name
    OutIma = logremap_cvip(InIma);
    Name = [file '> Logremap'];
    histo = [83 0];              	%update history information

%check if need to save history
if strcmp(hSHisto(1).Checked,'on')	%save new image history
    Ima.fInfo.history_info = historyupdate_cvip(Ima.fInfo.history_info,histo);  
end

%check if need to show function information
if strcmp(hVfinfo(1).Checked,'on')
    hIlist = findobj('Tag','txtIlist');%get handle of text element
    hIlist.String(end+1,1)=' ';   	%print an empty line
    txtInfo = historydeco_cvip(histo);
    hIlist.String(end+1,1:size(file,2)+1)=[file ':']; 
    for i=1:size(txtInfo)
        sInfo = txtInfo{i};       	%extract row to print
        sInfo = sprintf(sInfo);
        [~,rr] = size(sInfo);
        hIlist.String(end+1,1:rr) = sInfo;
    end
    hIlist.Value = size(hIlist.String,1);%goto last line
    figure(hMain);
end

%display image
if size(OutIma,1) > 3
    [row,col,band]=size(OutIma);  	%get new image size
    %update image information
    Ima.fInfo.no_of_bands=band;             
    Ima.fInfo.no_of_cols=col;              
    Ima.fInfo.no_of_rows=row;
    %update image structure
    Ima.cvipIma = OutIma;        	%read image data
    showgui_cvip(Ima, Name);       	%show image in viewer
end

end

% --------------------------------------------------------------------
function mVsLred_Callback(hObject, eventdata, handles)
% hObject    handle to mVsLred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
%Log remap Red band
hMain = findobj('Tag','Main');      %get the handle of Main figure
hSHisto = findobj('Tag','mVsaveHis');%get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = hMain.UserData;             %get image handle

if hNfig == 0 || isempty(hNfig) || ~isfield(hNfig.UserData,'cvipIma')
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Extract FFT Magnitude Error','modal'); 
else
    Ima = hNfig.UserData;          	%get image structure
    InIma = Ima.cvipIma;           	%read image data
    file = get(hNfig,'Name');       %get image name
    OutIma = logremap_cvip(InIma,1);
    Name = [file '> Logremap(R)'];
    histo = [83 1];              	%update history information

%check if need to save history
if strcmp(hSHisto(1).Checked,'on')	%save new image history
    Ima.fInfo.history_info = historyupdate_cvip(Ima.fInfo.history_info,histo);  
end

%check if need to show function information
if strcmp(hVfinfo(1).Checked,'on')
    hIlist = findobj('Tag','txtIlist');%get handle of text element
    hIlist.String(end+1,1)=' ';   	%print an empty line
    txtInfo = historydeco_cvip(histo);
    hIlist.String(end+1,1:size(file,2)+1)=[file ':']; 
    for i=1:size(txtInfo)
        sInfo = txtInfo{i};       	%extract row to print
        sInfo = sprintf(sInfo);
        [~,rr] = size(sInfo);
        hIlist.String(end+1,1:rr) = sInfo;
    end
    hIlist.Value = size(hIlist.String,1);%goto last line
    figure(hMain);
end

%display image
if size(OutIma,1) > 3
    [row,col,band]=size(OutIma);  	%get new image size
    %update image information
    Ima.fInfo.no_of_bands=band;             
    Ima.fInfo.no_of_cols=col;              
    Ima.fInfo.no_of_rows=row;
    %update image structure
    Ima.cvipIma = OutIma;        	%read image data
    showgui_cvip(Ima, Name);       	%show image in viewer
end

end

% --------------------------------------------------------------------
function mVsLgre_Callback(hObject, eventdata, handles)
% hObject    handle to mVsLgre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
%Log remap Green band
hMain = findobj('Tag','Main');      %get the handle of Main figure
hSHisto = findobj('Tag','mVsaveHis');%get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = hMain.UserData;             %get image handle

if hNfig == 0 || isempty(hNfig) || ~isfield(hNfig.UserData,'cvipIma')
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Extract FFT Magnitude Error','modal'); 
else
    Ima = hNfig.UserData;          	%get image structure
    InIma = Ima.cvipIma;           	%read image data
    file = get(hNfig,'Name');       %get image name
    OutIma = logremap_cvip(InIma,2);
    Name = [file '> Logremap(G)'];
    histo = [83 2];              	%update history information

%check if need to save history
if strcmp(hSHisto(1).Checked,'on')	%save new image history
    Ima.fInfo.history_info = historyupdate_cvip(Ima.fInfo.history_info,histo);  
end

%check if need to show function information
if strcmp(hVfinfo(1).Checked,'on')
    hIlist = findobj('Tag','txtIlist');%get handle of text element
    hIlist.String(end+1,1)=' ';   	%print an empty line
    txtInfo = historydeco_cvip(histo);
    hIlist.String(end+1,1:size(file,2)+1)=[file ':']; 
    for i=1:size(txtInfo)
        sInfo = txtInfo{i};       	%extract row to print
        sInfo = sprintf(sInfo);
        [~,rr] = size(sInfo);
        hIlist.String(end+1,1:rr) = sInfo;
    end
    hIlist.Value = size(hIlist.String,1);%goto last line
    figure(hMain);
end

%display image
if size(OutIma,1) > 3
    [row,col,band]=size(OutIma);  	%get new image size
    %update image information
    Ima.fInfo.no_of_bands=band;             
    Ima.fInfo.no_of_cols=col;              
    Ima.fInfo.no_of_rows=row;
    %update image structure
    Ima.cvipIma = OutIma;        	%read image data
    showgui_cvip(Ima, Name);       	%show image in viewer
end

end

% --------------------------------------------------------------------
function mVsLblu_Callback(hObject, eventdata, handles)
% hObject    handle to mVsLblu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
%Log remap Blue band
hMain = findobj('Tag','Main');      %get the handle of Main figure
hSHisto = findobj('Tag','mVsaveHis');%get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = hMain.UserData;             %get image handle

if hNfig == 0 || isempty(hNfig) || ~isfield(hNfig.UserData,'cvipIma')
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Extract FFT Magnitude Error','modal'); 
else
    Ima = hNfig.UserData;          	%get image structure
    InIma = Ima.cvipIma;           	%read image data
    file = get(hNfig,'Name');       %get image name
    OutIma = logremap_cvip(InIma,3);
    Name = [file '> Logremap(B)'];
    histo = [83 3];              	%update history information

%check if need to save history
if strcmp(hSHisto(1).Checked,'on')	%save new image history
    Ima.fInfo.history_info = historyupdate_cvip(Ima.fInfo.history_info,histo);  
end

%check if need to show function information
if strcmp(hVfinfo(1).Checked,'on')
    hIlist = findobj('Tag','txtIlist');%get handle of text element
    hIlist.String(end+1,1)=' ';   	%print an empty line
    txtInfo = historydeco_cvip(histo);
    hIlist.String(end+1,1:size(file,2)+1)=[file ':']; 
    for i=1:size(txtInfo)
        sInfo = txtInfo{i};       	%extract row to print
        sInfo = sprintf(sInfo);
        [~,rr] = size(sInfo);
        hIlist.String(end+1,1:rr) = sInfo;
    end
    hIlist.Value = size(hIlist.String,1);%goto last line
    figure(hMain);
end

%display image
if size(OutIma,1) > 3
    [row,col,band]=size(OutIma);  	%get new image size
    %update image information
    Ima.fInfo.no_of_bands=band;             
    Ima.fInfo.no_of_cols=col;              
    Ima.fInfo.no_of_rows=row;
    %update image structure
    Ima.cvipIma = OutIma;        	%read image data
    showgui_cvip(Ima, Name);       	%show image in viewer
end

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
clc;                             %clear screen
hGeo=findobj('Tag','Geom'); %check if was previously opened
if isempty(hGeo)
    hGeo=DlgGeom;           %call Analysis-Geometry Form
    set(gcf,'Name','Geometry','NumberTitle','off')
    updatemenus();          %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hGeo);
end
figure(hGeo);


% --------------------------------------------------------------------
function mEdge_Callback(hObject, eventdata, handles)
% hObject    handle to mEdge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hEdg=findobj('Tag','Edge'); %check if was previously opened
if isempty(hEdg)
    hEdg=DlgEdgLin;         %call Analysis-Edge/Line Form
    set(gcf,'Name','Edge \ Line Detection','NumberTitle','off')
    updatemenus();          %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hEdg);
end
figure(hEdg);


% --------------------------------------------------------------------
function mSeg_Callback(hObject, eventdata, handles)
% hObject    handle to mSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hSeg=findobj('Tag','Segm');	%check if was previously opened
if isempty(hSeg)
    hSeg=DlgGrayLvl;        %call Analysis-Segmentation Form
    set(gcf,'Name','Segmentation','NumberTitle','off')
    updatemenus();          %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hSeg);
end
figure(hSeg);


% --------------------------------------------------------------------
function mTrans_Callback(hObject, eventdata, handles)
% hObject    handle to mTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hTrans=findobj('Tag','Trans');	%check if was previously opened
if isempty(hTrans)
    hTrans=DlgTrans;            %call Anlysis-Transforms Form
    set(gcf,'Name','Transforms','NumberTitle','off')
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hTrans);
end
figure(hTrans);


% --------------------------------------------------------------------
function mFeat_Callback(hObject, eventdata, handles)
% hObject    handle to mFeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hFeat=findobj('Tag','Feat');         %check if was previously opened
if isempty(hFeat)
    hFeat=DlgFeat; %Call Anlysis-Geometry Form
    set(gcf,'Name','Features','NumberTitle','off')
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hFeat);
end
figure(hFeat);


% --------------------------------------------------------------------
function mPatt_Callback(hObject, eventdata, handles)
% hObject    handle to mPatt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hPatt=findobj('Tag','Patt');         %check if was previously opened
if isempty(hPatt)
    hPatt=DlgPatt; %Call Anlysis-Geometry Form
    set(gcf,'Name','Pattern Classification','NumberTitle','off')
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hPatt);
end
figure(hPatt);


% --------------------------------------------------------------------
function mEnh_Callback(hObject, eventdata, handles)
% hObject    handle to mEnh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mEhisto_Callback(hObject, eventdata, handles)
% hObject    handle to mEhisto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
%open the figure Enhance - Histogram/Contrast
hEhisto=findobj('Tag','HistConN');	%check if was previously opened
if isempty(hEhisto)
    hEhisto=Dlgenhance;          	%call Create Form
    set(gcf,'Name','Enhance - Histogram/Contrast','NumberTitle','off')
    updatemenus();             	%call function to update
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hEhisto);
end
figure(hEhisto);


% --------------------------------------------------------------------
function mEpseu_Callback(hObject, eventdata, handles)
% hObject    handle to mEpseu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
%open the figure Enhance - Histogram/Contrast
hEpseu=findobj('Tag','Pseudo');	%check if was previously opened
if isempty(hEpseu)
    hEpseu=DlgPseudo;          	%call Create Form
    set(gcf,'Name','Enhance - Pseudocolor','NumberTitle','off')
    updatemenus();             	%call function to update
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hEpseu);
end
figure(hEpseu);


% --------------------------------------------------------------------
function mESharp_Callback(hObject, eventdata, handles)
% hObject    handle to mESharp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
%open the figure Restoration - Frequency Filters
hmESharp=findobj('Tag','Sharp');	%check if was previously opened
if isempty(hmESharp)
    hmESharp=DlgSharp;          	%call Create Form
    set(gcf,'Name','Enhancement - Sharpening','NumberTitle','off')
    updatemenus();             	%call function to update
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hmESharp);
end
figure(hmESharp);


% --------------------------------------------------------------------
function mESmo_Callback(hObject, eventdata, handles)
% hObject    handle to mESmo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
%open the figure Restoration - Frequency Filters
hmESmo=findobj('Tag','Smooth');	%check if was previously opened
if isempty(hmESmo)
    hmESmo=DlgSmooth;          	%call Create Form
    set(gcf,'Name','Enhancement - Smoothing','NumberTitle','off')
    updatemenus();             	%call function to update
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hmESmo);
end
figure(hmESmo);

% --------------------------------------------------------------------
function mRes_Callback(hObject, eventdata, handles)
% hObject    handle to mRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mRNoi_Callback(hObject, eventdata, handles)
% hObject    handle to mRNoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
%open the figure Restoration - Frequency Filters
hmRNoi=findobj('Tag','RNoise');	%check if was previously opened
if isempty(hmRNoi)
    hmRNoi=DlgNoise;          	%call Create Form
    set(gcf,'Name','Restoration - Noise','NumberTitle','off')
    updatemenus();             	%call function to update
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hmRNoi);
end
figure(hmRNoi);


% --------------------------------------------------------------------
function mRSpaF_Callback(hObject, eventdata, handles)
% hObject    handle to mRSpaF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
%open the figure Restoration - Frequency Filters
hmRspaF=findobj('Tag','SpatFilt');	%check if was previously opened
if isempty(hmRspaF)
    hmRspaF=DlgSpatFilt;          	%call Create Form
    set(gcf,'Name','Restoration - Spatial Filters','NumberTitle','off')
    updatemenus();             	%call function to update
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hmRspaF);
end
figure(hmRspaF);


% --------------------------------------------------------------------
function mRFreqF_Callback(hObject, eventdata, handles)
% hObject    handle to mRFreqF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
%open the figure Restoration - Frequency Filters
hmRFreqF=findobj('Tag','FreqFilt');	%check if was previously opened
if isempty(hmRFreqF)
    hmRFreqF=FreqFilt;          	%call Create Form
    set(gcf,'Name','Restoration - Frequency Filters','NumberTitle','off')
    updatemenus();             	%call function to update
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hmRFreqF);
end
figure(hmRFreqF);

% --------------------------------------------------------------------
function mRGeoT_Callback(hObject, eventdata, handles)
% hObject    handle to mRGeoT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
%open the figure Restoration - Frequency Filters
hmRGeoT=findobj('Tag','GeoTrans');	%check if was previously opened
if isempty(hmRGeoT)
    hmRGeoT=DlgGeoTrans;          	%call Create Form
    set(gcf,'Name','Restoration - Geometric Transforms','NumberTitle','off')
    updatemenus();             	%call function to update
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hmRGeoT);
end
figure(hmRGeoT);

% --------------------------------------------------------------------
function mComp_Callback(hObject, eventdata, handles)
% hObject    handle to mComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mCpre_Callback(hObject, eventdata, handles)
% hObject    handle to mCpre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCpre=findobj('Tag','CPre');	%check if was previously opened
if isempty(hCpre)
    hCpre=DlgComPre;          	%call Create Form
    set(gcf,'Name','Compress - Preprocessing','NumberTitle','off')
    updatemenus();             	%call function to update
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCpre);
end
figure(hCpre);

% --------------------------------------------------------------------
function mCless_Callback(hObject, eventdata, handles)
% hObject    handle to mCless (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCLes=findobj('Tag','CLless');	%check if was previously opened
if isempty(hCLes)
    hCLes=DlgComLless;          %call Create Form
    set(gcf,'Name','Compress - Lossless','NumberTitle','off')
    updatemenus();            	%call function to update
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCLes);
end
figure(hCLes);

% --------------------------------------------------------------------
function mClossy_Callback(hObject, eventdata, handles)
% hObject    handle to mClossy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCLos=findobj('Tag','CLossy');	%check if was previously opened
if isempty(hCLos)
    hCLos=DlgComLossy;          %call Create Form
    set(gcf,'Name','Compress - Lossy','NumberTitle','off')
    updatemenus();            	%call function to update
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCLos);
end
figure(hCLos);

% --------------------------------------------------------------------
function mCpost_Callback(hObject, eventdata, handles)
% hObject    handle to mCpost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCpos=findobj('Tag','CPost');	%check if was previously opened
if isempty(hCpos)
    hCpos=DlgComPost;           %call Create Form
    set(gcf,'Name','Compress - Postprocessing','NumberTitle','off')
    updatemenus();              %call function to update
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCpos);
end
figure(hCpos);

% --------------------------------------------------------------------
function mUtil_Callback(hObject, eventdata, handles)
% hObject    handle to mUtil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mUshow_Callback(hObject, eventdata, handles)
% hObject    handle to mUshow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                                %clear screen
hMain = findobj('Tag','Main');      %get Main figure handle
hSutil = findobj('Tag','mUshow');   %get menu Show utilities handle
hSutis = findobj('Tag','mUshos');   %get menus Show utilities handle
g1data = guidata(hMain);            %get objects in main window
figure(hMain);                      %set focus to main window
if hObject.UserData == 0          %show utilities menus hSutil(1).UserData
    g1data.mFile.Position=3;       %shange menu position tu redraw screen
    On = 'On';                      %used in eval function
    for i=1:8                       %show menus in utilities
       eval(strcat('g1data.mU',num2str(i),'.Visible = On;')); 
    end
    for i=1:size(hSutis,1)          %update menu information
        hSutis(i).Checked = 'on';
    end
    hSutil.UserData = 1;
    hSutil.Checked = 'on';
    g1data.mFile.Position=1;        %restore menu to original position
else                                %hide menus
    Off = 'Off';                    %used in eval function
    for i=1:8                       %hide menus in utilities
       eval(strcat('g1data.mU',num2str(i),'.Visible = Off;')); 
    end
    for i=1:size(hSutis,1)          %update menu information
        hSutis(i).Checked = 'off';       
    end
    hSutil.UserData = 0;
    hSutil.Checked = 'off';
end
g1data.mUtil.UserData = eventdata;


% --------------------------------------------------------------------
function mUtil_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to mUtil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function mU1_Callback(hObject, eventdata, handles)
% hObject    handle to mU1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mU2_Callback(hObject, eventdata, handles)
% hObject    handle to mU2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mU3_Callback(hObject, eventdata, handles)
% hObject    handle to mU3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mU4_Callback(hObject, eventdata, handles)
% hObject    handle to mU4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mU5_Callback(hObject, eventdata, handles)
% hObject    handle to mU5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mU6_Callback(hObject, eventdata, handles)
% hObject    handle to mU6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mU7_Callback(hObject, eventdata, handles)
% hObject    handle to mU7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mU8_Callback(hObject, eventdata, handles)
% hObject    handle to mU8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mHelp_Callback(hObject, eventdata, handles)
% hObject    handle to mHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mHcon_Callback(hObject, eventdata, handles)
% hObject    handle to mHcon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
% [CVIP_root_path,~] = fileparts(mfilename('fullpath'));
% builddocsearchdb(fullfile(CVIP_root_path(1:end-3),'mFiles','html'));
doc 'Welcome to the CVIP Toolbox'

% --------------------------------------------------------------------
function mHabout_Callback(hObject, eventdata, handles)
% hObject    handle to mHabout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
DlgHelp;

% --------------------------------------------------------------------
function mAadd_Callback(hObject, eventdata, handles)
% hObject    handle to mAadd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hArith=findobj('Tag','Arith');	%check if was previously opened
if isempty(hArith)
    hArith=mUArith;             %call Arith-Add Form
    set(gcf,'Name','Utilities - Arith\Logic','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         
        figure(hPrev);     
    end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hArith);
end
hArith.UserData = 'Add';        %indicate selected option
mUArith('Arith_SizeChangedFcn',hArith,eventdata,guidata(hArith));
figure(hArith);

% --------------------------------------------------------------------
function mASub_Callback(hObject, eventdata, handles)
% hObject    handle to mASub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hArith=findobj('Tag','Arith');	%check if was previously opened
if isempty(hArith)
    hArith=mUArith;             %call Arith-Sub Form
    set(gcf,'Name','Utilities - Arith\Logic','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)        
        figure(hPrev);
    end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hArith);
end
hArith.UserData = 'Sub';        %indicate selected option
mUArith('Arith_SizeChangedFcn',hArith,eventdata,guidata(hArith));
figure(hArith);

% --------------------------------------------------------------------
function mAMul_Callback(hObject, eventdata, handles)
% hObject    handle to mAMul (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hArith=findobj('Tag','Arith');	%check if was previously opene
if isempty(hArith)
    hArith=mUArith;             %call Arith-Mul Form
    set(gcf,'Name','Utilities - Arith\Logic','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)    
        figure(hPrev);     
    end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hArith);
end
hArith.UserData = 'Mul';        %indicate selected option
mUArith('Arith_SizeChangedFcn',hArith,eventdata,guidata(hArith));
figure(hArith);

% --------------------------------------------------------------------
function mADiv_Callback(hObject, eventdata, handles)
% hObject    handle to mADiv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hArith=findobj('Tag','Arith');	%check if was previously opened
if isempty(hArith)
    hArith=mUArith;             %call Arith-Div Form
    set(gcf,'Name','Utilities - Arith\Logic','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)       
        figure(hPrev);     
    end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hArith);
end
hArith.UserData = 'Div';        %indicate selected option
mUArith('Arith_SizeChangedFcn',hArith,eventdata,guidata(hArith));
figure(hArith);

% --------------------------------------------------------------------
function mAAnd_Callback(hObject, eventdata, handles)
% hObject    handle to mAAnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hArith=findobj('Tag','Arith');	%check if was previously opened
if isempty(hArith)
    hArith=mUArith;             %call Arith-And Form
    set(gcf,'Name','Utilities - Arith\Logic','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)   
        figure(hPrev);    
    end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hArith);
end
hArith.UserData = 'And';        %indicate selected option
mUArith('Arith_SizeChangedFcn',hArith,eventdata,guidata(hArith));
figure(hArith);

% --------------------------------------------------------------------
function mANot_Callback(hObject, eventdata, handles)
% hObject    handle to mANot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hArith=findobj('Tag','Arith');	%check if was previously opened
if isempty(hArith)
    hArith=mUArith;             %call Arith-Not Form
    set(gcf,'Name','Utilities - Arith\Logic','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)       
        figure(hPrev);    
    end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hArith);
end
hArith.UserData = 'Not';        %indicate selected option
mUArith('Arith_SizeChangedFcn',hArith,eventdata,guidata(hArith));
figure(hArith);

% --------------------------------------------------------------------
function mAOr_Callback(hObject, eventdata, handles)
% hObject    handle to mAOr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hArith=findobj('Tag','Arith');	%check if was previously opened
if isempty(hArith)
    hArith=mUArith;             %call Arith-Or Form
    set(gcf,'Name','Utilities - Arith\Logic','NumberTitle','off')
    updatemenus();              %cheked for View information and save history
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)      
        figure(hPrev);    
    end
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hArith);
end
hArith.UserData = 'Or';         %indicate selected option
mUArith('Arith_SizeChangedFcn',hArith,eventdata,guidata(hArith));
figure(hArith);

% --------------------------------------------------------------------
function mAXor_Callback(hObject, eventdata, handles)
% hObject    handle to mAXor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hArith=findobj('Tag','Arith');	%check if was previously opened
if isempty(hArith)
    hArith=mUArith;             %call Arith-Xor Form
    set(gcf,'Name','Utilities - Arith\Logic','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)       
        figure(hPrev);     
    end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hArith);
end
hArith.UserData = 'Xor';        %indicate selected option
mUArith('Arith_SizeChangedFcn',hArith,eventdata,guidata(hArith));
figure(hArith);

% --------------------------------------------------------------------
function mFMean_Callback(hObject, eventdata, handles)
% hObject    handle to mFMean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hFilt=findobj('Tag','Filt');	%check if was previously opened
if isempty(hFilt)
    hFilt=mUFilt;               %call Arith Form
    set(gcf,'Name','Utilities - Filter','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)     
        figure(hPrev);     
    end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hFilt);
end
hFilt.UserData = 'Mean';        %indicate selected option
mUFilt('Filt_SizeChangedFcn',hFilt,eventdata,guidata(hFilt));
figure(hFilt);

% --------------------------------------------------------------------
function mFMedian_Callback(hObject, eventdata, handles)
% hObject    handle to mFMedian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hFilt=findobj('Tag','Filt');	%check if was previously opened
if isempty(hFilt)
    hFilt=mUFilt;             %call Arith Form
    set(gcf,'Name','Utilities - Filter','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)  
        figure(hPrev);   
    end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hFilt);
end
hFilt.UserData = 'Median';    %indicate selected option
mUFilt('Filt_SizeChangedFcn',hFilt,eventdata,guidata(hFilt));
figure(hFilt);

% --------------------------------------------------------------------
function mFLap_Callback(hObject, eventdata, handles)
% hObject    handle to mFLap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hFilt=findobj('Tag','Filt');	%check if was previously opened
if isempty(hFilt)
    hFilt=mUFilt;             %call Arith Form
    updatemenus();              %cheked for View information and save history
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)        
        figure(hPrev);    
    end
    set(gcf,'Name','Utilities - Filter','NumberTitle','off')
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hFilt);
end
hFilt.UserData = 'Lapla';    %indicate selected option
mUFilt('Filt_SizeChangedFcn',hFilt,eventdata,guidata(hFilt));
figure(hFilt);

% --------------------------------------------------------------------
function mFDif_Callback(hObject, eventdata, handles)
% hObject    handle to mFDif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hFilt=findobj('Tag','Filt');	%check if was previously opened
if isempty(hFilt)
    hFilt=mUFilt;             %call Arith Form
    set(gcf,'Name','Utilities - Filter','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)      
        figure(hPrev);    
    end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hFilt);
end
hFilt.UserData = 'Diff';    %indicate selected option
mUFilt('Filt_SizeChangedFcn',hFilt,eventdata,guidata(hFilt));
figure(hFilt);

% --------------------------------------------------------------------
function mFFil_Callback(hObject, eventdata, handles)
% hObject    handle to mFFil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hFilt=findobj('Tag','Filt');	%check if was previously opened
if isempty(hFilt)
    hFilt=mUFilt;             %call Arith Form
    updatemenus();              %cheked for View information and save history
    set(gcf,'Name','Utilities - Filter','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)      
        figure(hPrev);   
    end
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hFilt);
end
hFilt.UserData = 'Spe';    %indicate selected option
mUFilt('Filt_SizeChangedFcn',hFilt,eventdata,guidata(hFilt));
figure(hFilt);

% --------------------------------------------------------------------
function mFBlur_Callback(hObject, eventdata, handles)
% hObject    handle to mFBlur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hFilt=findobj('Tag','Filt');	%check if was previously opened
if isempty(hFilt)
    hFilt=mUFilt;             %call Arith Form
    updatemenus();              %cheked for View information and save history
    set(gcf,'Name','Utilities - Filter','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)      
        figure(hPrev);    
    end
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hFilt);
end
hFilt.UserData = 'Blur';    %indicate selected option
mUFilt('Filt_SizeChangedFcn',hFilt,eventdata,guidata(hFilt));
figure(hFilt);

% --------------------------------------------------------------------
function mSCrop_Callback(hObject, eventdata, handles)
% hObject    handle to mSCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hSize=findobj('Tag','Size');	%check if was previously opened
if isempty(hSize)
    hSize=mUSize;             %call Arith Form
    updatemenus();              %cheked for View information and save history
    set(gcf,'Name','Utilities - Size','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)       
        figure(hPrev);    
    end
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hSize);
end
hSize.UserData = 'Crop';    %indicate selected option
mUSize('Size_SizeChangedFcn',hSize,eventdata,guidata(hSize));
figure(hSize);

% --------------------------------------------------------------------
function mSFast_Callback(hObject, eventdata, handles)
% hObject    handle to mSFast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hSize=findobj('Tag','Size');	%check if was previously opened
if isempty(hSize)
    hSize=mUSize;             %call Arith Form
    updatemenus();              %cheked for View information and save history
    set(gcf,'Name','Utilities - Size','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)        
        figure(hPrev);   
    end
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hSize);
end
hSize.UserData = '2Size';    %indicate selected option
mUSize('Size_SizeChangedFcn',hSize,eventdata,guidata(hSize));
figure(hSize);

% --------------------------------------------------------------------
function mSRes_Callback(hObject, eventdata, handles)
% hObject    handle to mSRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hSize=findobj('Tag','Size');	%check if was previously opened
 

if isempty(hSize)
    hSize=mUSize;             %call Arith Form
    updatemenus();              %cheked for View information and save history
    set(gcf,'Name','Utilities - Size','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hSize);
end
hSize.UserData = 'Resize';    %indicate selected option
mUSize('Size_SizeChangedFcn',hSize,eventdata,guidata(hSize));
figure(hSize);

% --------------------------------------------------------------------
function mSSpa_Callback(hObject, eventdata, handles)
% hObject    handle to mSSpa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hSize=findobj('Tag','Size');	%check if was previously opened
 

if isempty(hSize)
    hSize=mUSize;             %call Arith Form
    updatemenus();              %cheked for View information and save history
    set(gcf,'Name','Utilities - Size','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hSize);
end
hSize.UserData = 'SpaQuant';    %indicate selected option
mUSize('Size_SizeChangedFcn',hSize,eventdata,guidata(hSize));
figure(hSize);

% --------------------------------------------------------------------
function mSData_Callback(hObject, eventdata, handles)
% hObject    handle to mSData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hStats=findobj('Tag','Stats');	%check if was previously opened
if isempty(hStats)
    hStats=mUStats;             %call Arith Form
    set(gcf,'Name','Utilities - Stats','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         
        figure(hPrev);     
    end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hStats);
end
hStats.UserData = 'Range';    %indicate selected option
mUStats('Stats_SizeChangedFcn',hStats,eventdata,guidata(hStats));
figure(hStats);

% --------------------------------------------------------------------
function mSIma_Callback(hObject, eventdata, handles)
% hObject    handle to mSIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hStats=findobj('Tag','Stats');	%check if was previously opened
 

if isempty(hStats)
    hStats=mUStats;             %call Arith Form
    set(gcf,'Name','Utilities - Stats','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hStats);
end
hStats.UserData = 'Stats';    %indicate selected option
mUStats('Stats_SizeChangedFcn',hStats,eventdata,guidata(hStats));
figure(hStats);

% --------------------------------------------------------------------
function mEBrig_Callback(hObject, eventdata, handles)
% hObject    handle to mEBrig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hEnh=findobj('Tag','Enha');	%check if was previously opened
 

if isempty(hEnh)
    hEnh=mUEnh;             %call Arith Form
    set(gcf,'Name','Utilities - Enhance','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hEnh);
end
hEnh.UserData = 'BriDa';    %indicate selected option
mUEnh('Enha_SizeChangedFcn',hEnh,eventdata,guidata(hEnh));
figure(hEnh);

% --------------------------------------------------------------------
function mEEdg_Callback(hObject, eventdata, handles)
% hObject    handle to mEEdg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hEnh=findobj('Tag','Enha');	%check if was previously opened
if isempty(hEnh)
    hEnh=mUEnh;             %call Arith Form
    set(gcf,'Name','Utilities - Enhance','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hEnh);
end
hEnh.UserData = 'Edge';    %indicate selected option
mUEnh('Enha_SizeChangedFcn',hEnh,eventdata,guidata(hEnh));
figure(hEnh);

% --------------------------------------------------------------------
function mEEqu_Callback(hObject, eventdata, handles)
% hObject    handle to mEEqu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hEnh=findobj('Tag','Enha');	%check if was previously opened
if isempty(hEnh)
    hEnh=mUEnh;             %call Arith Form
    set(gcf,'Name','Utilities - Enhance','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hEnh);
end
hEnh.UserData = 'HEqu';    %indicate selected option
mUEnh('Enha_SizeChangedFcn',hEnh,eventdata,guidata(hEnh));
figure(hEnh);

% --------------------------------------------------------------------
function mEStre_Callback(hObject, eventdata, handles)
% hObject    handle to mEStre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hEnh=findobj('Tag','Enha');	%check if was previously opened
if isempty(hEnh)
    hEnh=mUEnh;             %call Arith Form
    set(gcf,'Name','Utilities - Enhance','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hEnh);
end
hEnh.UserData = 'HStre';    %indicate selected option
mUEnh('Enha_SizeChangedFcn',hEnh,eventdata,guidata(hEnh));
figure(hEnh);

% --------------------------------------------------------------------
function mEPse_Callback(hObject, eventdata, handles)
% hObject    handle to mEPse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hEnh=findobj('Tag','Enha');	%check if was previously opened
if isempty(hEnh)
    hEnh=mUEnh;             %call Arith Form
    set(gcf,'Name','Utilities - Enhance','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hEnh);
end
hEnh.UserData = 'Pseu';    %indicate selected option
mUEnh('Enha_SizeChangedFcn',hEnh,eventdata,guidata(hEnh));
figure(hEnh);

% --------------------------------------------------------------------
function mEShar_Callback(hObject, eventdata, handles)
% hObject    handle to mEShar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hEnh=findobj('Tag','Enha');	%check if was previously opened
if isempty(hEnh)
    hEnh=mUEnh;             %call Arith Form
    set(gcf,'Name','Utilities - Enhance','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         
        figure(hPrev);    
    end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hEnh);
end
hEnh.UserData = 'Sharp';    %indicate selected option
mUEnh('Enha_SizeChangedFcn',hEnh,eventdata,guidata(hEnh));
figure(hEnh);
 
% --------------------------------------------------------------------
function mCCheck_Callback(hObject, eventdata, handles)
% hObject    handle to mCCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCrea=findobj('Tag','Crea');	%check if was previously opened
if isempty(hCrea)
    hCrea=mUCreate;             %call menu Utilities --> Create Form
    set(gcf,'Name','Utilities - Create','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         
        figure(hPrev);     
    end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCrea);
end
hCrea.UserData = 'Check';   %indicate selected option
mUCreate('Crea_SizeChangedFcn',hCrea,eventdata,guidata(hCrea));
figure(hCrea);

% --------------------------------------------------------------------
function mCEll_Callback(hObject, eventdata, handles)
% hObject    handle to mCEll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCrea=findobj('Tag','Crea');	%check if was previously opened
if isempty(hCrea)
    hCrea=mUCreate;               %call Create Form
    set(gcf,'Name','Utilities - Create','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         
        figure(hPrev);     
    end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCrea);
end
hCrea.UserData = 'Elli';      %indicate selected option
mUCreate('Crea_SizeChangedFcn',hCrea,eventdata,guidata(hCrea));
figure(hCrea);

% --------------------------------------------------------------------
function mCLine_Callback(hObject, eventdata, handles)
% hObject    handle to mCLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCrea=findobj('Tag','Crea');	%check if was previously opened
if isempty(hCrea)
    hCrea=mUCreate;               %call Create Form
    set(gcf,'Name','Utilities - Create','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCrea);
end
hCrea.UserData = 'Line';      %indicate selected option
mUCreate('Crea_SizeChangedFcn',hCrea,eventdata,guidata(hCrea));
figure(hCrea);

% --------------------------------------------------------------------
function mCRec_Callback(hObject, eventdata, handles)
% hObject    handle to mCRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCrea=findobj('Tag','Crea');	%check if was previously opened
 

if isempty(hCrea)
    hCrea=mUCreate;               %call Create Form
    set(gcf,'Name','Utilities - Create','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCrea);
end
hCrea.UserData = 'Rect';      %indicate selected option
mUCreate('Crea_SizeChangedFcn',hCrea,eventdata,guidata(hCrea));
figure(hCrea);

% --------------------------------------------------------------------
function mCCos_Callback(hObject, eventdata, handles)
% hObject    handle to mCCos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCrea=findobj('Tag','Crea');	%check if was previously opened
 

if isempty(hCrea)
    hCrea=mUCreate;               %call Create Form
    set(gcf,'Name','Utilities - Create','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCrea);
end
hCrea.UserData = 'Cos';       %indicate selected option
mUCreate('Crea_SizeChangedFcn',hCrea,eventdata,guidata(hCrea));
figure(hCrea);

% --------------------------------------------------------------------
function mCSin_Callback(hObject, eventdata, handles)
% hObject    handle to mCSin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCrea=findobj('Tag','Crea');	%check if was previously opened
 

if isempty(hCrea)
    hCrea=mUCreate;               %call Create Form
    set(gcf,'Name','Utilities - Create','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCrea);
end
hCrea.UserData = 'Sin';       %indicate selected option
mUCreate('Crea_SizeChangedFcn',hCrea,eventdata,guidata(hCrea));
figure(hCrea);

% --------------------------------------------------------------------
function mCSqu_Callback(hObject, eventdata, handles)
% hObject    handle to mCSqu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCrea=findobj('Tag','Crea');	%check if was previously opened
 

if isempty(hCrea)
    hCrea=mUCreate;               %call Create Form
    set(gcf,'Name','Utilities - Create','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCrea);
end
hCrea.UserData = 'Squa';      %indicate selected option
mUCreate('Crea_SizeChangedFcn',hCrea,eventdata,guidata(hCrea));
figure(hCrea);

% --------------------------------------------------------------------
function mCAss_Callback(hObject, eventdata, handles)
% hObject    handle to mCAss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCrea=findobj('Tag','Crea');	%check if was previously opened
 

if isempty(hCrea)
    hCrea=mUCreate;               %call Create Form
    set(gcf,'Name','Utilities - Create','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCrea);
end
hCrea.UserData = 'Asse';      %indicate selected option
mUCreate('Crea_SizeChangedFcn',hCrea,eventdata,guidata(hCrea));
figure(hCrea);

% --------------------------------------------------------------------
function mCGray_Callback(hObject, eventdata, handles)
% hObject    handle to mCGray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCrea=findobj('Tag','Crea');	%check if was previously opened
 

if isempty(hCrea)
    hCrea=mUCreate;               %call Create Form
    set(gcf,'Name','Utilities - Create','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCrea);
end
hCrea.UserData = 'Gray';     %indicate selected option
mUCreate('Crea_SizeChangedFcn',hCrea,eventdata,guidata(hCrea));
figure(hCrea);

% --------------------------------------------------------------------
function mCRGB_Callback(hObject, eventdata, handles)
% hObject    handle to mCRGB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCrea=findobj('Tag','Crea');	%check if was previously opened
 

if isempty(hCrea)
    hCrea=mUCreate;               %call Create Form
    set(gcf,'Name','Utilities - Create','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCrea);
end
hCrea.UserData = 'RGB';       %indicate selected option
mUCreate('Crea_SizeChangedFcn',hCrea,eventdata,guidata(hCrea));
figure(hCrea);

% --------------------------------------------------------------------
function mNoise_Callback(hObject, eventdata, handles)
% hObject    handle to mNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCrea=findobj('Tag','Crea');	%check if was previously opened
 

if isempty(hCrea)
    hCrea=mUCreate;               %call Create Form
    set(gcf,'Name','Utilities - Create','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCrea);
end
hCrea.UserData = 'Noise';     %indicate selected option
mUCreate('Crea_SizeChangedFcn',hCrea,eventdata,guidata(hCrea));
figure(hCrea);

% --------------------------------------------------------------------
function mCMask_Callback(hObject, eventdata, handles)
% hObject    handle to mCMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCrea=findobj('Tag','Crea');	%check if was previously opened
 

if isempty(hCrea)

    hCrea=mUCreate;               %call Create Form
    set(gcf,'Name','Utilities - Create','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCrea);
end


hCrea.UserData = 'Mask';     %indicate selected option
mUCreate('Crea_SizeChangedFcn',hCrea,eventdata,guidata(hCrea));
figure(hCrea);

% --------------------------------------------------------------------
function mCbor_Callback(hObject, eventdata, handles)
% hObject    handle to mCbor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCrea=findobj('Tag','Crea');	%check if was previously opened
 

if isempty(hCrea)
    hCrea=mUCreate;               %call Create Form
    set(gcf,'Name','Utilities - Create','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCrea);
end

hCrea.UserData = 'bor';     %indicate selected option
mUCreate('Crea_SizeChangedFcn',hCrea,eventdata,guidata(hCrea));
figure(hCrea);

% --------------------------------------------------------------------
function mCBin_Callback(hObject, eventdata, handles)
% hObject    handle to mCBin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hConv=findobj('Tag','Conv');	%check if was previously opened
 

if isempty(hConv)
    hConv=mUConv;               %call menu Utilities --> Convert Form
    set(gcf,'Name','Utilities - Convert','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hConv);
end
hConv.UserData = 'BinTH';   %indicate selected option
mUConv('Conv_SizeChangedFcn',hConv,eventdata,guidata(hConv));
figure(hConv);

% --------------------------------------------------------------------
function mCData_Callback(hObject, eventdata, handles)
% hObject    handle to mCData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hConv=findobj('Tag','Conv');	%check if was previously opened
 

if isempty(hConv)
    hConv=mUConv;               %call menu Utilities --> Convert Form
    set(gcf,'Name','Utilities - Convert','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hConv);
end
hConv.UserData = 'DataT';   %indicate selected option
mUConv('Conv_SizeChangedFcn',hConv,eventdata,guidata(hConv));
figure(hConv);

% --------------------------------------------------------------------
function mCFalf_Callback(hObject, eventdata, handles)
% hObject    handle to mCFalf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hConv=findobj('Tag','Conv');	%check if was previously opened
 

if isempty(hConv)
    hConv=mUConv;               %call menu Utilities --> Convert Form
    set(gcf,'Name','Utilities - Convert','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hConv);
end
hConv.UserData = 'Half';   %indicate selected option
mUConv('Conv_SizeChangedFcn',hConv,eventdata,guidata(hConv));
figure(hConv);

% --------------------------------------------------------------------
function mCGrayQ_Callback(hObject, eventdata, handles)
% hObject    handle to mCGrayQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hConv=findobj('Tag','Conv');	%check if was previously opened
 

if isempty(hConv)
    hConv=mUConv;               %call menu Utilities --> Convert Form
    set(gcf,'Name','Utilities - Convert','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hConv);
end
hConv.UserData = 'GrayQ';   %indicate selected option
mUConv('Conv_SizeChangedFcn',hConv,eventdata,guidata(hConv));
figure(hConv);

% --------------------------------------------------------------------
function mCGrayN_Callback(hObject, eventdata, handles)
% hObject    handle to mCGrayN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hConv=findobj('Tag','Conv');	%check if was previously opened
 

if isempty(hConv)
    hConv=mUConv;               %call menu Utilities --> Convert Form
    set(gcf,'Name','Utilities - Convert','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hConv);
end
hConv.UserData = 'GrayN';   %indicate selected option
mUConv('Conv_SizeChangedFcn',hConv,eventdata,guidata(hConv));
figure(hConv);

% --------------------------------------------------------------------
function mCGrayCol_Callback(hObject, eventdata, handles)
% hObject    handle to mCGrayCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hConv=findobj('Tag','Conv');	%check if was previously opened
 

if isempty(hConv)
    hConv=mUConv;                   %call menu Utilities --> Convert Form
    set(gcf,'Name','Utilities - Convert','NumberTitle','off')
    updatemenus();              %cheked for View information and save history
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hConv);
end
hConv.UserData = 'Gra2Col';     %indicate selected option
mUConv('Conv_SizeChangedFcn',hConv,eventdata,guidata(hConv));
figure(hConv);

% --------------------------------------------------------------------
function mCCol_Callback(hObject, eventdata, handles)
% hObject    handle to mCCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hConv=findobj('Tag','Conv');	%check if was previously opened
 

if isempty(hConv)
    hConv=mUConv;                   %call menu Utilities --> Convert Form
    set(gcf,'Name','Utilities - Convert','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hConv);
end
hConv.UserData = 'Col2Gray';    %indicate selected option
mUConv('Conv_SizeChangedFcn',hConv,eventdata,guidata(hConv));
figure(hConv);

% --------------------------------------------------------------------
function mCColS_Callback(hObject, eventdata, handles)
% hObject    handle to mCColS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hConv=findobj('Tag','Conv');	%check if was previously opened
if isempty(hConv)
    hConv=mUConv;               %call menu Utilities --> Convert Form
    set(gcf,'Name','Utilities - Convert','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hConv);
end
hConv.UserData = 'ColSpa';   %indicate selected option
mUConv('Conv_SizeChangedFcn',hConv,eventdata,guidata(hConv));
figure(hConv);

% --------------------------------------------------------------------
function mCLab_Callback(hObject, eventdata, handles)
% hObject    handle to mCLab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hConv=findobj('Tag','Conv');	%check if was previously opened
if isempty(hConv)
    hConv=mUConv;               %call menu Utilities --> Convert Form
    set(gcf,'Name','Utilities - Convert','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hConv);
end
hConv.UserData = 'Label';   %indicate selected option
mUConv('Conv_SizeChangedFcn',hConv,eventdata,guidata(hConv));
figure(hConv);

% --------------------------------------------------------------------
function mC2Ima_Callback(hObject, eventdata, handles)
% hObject    handle to mC2Ima (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hComp=findobj('Tag','Comp');	%check if was previously opened
if isempty(hComp)
    hComp=mUComp;               %call Compare 2 Images Form
    set(gcf,'Name','Compare Two Images','NumberTitle','off');
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         figure(hPrev);     end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hComp);
end
hComp.UserData = 'Sub';     %indicate selected option
mUComp('Comp_SizeChangedFcn',hComp,eventdata,guidata(hComp));
figure(hComp);

% --------------------------------------------------------------------
function mCPratt_Callback(hObject, eventdata, handles)
% hObject    handle to mCPratt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hComp=findobj('Tag','Comp');	%check if was previously opened
if isempty(hComp)
    hComp=mUComp;               %call Compare 2 Images Form
    set(gcf,'Name','Compare Two Images','NumberTitle','off');
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)
        if ~isempty(hPrev)         figure(hPrev);     end
    end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hComp);
end
hComp.UserData = 'Pratt';       %indicate selected option
mUComp('Comp_SizeChangedFcn',hComp,eventdata,guidata(hComp));
figure(hComp);

% --------------------------------------------------------------------
function mCPol_Callback(hObject, eventdata, handles)
% hObject    handle to mCPol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCrea=findobj('Tag','Crea');	%check if was previously opened
if isempty(hCrea)
    hCrea=mUCreate;               %call Create Form
    set(gcf,'Name','Utilities - Create','NumberTitle','off')
    updatemenus();              %cheked for View information and save history
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)       
        figure(hPrev);    
    end
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCrea);
end
hCrea.UserData = 'Poly';     %indicate selected option
mUCreate('Crea_SizeChangedFcn',hCrea,eventdata,guidata(hCrea));
figure(hCrea);


% --------------------------------------------------------------------
function mCExt_Callback(hObject, eventdata, handles)
% hObject    handle to mCExt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCrea=findobj('Tag','Crea');	%check if was previously opened
if isempty(hCrea)
    hCrea=mUCreate;               %call Create Form
    set(gcf,'Name','Utilities - Create','NumberTitle','off')
    updatemenus();              %cheked for View information and save history
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)       
        figure(hPrev);    
    end
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCrea);
end
hCrea.UserData = 'Extra';     %indicate selected option
mUCreate('Crea_SizeChangedFcn',hCrea,eventdata,guidata(hCrea));
figure(hCrea);


% --------------------------------------------------------------------
function mCCir_Callback(hObject, eventdata, handles)
% hObject    handle to mCCir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCrea=findobj('Tag','Crea');	%check if was previously opened
if isempty(hCrea)
    hCrea=mUCreate;               %call Create Form
    set(gcf,'Name','Utilities - Create','NumberTitle','off')
    updatemenus();              %cheked for View information and save history
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)         
        figure(hPrev);    
    end
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCrea);
end
hCrea.UserData = 'Circ';      %indicate selected option
mUCreate('Crea_SizeChangedFcn',hCrea,eventdata,guidata(hCrea));
figure(hCrea);

% --------------------------------------------------------------------
function mCDia_Callback(hObject, eventdata, handles)
% hObject    handle to mCDia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
hCrea=findobj('Tag','Crea');	%check if was previously opened
if isempty(hCrea)
    hCrea=mUCreate;             %call Create Form
    set(gcf,'Name','Utilities - Create','NumberTitle','off')
    hPrev=findobj('Tag',handles.mUtil.UserData);%check if was previously opened 
    if ~isempty(hPrev)        
        figure(hPrev);    
    end
    updatemenus();              %cheked for View information and save history
    group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hCrea);
end
hCrea.UserData = 'Diam';     	%indicate selected option
mUCreate('Crea_SizeChangedFcn',hCrea,eventdata,guidata(hCrea));
figure(hCrea);



% --- Executes on selection change in txtIlist.
function txtIlist_Callback(hObject, eventdata, handles)
% hObject    handle to txtIlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns txtIlist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from txtIlist


% --- Executes during object creation, after setting all properties.
function txtIlist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtIlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function ImClear_Callback(hObject, eventdata, handles)
% hObject    handle to ImClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.txtIlist.String = '.:: CVIPTools Function Information ::.';
handles.txtIlist.Value = 1;

% --------------------------------------------------------------------
function Imenu_Callback(hObject, eventdata, handles)
% hObject    handle to Imenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ImCopy_Callback(hObject, eventdata, handles)
% hObject    handle to ImCopy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%preparing test in list to be copied as a unique array
% text = [handles.txtIlist.String(1,:)];     %copy first line
% for i = 3:size(handles.txtIlist.String,1)
%     text = [text handles.txtIlist.String(i,:)];
% end
%  % create ClipboardHandler object
% %     cpobj = com.mathworks.page.utils.ClipboardHandler;
% % text=handles.edit1.String(end+1);
% %     % do the copy
% %     cpobj.copy(text{:});
% 
% clipboard('copy', string(text));
clc;
h = msgbox('Select text and Use "Ctrl + C" to copy content','CVIPTools Message',...
    'help', 'modal');
% warning ('off','all');
% javaFrame = get(h,'JavaFrame');
% javaFrame.setFigureIcon(javax.swing.ImageIcon([pwd '\Resources\icon_48.PNG']));

function showImages(handles, cpath, file)
    InIma = imastruc_cvip([cpath file]);
    %check if need to show function information
    hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
    if strcmp(hVfinfo(1).Checked,'on')
        if ~isa(InIma.fInfo.history_info,'char')
            histo = ['yes size= ' num2str(size(InIma.fInfo.history_info,1))];
        else
            histo = 'none';
        end
        hIlist = findobj('Tag','txtIlist');     %get handle of text element
        txtInfo = [{' '};{'Opening Image:'};{[InIma.fInfo.filename]};...
            {'Image Information:'};{['Mod. Date: ' InIma.fInfo.file_mod_date]};...
            {['Image Format: ' InIma.fInfo.image_format ', Color Format: ' ...
            InIma.fInfo.color_format]};{['Data Type: ' InIma.fInfo.cvip_type ...
            ', Data Format: ' InIma.fInfo.data_format]};{['Compression: ' ...
            InIma.fInfo.cmpr_format ', Rows: ' num2str(InIma.fInfo.no_of_rows)...
            ', Cols: ' num2str(InIma.fInfo.no_of_cols) ', Bands: ' ...
            num2str(InIma.fInfo.no_of_bands)]}; {['File Size: ' ...
            num2str(InIma.fInfo.file_size)]}; {['History: ' histo]}];

        for i=1:size(txtInfo,1)
            sInfo = txtInfo{i};                 %exract row to print
            hIlist.String(end+1,1:size(sInfo,2)) = sInfo;
        end
        hIlist.Value = size(hIlist.String,1);   %goto last line
        figure(handles.Main);
    end
    showgui_cvip(InIma, file);

% --------------------------------------------------------------------
function mCVIPweb_Callback(hObject, eventdata, handles)
% hObject    handle to mCVIPweb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
web('https://cviptools.siue.edu/')

function updatemenus()
%set initial values for view menu
hSHisto = findobj('Tag','mVsaveHis'); %get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hCount = 0;                         %history checked counter
iCount = 0;                         %information checked counter
for i=1:size(hSHisto,1)
    %look for checked view history menus 
    if strcmp(hSHisto(i).Checked,'on')
        hCount = hCount+1;
    end
    %look for checked view information menus 
    if strcmp(hVfinfo(i).Checked,'on')
        iCount = iCount+1;
    end
end
%update all view history menus
if hCount > 0
    for i=1:size(hSHisto,1)
        hSHisto(i).Checked = 'on';
    end
end
%update all view information menus
if iCount > 0
    for i=1:size(hSHisto,1)
        hVfinfo(i).Checked = 'on';
    end
end


% --- Executes when user attempts to close Main.
function Main_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clc;                             %clear screen
Answ = questdlg('This action will close the GUI. Do you want to continue?',...
    'CVIPtools Toolbox Message','Yes','No','No');

if strcmp(Answ, 'Yes')
    % Hint: delete(hObject) closes the figure
    delete(hObject);
    close ALL;    
end


% --------------------------------------------------------------------
function fExit_Callback(hObject, eventdata, handles)
% hObject    handle to fExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;                             %clear screen
delete(hObject);
close ALL;


% --------------------------------------------------------------------
function mFegHisto_Callback(hObject, eventdata, handles)
% hObject    handle to mFegHisto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mFig_Callback(hObject, eventdata, handles)
% hObject    handle to mFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
