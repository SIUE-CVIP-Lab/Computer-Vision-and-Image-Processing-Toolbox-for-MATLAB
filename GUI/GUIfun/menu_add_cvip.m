function vargout = menu_add_cvip(hObject)
%MENU_ADD_CVIP Creates the menus required for figures of the CVIP toolbox GUI. 
% The function takes the Object handle (hObject) and creates the menus
% View, Analysis, Enhance, Restoration, Compresion, Utilities, Help and the
% CVIP Website link to any MATLAB figure that calls the function on its the
% create function
%
% Syntax :
% -------
% menu_add_cvip(hObject)
%   
% Input Parameters include :
% ------------------------
%         hObject   handle of the current figure.
%
%
% Output Parameter include :  
% ------------------------
%         Menu objects according t the exposed in the function description.
%                                         
%
% Example :
% -------
%               %Here we use the callback OpeningFcn of the mUStats MATLAB
%               % figure to call the function and creates the menus
%
%               % --- Executes just before mUStats is made visible.
%               % function mUStats_OpeningFcn(hObject, eventdata, handles, varargin)
%               % This function has no output args, see OutputFcn.
%               % hObject    handle to figure
%               % eventdata  reserved - to be defined in a future version of MATLAB
%               % handles    structure with handles and user data (see GUIDATA)
%               % varargin   command line arguments to mUStats (see VARARGIN)
%
%               % Choose default command line output for mUStats
%               handles.output = hObject;
%
%               % Update handles structure
%               guidata(hObject, handles);
%
%               %UIWAIT makes mUStats wait for user response (see UIRESUME)
%               % uiwait(handles.Stats);
%               % call function to create menus in current figure
%               menu_add_cvip(hObject);
%
% Reference
% ---------
%  1.Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications 
%  with MATLAB and CVIPtools, 3rd Edition. 

%==========================================================================
%
%           Author:                 Julian Rene Cuellar Buritica
%           Initial coding date:    06/18/2019
%           Latest update date:     06/19/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIPtools Matlab GUI, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.1  06/19/2019  09:52:02  jucuell
 % Function coding and initial testing, help information addition.
%
clc
%create View menu linked to menu functions in CVIPToolbox figure
ViewMenu = uimenu('Parent',hObject,'Label','&View');  
uimenu('Parent',ViewMenu,'Label','&CVIP Function Information','Tag','mVfi',...
    'Callback',@(hObject,eventdata)CVIPToolbox('mVfi_Callback',hObject,...
    eventdata,guidata(hObject)));
