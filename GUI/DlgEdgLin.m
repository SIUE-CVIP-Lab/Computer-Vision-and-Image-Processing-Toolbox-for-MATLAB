function varargout = DlgEdgLin(varargin)
% DLGEDGLIN MATLAB code for DlgEdgLin.fig
%      DLGEDGLIN, by itself, creates a new DLGEDGLIN or raises the existing
%      singleton*.
%
%      H = DLGEDGLIN returns the handle to a new DLGEDGLIN or the handle to
%      the existing singleton*.
%
%      DLGEDGLIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DLGEDGLIN.M with the given input arguments.
%
%      DLGEDGLIN('Property','Value',...) creates a new DLGEDGLIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgEdgLin_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgEdgLin_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DlgEdgLin

% Last Modified by GUIDE v2.5 27-Feb-2020 16:28:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgEdgLin_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgEdgLin_OutputFcn, ...
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
 % Revision 1.4  05/24/2019  13:32:15  jucuell
 % including the icons to extract the histogram, R, G and B band from the
 % selected image.
%
 % Revision 1.3  01/12/2019  14:21:00  jucuell
 % updating image handling, visualization, history displaying and saving.
%
 % Revision 1.2  12/12/2018  15:21:14  jucuell
 % updating menu creation programmatically, callbacks to Main figure and
 % the use of the utilities menus in the Main figure.
%
 % Revision 1.1  11/21/2017  15:23:31  jucuell
 % Initial coding and testing.
%

% --- Executes just before DlgEdgLin is made visible.
function DlgEdgLin_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DlgEdgLin (see VARARGIN)

% Choose default command line output for DlgEdgLin
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DlgEdgLin wait for user response (see UIRESUME)
% uiwait(handles.Edge);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';%hide Analysis menu
handles.mComp.Visible = 'Off';%hide Compression menu


% --- Outputs from this function are returned to the command line.
function varargout = DlgEdgLin_OutputFcn(hObject, eventdata, handles) 
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
 close(handles.Edge)


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
clc                             %clear screen

%changing pointer arrow to watch on cursor
figure_set = findall(groot,'Type','Figure');
set(figure_set,'pointer','watch');
%changing pointer watch back to arrow on cursor
set(figure_set,'pointer','arrow');

handles.txtRes.String = 'Working...';
handles.txtRres.String = 'Working...';
handles.txtGres.String = 'Working...';
handles.txtBres.String = 'Working...';
drawnow;                            %force GUI update
hMain = findobj('Tag','Main');      %get the handle of Main figure
hSHisto = findobj('Tag','mVsaveHis');%get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
if handles.bPra.Value
    hNfig = handles.bIdeIma;        %get image handle
else
    hNfig = hMain.UserData;       	%get image handle
end
hNfig2 = handles.bSelIma.UserData;  %get image handle
%check for Image to process
if hNfig == 0 || isempty(hNfig) || ~isfield(hNfig.UserData,'cvipIma')
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Edge/Lin Error','modal'); 

elseif handles.bCer.Value && size(hNfig.UserData.cvipIma,3) == 1
    errordlg(['This operation requires a Color Image. Please select '...
        'a Color Image and try again.'],'Edge/Lin Error','modal'); 
%check for required second image
elseif handles.bPra.Value && (isempty(hNfig2) || ~isfield(hNfig2,'cvipIma'))
    errordlg(['This operation requires 2 Images. Select a 2nd'...
                ' Image and try again!'],'Edge/Lin Error','modal');
else
    
Ima = hNfig.UserData;               %get image information
InIma = Ima.cvipIma;                %read image data
if handles.bPra.Value == 0
    file = get(hNfig,'Name');      	%get image name
end
Index = 1;                          %history index
histo = [0 0];                      %history initialization
OutIma = 0;                         %output Image initialization

%check pre operations
if handles.preFil.Value ~= 1
    Index = 3;                      %history index
    switch handles.preFil.Value     %apply prefilter to image
        case 2                      %average filter
            Mask = ones(3)/9;       %create center-weighted mask
            histo = [169 3; 202 0]; %update image history
        case 3                      %center-weighted average
            Mask = ones(3);         %create center-weighted mask
            Mask(2,2) = 9;
            histo = [205 3; 202 0]; %update image history
        case 4                      %Gaussian mask size = 3
            Mask = gaussmask_cvip(3);%Gaussian mask
            %remap output
            %OutIma = remap_cvip(OutIma, [0 255]);
            histo = [204 3; 202 0]; %update image history
        case 5                      %Gaussian mask size = 5
            Mask = gaussmask_cvip(5);%Gaussian mask
            %remap output
            %OutIma = remap_cvip(OutIma, [0 255]);
            histo = [204 5; 202 0]; %update image history
        case 6
            Mask = gaussmask_cvip(7);
            %remap output
            %OutIma = remap_cvip(OutIma, [0 255]);
            histo = [204 7 202 0]; %update image history
        case 7 
            Mask  = gaussmak_cvip(9);
            %remap output
            %OutIma = remap_cvip(OutIma, [0 255]);
            histo = [204 9 202 0]; %update image history
        case 8 
            Mask = gaussmask_cvip(11);
            %remap output
            %OutIma = remap_cvip(OutIma, [0 255]);
            histo = [204 11 202 0]; %update image history
    end
    if handles.kDC.Value            %keep DC when applying filter
        Center = (size(Mask,1) + 1) / 2;
        Mask(Center,Center) = Mask(Center,Center) + 1;
    end
    InIma = convolve_filter_cvip(InIma,Mask);
end

%IMAGE OPERATIONS
if handles.bRob.Value==1            %Roberts edge detector
    Type = handles.RobType.Value;  	%get robers type
    OutIma = roberts_ed_cvip(InIma, Type);%call Roberts function
    Name = [file,' > Roberts (',num2str(Type),')'];
    histo(Index,:) = [054 Type];    %update image history

elseif handles.bSob.Value==1        %Sobel edge detector
    %get kernel size
    kernel = str2double(handles.SobKer.String(handles.SobKer.Value));  
    [OutIma, edge_dir] = sobel_ed_cvip(InIma,(kernel));%call Sobel function
    Ima.cvipIma = edge_dir;         %update cvip image
    Name = strcat(file,' > Sobel (Dir-',num2str(kernel),')');%Dir image name
    showgui_cvip(Ima, Name);      	%show image in viewer
    Name = strcat(file,' > Sobel (Mag-',num2str(kernel),')');%Mag image name
    histo(Index,:) = [057 kernel];  %update image history

elseif handles.bPre.Value==1    %Prewitt edge detector
    %get kernel size
    kernel = str2double(handles.SobKer.String(handles.SobKer.Value));  
    [OutIma, edge_dir] = prewitt_ed_cvip(InIma,(kernel));%call Sobel function
    Ima.cvipIma = edge_dir;         %update cvip image
    Name = strcat(file,' > Prewitt (Dir-',num2str(kernel),')');%Dir image name
    showgui_cvip(Ima, Name);      	%show image in viewer
%     if band == 3
%         edge_mag = hist_stretch_cvip(edge_mag,0,1,0,0);
%         edge_dir = hist_stretch_cvip(edge_dir,0,1,0,0);
%     else
%         edge_dir = remap_cvip(edge_dir);
%     end
    Name = strcat(file,' > Prewitt (Mag-',num2str(kernel),')');%Mag image name
    histo(Index,:) = [052 kernel];  %update image history

elseif handles.bLap.Value==1        %Prewitt edge detector
    mask_type = handles.lMask.Value;%get mask type
    OutIma = laplacian_ed_cvip(InIma, mask_type);%call Laplacian function
%     if band == 3
%         edge_mag = hist_stretch_cvip(edge_mag,0,1,0,0);
%     end
    Name = [file,' > Laplacian (Mag-',num2str(mask_type),')'];%Mag image name
    histo(Index,:) = [047 mask_type];%update image history
    
elseif handles.bKir.Value==1        %Kirsch edge detector
    [OutIma, edge_dir] = kirsch_ed_cvip(InIma);%call Kirsch function
    Ima.cvipIma = edge_dir;         %update cvip image
    Name = strcat(file,' > Kirsch (Dir)');%Dir image name
    showgui_cvip(Ima, Name);      	%show image in viewer
%     if band == 3
%         edge_mag = hist_stretch_cvip(edge_mag,0,1,0,0);
%         edge_dir = hist_stretch_cvip(edge_dir,0,1,0,0);
%     end
    Name = strcat(file,' > Kirsch (Mag)');%Mag image name
    histo(Index,:) = [046 0];       %update image history

elseif handles.bRobi.Value==1    %Robinson edge detector
    [OutIma, edge_dir] = robinson_ed_cvip(InIma);%call Robinson function
    Ima.cvipIma = edge_dir;         %update cvip image
    Name = [file,' > Robinson (Dir)'];%Dir image name
    showgui_cvip(Ima, Name);      	%show image in viewer
%     if band == 3
%         edge_mag = hist_stretch_cvip(edge_mag,0,1,0,0);
%         edge_dir = hist_stretch_cvip(edge_dir,0,1,0,0);
%     end
    Name = strcat(file,' > Robinson (Mag)');%Mag image name
    histo(Index,:) = [055 0];       %update image history

elseif handles.bPyr.Value==1    %Pyramid edge detector
    [OutIma, edge_dir] = pyramid_ed_cvip(InIma);%call Pyramid function
    Ima.cvipIma = edge_dir;         %update cvip image
    Name = strcat(file,' > Pyramid (Dir)');%Dir image name
    showgui_cvip(Ima, Name);      	%show image in viewer
    Name = strcat(file,' > Pyramid (Mag)');%Mag image name
    histo(Index,:) = [053 0];      	%update image history

elseif handles.bCer.Value==1    %Cerchar edge detector
    OutIma = cerchar_ed_cvip(InIma);%call Cerchar function
%     if band == 3
%         edge_mag = hist_stretch_cvip(edge_mag,0,1,0,0);
%     end
    Name = strcat(file,' > Cerchar');%Mag image name
    if handles.cNOT.Value == 1      %Check if want to apply NOT
        OutIma = remap_cvip(OutIma, [0 255]);
        OutIma = not_cvip(OutIma);%show NOT image
    end
    histo(Index,:) = [043 handles.cNOT.Value];%update image history
    
elseif handles.bMar.Value==1    %Marr Hildreth edge detector
    sigma = str2double(handles.popSig.String(handles.popSig.Value,:));
    delta = str2double(handles.popDel.String(handles.popDel.Value));
    OutIma = marr_hildreth_ed_cvip(InIma, sigma, delta);
    Name = [file ' > Marr Hildreth (',num2str(sigma) ',' num2str(delta),')'];   
    histo = [049 sigma delta];      %update image history

elseif handles.bCan.Value==1        %Canny edge detector
    sigma = str2double(handles.popSig.String(handles.popSig.Value,:));
    low = str2double(handles.popLow.String(handles.popLow.Value));
    high = str2double(handles.popHigh.String(handles.popHigh.Value));
    [OutIma, Mag, Dir] = canny_ed_cvip(InIma, sigma, low, high);
    if handles.cShow.Value
        Ima.cvipIma = Mag;          %update cvip image
        Name = strcat(file,' > Canny (Mag)(',num2str(sigma),',', ...
            num2str(low),'-',num2str(high),')');
        showgui_cvip(Ima, Name);  	%show image in viewer
        Ima.cvipIma = Dir;          %update cvip image
        Name = strcat(file,' > Canny (Dir)(',num2str(sigma),',', ...
            num2str(low),'-',num2str(high),')');
        showgui_cvip(Ima, Name);    %show image in viewer
    end
    Name = strcat(file,' > Canny (',num2str(sigma),',',num2str(low), ...
        '-',num2str(high),')');
    histo = [042 sigma low high];   %update image history

elseif handles.bCoi.Value==1        %Boie-Cox edge detector
    va = str2double(handles.popSig.String(handles.popSig.Value,:));
    low = str2double(handles.popLow.String(handles.popLow.Value));
    high = str2double(handles.popHigh.String(handles.popHigh.Value));
    hys = handles.cHys.Value;
    thin = handles.cThin.Value;
    [OutIma,THIma,HIma] = boiecox_ed_cvip(InIma, va, hys, thin, high, low);
    if handles.cShow.Value
        Name = [file ' > Boie-Cox (TH)(' num2str(high) ')'];
        Ima.cvipIma = THIma;       	%update cvip image
        showgui_cvip(Ima, Name);  	%show image in viewer
        Name = [file ' > Boie-Cox (Hys)(' num2str(low) '-' num2str(high) ')'];
        Ima.cvipIma = HIma;        	%update cvip image
        showgui_cvip(Ima, Name);  	%show image in viewer
    end
    Name = [file ' > Boie-Cox (',num2str(va) ',' num2str(low) '-' ...
        num2str(high),')'];
    histo = [041 va hys thin high low];%update image history
    
elseif handles.bShe.Value==1        %Shen-Castan edge detector
    smo = str2double(handles.popSmo.String(handles.popSmo.Value,:));
    low = str2double(handles.popLow.String(handles.popLow.Value));
    high = str2double(handles.popHigh.String(handles.popHigh.Value));
    [OutIma, mag, before] = shen_castan_ed_cvip(InIma, smo , low, high);
    if handles.cShow.Value
        Name = [file ' > Shen-Castan (Mag Sup.)'];
        Ima.cvipIma = mag;       	%update cvip image
        showgui_cvip(Ima, Name);  	%show image in viewer
        Name = [file ' > Shen-Castan (Before Sup.)' ];
        Ima.cvipIma = before;     	%update cvip image
        showgui_cvip(Ima, Name);  	%show image in viewer
    end    
    Name = [file ' > Shen-Castan (After Hys.)(' num2str(smo) ','  ...
        num2str(low) '-' num2str(high) ')'];
    histo = [056 smo low high];     %update image history
  