Viewch1=uimenu('Parent',ViewMenu,'Label','CVIP &Image History'); 
uimenu('Parent',Viewch1,'Label','&View Image History','Callback',...
    @(hObject,eventdata)CVIPToolbox('mVvimaHis_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',Viewch1,'Label','&Start Saving Image History','Tag',...
    'mVsaveHis','Callback',@(hObject,eventdata)CVIPToolbox ...
    ('mVsaveHis_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',ViewMenu,'Label','Show &Histogram','Separator','On','Callback',...
    @(hObject,eventdata)CVIPToolbox('mVhisto_Callback',hObject,eventdata,guidata(hObject)));
Viewch2=uimenu('Parent',ViewMenu,'Label','Show &Spectrum'); 
uimenu('Parent',Viewch2,'Label','FFT &Phase','Callback',...
    @(hObject,eventdata)CVIPToolbox('mVsfftp_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',Viewch2,'Label','FFT &Magnitude','Callback',...
    @(hObject,eventdata)CVIPToolbox('mVsfftm_Callback',hObject,eventdata,guidata(hObject)));
Viewch21=uimenu('Parent',Viewch2,'Label','&Log-remapped');
uimenu('Parent',Viewch21,'Label','&All Bands','Callback',...
    @(hObject,eventdata)CVIPToolbox('mVsLall_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',Viewch21,'Label','&Red Band','Callback',...
    @(hObject,eventdata)CVIPToolbox('mVsLred_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',Viewch21,'Label','&Green Band','Callback',...
    @(hObject,eventdata)CVIPToolbox('mVsLgre_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',Viewch21,'Label','&Blue Band','Callback',...
    @(hObject,eventdata)CVIPToolbox('mVsLblu_Callback',hObject,eventdata,guidata(hObject)));
Viewch3=uimenu('Parent',ViewMenu,'Label','&View Band'); 
uimenu('Parent',Viewch3,'Label','&Red','Callback',...
    @(hObject,eventdata)CVIPToolbox('mVBred_Callback',hObject,...
    eventdata,guidata(hObject)));
uimenu('Parent',Viewch3,'Label','&Green','Callback',...
    @(hObject,eventdata)CVIPToolbox('mVBgre_Callback',hObject,...
    eventdata,guidata(hObject)));
uimenu('Parent',Viewch3,'Label','&Blue','Callback',...
    @(hObject,eventdata)CVIPToolbox('mVBlue_Callback',hObject,...
    eventdata,guidata(hObject)));

%create Analysis menu linked to menu functions in CVIPToolbox figure
AnaMenu = uimenu('Parent',hObject,'Label','&Analysis');  
uimenu('Parent',AnaMenu,'Label','&Geometry','Callback',@(hObject,...
    eventdata)CVIPToolbox('mGeo_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',AnaMenu,'Label','&Edge/Line Detection','Callback',@(hObject,...
    eventdata)CVIPToolbox('mEdge_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',AnaMenu,'Label','&Segmentation','Callback',@(hObject,...
    eventdata)CVIPToolbox('mSeg_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',AnaMenu,'Label','&Transforms','Callback',@(hObject,...
    eventdata)CVIPToolbox('mTrans_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',AnaMenu,'Label','&Features','Callback',@(hObject,...
    eventdata)CVIPToolbox('mFeat_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',AnaMenu,'Label','&Pattern Classification','Callback',@(hObject,...
    eventdata)CVIPToolbox('mPatt_Callback',hObject,eventdata,guidata(hObject)));

%create Enhance menu linked to menu functions in CVIPToolbox figure
EnhMenu = uimenu('Parent',hObject,'Label','&Enhancement');  
uimenu('Parent',EnhMenu,'Label','&Histogram/Contrast','Callback',@(hObject,...
    eventdata)CVIPToolbox('mEhisto_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',EnhMenu,'Label','&Pseudocolor','Callback',@(hObject,...
    eventdata)CVIPToolbox('mEpseu_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',EnhMenu,'Label','&Sharpening','Callback',@(hObject,...
    eventdata)CVIPToolbox('mESharp_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',EnhMenu,'Label','S&moothing','Callback',@(hObject,...
    eventdata)CVIPToolbox('mESmo_Callback',hObject,eventdata,guidata(hObject)));

%create Restoration menu linked to menu functions in CVIPToolbox figure
ResMenu = uimenu('Parent',hObject,'Label','&Restoration');  
uimenu('Parent',ResMenu,'Label','&Noise','Callback',@(hObject,...
    eventdata)CVIPToolbox('mRNoi_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',ResMenu,'Label','&Spatial Filters','Callback',@(hObject,...
    eventdata)CVIPToolbox('mRSpaF_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',ResMenu,'Label','&Frequency Filters','Callback',@(hObject,...
    eventdata)CVIPToolbox('mRFreqF_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',ResMenu,'Label','&Geometric Transforms','Callback',@(hObject,...
    eventdata)CVIPToolbox('mRGeoT_Callback',hObject,eventdata,guidata(hObject)));

%create Compression menu linked to menu functions in CVIPToolbox figure
CompMenu = uimenu('Parent',hObject,'Label','&Compression');  
uimenu('Parent',CompMenu,'Label','&Preprocessing','Callback',@(hObject,...
    eventdata)CVIPToolbox('mCpre_Callback',hObject,eventdata,guidata(hObject)));
Loss = uimenu('Parent',CompMenu,'Label','&Lossless','Callback',@(hObject,...
    eventdata)CVIPToolbox('mCless_Callback',hObject,eventdata,guidata(hObject)));
Loss.Enable = 'Off';
uimenu('Parent',CompMenu,'Label','Lo&ssy','Callback',@(hObject,...
    eventdata)CVIPToolbox('mClossy_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',CompMenu,'Label','Pos&tprocessing','Callback',@(hObject,...
    eventdata)CVIPToolbox('mCpost_Callback',hObject,eventdata,guidata(hObject)));

%create Utilities menu linked to menu functions in CVIPToolbox figure
UtilMenu = uimenu('Parent',hObject,'Label','&Utilities');  %'Tag','mUshow',
SUtilmenu = uimenu('Parent',UtilMenu,'Label','&Show utilities','Tag','mUshos','Callback',@(hObject,...
    eventdata)CVIPToolbox('mUshow_Callback',hObject,eventdata,guidata(hObject)));
SUtilmenu.UserData = 0;

%create Help menu linked to menu functions in CVIPToolbox figure
HelpMenu = uimenu('Parent',hObject,'Label','&Help');  
uimenu('Parent',HelpMenu,'Label','&Contents','Callback',@(hObject,...
    eventdata)CVIPToolbox('mHcon_Callback',hObject,eventdata,guidata(hObject)));
uimenu('Parent',HelpMenu,'Label','&About CVIP MATLAB Toolbox...','Callback',@(hObject,...
    eventdata)CVIPToolbox('mHabout_Callback',hObject,eventdata,guidata(hObject)));

%create CVIP Web menu linked to menu functions in CVIPToolbox figure
HelpMenu = uimenu('Parent',hObject,'Label','CVIPtools &Website','Callback',@(hObject,...
    eventdata)CVIPToolbox('mCVIPweb_Callback',hObject,eventdata,guidata(hObject)));  
%setup Help menu color
HelpMenu.ForegroundColor = [0 0 1];
% 
% %menu order
% ViewMenu.Position=2;
% handles.mView.Visible = 'off';

%UITOOLBAR MENU
%create histogram icon linked to menu functions in CVIPToolbox figure
%get Resources path
cpath = mfilename( 'fullpath' );
cpath = [cpath(1:end-20) 'Resources'];
uiTool = findobj('tag', 'uitoolbar1');
[img,map] = imread([cpath '\Histogram.gif']);%read icon image
icon = ind2rgb(img,map);    %Convert image from indexed to truecolor
% Create a uipushtool in the toolbar
uiHisto = uipushtool(uiTool(1),'Tooltip','Show Histogram','Tag', ...
    'HHisto','ClickedCallback',@(hObject,eventdata)CVIPToolbox...
    ('mVhisto_Callback',hObject,eventdata,guidata(hObject)));
uiHisto.CData = icon;       %Set the button icon

%create extract R band linked to menu functions in CVIPToolbox figure
[img,map] = imread([cpath '\RedBand.gif']);%read icon image
icon = ind2rgb(img,map);    %Convert image from indexed to truecolor
% Create a uipushtool in the toolbar
uiRband = uipushtool(uiTool(1),'TooltipString','Show Red Band','Tag', ...
    'RRBand', 'ClickedCallback',@(hObject,eventdata)CVIPToolbox...
    ('mVBred_Callback',hObject,eventdata,guidata(hObject)));
uiRband.CData = icon;       %Set the button icon

%create extract G band linked to menu functions in CVIPToolbox figure
[img,map] = imread([cpath '\GreenBand.gif']);%read icon image
icon = ind2rgb(img,map);    %Convert image from indexed to truecolor
% Create a uipushtool in the toolbar
uiGband = uipushtool(uiTool(1),'Tooltip','Show Green Band','Tag', ...
    'GGBand', 'ClickedCallback',@(hObject,eventdata)CVIPToolbox...
    ('mVBgre_Callback',hObject,eventdata,guidata(hObject)));
uiGband.CData = icon;       %Set the button icon

%create extract B band linked to menu functions in CVIPToolbox figure
[img,map] = imread([cpath '\BlueBand.gif']);%read icon image
icon = ind2rgb(img,map);    %Convert image from indexed to truecolor
% Create a uipushtool in the toolbar
uiBband = uipushtool(uiTool(1),'Tooltip','Show Blue Band','Tag', ...
    'BBBand', 'ClickedCallback',@(hObject,eventdata)CVIPToolbox...
    ('mVBlue_Callback',hObject,eventdata,guidata(hObject)));
uiBband.CData = icon;       %Set the button icon

%crete a delete all images button
[img,map] = imread([cpath '\DeleteAll.gif']);%read icon image
icon = ind2rgb(img,map);    %Convert image from indexed to truecolor
%Create a uipushtool in the toolbar
uiDeleteAll = uipushtool(uiTool(1),'Tooltip','Delete All Images','Tag',...
    'DeleteAll','ClickedCallback',@(hObject,eventdata)CVIPToolbox...
    ('mDeleteAll_Callback',hObject,eventdata,guidata(hObject)));
uiDeleteAll.CData = icon;

%vargout for NewFig
vargout = [uiHisto uiRband uiGband uiBband];