elseif handles.bFrei.Value          %Frei-Chen edge detector
    %check pre operations
    if handles.popPre.Value ~= 1
        Index = 3;                 	%history Index
        switch handles.popPre.Value	%apply prefilter to image    
            case 2                	%average filter
                Mask = ones(3)/9;   %create center-weighted mask
                histo = [169 3; 202 0]; %update image history
            case 3                 	%center-weighted average
                Mask = ones(3);    	%create center-weighted mask
                Mask(2,2) = 9;
                histo = [205 3; 202 0]; %update image history
            case 4                 	%Gaussian mask size = 3
                Mask = gaussmask_cvip(3);%Gaussian mask
                histo = [204 3; 202 0];%update image history
            case 5                	%Gaussian mask size = 5
                Mask = gaussmask_cvip(5);%Gaussian mask
                histo = [204 5; 202 0];%update image history
        end
        
        if handles.cKeep.Value      %keep DC when applying filter
            Center = (size(Mask,1) + 1) / 2;
            Mask(Center,Center) = Mask(Center,Center) + 1;
        end
        InIma = convolve_filter_cvip(InIma,Mask);
    end
    Sub = handles.popPro.Value;
    [OutIma , dir] = frei_chen_ed_cvip(InIma, Sub);
    Name = strcat(file,' > Frei-Chen (Cos-Theta)(',num2str(Sub),')');
    Ima.cvipIma = dir;             	%update cvip image
    showgui_cvip(Ima, Name);       	%show image in viewer
    histo(Index,:) = [044 Sub];    	%update image history
    %check post thresholding
    if handles.popPos.Value ~= 1
        THlvl = str2double(handles.popPos.String(handles.popPos.Value));
        OutIma = threshold_cvip(OutIma, THlvl);
        histo(end+1,:) = [181 THlvl];%update image history
    end
    Name = strcat(file,' > Frei-Chen (Mag)(',num2str(Sub),')');

elseif handles.bMor.Value         	%Moravec Corner detector
    TH = str2double(handles.popTH.String(handles.popTH.Value));
    OutIma = moravec_corner_cvip(InIma , TH);
    Name = strcat(file,' > Moravec (',num2str(TH),')');
    histo = [050 TH];               %update image history
    
elseif handles.bHar.Value           %Harris Corner detector
    TH = str2double(handles.popTH.String(handles.popTH.Value));
    Std = str2double(handles.popStd.String(handles.popStd.Value));
    Alfa = str2double(handles.popAlph.String(handles.popAlph.Value));
    Max = str2double(handles.popMax.String(handles.popMax.Value));
    OutIma = harris_corner_cvip(InIma, TH, Std, Alfa, Max);
    Name = [file,' > Harris (',num2str(TH),',',num2str(Std),',', ...
        num2str(Alfa),',',num2str(Max),')'];
    histo = [045 TH Std Alfa Max];  %update image history

elseif handles.bHou.Value           %Hough filter
    theta_string = handles.eTheta.String;
    Delta_Theta = str2double(handles.popH2.String(handles.popH2.Value));
        %removing the possible dash from the theta string
        %formatting theta based on user inputs 
        dash_location = find(theta_string == '-');
        if isempty(dash_location)
            theta = str2double(theta_string);
        else
            theta_value(1,1) = str2double(theta_string(1:dash_location-1));
            theta_value(1,2) = str2double(theta_string(dash_location+1:end));
            theta = [theta_value(1,1) Delta_Theta theta_value(1,2)];
        end
    rho = str2double(handles.popStd.String(handles.popStd.Value));
    LP = str2double(handles.popAlph.String(handles.popAlph.Value));
    Segment_Pixels = str2double(handles.popMax.String(handles.popMax.Value));
    Max_Connect = str2double(handles.popH1.String(handles.popH1.Value));
    %producing the hough image and RC_cell as they are always needed
    [Hough_Image,RC_cell] = hough_transform_cvip(InIma,theta,rho);
    %switching through the different output Displayed Image options
    switch handles.popsca.Value
        case 1 %Hough Image
            OutIma = Hough_Image;
            Name = [file,' > Hough'];
        case 2 %Inverse Hough Image
            OutIma = hough_inverse_cvip(Hough_Image,RC_cell,LP);
            Name = [file,' > InvHough'];
        case 3 %Aftering ANDing Image
            Inverse_Hough_Image = inverse_hpugh_cvip(Hough_Image,RC_cell,LP);
            OutIma = and_cvip(Inverse_Hough_Image,InIma);
            Name = [file,' > AfterAND'];
        case 4 %After Connection Image
            
        case 5 %Final Image (After Extinction Image)
    end
        
elseif handles.bEdg.Value==1        %Edge Link filter
    Conn = str2double(handles.popConn.String(handles.popConn.Value));
    OutIma = edge_link_filter_cvip(InIma,Conn);
    Name = [file,' > Edge Link (',num2str(Conn),')'];%Image Name
    histo = [059 Conn];             %update image history
    
elseif handles.bPra.Value==1        %Pratt Figure of Merit
    handles.txtRres.String = 'Working...';
    Sca = str2num(handles.popsca.String{handles.popsca.Value});
    histo = [051 Sca];              %update image history
    handles.txtRres.String = '...';
    handles.txtGres.String = '...';
    handles.txtBres.String = '...';
    InIma2 = hNfig2.cvipIma;     	%get 2nd image
    band = size(InIma,3);
    band2 = size(InIma2,3);
    tic
    if band == 3 || band2 == 3
        [FOMR, FOMG, FOMB] = pratt_merit_cvip(InIma, InIma2, Sca);
        handles.txtRres.String = FOMR;
        handles.txtGres.String = FOMG;
        handles.txtBres.String = FOMB;
        handles.txtRres.ForegroundColor = [1 0 0];
        handles.txtRres.Visible = 'On';
        handles.txtGres.Visible = 'On';
        handles.txtBres.Visible = 'On';
    else
        FOM = pratt_merit_cvip(InIma, InIma2, Sca);
        handles.txtRres.String = FOM;
        handles.txtRres.ForegroundColor = [0 0 0];
        handles.txtRres.Visible = 'On';
        handles.txtGres.Visible = 'Off';
        handles.txtBres.Visible = 'Off';
    end
    toc
end

%check post thresholding
if handles.posTH.Value ~= 1
    THlvl = str2double(handles.posTH.String(handles.posTH.Value));
    OutIma = threshold_cvip(OutIma, THlvl);
    histo(end+1,:) = [181 THlvl];   %update image history
end

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


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
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


% --- Executes on selection change in preFil.
function preFil_Callback(hObject, eventdata, handles)
% hObject    handle to preFil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns preFil contents as cell array
%        contents{get(hObject,'Value')} returns selected item from preFil


% --- Executes during object creation, after setting all properties.
function preFil_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preFil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in kDC.
function kDC_Callback(hObject, eventdata, handles)
% hObject    handle to kDC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of kDC


% --- Executes on selection change in posTH.
function posTH_Callback(hObject, eventdata, handles)
% hObject    handle to posTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns posTH contents as cell array
%        contents{get(hObject,'Value')} returns selected item from posTH


% --- Executes during object creation, after setting all properties.
function posTH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to posTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in RobType.
function RobType_Callback(hObject, eventdata, handles)
% hObject    handle to RobType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RobType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RobType


% --- Executes during object creation, after setting all properties.
function RobType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RobType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bTH.
function bTH_Callback(hObject, eventdata, handles)
% hObject    handle to bTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc                                 %clear screen
hMain = findobj('Tag','Main');      %get the handle of Main figure
hNfig = hMain.UserData;             %get image handle
%check for Image to process
if hNfig == 0 || isempty(hNfig) || ~isfield(hNfig.UserData,'cvipIma')
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Edge/Lin Error','modal'); 
else
    Ima = hNfig.UserData;         	%get image information
    InIma = Ima.cvipIma;           	%read image data
    file=get(hNfig,'Name');         %get image name
    %get Threshold value from GUI
    THlvl = str2double(handles.THlvl.String(handles.THlvl.Value));
    if max(max(InIma(:))) <= 1      %detect if image data type is double
        Ima.cvipIma = threshold_cvip(InIma, THlvl/255);
    else
        Ima.cvipIma = threshold_cvip(uint8(InIma), THlvl);
    end
    Name = [file ' > TH (' num2str(THlvl) ')'];
    showgui_cvip(Ima, Name);      	%show image in viewer
end
 


% --- Executes on selection change in THlvl.
function THlvl_Callback(hObject, eventdata, handles)
% hObject    handle to THlvl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns THlvl contents as cell array
%        contents{get(hObject,'Value')} returns selected item from THlvl


% --- Executes during object creation, after setting all properties.
function THlvl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to THlvl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bRob.
function bRob_Callback(hObject, eventdata, handles)
% hObject    handle to bRob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bRob
%show and hide controls
handles.p3rdEdge.Visible = 'Off';
handles.p2ndEdge.Visible = 'Off';

handles.p1stEdge.Visible = 'On';
handles.kDC.Visible = 'On';
handles.txtpFil.Visible = 'On';
handles.preFil.Visible = 'On';
handles.txtpTH.Visible = 'On';
handles.posTH.Visible = 'On';
handles.txtType.Visible = 'On';
handles.RobType.Visible = 'On';
handles.bShow.String = 'Show Type';
handles.bShow.Visible = 'On';
handles.txtKernel.Visible = 'Off';
handles.SobKer.Visible = 'Off';
handles.txtMask.Visible = 'Off';
handles.lMask.Visible = 'Off';
handles.cNOT.Visible = 'Off';


% --- Executes on button press in bSob.
function bSob_Callback(hObject, eventdata, handles)
% hObject    handle to bSob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bSob
%show and hide controls
handles.p3rdEdge.Visible = 'Off';
handles.p2ndEdge.Visible = 'Off';

handles.p1stEdge.Visible = 'On';
handles.kDC.Visible = 'On';
handles.txtpFil.Visible = 'On';
handles.preFil.Visible = 'On';
handles.txtpTH.Visible = 'On';
handles.posTH.Visible = 'On';
handles.txtType.Visible = 'Off';
handles.RobType.Visible = 'Off';
handles.bShow.Visible = 'Off';
handles.txtKernel.Visible = 'On';
handles.SobKer.Visible = 'On';
handles.txtMask.Visible = 'Off';
handles.lMask.Visible = 'Off';
handles.cNOT.Visible = 'Off';

% --- Executes on selection change in SobKer.
function SobKer_Callback(hObject, eventdata, handles)
% hObject    handle to SobKer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SobKer contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SobKer


% --- Executes during object creation, after setting all properties.
function SobKer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SobKer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bLap.
function bLap_Callback(hObject, eventdata, handles)
% hObject    handle to bLap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bLap
%show and hide controls
handles.p3rdEdge.Visible = 'Off';
handles.p2ndEdge.Visible = 'Off';

handles.p1stEdge.Visible = 'On';
handles.kDC.Visible = 'On';
handles.txtpFil.Visible = 'On';
handles.preFil.Visible = 'On';
handles.txtpTH.Visible = 'On';
handles.posTH.Visible = 'On';
handles.txtType.Visible = 'Off';
handles.RobType.Visible = 'Off';
handles.bShow.String = 'Show Mask';
handles.bShow.Visible = 'On';
handles.txtKernel.Visible = 'Off';
handles.SobKer.Visible = 'Off';
handles.txtMask.Visible = 'On';
handles.lMask.Visible = 'On';
handles.cNOT.Visible = 'Off';

% --- Executes on selection change in lMask.
function lMask_Callback(hObject, eventdata, handles)
% hObject    handle to lMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lMask contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lMask


% --- Executes during object creation, after setting all properties.
function lMask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bKir.
function bKir_Callback(hObject, eventdata, handles)
% hObject    handle to bKir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bKir
%show and hide controls
handles.p3rdEdge.Visible = 'Off';
handles.p2ndEdge.Visible = 'Off';

handles.p1stEdge.Visible = 'On';
handles.kDC.Visible = 'Off';
handles.txtpFil.Visible = 'On';
handles.preFil.Visible = 'On';
handles.txtpTH.Visible = 'On';
handles.posTH.Visible = 'On';
handles.txtType.Visible = 'Off';
handles.RobType.Visible = 'Off';
handles.bShow.Visible = 'Off';
handles.txtKernel.Visible = 'Off';
handles.SobKer.Visible = 'Off';
handles.txtMask.Visible = 'Off';
handles.lMask.Visible = 'Off';
handles.cNOT.Visible = 'Off';

% --- Executes on button press in bRobi.
function bRobi_Callback(hObject, eventdata, handles)
% hObject    handle to bRobi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bRobi
%show and hide controls
handles.p3rdEdge.Visible = 'Off';
handles.p2ndEdge.Visible = 'Off';

handles.p1stEdge.Visible = 'On';
handles.kDC.Visible = 'Off';
handles.txtpFil.Visible = 'On';
handles.preFil.Visible = 'On';
handles.txtpTH.Visible = 'On';
handles.posTH.Visible = 'On';
handles.txtType.Visible = 'Off';
handles.RobType.Visible = 'Off';
handles.bShow.Visible = 'Off';
handles.txtKernel.Visible = 'Off';
handles.SobKer.Visible = 'Off';
handles.txtMask.Visible = 'Off';
handles.lMask.Visible = 'Off';
handles.cNOT.Visible = 'Off';

% --- Executes on button press in bPyr.
function bPyr_Callback(hObject, eventdata, handles)
% hObject    handle to bPyr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bPyr
%show and hide controls
handles.p3rdEdge.Visible = 'Off';
handles.p2ndEdge.Visible = 'Off';

handles.p1stEdge.Visible = 'On';
handles.kDC.Visible = 'Off';
handles.txtpFil.Visible = 'On';
handles.preFil.Visible = 'On';
handles.txtpTH.Visible = 'On';
handles.posTH.Visible = 'On';
handles.txtType.Visible = 'Off';
handles.RobType.Visible = 'Off';
handles.bShow.Visible = 'Off';
handles.txtKernel.Visible = 'Off';
handles.SobKer.Visible = 'Off';
handles.txtMask.Visible = 'Off';
handles.lMask.Visible = 'Off';
handles.cNOT.Visible = 'Off';

% --- Executes on button press in bCer.
function bCer_Callback(hObject, eventdata, handles)
% hObject    handle to bCer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bCer
%show and hide controls
handles.p3rdEdge.Visible = 'Off';
handles.p2ndEdge.Visible = 'Off';

handles.p1stEdge.Visible = 'On';
handles.kDC.Visible = 'Off';
handles.txtpFil.Visible = 'Off';
handles.preFil.Visible = 'Off';
handles.preFil.Value = 1;
handles.txtpTH.Visible = 'Off';
handles.posTH.Visible = 'Off';
handles.posTH.Value = 1;
handles.txtType.Visible = 'Off';
handles.RobType.Visible = 'Off';
handles.bShow.Visible = 'Off';
handles.txtKernel.Visible = 'Off';
handles.SobKer.Visible = 'Off';
handles.txtMask.Visible = 'Off';
handles.lMask.Visible = 'Off';
handles.cNOT.Visible = 'On';


% --- Executes on button press in cNOT.
function cNOT_Callback(hObject, eventdata, handles)
% hObject    handle to cNOT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cNOT


% --- Executes on button press in bPre.
function bPre_Callback(hObject, eventdata, handles)
% hObject    handle to bPre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bPre
%show and hide controls
handles.p3rdEdge.Visible = 'Off';
handles.p2ndEdge.Visible = 'Off';

handles.p1stEdge.Visible = 'On';
handles.kDC.Visible = 'On';
handles.txtpFil.Visible = 'On';
handles.preFil.Visible = 'On';
handles.txtpTH.Visible = 'On';
handles.posTH.Visible = 'On';
handles.txtType.Visible = 'Off';
handles.RobType.Visible = 'Off';
handles.bShow.Visible = 'Off';
handles.txtKernel.Visible = 'On';
handles.SobKer.Visible = 'On';
handles.txtMask.Visible = 'Off';
handles.lMask.Visible = 'Off';
handles.cNOT.Visible = 'Off';


% --- Executes on button press in bEdg.
function bEdg_Callback(hObject, eventdata, handles)
% hObject    handle to bEdg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bEdg
%show and hide controls
handles.p1stEdge.Visible = 'Off';
handles.p2ndEdge.Visible = 'Off';

handles.p3rdEdge.Visible = 'On';
handles.lblConn.String = 'Connect Distance (max)';
handles.lblConn.Visible = 'On';
handles.popConn.Visible = 'On';
handles.lblTH.Visible = 'Off';
handles.popTH.Visible = 'Off';
handles.lblAlph.Visible = 'Off';
handles.popAlph.Visible = 'Off';
handles.lblMax.Visible = 'Off';
handles.popMax.Visible = 'Off';
handles.lblStd.Visible = 'Off';
handles.popStd.Visible = 'Off';
handles.lblSca.Visible = 'Off';
handles.popsca.Visible = 'Off';
handles.lblRes.Visible = 'Off';
handles.txtRres.Visible = 'Off';
handles.txtGres.Visible = 'Off';
handles.txtBres.Visible = 'Off';
handles.txtSelIma.Visible = 'Off';
handles.txtIdeIma.Visible = 'Off';
handles.lblIdeal.Visible = 'Off';
handles.bIdeIma.Visible = 'Off';
handles.bSelIma.Visible = 'Off';
handles.preFil.Value = 1;
handles.posTH.Value = 1;

%handles for the modified Hough
handles.eTheta.Visible = 'Off';
handles.tH1.Visible = 'Off';
handles.popH1.Visible = 'Off';
handles.tH2.Visible = 'Off';
handles.popH2.Visible = 'Off';


% --- Executes on selection change in popConn.
function popConn_Callback(hObject, eventdata, handles)
% hObject    handle to popConn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popConn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popConn


% --- Executes during object creation, after setting all properties.
function popConn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popConn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popTH.
function popTH_Callback(hObject, eventdata, handles)
% hObject    handle to popTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popTH contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popTH


% --- Executes during object creation, after setting all properties.
function popTH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popAlph.
function popAlph_Callback(hObject, eventdata, handles)
% hObject    handle to popAlph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popAlph contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popAlph


% --- Executes during object creation, after setting all properties.
function popAlph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popAlph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popMax.
function popMax_Callback(hObject, eventdata, handles)
% hObject    handle to popMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMax contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMax


% --- Executes during object creation, after setting all properties.
function popMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popStd.
function popStd_Callback(hObject, eventdata, handles)
% hObject    handle to popStd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popStd contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popStd


% --- Executes during object creation, after setting all properties.
function popStd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popStd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popsca.
function popsca_Callback(hObject, eventdata, handles)
% hObject    handle to popsca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popsca contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popsca
handles.txtRres.String = '...';
handles.txtGres.String = '...';
handles.txtBres.String = '...';

% --- Executes during object creation, after setting all properties.
function popsca_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popsca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtRes_Callback(hObject, eventdata, handles)
% hObject    handle to txtRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtRes as text
%        str2double(get(hObject,'String')) returns contents of txtRes as a double


% --- Executes during object creation, after setting all properties.
function txtRes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtSelIma_Callback(hObject, eventdata, handles)
% hObject    handle to txtSelIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtSelIma as text
%        str2double(get(hObject,'String')) returns contents of txtSelIma as a double


% --- Executes during object creation, after setting all properties.
function txtSelIma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSelIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtIdeIma_Callback(hObject, eventdata, handles)
% hObject    handle to txtIdeIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtIdeIma as text
%        str2double(get(hObject,'String')) returns contents of txtIdeIma as a double


% --- Executes during object creation, after setting all properties.
function txtIdeIma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtIdeIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bIdeIma.
function bIdeIma_Callback(hObject, eventdata, handles)
% hObject    handle to bIdeIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%capture ideal image information and save it
clc                             %clear screen
hMain = findobj('Tag','Main');  %get the handle of Main form
hNfig = hMain.UserData;         %get image handle
if hNfig ~= 0 && isfield(hNfig.UserData,'cvipIma')%check for Image to save
    file=get(hNfig,'Name');    	%get image name
    hObject.UserData = hNfig.UserData;%read image info
    handles.txtIdeIma.String = file;  %show image name
end

% --- Executes on button press in bSelIma.
function bSelIma_Callback(hObject, eventdata, handles)
% hObject    handle to bSelIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc                             %clear screen
hMain = findobj('Tag','Main');  %get the handle of Main form
hNfig = hMain.UserData;         %get image handle
if hNfig ~= 0 && isfield(hNfig.UserData,'cvipIma')%check for Image to save
    file=get(hNfig,'Name');    	%get image name
    hObject.UserData = hNfig.UserData;%read image info
    handles.txtSelIma.String = file;  %show image name
end


% --- Executes on button press in bMor.
function bMor_Callback(hObject, eventdata, handles)
% hObject    handle to bMor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bMor
%show and hide controls
handles.p1stEdge.Visible = 'Off';
handles.p2ndEdge.Visible = 'Off';

handles.p3rdEdge.Visible = 'On';
handles.lblConn.Visible = 'Off';
handles.popConn.Visible = 'Off';
handles.lblTH.Visible = 'On';
handles.popTH.Visible = 'On';
handles.lblAlph.Visible = 'Off';
handles.popAlph.Visible = 'Off';
handles.lblMax.Visible = 'Off';
handles.popMax.Visible = 'Off';
handles.lblStd.Visible = 'Off';
handles.popStd.Visible = 'Off';
handles.lblSca.Visible = 'Off';
handles.popsca.Visible = 'Off';
handles.lblRes.Visible = 'Off';
handles.txtRres.Visible = 'Off';
handles.txtGres.Visible = 'Off';
handles.txtBres.Visible = 'Off';
handles.txtSelIma.Visible = 'Off';
handles.txtIdeIma.Visible = 'Off';
handles.lblIdeal.Visible = 'Off';
handles.bIdeIma.Visible = 'Off';
handles.bSelIma.Visible = 'Off';
handles.preFil.Value = 1;
handles.posTH.Value = 1;

%handles for the modified Hough
handles.eTheta.Visible = 'Off';
handles.lblTH.String = 'Threshold';
handles.tH1.Visible = 'Off';
handles.popH1.Visible = 'Off';
handles.tH2.Visible = 'Off';
handles.popH2.Visible = 'Off';


% --- Executes on button press in bHar.
function bHar_Callback(hObject, eventdata, handles)
% hObject    handle to bHar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bHar
%show and hide controls
handles.p1stEdge.Visible = 'Off';
handles.p2ndEdge.Visible = 'Off';

handles.p3rdEdge.Visible = 'On';
handles.lblConn.Visible = 'Off';
handles.popConn.Visible = 'Off';
handles.lblTH.Visible = 'On';
handles.popTH.Visible = 'On';
handles.lblAlph.Visible = 'On';
handles.popAlph.Visible = 'On';
handles.lblMax.Visible = 'On';
handles.popMax.Visible = 'On';
handles.lblStd.Visible = 'On';
handles.popStd.Visible = 'On';
handles.lblSca.Visible = 'Off';
handles.popsca.Visible = 'Off';
handles.lblRes.Visible = 'Off';
handles.txtRres.Visible = 'Off';
handles.txtGres.Visible = 'Off';
handles.txtBres.Visible = 'Off';
handles.txtSelIma.Visible = 'Off';
handles.txtIdeIma.Visible = 'Off';
handles.lblIdeal.Visible = 'Off';
handles.bIdeIma.Visible = 'Off';
handles.bSelIma.Visible = 'Off';

%handles for the modified Hough
handles.eTheta.Visible = 'Off';
handles.lblTH.String = 'Threshold';
handles.lblStd.String = 'Std. Deviation';
handles.popStd.String = [1 2 3 5 8 10 12 15 20];
handles.lblAlph.String = 'Alpha';
handles.popAlpha.String = [0.50 0.40 0.30 0.20 0.10 0.08 0.05 0.04 0.03 0.02 0.01];
handles.lblMax.String = 'Max';
handles.popMax.String = [1.0 2.0];
handles.tH1.Visible = 'Off';
handles.popH1.Visible = 'Off';
handles.tH2.Visible = 'Off';
handles.popH2.Visible = 'Off';


% --- Executes on button press in bPra.
function bPra_Callback(hObject, eventdata, handles)
% hObject    handle to bPra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bPra
%show and hide controls
handles.p1stEdge.Visible = 'Off';
handles.p2ndEdge.Visible = 'Off';

handles.p3rdEdge.Visible = 'On';
handles.lblConn.String = 'Edge Detection Image';
handles.lblConn.Visible = 'On';
handles.popConn.Visible = 'Off';
handles.lblTH.Visible = 'Off';
handles.popTH.Visible = 'Off';
handles.lblAlph.Visible = 'Off';
handles.popAlph.Visible = 'Off';
handles.lblMax.Visible = 'Off';
handles.popMax.Visible = 'Off';
handles.lblStd.Visible = 'Off';
handles.popStd.Visible = 'Off';
handles.lblSca.Visible = 'On';
handles.popsca.Visible = 'On';
handles.lblRes.Visible = 'On';
handles.txtRres.String = '';
handles.txtGres.String = '';
handles.txtBres.String = '';
handles.txtRres.Visible = 'On';
handles.txtGres.Visible = 'Off';
handles.txtBres.Visible = 'Off';
handles.txtSelIma.String = 'Select Edge Detection Image...';
handles.txtIdeIma.String = 'Select Ideal Edge Image..';
handles.txtSelIma.Visible = 'On';
handles.txtIdeIma.Visible = 'On';
handles.lblIdeal.Visible = 'On';
handles.bIdeIma.Visible = 'On';
handles.bSelIma.Visible = 'On';
handles.preFil.Value = 1;
handles.posTH.Value = 1;

%handles for the modified Hough
handles.eTheta.Visible = 'Off';
handles.tH1.Visible = 'Off';
handles.popH1.Visible = 'Off';
handles.tH2.Visible = 'Off';
handles.popH2.Visible = 'Off';
handles.lblSca.String = 'Scale Factor';
handles.popsca.String = {'1/9';'1/8';'1/7';'1/6';'1/5';'1/4';'1/3';'1/2';'1'};
handles.popsca.Position = [22.8 0.30769 10 1.538];


% --- Executes on button press in bHou.
function bHou_Callback(hObject, eventdata, handles)
% hObject    handle to bHou (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bHou
%show and hide controls
handles.p1stEdge.Visible = 'Off';
handles.p2ndEdge.Visible = 'Off';

handles.p3rdEdge.Visible = 'On';
handles.lblConn.Visible = 'Off';
handles.popConn.Visible = 'Off';
handles.lblTH.Visible = 'On';
handles.popTH.Visible = 'Off';
handles.lblAlph.Visible = 'On';
handles.popAlph.Visible = 'On';
handles.lblMax.Visible = 'On';
handles.popMax.Visible = 'On';
handles.lblStd.Visible = 'On';
handles.popStd.Visible = 'On';
handles.lblSca.Visible = 'On';
handles.popsca.Visible = 'On';
handles.lblRes.Visible = 'Off';
handles.txtRres.Visible = 'Off';
handles.txtGres.Visible = 'Off';
handles.txtBres.Visible = 'Off';
handles.txtSelIma.Visible = 'Off';
handles.txtIdeIma.Visible = 'Off';
handles.lblIdeal.Visible = 'Off';
handles.bIdeIma.Visible = 'Off';
handles.bSelIma.Visible = 'Off';
handles.preFil.Value = 1;
handles.posTH.Value = 1;

%handles for the modified Hough
handles.eTheta.Visible = 'On';
handles.eTheta.String = '0-45';
handles.lblTH.String = 'Line Angles';
handles.lblStd.String = 'Delta Length (Rho)';
handles.popStd.String = {'1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'; '10'};
handles.popStd.Value = 1;
handles.lblAlph.String = 'Line Pixels (min)';
handles.popAlph.String = {'10'; '20'; '50'; '100'};
handles.popAlph.Value = 2;
handles.lblMax.String = 'Segment Pixels (min)';
handles.popMax.String = {'1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'; '10'};
handles.popMax.Value = 10;
handles.tH1.Visible = 'On';
handles.tH1.String = 'Max Connnect';
handles.popH1.Visible = 'On';
handles.popH1.String = {'1'; '2'; '5'; '10'; '15'; '20'};
handles.popH1.Value = 2;
handles.tH2.Visible = 'On';
handles.tH2.String = 'Delta Theta';
handles.popH2.Visible = 'On';
handles.popH2.String = {'1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'};
handles.lblSca.String = 'Displayed Image';
handles.popsca.String = {'Hough Image'; 'Inverse Hough'; 'After ANDing'; 'After Connection'; 'Final Result (after extinction)'};


% --- Executes on button press in bMar.
function bMar_Callback(hObject, eventdata, handles)
% hObject    handle to bMar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bMar
%show and hide controls
handles.p1stEdge.Visible = 'Off';
handles.p3rdEdge.Visible = 'Off';

handles.p2ndEdge.Visible = 'On';
handles.lblSig.String = 'Sigma';
handles.lblSig.Visible = 'On';
handles.popSig.String = ['1.0'; '1.2'; '1.5'; '1.8'; '2.0'; ...
    '2.2'; '2.5'; '2.8'; '3.0'; '3.2'; '3.5'; '3.8'; '4.0'; '4.2'; '4.5'; '4.8'; '5.0'];
handles.popSig.Value = 5;
handles.popSig.Visible = 'On';
handles.lblDel.String = 'Delta';
handles.lblDel.Visible = 'On';
handles.popDel.Visible = 'On';
handles.popLow.Visible = 'Off';
handles.popHigh.Visible = 'Off';
handles.lblHigh.Visible = 'Off';
handles.cThin.Visible = 'Off';
handles.cHys.Visible = 'Off';
handles.popSmo.Visible = 'Off';
handles.cShow.Visible = 'Off';
handles.lblPre.Visible = 'Off';
handles.popPre.Visible = 'Off';
handles.lblPos.Visible = 'Off';
handles.popPos.Visible = 'Off';
handles.lblPro.Visible = 'Off';
handles.popPro.Visible = 'Off';
handles.cKeep.Visible = 'Off';
handles.preFil.Value = 1;
handles.posTH.Value = 1;


% --- Executes on button press in bCan.
function bCan_Callback(hObject, eventdata, handles)
% hObject    handle to bCan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bCan
%show and hide controls
handles.p1stEdge.Visible = 'Off';
handles.p3rdEdge.Visible = 'Off';

handles.p2ndEdge.Visible = 'On';
handles.lblSig.String = 'Variance';
handles.lblSig.Visible = 'On';
handles.popSig.String = ['0.5'; '0.6'; '0.8'; '1.0'; '1.2'; '1.5'; '1.8'; '2.0'; ...
    '2.2'; '2.5'; '2.8'; '3.0'; '3.2'; '3.5'; '3.8'; '4.0'; '4.2'; '4.5'; '4.8'; '5.0'];
handles.popSig.Value = 1;
handles.popSig.Visible = 'On';
handles.lblDel.String = 'Low Threshold Factor';
handles.lblDel.Visible = 'On';
handles.popDel.Visible = 'Off';
handles.popLow.String = {'1.0'; '2.0'; '3.0'; '4.0'; '5.0'; '6.0'; ...
        '7.0'; '8.0'; '9.0'; '10.0'};
handles.popLow.Visible = 'On';
handles.popHigh.Visible = 'On';
handles.lblHigh.String = 'High Threshold Factor';
handles.lblHigh.Visible = 'On';
handles.cThin.Visible = 'Off';
handles.cHys.Visible = 'Off';
handles.popSmo.Visible = 'Off';
handles.cShow.Visible = 'On';
handles.lblPre.Visible = 'Off';
handles.popPre.Visible = 'Off';
handles.lblPos.Visible = 'Off';
handles.popPos.Visible = 'Off';
handles.lblPro.Visible = 'Off';
handles.popPro.Visible = 'Off';
handles.cKeep.Visible = 'Off';
handles.preFil.Value = 1;
handles.posTH.Value = 1;

% --- Executes on selection change in popSig.
function popSig_Callback(hObject, eventdata, handles)
% hObject    handle to popSig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popSig contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSig


% --- Executes during object creation, after setting all properties.
function popSig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popSig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popDel.
function popDel_Callback(hObject, eventdata, handles)
% hObject    handle to popDel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popDel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popDel


% --- Executes during object creation, after setting all properties.
function popDel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popDel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popLow.
function popLow_Callback(hObject, eventdata, handles)
% hObject    handle to popLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popLow contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popLow


% --- Executes during object creation, after setting all properties.
function popLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popHigh.
function popHigh_Callback(hObject, eventdata, handles)
% hObject    handle to popHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popHigh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popHigh


% --- Executes during object creation, after setting all properties.
function popHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bCoi.
function bCoi_Callback(hObject, eventdata, handles)
% hObject    handle to bCoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bCoi
%show and hide controls
handles.p1stEdge.Visible = 'Off';
handles.p3rdEdge.Visible = 'Off';

handles.p2ndEdge.Visible = 'On';
handles.lblSig.String = 'Variance';
handles.lblSig.Visible = 'On';
handles.popSig.String = ['0.5'; '0.6'; '0.8'; '1.0'; '1.2'; '1.5'; '1.8'; '2.0'; ...
    '2.2'; '2.5'; '2.8'; '3.0'; '3.2'; '3.5'; '3.8'; '4.0'; '4.2'; '4.5'; '4.8'; '5.0'];
handles.popSig.Value = 4;
handles.popSig.Visible = 'On';
handles.lblDel.String = 'Low Threshold Factor';
handles.lblDel.Visible = 'On';
handles.popDel.Visible = 'Off';
handles.popLow.Visible = 'On';
handles.popHigh.Visible = 'On';
handles.lblHigh.Visible = 'On';
handles.cThin.Visible = 'On';
handles.cHys.Visible = 'On';
handles.popSmo.Visible = 'Off';
handles.cShow.Visible = 'On';
handles.lblPre.Visible = 'Off';
handles.popPre.Visible = 'Off';
handles.lblPos.Visible = 'Off';
handles.popPos.Visible = 'Off';
handles.lblPro.Visible = 'Off';
handles.popPro.Visible = 'Off';
handles.cKeep.Visible = 'Off';
handles.preFil.Value = 1;
handles.posTH.Value = 1;
cHys_Callback(handles.cHys, eventdata, handles);

% --- Executes on button press in bShe.
function bShe_Callback(hObject, eventdata, handles)
% hObject    handle to bShe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bShe
%show and hide controls
handles.p1stEdge.Visible = 'Off';
handles.p3rdEdge.Visible = 'Off';

handles.p2ndEdge.Visible = 'On';
handles.lblSig.String = 'Smoothing Factor';
handles.lblSig.Visible = 'On';
handles.popSig.Visible = 'Off';
handles.lblDel.String = 'Low Threshold Factor';
handles.lblDel.Visible = 'On';
handles.popDel.Visible = 'Off';
handles.popLow.String = {'1.0'; '2.0'; '3.0'; '4.0'; '5.0'; '6.0'; ...
        '7.0'; '8.0'; '9.0'; '10.0'};
handles.popLow.Visible = 'On';
handles.popHigh.Visible = 'On';
handles.lblHigh.String = 'High Threshold Factor';
handles.lblHigh.Visible = 'On';
handles.cThin.Visible = 'Off';
handles.cHys.Visible = 'Off';
handles.popSmo.Visible = 'On';
handles.cShow.Visible = 'On';
handles.lblPre.Visible = 'Off';
handles.popPre.Visible = 'Off';
handles.lblPos.Visible = 'Off';
handles.popPos.Visible = 'Off';
handles.lblPro.Visible = 'Off';
handles.popPro.Visible = 'Off';
handles.cKeep.Visible = 'Off';
handles.preFil.Value = 1;
handles.posTH.Value = 1;

% --- Executes on button press in bFrei.
function bFrei_Callback(hObject, eventdata, handles)
% hObject    handle to bFrei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bFrei
%show and hide controls
handles.p1stEdge.Visible = 'Off';
handles.p3rdEdge.Visible = 'Off';

handles.p2ndEdge.Visible = 'On';
handles.lblSig.Visible = 'Off';
handles.popSig.Visible = 'Off';
handles.lblDel.Visible = 'Off';
handles.popDel.Visible = 'Off';
handles.popLow.Visible = 'Off';
handles.popHigh.Visible = 'Off';
handles.lblHigh.Visible = 'Off';
handles.cThin.Visible = 'Off';
handles.cHys.Visible = 'Off';
handles.popSmo.Visible = 'Off';
handles.cShow.Visible = 'Off';
handles.lblPre.Visible = 'On';
handles.popPre.Visible = 'On';
handles.lblPos.Visible = 'On';
handles.popPos.Visible = 'On';
handles.lblPro.Visible = 'On';
handles.popPro.Visible = 'On';
handles.cKeep.Visible = 'On';
handles.preFil.Value = 1;
handles.posTH.Value = 1;

% --- Executes on button press in cHys.
function cHys_Callback(hObject, eventdata, handles)
% hObject    handle to cHys (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cHys
if hObject.Value == 0        %apply ordinary TH
    handles.popLow.String = {'1.0'; '2.0'; '3.0'; '4.0'; '5.0'; '6.0'; ...
        '7.0'; '8.0'; '9.0'; '10.0'};
    handles.lblDel.Visible = 'off';
    handles.popLow.Visible = 'off';
    handles.lblHigh.String = 'Threshold Factor';
else
    handles.popLow.String = {'0.1'; '0.2'; '0.3'; '0.4'; '0.5'; '0.6'; ...
        '0.7'; '0.8'; '0.9'; '1.0'};
    handles.lblDel.Visible = 'on';
    handles.popLow.Visible = 'on';
    handles.lblHigh.String = 'High Threshold Factor';
end

% --- Executes on button press in cThin.
function cThin_Callback(hObject, eventdata, handles)
% hObject    handle to cThin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cThin


% --- Executes on selection change in popSmo.
function popSmo_Callback(hObject, eventdata, handles)
% hObject    handle to popSmo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popSmo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSmo


% --- Executes during object creation, after setting all properties.
function popSmo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popSmo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popPre.
function popPre_Callback(hObject, eventdata, handles)
% hObject    handle to popPre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popPre contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popPre


% --- Executes during object creation, after setting all properties.
function popPre_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popPre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popPos.
function popPos_Callback(hObject, eventdata, handles)
% hObject    handle to popPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popPos contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popPos


% --- Executes during object creation, after setting all properties.
function popPos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popPro.
function popPro_Callback(hObject, eventdata, handles)
% hObject    handle to popPro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popPro contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popPro


% --- Executes during object creation, after setting all properties.
function popPro_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popPro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cKeep.
function cKeep_Callback(hObject, eventdata, handles)
% hObject    handle to cKeep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cKeep


% --- Executes on button press in cShow.
function cShow_Callback(hObject, eventdata, handles)
% hObject    handle to cShow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cShow


% --- Executes on button press in bShow.
function bShow_Callback(hObject, eventdata, handles)
% hObject    handle to bShow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
%display image with filter masks
figure, h = gcf;
if handles.bRob.Value
    cpath = mfilename( 'fullpath' );
    imshow([cpath(1:end-9) 'Resources\EquRob.png']);
    h.Name = 'Analysis: Edge/Line Detection - Roberts';
elseif handles.bLap.Value
    cpath = mfilename( 'fullpath' );
    imshow([cpath(1:end-9) 'Resources\EquLap.png']);
    h.Name = 'Analysis: Edge/Line Detection - Laplacian';
end
axis('off');
h.Resize = 'Off';
h.MenuBar = 'none';
h.DockControls = 'Off';
h.WindowStyle = 'modal';

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
CVIPToolbox('fSave_Callback',hObject,eventdata,guidata(hObject))


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
CVIPToolbox('fSave_Callback',hObject,eventdata,guidata(hObject))

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


function txtGres_Callback(hObject, eventdata, handles)
% hObject    handle to txtGres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtGres as text
%        str2double(get(hObject,'String')) returns contents of txtGres as a double


% --- Executes during object creation, after setting all properties.
function txtGres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtGres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtRres_Callback(hObject, eventdata, handles)
% hObject    handle to txtRres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtRres as text
%        str2double(get(hObject,'String')) returns contents of txtRres as a double


% --- Executes during object creation, after setting all properties.
function txtRres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtRres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtBres_Callback(hObject, eventdata, handles)
% hObject    handle to txtBres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBres as text
%        str2double(get(hObject,'String')) returns contents of txtBres as a double


% --- Executes during object creation, after setting all properties.
function txtBres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on posTH and none of its controls.
function posTH_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to posTH (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on THlvl and none of its controls.
function THlvl_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to THlvl (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data


% --- Executes on key press with focus on popSmo and none of its controls.
function popSmo_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popSmo (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on popLow and none of its controls.
function popLow_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popLow (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on popHigh and none of its controls.
function popHigh_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popHigh (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data


% --- Executes on key press with focus on popPos and none of its controls.
function popPos_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popPos (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on popSig and none of its controls.
function popSig_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popSig (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on popTH and none of its controls.
function popTH_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popTH (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on popAlph and none of its controls.
function popAlph_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popAlph (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on popConn and none of its controls.
function popConn_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popConn (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on popMax and none of its controls.
function popMax_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popMax (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on popsca and none of its controls.
function popsca_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popsca (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data



function eTheta_Callback(hObject, eventdata, handles)
% hObject    handle to eTheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eTheta as text
%        str2double(get(hObject,'String')) returns contents of eTheta as a double


% --- Executes during object creation, after setting all properties.
function eTheta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eTheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popH1.
function popH1_Callback(hObject, eventdata, handles)
% hObject    handle to popH1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popH1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popH1


% --- Executes during object creation, after setting all properties.
function popH1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popH1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popH2.
function popH2_Callback(hObject, eventdata, handles)
% hObject    handle to popH2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popH2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popH2


% --- Executes during object creation, after setting all properties.
function popH2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popH2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
