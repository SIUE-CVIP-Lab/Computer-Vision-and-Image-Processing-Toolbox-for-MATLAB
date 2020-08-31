function varargout = DlgGrayLvl(varargin)
% SEGM MATLAB code for Segm.fig
%      SEGM, by itself, creates a new SEGM or raises the existing
%      singleton*.
%
%      H = SEGM returns the handle to a new SEGM or the handle to
%      the existing singleton*.
%
%      SEGM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGM.M with the given input arguments.
%
%      SEGM('Property','Value',...) creates a new SEGM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgGrayLvl_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgGrayLvl_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Segm

% Last Modified by GUIDE v2.5 04-Jun-2019 08:28:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgGrayLvl_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgGrayLvl_OutputFcn, ...
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
%           Initial coding date:    05/24/2019
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     01/25/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.5  05/24/2019  14:48:15  jucuell
 % including the icons to extract the histogram, R, G and B band from the
 % selected image.
%
 % Revision 1.4  01/25/2019  11:48:17  jucuell
 % adding of buttons to specify the direction of the mask for Morphological
 % filters
%
 % Revision 1.3  01/21/2019  11:07:53  jucuell
 % accesing images from Main figure, function calling update and testing, 
 % history visualization.
%
 % Revision 1.2  12/17/2018  10:14:51  jucuell
 % updating menu creation programmatically, callbacks to Main figure and
 % the use of the utilities menus in the Main figure.
%
 % Revision 1.1  01/25/2018  15:23:31  jucuell
 % Initial coding and testing.
 % 
%

% --- Executes just before Segm is made visible.
function DlgGrayLvl_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Segm (see VARARGIN)

% Choose default command line output for Segm
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';%hide Analysis menu
handles.mComp.Visible = 'Off';%hide Compression menu
handles.mView.Visible = 'Off';%hide View menu


% --- Outputs from this function are returned to the command line.
function varargout = DlgGrayLvl_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btCancel.
function btCancel_Callback(hObject, eventdata, handles)
% hObject    handle to btCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get the current position from the handles structure
% to pass to the modal dialog.
%pos_size = get(handles.Segm,'Position');
% Prepare to close application window
 delete(handles.Segm)

% --- Executes on selection change in GrayLvl.
function GrayLvl_Callback(hObject, eventdata, handles)
% hObject    handle to GrayLvl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function GrayLvl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GrayLvl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Segm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Segm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function Segm_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Segm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse motion over figure - except title and menu.
function Segm_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to Segm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when Segm is resized.
function Segm_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to Segm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bCancel.
function bCancel_Callback(hObject, eventdata, handles)
% hObject    handle to bCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.Segm);

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
clc                                 %clear screen

%changing pointer arrow to watch on cursor
figure_set = findall(groot,'Type','Figure');
set(figure_set,'pointer','watch');

hMain = findobj('Tag','Main');      %get the handle of Main figure
hSHisto = findobj('Tag','mVsaveHis');%get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = hMain.UserData;             %get image handle

%check for Image to process
if hNfig == 0 || isempty(hNfig) || ~isfield(hNfig.UserData,'cvipIma')
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Segmentation Error','modal'); 

elseif handles.bPCT.Value && size(hNfig.UserData.cvipIma,3) == 1
    errordlg(['This operation requires a Color Image. Please select '...
        'a Color Image and try again.'],'Segmentation Error','modal'); 
    
else
    
Ima = hNfig.UserData;               %get image information
InIma = Ima.cvipIma;                %read image data
file = get(hNfig,'Name');           %get image name
histo = [0 0];                      %history initialization
OutIma = 0;                         %output Image initialization

%perform image operations
if handles.bGray.Value==1           %Gray Level Quantization
    %get robers type
    graylevel = str2double(handles.gGray.String(handles.gGray.Value));
    if handles.gMeth.Value == 1   	%standard gray lvl quant
        OutIma = gray_quant_cvip(InIma, graylevel);%call function
        Name = [file,' > Gray Lvl Quant (',num2str(graylevel),')'];
        histo = [173 graylevel];    %update image history
    else
        OutIma = igs_cvip(InIma, graylevel);%call igs gray fn.
        Name = [file,' > IGS Gray Lvl Quant (',num2str(graylevel),')'];
        histo = [175 graylevel];    %update image history
    end

elseif handles.bAuto.Value==1       %Auto Single Threshold
    %get kernel size
    limit = str2double(handles.aLimit.String(handles.aLimit.Value));  
    OutIma = autothreshold_cvip(InIma, limit);%call Sobel function
    Name = [file,' > Auto Threshold (',num2str(limit),')'];
    histo = [171 limit];            %update image history
    
elseif handles.bOtsu.Value==1       %Otsu Threshold
    OutIma = otsu_cvip(InIma);     	%call Otsu function
    Name = [file,' > Otsu '];       %Image name
    histo = [177 0];                %update image history
    
elseif handles.bHist.Value==1       %Histogram Thresholding
    PCT = handles.ctPCT.Value;       %use PCT for color images
    OutIma = hist_thresh_cvip(InIma, PCT);%call Otsu function
    Name = [file,' > Hist. Threshold (' num2str(PCT) ')'];
    histo = [174 PCT];             	%update image history
    
elseif handles.bFuzzy.Value==1      %Fuzzy C Mean Threshold
    %get kernel size
    N = str2double(handles.fGauss.String(handles.fGauss.Value));
    OutIma = fuzzyc_cvip(InIma, N);	%call Otsu function
    Name = [file,' > Fuzzy C (',num2str(N),')'];
    histo = [172 N];                %update image history
    
elseif handles.bMedian.Value==1     %Median Cut Thresholding
    %get Number of desired clors
    numCol = str2double(handles.cMean.String(handles.cMean.Value));
    OutIma = median_cut_cvip(InIma, numCol);%call median cut function
    Name = [file,' > Median Cut (',num2str(numCol),')'];
    histo = [176 numCol];        	%update image history
    
elseif handles.bPCT.Value==1        %PCT/Median segmentation
    %get Number of desired clors
    numCol = str2double(handles.cMean.String(handles.cMean.Value));
    OutIma = pct_median_cvip(InIma, numCol);%call PCT/Median function
    Name = [file,' > PCT/Median (',num2str(numCol),')'];
    histo = [178 numCol];        	%update image history
    
elseif handles.bSCT.Value==1        %SCT/Center segmentation
    %get colors along each axes
    nColA = str2double(handles.SCTaCol.String(handles.SCTaCol.Value));
    nColB = str2double(handles.SCTbCol.String(handles.SCTbCol.Value));
    mOpt = handles.popMopt.Value;
    OutIma = sct_split_cvip(InIma, nColA, nColB, mOpt);%call SCT function
    Name = [file,' > SCT/Center (',num2str(nColA),',',num2str(nColB),...
        ',',num2str(mOpt),')'];
    histo = [179 nColA nColB mOpt];	%update image history
    
elseif handles.bMulti.Value         %Multi resolution segmentation
        msgbox('Function or Operation not yet implemented.', ...
            'Segmentation Info','help', 'modal');
        Name = '';
        histo = 0;
        OutIma = 0;
    
elseif handles.bSplit.Value==1    %Split and Merge
    %get entry level
    N = str2double(handles.Entry.String(handles.Entry.Value));
    %homogeneity test
    if handles.bVar.Value           %variance
        %get threshold
        Args = str2double(handles.Thre.String(handles.Thre.Value));
        OutIma = split_merge_cvip(InIma, N, 3, Args);%call Var Th function
        Name = ['(Variance,' num2str(N) ',3,' num2str(Args) ')'];
        histo = [180 N 3 Args];   	%update image history
        
    elseif handles.bLocM.Value == 1
        OutIma = split_merge_cvip(InIma, N, 1);%call Local mean vs global
        Name = ['(Loc. Mean Vs Global,' num2str(N) ',1)'];
        histo = [180 N 1 0];        %update image history
        
    elseif handles.bLocS.Value == 1
        OutIma = split_merge_cvip(InIma, N, 2);%Local std vs global mean
        Name = ['(Loc. Std. Vs Global,' num2str(N) ',2)'];
        histo = [180 N 2 0];        %update image history
        
    else                            %operation not yet implemented
        msgbox('Function or Operation not yet implemented.', ...
            'Segmentation Info','help', 'modal');
        Name = '';
        histo = 0;
        OutIma = 0;
    end
    Name = [file,' > Split and Merge ',Name];

elseif handles.bWater.Value==1      %Sobel edge detector
    msgbox('Function or Operation not yet implemented.', ...
            'Segmentation Info','help', 'modal');
        histo = 0;
        OutIma = 0;

elseif handles.bGrad.Value==1       %vector flow snake
    msgbox('Function or Operation not yet implemented.', ...
            'Segmentation Info','help', 'modal');
        histo = 0;
        OutIma = 0;
    
elseif handles.bDil.Value==1        %Morpho filter dilate
    ktype = handles.popStru.Value;
    kSize = str2double(handles.popSize.String(handles.popSize.Value));
    Val1 = str2double(handles.popVal1.String(handles.popVal1.Value));
    Val2 = str2double(handles.popVal2.String(handles.popVal2.Value));
    a = 0;  %control vble for SE parameters
    if ktype == 1                   %circle SE
        OutIma = morphdilate_cvip(InIma, 1);%call Dilate function
        Name = strcat(file,' > Morpho Dil. Circle(',num2str(kSize),')');
    elseif ktype == 2               %square SE
        Val1 = str2double(handles.popVal1.String(handles.popVal1.Value));
        if Val1 > kSize
            a=errordlg(['Invalid Input Parameters: Check structuring ' ...
                'Element.'], 'Segmentation Error', 'modal');
        else
            OutIma = morphdilate_cvip(InIma, 2, kSize, Val1);%call Dilate
            Name = strcat(file,' > Morpho Dil. Square(',num2str(kSize),')');
        end
    elseif ktype == 3               %rectangular SE
        if Val1 > kSize || Val2 > kSize
            a=errordlg(['Invalid Input Parameters: Check structuring ' ...
                'Element.'], 'Segmentation Error', 'modal');
        else
            OutIma = morphdilate_cvip(InIma, 3, kSize, [Val1 Val2]);%Dilate
            Name = strcat(file,' > Morpho Dil. Rectangle(',num2str(kSize),')');
        end
    elseif ktype == 4               %cross SE
        if Val1 > kSize || Val2 > kSize
            a=errordlg(['Invalid Input Parameters: Check structuring ' ...
                'Element.'], 'Segmentation Error', 'modal');
        else
            OutIma = morphdilate_cvip(InIma, 4, kSize, [Val1 Val2]);%Dilate
            Name = strcat(file,' > Morpho Dil. Cross(',num2str(kSize),')');
        end
    else                          	%custom SE
        
    end
     if a == 0
        histo = [092 ktype kSize Val1 Val2];%update history
    end
elseif handles.bEro.Value==1        %Morpho filter erode
    ktype = handles.popStru.Value;
    kSize = str2double(handles.popSize.String(handles.popSize.Value));
    Val1 = str2double(handles.popVal1.String(handles.popVal1.Value));
    Val2 = str2double(handles.popVal2.String(handles.popVal2.Value));
    a = 0;                          %control vble for SE parameters
    if ktype == 1                   %circle SE
        OutIma = morpherode_cvip(InIma, 1);%call Dilate function
        Name = strcat(file,' > Morpho Ero. Circle(',num2str(kSize),')');
    elseif ktype == 2               %square SE
        if Val1 > kSize
            a=errordlg(['Invalid Input Parameters: Check structuring ' ...
                'Element.'], 'Segmentation Error', 'modal');
        else
            OutIma = morpherode_cvip(InIma, 2, kSize, Val1);%call Erode
            Name = strcat(file,' > Morpho Ero. Square(',num2str(kSize),')');
        end
    elseif ktype == 3               %rectangular SE
        if Val1 > kSize || Val2 > kSize
            a=errordlg(['Invalid Input Parameters: Check structuring ' ...
                'Element.'], 'Segmentation Error', 'modal');
        else
            OutIma = morpherode_cvip(InIma, 3, kSize, [Val1 Val2]);%Erode
            Name = strcat(file,' > Morpho Ero. Rectangle(',num2str(kSize),')');
        end
    elseif ktype == 4               %cross SE
        if Val1 > kSize || Val2 > kSize
            a=errordlg(['Invalid Input Parameters: Check structuring ' ...
                'Element.'], 'Segmentation Error', 'modal');
        else
            OutIma = morpherode_cvip(InIma, 4, kSize, [Val1 Val2]);%Erode
            Name = strcat(file,' > Morpho Ero. Cross(',num2str(kSize),')');
        end
    else                          	%custom SE
        
    end
    if a == 0
        histo = [093 ktype kSize Val1 Val2];%update history
    end
elseif handles.bOpe.Value==1        %Morpho filter opening
    ktype = handles.popStru.Value;
    kSize = str2double(handles.popSize.String(handles.popSize.Value));
    Val1 = str2double(handles.popVal1.String(handles.popVal1.Value));
    Val2 = str2double(handles.popVal2.String(handles.popVal2.Value));
    a = 0;                          %control vble for SE parameters
    if ktype == 1                   %circle SE
        OutIma = morphopen_cvip(InIma, 1);%call Open function
        Name = strcat(file,' > Morpho Open Circle(',num2str(kSize),')');
    elseif ktype == 2               %square SE
        if Val1 > kSize
            a=errordlg(['Invalid Input Parameters: Check structuring ' ...
                'Element.'], 'Segmentation Error', 'modal');
        else
            OutIma = morphopen_cvip(InIma, 2, kSize, kVal1);%call Open
            Name = strcat(file,' > Morpho Open Square(',num2str(kSize),')');
        end
    elseif ktype == 3               %rectangular SE
        if Val1 > kSize || Val2 > kSize
            a=errordlg(['Invalid Input Parameters: Check structuring ' ...
                'Element.'], 'Segmentation Error', 'modal');
        else    
            OutIma = morphopen_cvip(InIma, 3, kSize, [Val1 Val2]);%Open
            Name = strcat(file,' > Morpho Open Rectangle(',num2str(kSize),')');
        end
    elseif ktype == 4               %cross SE
        if Val1 > kSize || Val2 > kSize
            a=errordlg(['Invalid Input Parameters: Check structuring ' ...
                'Element.'], 'Segmentation Error', 'modal');
        else
            OutIma = morphopen_cvip(InIma, 4, kSize, [Val1 Val2]);%Open
            Name = strcat(file,' > Morpho Open Cross(',num2str(kSize),')');
        end
    else                        	%custom SE
        
    end
     if a == 0
        histo = [095 ktype kSize Val1 Val2];%update history
     end
    
elseif handles.bClos.Value==1       %Morpho filter close
    ktype = handles.popStru.Value;
    kSize = str2double(handles.popSize.String(handles.popSize.Value));
    Val1 = str2double(handles.popVal1.String(handles.popVal1.Value));
    Val2 = str2double(handles.popVal2.String(handles.popVal2.Value));
    a = 0;                          %control vble for SE parameters
    if ktype == 1                   %circle SE
        OutIma = morphclose_cvip(InIma, 1);%call Close function
        Name = strcat(file,' > Morpho Open Circle(',num2str(kSize),')');
    elseif ktype == 2               %square SE
        if Val1 > kSize
            a=errordlg(['Invalid Input Parameters: Check structuring ' ...
                'Element.'], 'Segmentation Error', 'modal');
        else
            OutIma = morphclose_cvip(InIma, 2, kSize, kVal1);%call Close
            Name = strcat(file,' > Morpho Open Square(',num2str(kSize),')');
        end
    elseif ktype == 3               %rectangular SE
        if Val1 > kSize || Val2 > kSize
            a=errordlg(['Invalid Input Parameters: Check structuring ' ...
                'Element.'], 'Segmentation Error', 'modal');
        else    
            OutIma = morphclose_cvip(InIma, 3, kSize, [Val1 Val2]);%Close
            Name = strcat(file,' > Morpho Open Rectangle(',num2str(kSize),')');
        end
    elseif ktype == 4               %cross SE
        if Val1 > kSize || Val2 > kSize
            a=errordlg(['Invalid Input Parameters: Check structuring ' ...
                'Element.'], 'Segmentation Error', 'modal');
        else
            OutIma = morphclose_cvip(InIma, 4, kSize, [Val1 Val2]);%Close
            Name = strcat(file,' > Morpho Open Cross(',num2str(kSize),')');
        end
    else                        	%custom SE
        
    end
     if a == 0
        histo = [091 ktype kSize Val1 Val2];%update history
     end
    
elseif handles.bIter.Value==1       %Morpho filter iterative mode   
    %Checking to make sure the input images are binary
    if size(unique(InIma(:)),1) ~= 2 
        f = uifigure;
        uialert(f,'Please use an image with only 2 unique values','Warning');
    end
    bool = handles.bBool.Value - 1;	%get bool function
    n = str2double(handles.bItera.String(handles.bItera.Value));%itera
    if bool == 0
        OutIma = zeros(size(InIma));%zero output image
        Sur1 = 0;                   %surrounds code
        Sur2 = 0;
    else
        Surr = [handles.c1.Value*handles.c1.UserData handles.c2.Value*handles.c2.UserData ...
            handles.c3.Value*handles.c3.UserData handles.c4.Value*handles.c4.UserData ...
            handles.c5.Value*handles.c5.UserData handles.c6.Value*handles.c6.UserData ...
            handles.c7.Value*handles.c7.UserData handles.c8.Value*handles.c8.UserData ...
            handles.c9.Value*handles.c9.UserData handles.c10.Value*handles.c10.UserData ...
            handles.c11.Value*handles.c11.UserData handles.c12.Value*handles.c12.UserData ...
            handles.c13.Value*handles.c13.UserData handles.c14.Value*handles.c14.UserData];
        Surr = nonzeros(Surr);      %get values > 0
        Surr = Surr';               %transpose vector
        %encode surrounds into 2 bytes
        Sur1 = '00000000';
        Sur2 = '00000000';
        for i=1:8
            Sur1(i) = num2str(eval(strcat('handles.c',num2str(i),'.Value'))); 
        end
        for i=9:14
            Sur2(i-8) = num2str(eval(strcat('handles.c',num2str(i),'.Value'))); 
        end
        Sur1 = bin2dec(Sur1);
        Sur2 = bin2dec(Sur2);
        %call Morpho Iter function
        OutIma = morphitermod_cvip(InIma, Surr, n, bool, handles.cRot.Value);
    end
    Name = [file ' > Morpho Itera (' num2str(Sur1) ',' num2str(Sur2) ',' ...
        num2str(n) ',' num2str(bool) ',' num2str(handles.cRot.Value) ')'];
    histo = [094 Sur1 Sur2 n bool handles.cRot.Value];%update history
    
elseif handles.bHit.Value==1        %Morpho filter hit or miss
    %Checking to make sure the input images are binary
    if size(unique(InIma(:)),1) ~= 2 
        f = uifigure;
        uialert(f,'Please use an image with only 2 unique values','Warning');
    end
    %call hit miss function
    OutIma = morph_hitmiss_cvip(InIma, str2double(handles.tabMorpho.Data));
    Name = [file,' > Morpho. Hit or Miss (',...
        handles.pMorphfSize.SelectedObject.String,')'];
    histo = [098 size(handles.tabMorpho.Data)];%update history
    
elseif handles.bThi.Value==1        %Morpho filter thinning
    %Checking to make sure the input images are binary
    if size(unique(InIma(:)),1) ~= 2 
        f = uifigure;
        uialert(f,'Please use an image with only 2 unique values','Warning');
    end
    %call thinning function
    OutIma = morph_thinning_cvip(InIma, str2double(handles.tabMorpho.Data));
    Name = [file,' > Morpho. Thinning (',...
        handles.pMorphfSize.SelectedObject.String,')'];
    histo = [096 size(handles.tabMorpho.Data)];%update history

elseif handles.bSke.Value==1        %Morpho filter Skelenotization
    %Checking to make sure the input images are binary
    if size(unique(InIma(:)),1) ~= 2 
        f = uifigure;
        uialert(f,'Please use an image with only 2 unique values','Warning');
    end
    filtSkel = str2double(handles.tabMorpho.Data);%get skeleton mask
    %get iter num
    Iter = str2double(handles.popSkeIter.String(handles.popSkeIter.Value));
    conn = handles.popSkeCon.Value - 1;%get type of connectivity
    met = handles.popSkeMet.Value - 1;%get method
    %call Skelenotization function
    OutIma = morph_skeleton_cvip(InIma, filtSkel, Iter, conn, met);
    Name = [file,' > Morpho. Skelenotization (',...
        handles.pMorphfSize.SelectedObject.String,')'];
    histo = [097 size(filtSkel,1) Iter conn met];%update history
        
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
        sInfo = sprintf(sInfo);
        [~,rr] = size(sInfo);
        hIlist.String(end+1,1:rr) = sInfo;
    end
    hIlist.Value = size(hIlist.String,1);       %goto last line
    figure(hMain);
end
end

if sum(OutIma(:)) ~= 0

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

 
% --- Executes on button press in bGray.
function bGray_Callback(hObject, eventdata, handles)
% hObject    handle to bGray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Show related objects Hide others
hide_all(handles);
set(handles.pGray,'Visible','On');
handles.bgDir.Visible = 'Off';
handles.tabMorpho.Visible = 'Off';
handles.txtTbl.Visible = 'Off';
set(handles.ctPCT,'Visible','Off');


% --- Executes on selection change in gGray.
function gGray_Callback(hObject, eventdata, handles)
% hObject    handle to gGray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function gGray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gGray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in gMeth.
function gMeth_Callback(hObject, eventdata, handles)
% hObject    handle to gMeth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function gMeth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gMeth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bAuto.
function bAuto_Callback(hObject, eventdata, handles)
% hObject    handle to bAuto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bAuto
%Show related objects Hide others
hide_all(handles);
set(handles.lblaLim,'Visible','On');
set(handles.aLimit,'Visible','On');
handles.bgDir.Visible = 'Off';
handles.tabMorpho.Visible = 'Off';
handles.txtTbl.Visible = 'Off';
set(handles.ctPCT,'Visible','Off');


% --- Executes on selection change in aLimit.
function aLimit_Callback(hObject, eventdata, handles)
% hObject    handle to aLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function aLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in fGauss.
function fGauss_Callback(hObject, eventdata, handles)
% hObject    handle to fGauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fGauss contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fGauss


% --- Executes during object creation, after setting all properties.
function fGauss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fGauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cMean.
function cMean_Callback(hObject, eventdata, handles)
% hObject    handle to cMean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cMean contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cMean


% --- Executes during object creation, after setting all properties.
function cMean_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cMean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SCTaCol.
function SCTaCol_Callback(hObject, eventdata, handles)
% hObject    handle to SCTaCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SCTaCol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SCTaCol


% --- Executes during object creation, after setting all properties.
function SCTaCol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SCTaCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in Entry.
function Entry_Callback(hObject, eventdata, handles)
% hObject    handle to Entry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Entry contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Entry


% --- Executes during object creation, after setting all properties.
function Entry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Entry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Perc.
function Perc_Callback(hObject, eventdata, handles)
% hObject    handle to Perc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Perc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Perc


% --- Executes during object creation, after setting all properties.
function Perc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Perc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in mLocM.
function mLocM_Callback(hObject, eventdata, handles)
% hObject    handle to mLocM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mLocM


% --- Executes on button press in mLocS.
function mLocS_Callback(hObject, eventdata, handles)
% hObject    handle to mLocS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mLocS


% --- Executes on button press in mWeigh.
function mWeigh_Callback(hObject, eventdata, handles)
% hObject    handle to mWeigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mWeigh


% --- Executes on button press in mPure.
function mPure_Callback(hObject, eventdata, handles)
% hObject    handle to mPure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mPure
hide_all(handles);
set(handles.pSpMe.lblEntry,'Visible','Off');
set(handles.pSpMe.Entry,'Visible','Off');
set(handles.pSpMe.lblThre,'Visible','Off');
set(handles.pSpMe.Thre,'Visible','Off');
set(handles.pSpMe.lblPerc,'Visible','Off');
set(handles.pSpMe.Perc,'Visible','Off');
set(handles.pSpMe.lblSim,'Visible','Off');
set(handles.pSpMe.Sim,'Visible','Off');
set(handles.pSpMe.lblPixel,'Visible','Off');
set(handles.pSpMe.Pixel,'Visible','Off');
handles.bgDir.Visible = 'Off';

% --- Executes on button press in mVaria.
function mVaria_Callback(hObject, eventdata, handles)
% hObject    handle to mVaria (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mVaria

% --- Executes on selection change in Thres.
function Thres_Callback(hObject, eventdata, handles)
% hObject    handle to Thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Thres contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Thres


% --- Executes during object creation, after setting all properties.
function Thres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PCT.
function PCT_Callback(hObject, eventdata, handles)
% hObject    handle to PCT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PCT


% --- Executes on selection change in Pixel.
function Pixel_Callback(hObject, eventdata, handles)
% hObject    handle to Pixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Pixel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Pixel


% --- Executes during object creation, after setting all properties.
function Pixel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Sim.
function Sim_Callback(hObject, eventdata, handles)
% hObject    handle to Sim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Sim contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Sim


% --- Executes during object creation, after setting all properties.
function Sim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bSplit.
function bSplit_Callback(hObject, eventdata, handles)
% hObject    handle to bSplit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bSplit
%Show related objects Hide others
hide_all(handles);
set(handles.bSpMe,'Visible','On');
set(handles.lblEntry,'Visible','On');
set(handles.Entry,'Visible','On');
handles.bgDir.Visible = 'Off';
handles.tabMorpho.Visible = 'Off';
handles.txtTbl.Visible = 'Off';


% --- Executes on selection change in Thre.
function Thre_Callback(hObject, eventdata, handles)
% hObject    handle to Thre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Thre contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Thre


% --- Executes during object creation, after setting all properties.
function Thre_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Thre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bPure.
function bPure_Callback(hObject, eventdata, handles)
% hObject    handle to bPure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bPure
set(handles.lblThre,'Visible','Off');
set(handles.Thre,'Visible','Off');
set(handles.lblPerc,'Visible','Off');
set(handles.Perc,'Visible','Off');
set(handles.lblSim,'Visible','Off');
set(handles.Sim,'Visible','Off');
set(handles.lblPixel,'Visible','Off');
set(handles.Pixel,'Visible','Off');
handles.bgDir.Visible = 'Off';


% --- Executes on button press in bVar.
function bVar_Callback(hObject, eventdata, handles)
% hObject    handle to bVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bVar
set(handles.lblThre,'Visible','On');
set(handles.Thre,'Visible','On');
set(handles.lblPerc,'Visible','Off');   %function not yet implemented
set(handles.Perc,'Visible','Off');
set(handles.lblSim,'Visible','Off');
set(handles.Sim,'Visible','Off');
set(handles.lblPixel,'Visible','Off');
set(handles.Pixel,'Visible','Off');


% --- Executes on button press in bTex.
function bTex_Callback(hObject, eventdata, handles)
% hObject    handle to bTex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bTex

set(handles.lblThre,'Visible','Off');
set(handles.Thre,'Visible','Off');
set(handles.lblPerc,'Visible','Off');
set(handles.Perc,'Visible','Off');
set(handles.lblSim,'Visible','On');
set(handles.Sim,'Visible','On');
set(handles.lblPixel,'Visible','On');
set(handles.Pixel,'Visible','On');


% --- Executes on button press in bLocM.
function bLocM_Callback(hObject, eventdata, handles)
% hObject    handle to bLocM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bLocM

set(handles.lblThre,'Visible','Off');
set(handles.Thre,'Visible','Off');
set(handles.lblPerc,'Visible','Off');
set(handles.Perc,'Visible','Off');
set(handles.lblSim,'Visible','Off');
set(handles.Sim,'Visible','Off');
set(handles.lblPixel,'Visible','Off');
set(handles.Pixel,'Visible','Off');


% --- Executes on button press in bLocS.
function bLocS_Callback(hObject, eventdata, handles)
% hObject    handle to bLocS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bLocS
set(handles.lblThre,'Visible','Off');
set(handles.Thre,'Visible','Off');
set(handles.lblPerc,'Visible','Off');
set(handles.Perc,'Visible','Off');
set(handles.lblSim,'Visible','Off');
set(handles.Sim,'Visible','Off');
set(handles.lblPixel,'Visible','Off');
set(handles.Pixel,'Visible','Off');


% --- Executes on button press in bWeig.
function bWeig_Callback(hObject, eventdata, handles)
% hObject    handle to bWeig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bWeig
set(handles.lblThre,'Visible','On');
set(handles.Thre,'Visible','On');
set(handles.lblPerc,'Visible','Off');
set(handles.Perc,'Visible','Off');
set(handles.lblSim,'Visible','Off');
set(handles.Sim,'Visible','Off');
set(handles.lblPixel,'Visible','Off');
set(handles.Pixel,'Visible','Off');


% --- Executes on button press in bOtsu.
function bOtsu_Callback(hObject, eventdata, handles)
% hObject    handle to bOtsu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bOtsu
%Show related objects Hide others
hide_all(handles);
handles.bgDir.Visible = 'Off';
handles.tabMorpho.Visible = 'Off';
handles.txtTbl.Visible = 'Off';
set(handles.ctPCT,'Visible','Off');


% --- Executes on button press in bHist.
function bHist_Callback(hObject, eventdata, handles)
% hObject    handle to bHist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bHist
%Show related objects Hide others
hide_all(handles);
set(handles.ctPCT,'Visible','On');
handles.bgDir.Visible = 'Off';
handles.tabMorpho.Visible = 'Off';
handles.txtTbl.Visible = 'Off';


% --- Executes on button press in bFuzzy.

function bFuzzy_Callback(hObject, eventdata, handles)
% hObject    handle to bFuzzy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bFuzzy
%Show related objects Hide others
hide_all(handles);
set(handles.lblGauss,'Visible','On');
set(handles.fGauss,'Visible','On');
handles.bgDir.Visible = 'Off';
handles.tabMorpho.Visible = 'Off';
handles.txtTbl.Visible = 'Off';
set(handles.ctPCT,'Visible','Off');

% --- Executes on button press in bMedian.
function bMedian_Callback(hObject, eventdata, handles)
% hObject    handle to bMedian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bMedian
%Show related objects Hide others
hide_all(handles);
set(handles.lblMedian,'Visible','On');
set(handles.cMean,'Visible','On');
handles.bgDir.Visible = 'Off';
handles.tabMorpho.Visible = 'Off';
handles.txtTbl.Visible = 'Off';
set(handles.ctPCT,'Visible','Off');

% --- Executes on button press in bPCT.
function bPCT_Callback(hObject, eventdata, handles)
% hObject    handle to bPCT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bPCT
%Show related objects Hide others
hide_all(handles);
set(handles.lblMedian,'Visible','On');
set(handles.cMean,'Visible','On');
handles.bgDir.Visible = 'Off';
handles.tabMorpho.Visible = 'Off';
handles.txtTbl.Visible = 'Off';
set(handles.ctPCT,'Visible','Off');

% --- Executes on button press in bSCT.
function bSCT_Callback(hObject, eventdata, handles)
% hObject    handle to bSCT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bSCT
%Show related objects Hide others
hide_all(handles);
set(handles.pSCT,'Visible','On');
handles.bgDir.Visible = 'Off';
handles.tabMorpho.Visible = 'Off';
handles.txtTbl.Visible = 'Off';
set(handles.ctPCT,'Visible','Off');

% --- Executes on button press in bMulti.
function bMulti_Callback(hObject, eventdata, handles)
% hObject    handle to bMulti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bMulti
%Show related objects Hide others
hide_all(handles);
set(handles.bSpMe,'Visible','On');
handles.bgDir.Visible = 'Off';
handles.tabMorpho.Visible = 'Off';
handles.txtTbl.Visible = 'Off';
set(handles.ctPCT,'Visible','Off');

% --- Executes on button press in bWater.
function bWater_Callback(hObject, eventdata, handles)
% hObject    handle to bWater (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bWater
%Show related objects Hide others
hide_all(handles);
handles.bgDir.Visible = 'Off';
handles.tabMorpho.Visible = 'Off';
handles.txtTbl.Visible = 'Off';
set(handles.ctPCT,'Visible','Off');

% --- Executes on button press in bGrad.
function bGrad_Callback(hObject, eventdata, handles)
% hObject    handle to bGrad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bGrad
%Show related objects Hide others
hide_all(handles);
handles.bgDir.Visible = 'Off';
handles.tabMorpho.Visible = 'Off';
handles.txtTbl.Visible = 'Off';
set(handles.ctPCT,'Visible','Off');

% --- Executes on button press in cRot.
function cRot_Callback(hObject, eventdata, handles)
% hObject    handle to cRot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cRot


% --- Executes on button press in bSur.
function bSur_Callback(hObject, eventdata, handles)
% hObject    handle to bSur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%show image with surrounds for iterative filter



% --- Executes on selection change in bItera.
function bItera_Callback(hObject, eventdata, handles)
% hObject    handle to bItera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns bItera contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bItera
pop_add_cvip(hObject, eventdata);   %call function to add user data 


% --- Executes during object creation, after setting all properties.
function bItera_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bItera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in bSub.
function bSub_Callback(hObject, eventdata, handles)
% hObject    handle to bSub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns bSub contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bSub


% --- Executes during object creation, after setting all properties.
function bSub_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bSub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in bBool.
function bBool_Callback(hObject, eventdata, handles)
% hObject    handle to bBool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns bBool contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bBool


% --- Executes during object creation, after setting all properties.
function bBool_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bBool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in c1.
function c1_Callback(hObject, eventdata, handles)
% hObject    handle to c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c1


% --- Executes on button press in c8.
function c8_Callback(hObject, eventdata, handles)
% hObject    handle to c8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c8


% --- Executes on button press in c2.
function c2_Callback(hObject, eventdata, handles)
% hObject    handle to c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c2


% --- Executes on button press in c9.
function c9_Callback(hObject, eventdata, handles)
% hObject    handle to c9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c9


% --- Executes on button press in c3.
function c3_Callback(hObject, eventdata, handles)
% hObject    handle to c3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c3


% --- Executes on button press in c10.
function c10_Callback(hObject, eventdata, handles)
% hObject    handle to c10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c10


% --- Executes on button press in c4.
function c4_Callback(hObject, eventdata, handles)
% hObject    handle to c4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c4


% --- Executes on button press in c11.
function c11_Callback(hObject, eventdata, handles)
% hObject    handle to c11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c11


% --- Executes on button press in c5.
function c5_Callback(hObject, eventdata, handles)
% hObject    handle to c5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c5


% --- Executes on button press in c12.
function c12_Callback(hObject, eventdata, handles)
% hObject    handle to c12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c12


% --- Executes on button press in c6.
function c6_Callback(hObject, eventdata, handles)
% hObject    handle to c6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c6


% --- Executes on button press in c13.
function c13_Callback(hObject, eventdata, handles)
% hObject    handle to c13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c13


% --- Executes on button press in c7.
function c7_Callback(hObject, eventdata, handles)
% hObject    handle to c7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c7


% --- Executes on button press in c14.
function c14_Callback(hObject, eventdata, handles)
% hObject    handle to c14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c14


% --- Executes on selection change in SCTbCol.
function SCTbCol_Callback(hObject, eventdata, handles)
% hObject    handle to SCTbCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SCTbCol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SCTbCol


% --- Executes during object creation, after setting all properties.
function SCTbCol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SCTbCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bDil.
function bDil_Callback(hObject, eventdata, handles)
% hObject    handle to bDil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bDil
%show or hide controls
handles.cRot.Visible = 'Off';
handles.bBool.Visible = 'Off';
handles.bItera.Visible = 'Off';
handles.bSub.Visible = 'Off';
handles.bView.Visible = 'Off';
handles.c1.Visible = 'Off';
handles.c2.Visible = 'Off';
handles.c3.Visible = 'Off';
handles.c4.Visible = 'Off';
handles.c5.Visible = 'Off';
handles.c6.Visible = 'Off';
handles.c7.Visible = 'Off';
handles.c8.Visible = 'Off';
handles.c9.Visible = 'Off';
handles.c10.Visible = 'Off';
handles.c11.Visible = 'Off';
handles.c12.Visible = 'Off';
handles.c13.Visible = 'Off';
handles.c14.Visible = 'Off';
handles.pGray.Visible = 'Off';
handles.pGauss.Visible = 'Off';
handles.fGauss.Visible = 'Off';
handles.lblaLim.Visible = 'Off';
handles.aLimit.Visible = 'Off';
handles.lblMedian.Visible = 'Off';
handles.cMean.Visible = 'Off';
handles.pSCT.Visible = 'Off';
handles.bSpMe.Visible = 'Off';
handles.lblStruc.String = ['Structuring Element:                      '...
    '   Size:                         Thickness:                      '...
    'Cross size:'];
handles.lblStruc.Visible = 'On';
handles.popStru.Value = 4;
handles.popStru.Visible = 'On';
handles.popSize.Visible = 'On';
handles.popVal1.Visible = 'On';
handles.popVal2.Visible = 'On';
handles.pMorphfSize.Visible = 'Off';
handles.tabMorpho.Visible = 'Off';
handles.txtTbl.Visible = 'Off';
handles.lblSkeInfo.Visible = 'Off';
handles.popSkeIter.Visible = 'Off';
handles.popSkeCon.Visible = 'Off';
handles.popSkeMet.Visible = 'Off';
handles.bgDir.Visible = 'Off';

% --- Executes on button press in cCPT.
function cCPT_Callback(hObject, eventdata, handles)
% hObject    handle to cCPT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cCPT



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


% --- Executes on button press in bClos.
function bClos_Callback(hObject, eventdata, handles)
% hObject    handle to bClos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bClos
%show or hide controls
handles.cRot.Visible = 'Off';
handles.bBool.Visible = 'Off';
handles.bItera.Visible = 'Off';
handles.bSub.Visible = 'Off';
handles.bView.Visible = 'Off';
handles.c1.Visible = 'Off';
handles.c2.Visible = 'Off';
handles.c3.Visible = 'Off';
handles.c4.Visible = 'Off';
handles.c5.Visible = 'Off';
handles.c6.Visible = 'Off';
handles.c7.Visible = 'Off';
handles.c8.Visible = 'Off';
handles.c9.Visible = 'Off';
handles.c10.Visible = 'Off';
handles.c11.Visible = 'Off';
handles.c12.Visible = 'Off';
handles.c13.Visible = 'Off';
handles.c14.Visible = 'Off';
handles.pGray.Visible = 'Off';
handles.pGauss.Visible = 'Off';
handles.fGauss.Visible = 'Off';
handles.lblaLim.Visible = 'Off';
handles.aLimit.Visible = 'Off';
handles.lblMedian.Visible = 'Off';
handles.cMean.Visible = 'Off';
handles.pSCT.Visible = 'Off';
handles.bSpMe.Visible = 'Off';
handles.lblStruc.String = ['Structuring Element:                      '...
    '   Size:                         Thickness:                      '...
    'Cross size:'];
handles.lblStruc.Visible = 'On';
handles.popStru.Value = 4;
handles.popStru.Visible = 'On';
handles.popSize.Visible = 'On';
handles.popVal1.Visible = 'On';
handles.popVal2.Visible = 'On';
handles.pMorphfSize.Visible = 'Off';
handles.tabMorpho.Visible = 'Off';
handles.txtTbl.Visible = 'Off';
handles.lblSkeInfo.Visible = 'Off';
handles.popSkeIter.Visible = 'Off';
handles.popSkeCon.Visible = 'Off';
handles.popSkeMet.Visible = 'Off';
handles.bgDir.Visible = 'Off';

% --- Executes on button press in bSke.
function bSke_Callback(hObject, eventdata, handles)
% hObject    handle to bSke (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bSke
%show or hide controls
handles.cRot.Visible = 'Off';
handles.bBool.Visible = 'Off';
handles.bItera.Visible = 'Off';
handles.bSub.Visible = 'Off';
handles.bView.Visible = 'Off';
handles.c1.Visible = 'Off';
handles.c2.Visible = 'Off';
handles.c3.Visible = 'Off';
handles.c4.Visible = 'Off';
handles.c5.Visible = 'Off';
handles.c6.Visible = 'Off';
handles.c7.Visible = 'Off';
handles.c8.Visible = 'Off';
handles.c9.Visible = 'Off';
handles.c10.Visible = 'Off';
handles.c11.Visible = 'Off';
handles.c12.Visible = 'Off';
handles.c13.Visible = 'Off';
handles.c14.Visible = 'Off';
handles.pGray.Visible = 'Off';
handles.pGauss.Visible = 'Off';
handles.fGauss.Visible = 'Off';
handles.lblaLim.Visible = 'Off';
handles.aLimit.Visible = 'Off';
handles.lblMedian.Visible = 'Off';
handles.cMean.Visible = 'Off';
handles.pSCT.Visible = 'Off';
handles.bSpMe.Visible = 'Off';
handles.lblStruc.String = ['Structuring Element:                      '...
    '   Size:                         Thickness:                      '...
    'Cross size:'];
handles.lblStruc.Visible = 'Off';
handles.popStru.Visible = 'Off';
handles.popSize.Visible = 'Off';
handles.popVal1.Visible = 'Off';
handles.popVal2.Visible = 'Off';
handles.pMorphfSize.Visible = 'On';
handles.tabMorpho.Data = [{'x'}, {'1'}, {'1'}; {'0'}, {'1'}, {'1'};...
                          {'0'}, {'0'}, {'x'}];%3 x 3 Skelenotization mask
handles.tabMorpho.Visible = 'On';
handles.bSz3.Value=1;
handles.txtTbl.String = 'Skeletonization Mask';
handles.txtTbl.Visible = 'On';
handles.bgDir.Visible = 'On';
%change size and position of table according to new size
handles.tabMorpho.Position(3) = 155;
handles.tabMorpho.Position(4) = 77;
handles.tabMorpho.Position(2) = 282;
handles.lblSkeInfo.Visible = 'On';
handles.popSkeIter.Visible = 'On';
handles.popSkeCon.Visible = 'On';
handles.popSkeMet.Visible = 'On';
for i=1:8                           %set default color to Dir buttons
    eval(['handles.bDir',num2str(i),'.BackgroundColor=[0.94 0.94 0.94];']); 
end
handles.bDir3.BackgroundColor = [0 0.8 0];
handles.popSkeCon.Value = 1;

% --- Executes on button press in bOpe.
function bOpe_Callback(hObject, eventdata, handles)
% hObject    handle to bOpe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bOpe
%show or hide controls
handles.cRot.Visible = 'Off';
handles.bBool.Visible = 'Off';
handles.bItera.Visible = 'Off';
handles.bSub.Visible = 'Off';
handles.bView.Visible = 'Off';
handles.c1.Visible = 'Off';
handles.c2.Visible = 'Off';
handles.c3.Visible = 'Off';
handles.c4.Visible = 'Off';
handles.c5.Visible = 'Off';
handles.c6.Visible = 'Off';
handles.c7.Visible = 'Off';
handles.c8.Visible = 'Off';
handles.c9.Visible = 'Off';
handles.c10.Visible = 'Off';
handles.c11.Visible = 'Off';
handles.c12.Visible = 'Off';
handles.c13.Visible = 'Off';
handles.c14.Visible = 'Off';
handles.pGray.Visible = 'Off';
handles.pGauss.Visible = 'Off';
handles.fGauss.Visible = 'Off';
handles.lblaLim.Visible = 'Off';
handles.aLimit.Visible = 'Off';
handles.lblMedian.Visible = 'Off';
handles.cMean.Visible = 'Off';
handles.pSCT.Visible = 'Off';
handles.bSpMe.Visible = 'Off';
handles.lblStruc.String = ['Structuring Element:                      '...
    '   Size:                         Thickness:                      '...
    'Cross size:'];
handles.lblStruc.Visible = 'On';
handles.popStru.Value = 4;
handles.popStru.Visible = 'On';
handles.popSize.Visible = 'On';
handles.popVal1.Visible = 'On';
handles.popVal2.Visible = 'On';
handles.pMorphfSize.Visible = 'Off';
handles.tabMorpho.Visible = 'Off';
handles.txtTbl.Visible = 'Off';
handles.lblSkeInfo.Visible = 'Off';
handles.popSkeIter.Visible = 'Off';
handles.popSkeCon.Visible = 'Off';
handles.popSkeMet.Visible = 'Off';
handles.bgDir.Visible = 'Off';

% --- Executes on button press in bThi.
function bThi_Callback(hObject, eventdata, handles)
% hObject    handle to bThi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bThi
%show or hide controls
handles.cRot.Visible = 'Off';
handles.bBool.Visible = 'Off';
handles.bItera.Visible = 'Off';
handles.bSub.Visible = 'Off';
handles.bView.Visible = 'Off';
handles.c1.Visible = 'Off';
handles.c2.Visible = 'Off';
handles.c3.Visible = 'Off';
handles.c4.Visible = 'Off';
handles.c5.Visible = 'Off';
handles.c6.Visible = 'Off';
handles.c7.Visible = 'Off';
handles.c8.Visible = 'Off';
handles.c9.Visible = 'Off';
handles.c10.Visible = 'Off';
handles.c11.Visible = 'Off';
handles.c12.Visible = 'Off';
handles.c13.Visible = 'Off';
handles.c14.Visible = 'Off';
handles.pGray.Visible = 'Off';
handles.pGauss.Visible = 'Off';
handles.fGauss.Visible = 'Off';
handles.lblaLim.Visible = 'Off';
handles.aLimit.Visible = 'Off';
handles.lblMedian.Visible = 'Off';
handles.cMean.Visible = 'Off';
handles.pSCT.Visible = 'Off';
handles.bSpMe.Visible = 'Off';
handles.lblStruc.String = ['Structuring Element:                      '...
    '   Size:                         Thickness:                      '...
    'Cross size:'];
handles.lblStruc.Visible = 'Off';
handles.popStru.Visible = 'Off';
handles.popSize.Visible = 'Off';
handles.popVal1.Visible = 'Off';
handles.popVal2.Visible = 'Off';
handles.pMorphfSize.Visible = 'On';
handles.tabMorpho.Data = [{'x'}, {'1'}, {'1'}; {'0'}, {'1'}, ...
                          {'1'}; {'0'}, {'0'}, {'x'}]; %3 x 3 Thining mask
handles.tabMorpho.Visible = 'On';
handles.txtTbl.String = 'Thinning Mask';
handles.txtTbl.Visible = 'On';
handles.bSz3.Value=1;
handles.bgDir.Visible = 'On';
%change size and position of table according to new size
handles.tabMorpho.Position(3) = 155;
handles.tabMorpho.Position(4) = 77;
handles.tabMorpho.Position(2) = 282;
handles.lblSkeInfo.Visible = 'Off';
handles.popSkeIter.Visible = 'Off';
handles.popSkeCon.Visible = 'Off';
handles.popSkeMet.Visible = 'Off';
for i=1:8                           %set default color to Dir buttons
    eval(['handles.bDir',num2str(i),'.BackgroundColor=[0.94 0.94 0.94];']); 
end
handles.bDir3.BackgroundColor = [0 0.8 0];

% --- Executes on button press in bEro.
function bEro_Callback(hObject, eventdata, handles)
% hObject    handle to bEro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bEro
%show or hide controls
handles.cRot.Visible = 'Off';
handles.bBool.Visible = 'Off';
handles.bItera.Visible = 'Off';
handles.bSub.Visible = 'Off';
handles.bView.Visible = 'Off';
handles.c1.Visible = 'Off';
handles.c2.Visible = 'Off';
handles.c3.Visible = 'Off';
handles.c4.Visible = 'Off';
handles.c5.Visible = 'Off';
handles.c6.Visible = 'Off';
handles.c7.Visible = 'Off';
handles.c8.Visible = 'Off';
handles.c9.Visible = 'Off';
handles.c10.Visible = 'Off';
handles.c11.Visible = 'Off';
handles.c12.Visible = 'Off';
handles.c13.Visible = 'Off';
handles.c14.Visible = 'Off';
handles.pGray.Visible = 'Off';
handles.pGauss.Visible = 'Off';
handles.fGauss.Visible = 'Off';
handles.lblaLim.Visible = 'Off';
handles.aLimit.Visible = 'Off';
handles.lblMedian.Visible = 'Off';
handles.cMean.Visible = 'Off';
handles.pSCT.Visible = 'Off';
handles.bSpMe.Visible = 'Off';
handles.lblStruc.String = ['Structuring Element:                      '...
    '   Size:                         Thickness:                      '...
    'Cross size:'];
handles.lblStruc.Visible = 'On';
handles.popStru.Value = 4;
handles.popStru.Visible = 'On';
handles.popSize.Visible = 'On';
handles.popVal1.Visible = 'On';
handles.popVal2.Visible = 'On';
handles.pMorphfSize.Visible = 'Off';
handles.tabMorpho.Visible = 'Off';
handles.txtTbl.Visible = 'Off';
handles.lblSkeInfo.Visible = 'Off';
handles.popSkeIter.Visible = 'Off';
handles.popSkeCon.Visible = 'Off';
handles.popSkeMet.Visible = 'Off';
handles.bgDir.Visible = 'Off';

% --- Executes on button press in bHit.
function bHit_Callback(hObject, eventdata, handles)
% hObject    handle to bHit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bHit
%show or hide controls
handles.cRot.Visible = 'Off';
handles.bBool.Visible = 'Off';
handles.bItera.Visible = 'Off';
handles.bSub.Visible = 'Off';
handles.bView.Visible = 'Off';
handles.c1.Visible = 'Off';
handles.c2.Visible = 'Off';
handles.c3.Visible = 'Off';
handles.c4.Visible = 'Off';
handles.c5.Visible = 'Off';
handles.c6.Visible = 'Off';
handles.c7.Visible = 'Off';
handles.c8.Visible = 'Off';
handles.c9.Visible = 'Off';
handles.c10.Visible = 'Off';
handles.c11.Visible = 'Off';
handles.c12.Visible = 'Off';
handles.c13.Visible = 'Off';
handles.c14.Visible = 'Off';
handles.pGray.Visible = 'Off';
handles.pGauss.Visible = 'Off';
handles.fGauss.Visible = 'Off';
handles.lblaLim.Visible = 'Off';
handles.aLimit.Visible = 'Off';
handles.lblMedian.Visible = 'Off';
handles.cMean.Visible = 'Off';
handles.pSCT.Visible = 'Off';
handles.bSpMe.Visible = 'Off';
handles.lblStruc.String = ['Structuring Element:                      '...
    '   Size:                         Thickness:                      '...
    'Cross size:'];
handles.lblStruc.Visible = 'Off';
handles.popStru.Visible = 'Off';
handles.popSize.Visible = 'Off';
handles.popVal1.Visible = 'Off';
handles.popVal2.Visible = 'Off';
handles.pMorphfSize.Visible = 'On';
handles.tabMorpho.Data = [{'x'}, {'0'}, {'0'}; {'1'}, {'1'}, {'0'}; ...
                          {'x'}, {'1'}, {'x'}];%3 x 3 Hit Miss mask
handles.tabMorpho.Visible = 'On';
handles.txtTbl.String = 'Hit or Miss Mask';
handles.txtTbl.Visible = 'On';
handles.bSz3.Value=1;
handles.bgDir.Visible = 'On';
%change size and position of table according to new size
handles.tabMorpho.Position(3) = 155;
handles.tabMorpho.Position(4) = 77;
handles.tabMorpho.Position(2) = 282;
handles.lblSkeInfo.Visible = 'Off';
handles.popSkeIter.Visible = 'Off';
handles.popSkeCon.Visible = 'Off';
handles.popSkeMet.Visible = 'Off';
for i=1:8                           %set default color to Dir buttons
    eval(['handles.bDir',num2str(i),'.BackgroundColor=[0.94 0.94 0.94];']); 
end
handles.bDir3.BackgroundColor = [0 0.8 0];

% --- Executes on button press in bIter.
function bIter_Callback(hObject, eventdata, handles)
% hObject    handle to bIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bIter
%show or hide controls
handles.cRot.Visible = 'On';
handles.bBool.Visible = 'On';
handles.bItera.Visible = 'On';
handles.bSub.Visible = 'On';
handles.bView.Visible = 'On';
handles.c1.Visible = 'On';
handles.c2.Visible = 'On';
handles.c3.Visible = 'On';
handles.c4.Visible = 'On';
handles.c5.Visible = 'On';
handles.c6.Visible = 'On';
handles.c7.Visible = 'On';
handles.c8.Visible = 'On';
handles.c9.Visible = 'On';
handles.c10.Visible = 'On';
handles.c11.Visible = 'On';
handles.c12.Visible = 'On';
handles.c13.Visible = 'On';
handles.c14.Visible = 'On';
handles.pGray.Visible = 'Off';
handles.pGauss.Visible = 'Off';
handles.fGauss.Visible = 'Off';
handles.lblaLim.Visible = 'Off';
handles.aLimit.Visible = 'Off';
handles.lblMedian.Visible = 'Off';
handles.cMean.Visible = 'Off';
handles.pSCT.Visible = 'Off';
handles.bSpMe.Visible = 'Off';
handles.lblStruc.String = ['Structuring Element:                      '...
    '   Size:                         Thickness:                      '...
    'Cross size:'];
handles.lblStruc.Visible = 'Off';
handles.popStru.Visible = 'Off';
handles.popSize.Visible = 'Off';
handles.popVal1.Visible = 'Off';
handles.popVal2.Visible = 'Off';
handles.pMorphfSize.Visible = 'Off';
handles.tabMorpho.Visible = 'Off';
handles.txtTbl.Visible = 'Off';
handles.lblSkeInfo.Visible = 'Off';
handles.popSkeIter.Visible = 'Off';
handles.popSkeCon.Visible = 'Off';
handles.popSkeMet.Visible = 'Off';
handles.bgDir.Visible = 'Off';

% --- Executes on button press in bView.
function bView_Callback(hObject, ~, handles)
% hObject    handle to bView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc; figure;
cpath = mfilename( 'fullpath' );
imshow([cpath(1:end-10) 'Resources\MphIterSurrounds.png']);
axis('off');
h = gcf;
h.MenuBar = 'none';
h.Name = 'Analysis: Segmentation - Iterative Filter Surrounds';
h.Resize = 'Off';
h.DockControls = 'Off';
h.WindowStyle = 'modal';

% --- Executes on selection change in popStru.
function popStru_Callback(hObject, eventdata, handles)
% hObject    handle to popStru (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popStru contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popStru
handles.tabMorpho.Visible = 'Off';
handles.txtTbl.Visible = 'Off';
if hObject.Value == 1       %circle
    handles.lblStruc.String = 'Structuring Element:                         Size:';
    handles.popVal1.Visible = 'Off';
    handles.popVal2.Visible = 'Off';
elseif hObject.Value == 2   %square
    handles.lblStruc.String = 'Structuring Element:                         Size:                                   Side:';
    handles.popVal1.Visible = 'On';
    handles.popVal2.Visible = 'Off';
elseif hObject.Value == 3   %rectangle
    handles.lblStruc.String = 'Structuring Element:                         Size:                                   Width:                             Height:';
    handles.popVal1.Visible = 'On';
    handles.popVal2.Visible = 'On';
elseif hObject.Value == 4   %cross
    handles.lblStruc.String = ['Structuring Element:                   '...
    '      Size:                         Thickness:                    '...
    '  Cross size:'];
    handles.popVal1.Visible = 'On';
    handles.popVal2.Visible = 'On';
else                        %custom
    handles.lblStruc.String = 'Structuring Element:                         Size:';
    handles.popVal1.Visible = 'Off';
    handles.popVal2.Visible = 'Off';
    handles.tabMorpho.Data = [{'1'}, {'0'}, {'0'}; {'1'}, {'1'}, {'1'};...
        {'1'}, {'0'}, {'0'}];%rotated T SE
    handles.tabMorpho.Visible = 'On';
    handles.txtTbl.String = 'Custom Structuring Element';
    handles.txtTbl.Visible = 'On';
    handles.popSize.Value=1;

end

% --- Executes during object creation, after setting all properties.
function popStru_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popStru (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popSize.
function popSize_Callback(hObject, eventdata, handles)
% hObject    handle to popSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popSize contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSize
%change the size for custom SE
if handles.popStru.Value == 5
    kSize = str2double(handles.popSize.String(handles.popSize.Value));
    if kSize < 3 || kSize > 9
       errordlg(['Selected size is too small or too big, please select '...
        'a SE size between 3 and 9.'],'Segmentation Error','modal'); 
        kSize = 3;
        handles.popSize.Value = 1;
        handles.tabMorpho.Data = [{'1'}, {'0'}, {'0'}; {'1'}, {'1'}, {'1'};...
        {'1'}, {'0'}, {'0'}];%rotated T SE
    else
        handles.tabMorpho.Data = zeros(kSize);
    end
    handles.tabMorpho.Position(3) = kSize*40 + 35;
    handles.tabMorpho.Position(4) = kSize*19 + 20;
    handles.tabMorpho.Position(2) = 282 - 19 * (kSize-3);
end


% --- Executes during object creation, after setting all properties.
function popSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popVal1.
function popVal1_Callback(hObject, eventdata, handles)
% hObject    handle to popVal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popVal1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popVal1


% --- Executes during object creation, after setting all properties.
function popVal1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popVal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popVal2.
function popVal2_Callback(hObject, eventdata, handles)
% hObject    handle to popVal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popVal2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popVal2


% --- Executes during object creation, after setting all properties.
function popVal2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popVal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bSz3.
function bSz3_Callback(hObject, eventdata, handles)
% hObject    handle to bSz3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bSz3
for i=1:8                           %set default color to Dir buttons
    eval(['handles.bDir',num2str(i),'.BackgroundColor=[0.94 0.94 0.94];']); 
end

mask_direction(handles,1);          %rotate Morph mask
handles.bDir3.BackgroundColor = [0 0.8 0];
%change size and position of table according to new size
handles.tabMorpho.Position(3) = 3*40 + 35;
handles.tabMorpho.Position(4) = 3*19 + 20;
handles.tabMorpho.Position(2) = 282;

% --- Executes on button press in bSz5.
function bSz5_Callback(hObject, eventdata, handles)
% hObject    handle to bSz5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bSz5
for i=1:8                           %set default color to Dir buttons
    eval(['handles.bDir',num2str(i),'.BackgroundColor=[0.94 0.94 0.94];']); 
end

mask_direction(handles,1);          %rotate Morph mask
handles.bDir3.BackgroundColor = [0 0.8 0];
%change size and position of table according to new size
handles.tabMorpho.Position(3) = 5*40 + 35;
handles.tabMorpho.Position(4) = 5*19 + 20;
handles.tabMorpho.Position(2) = 282 - 19 * (2);


% --- Executes on button press in bSz7.
function bSz7_Callback(hObject, eventdata, handles)
% hObject    handle to bSz7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bSz7
for i=1:8                           %set default color to Dir buttons
    eval(['handles.bDir',num2str(i),'.BackgroundColor=[0.94 0.94 0.94];']); 
end

mask_direction(handles,1);          %rotate Morph mask
handles.bDir3.BackgroundColor = [0 0.8 0];
%change size and position of table according to new size
handles.tabMorpho.Position(3) = 7*40 + 35;
handles.tabMorpho.Position(4) = 7*19 + 20;
handles.tabMorpho.Position(2) = 282 - 19 * (4);


% --- Executes on button press in bSz9.
function bSz9_Callback(hObject, eventdata, handles)
% hObject    handle to bSz9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bSz9
for i=1:8                           %set default color to Dir buttons
    eval(['handles.bDir',num2str(i),'.BackgroundColor=[0.94 0.94 0.94];']); 
end
handles.bDir3.BackgroundColor = [0 0.8 0];

mask_direction(handles,1);          %rotate Morph mask
handles.bDir3.BackgroundColor = [0 0.8 0];
%change size and position of table according to new size
handles.tabMorpho.Position(3) = 9*40 + 35;
handles.tabMorpho.Position(4) = 9*19 + 20;
handles.tabMorpho.Position(2) = 282 - 19 * (6);


% --- Executes on selection change in popSkeIter.
function popSkeIter_Callback(hObject, eventdata, handles)
% hObject    handle to popSkeIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popSkeIter contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSkeIter


% --- Executes during object creation, after setting all properties.
function popSkeIter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popSkeIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popSkeCon.
function popSkeCon_Callback(hObject, eventdata, handles)
% hObject    handle to popSkeCon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popSkeCon contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSkeCon
%show the respective mask
mask_direction(handles,1);          %rotate Morph mask
handles.bDir3.BackgroundColor = [0 0.8 0];
if handles.popSkeCon.Value == 2
    mask_direction(handles,0);    	%rotate Morph mask
    handles.bDir2.BackgroundColor = [0 0.8 0];
end


% --- Executes during object creation, after setting all properties.
function popSkeCon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popSkeCon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popSkeMet.
function popSkeMet_Callback(hObject, eventdata, handles)
% hObject    handle to popSkeMet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popSkeMet contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSkeMet


% --- Executes during object creation, after setting all properties.
function popSkeMet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popSkeMet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

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


% --- Executes on key press with focus on popSkeIter and none of its controls.
function popSkeIter_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popSkeIter (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on popSize and none of its controls.
function popSize_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popSize (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on popVal1 and none of its controls.
function popVal1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popVal1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on popVal2 and none of its controls.
function popVal2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popVal2 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on bItera and none of its controls.
function bItera_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to bItera (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on Entry and none of its controls.
function Entry_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Entry (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on Perc and none of its controls.
function Perc_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Perc (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on Thre and none of its controls.
function Thre_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Thre (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on Pixel and none of its controls.
function Pixel_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Pixel (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on Sim and none of its controls.
function Sim_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Sim (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on SCTaCol and none of its controls.
function SCTaCol_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to SCTaCol (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on SCTbCol and none of its controls.
function SCTbCol_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to SCTbCol (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on cMean and none of its controls.
function cMean_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to cMean (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on fGauss and none of its controls.
function fGauss_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to fGauss (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on aLimit and none of its controls.
function aLimit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to aLimit (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);   %call function to add user data


% --- Executes on button press in ctPCT.
function ctPCT_Callback(hObject, eventdata, handles)
% hObject    handle to ctPCT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ctPCT

function cPCT_Callback(hObject, eventdata, handles)
% hObject    handle to ctPCT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ctPCT

function hide_all(handles)          %hide all objects in GUI
%set(handles.ctPCT,'Visible','Off');
set(handles.pGray,'Visible','Off');
set(handles.lblaLim,'Visible','Off');
set(handles.aLimit,'Visible','Off');
set(handles.lblGauss,'Visible','Off');
set(handles.fGauss,'Visible','Off');
set(handles.lblMedian,'Visible','Off');
set(handles.cMean,'Visible','Off');
set(handles.pSCT,'Visible','Off');
set(handles.bSpMe,'Visible','Off');


% --- Executes on button press in bDir3.
function bDir3_Callback(hObject, eventdata, handles)
% hObject    handle to bDir3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mask_direction(handles,1);          %rotate Morph mask

% --- Executes on button press in bDir2.
function bDir2_Callback(hObject, eventdata, handles)
% hObject    handle to bDir2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mask_direction(handles,0);          %rotate Morph mask

% --- Executes on button press in bDir1.
function bDir1_Callback(hObject, eventdata, handles)
% hObject    handle to bDir1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mask_direction(handles,1);          %rotate Morph mask

% --- Executes on button press in bDir5.
function bDir5_Callback(hObject, eventdata, handles)
% hObject    handle to bDir5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mask_direction(handles,0);          %rotate Morph mask

% --- Executes on button press in bDir4.
function bDir4_Callback(hObject, eventdata, handles)
% hObject    handle to bDir4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mask_direction(handles,0);          %rotate Morph mask

% --- Executes on button press in bDir8.
function bDir8_Callback(hObject, eventdata, handles)
% hObject    handle to bDir8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mask_direction(handles,1);          %rotate Morph mask

% --- Executes on button press in bDir7.
function bDir7_Callback(hObject, eventdata, handles)
% hObject    handle to bDir7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mask_direction(handles,0);          %rotate Morph mask

% --- Executes on button press in bDir6.
function bDir6_Callback(hObject, eventdata, handles)
% hObject    handle to bDir6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mask_direction(handles,1);          %rotate Morph mask

%function to rotate mask for Morph filters
function mask_direction(handles, done)
clc;
for i=1:8                           %set default color to Dir buttons
    eval(['handles.bDir',num2str(i),'.BackgroundColor=[0.94 0.94 0.94];']); 
end
if handles.bHit.Value               %base masks for Hit or Miss
    if handles.bSz3.Value
        handles.tabMorpho.Data = [{'x'}, {'0'}, {'0'}; {'1'}, {'1'}, ...
                {'0'}; {'x'}, {'1'}, {'x'}];
        %define base mask for up, down, left and right
        if done == 0
            handles.tabMorpho.Data = [{'0'}, {'0'}, {'0'}; {'x'}, {'1'},...
                {'x'}; {'1'}, {'x'}, {'1'}];
        end
    elseif handles.bSz5.Value
        handles.tabMorpho.Data = [{'x'}, {'x'}, {'0'}, {'0'}, {'0'}; ...
      {'x'}, {'x'}, {'0'}, {'0'}, {'0'}; {'1'}, {'1'}, {'1'}, {'0'}, {'0'};...
      {'x'}, {'x'}, {'1'}, {'x'}, {'x'}; {'x'}, {'x'}, {'1'}, {'x'}, {'x'}];
        %define base mask for up, down, left and right
        if done == 0
        handles.tabMorpho.Data = [{'0'}, {'0'}, {'0'}, {'0'}, {'0'}; ...
      {'x'}, {'0'}, {'0'}, {'0'}, {'x'}; {'x'}, {'x'}, {'1'}, {'x'}, {'x'};...
      {'x'}, {'1'}, {'x'}, {'1'}, {'x'}; {'1'}, {'x'}, {'x'}, {'x'}, {'1'}];
        end
    elseif handles.bSz7.Value
        handles.tabMorpho.Data = [{'x'}, {'x'}, {'x'}, {'0'}, {'0'}, ...
             {'0'}, {'0'}; {'x'}, {'x'}, {'x'}, {'0'}, {'0'}, {'0'}, {'0'};...
             {'x'}, {'x'}, {'x'}, {'0'}, {'0'}, {'0'}, {'0'};
             {'1'}, {'1'}, {'1'}, {'1'}, {'0'}, {'0'}, {'0'};
             {'x'}, {'x'}, {'x'}, {'1'}, {'x'}, {'x'}, {'x'};
             {'x'}, {'x'}, {'x'}, {'1'}, {'x'}, {'x'}, {'x'};
             {'x'}, {'x'}, {'x'}, {'1'}, {'x'}, {'x'}, {'x'}];
        %define base mask for up, down, left and right
        if done == 0
        handles.tabMorpho.Data = [{'0'}, {'0'}, {'0'}, {'0'}, {'0'}, ...
             {'0'}, {'0'}; {'x'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'x'};...
             {'x'}, {'x'}, {'0'}, {'0'}, {'0'}, {'x'}, {'x'};
             {'x'}, {'x'}, {'x'}, {'1'}, {'x'}, {'x'}, {'x'};
             {'x'}, {'x'}, {'1'}, {'x'}, {'1'}, {'x'}, {'x'};
             {'x'}, {'1'}, {'x'}, {'x'}, {'x'}, {'1'}, {'x'};
             {'1'}, {'x'}, {'x'}, {'x'}, {'x'}, {'x'}, {'1'}];
        %define base mask for up, down, left and right
        end
    elseif handles.bSz9.Value
        handles.tabMorpho.Data = [{'x'}, {'x'}, {'x'}, {'x'}, {'0'}, ...
      {'0'}, {'0'}, {'0'}, {'0'}; {'x'}, {'x'}, {'x'}, {'x'}, {'0'}, {'0'},...
      {'0'}, {'0'}, {'0'}; {'x'}, {'x'}, {'x'}, {'x'}, {'0'}, {'0'}, {'0'},...
      {'0'}, {'0'}; {'x'}, {'x'}, {'x'}, {'x'}, {'0'}, {'0'}, {'0'}, {'0'},... 
      {'0'}; {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'0'}, {'0'}, {'0'}, {'0'};...
      {'x'}, {'x'}, {'x'}, {'x'}, {'1'}, {'x'}, {'x'}, {'x'}, {'x'}; ...
      {'x'}, {'x'}, {'x'}, {'x'}, {'1'}, {'x'}, {'x'}, {'x'}, {'x'}; ...
      {'x'}, {'x'}, {'x'}, {'x'}, {'1'}, {'x'}, {'x'}, {'x'}, {'x'}; ...
      {'x'}, {'x'}, {'x'}, {'x'}, {'1'}, {'x'}, {'x'}, {'x'}, {'x'};];
        %define base mask for up, down, left and right
        if done == 0
        handles.tabMorpho.Data = [{'0'}, {'0'}, {'0'}, {'0'}, {'0'}, ...
      {'0'}, {'0'}, {'0'}, {'0'}; {'x'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'},...
      {'0'}, {'0'}, {'x'}; {'x'}, {'x'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'},...
      {'x'}, {'x'}; {'x'}, {'x'}, {'x'}, {'0'}, {'0'}, {'0'}, {'x'}, {'x'},... 
      {'x'}; {'x'}, {'x'}, {'x'}, {'x'}, {'1'}, {'x'}, {'x'}, {'x'}, {'x'};...
      {'x'}, {'x'}, {'x'}, {'1'}, {'x'}, {'1'}, {'x'}, {'x'}, {'x'}; ...
      {'x'}, {'x'}, {'1'}, {'x'}, {'x'}, {'x'}, {'1'}, {'x'}, {'x'}; ...
      {'x'}, {'1'}, {'x'}, {'x'}, {'x'}, {'x'}, {'x'}, {'1'}, {'x'}; ...
      {'1'}, {'x'}, {'x'}, {'x'}, {'x'}, {'x'}, {'x'}, {'x'}, {'1'};];
        end
    end
elseif handles.bThi.Value || handles.bSke.Value
    %default masks for skelenotization and thinning
    if handles.bSz3.Value
        handles.tabMorpho.Data = [{'x'}, {'1'}, {'1'}; {'0'}, {'1'}, ...
                                  {'1'}; {'0'}, {'0'}, {'x'}];
        %define base mask for up, down, left and right
        if done == 0
            handles.tabMorpho.Data = [{'0'}, {'0'}, {'0'}; {'x'}, {'1'}, ...
                                  {'x'}; {'1'}, {'1'}, {'1'}];
            handles.tabMorpho.Data = flip(handles.tabMorpho.Data);
        end
    elseif handles.bSz5.Value
        handles.tabMorpho.Data = [{'x'}, {'1'}, {'1'}, {'1'}, {'1'}; ...
      {'0'}, {'x'}, {'1'}, {'1'}, {'1'}; {'0'}, {'0'}, {'1'}, {'1'}, {'1'}; ...
      {'0'}, {'0'}, {'0'}, {'x'}, {'1'}; {'0'}, {'0'}, {'0'}, {'0'}, {'x'}];
        %define base mask for up, down, left and right
        if done == 0
        handles.tabMorpho.Data = [{'0'}, {'0'}, {'0'}, {'0'}, {'0'}; ...
      {'0'}, {'0'}, {'0'}, {'0'}, {'0'}; {'x'}, {'x'}, {'1'}, {'x'}, {'x'}; ...
      {'1'}, {'1'}, {'1'}, {'1'}, {'1'}; {'1'}, {'1'}, {'1'}, {'1'}, {'1'}];
        handles.tabMorpho.Data = flip(handles.tabMorpho.Data);
        end
    elseif handles.bSz7.Value
        handles.tabMorpho.Data = [{'x'}, {'1'}, {'1'}, {'1'}, {'1'}, ...
             {'1'}, {'1'}; {'0'}, {'x'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}; ...
             {'0'}, {'0'}, {'x'}, {'1'}, {'1'}, {'1'}, {'1'}; ...
             {'0'}, {'0'}, {'0'}, {'1'}, {'1'}, {'1'}, {'1'}; ...
             {'0'}, {'0'}, {'0'}, {'0'}, {'x'}, {'1'}, {'1'}; ...
             {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'x'}, {'1'}; ...
             {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'x'}];
        %define base mask for up, down, left and right
        if done == 0
        handles.tabMorpho.Data = [{'0'}, {'0'}, {'0'}, {'0'}, {'0'}, ...
             {'0'}, {'0'}; {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'}; ...
             {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'}; ...
             {'x'}, {'x'}, {'x'}, {'1'}, {'x'}, {'x'}, {'x'}; ...
             {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}; ...
             {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}; ...
             {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}];
        handles.tabMorpho.Data = flip(handles.tabMorpho.Data);
        %define base mask for up, down, left and right
        end
    elseif handles.bSz9.Value
        handles.tabMorpho.Data = [{'x'}, {'1'}, {'1'}, {'1'}, {'1'}, ...
      {'1'}, {'1'}, {'1'}, {'1'}; {'0'}, {'x'}, {'1'}, {'1'}, {'1'}, {'1'},...
      {'1'}, {'1'}, {'1'}; {'0'}, {'0'}, {'x'}, {'1'}, {'1'}, {'1'}, {'1'},...
      {'1'}, {'1'}; {'0'}, {'0'}, {'0'}, {'x'}, {'1'}, {'1'}, {'1'}, {'1'},...
      {'1'}; {'0'}, {'0'}, {'0'}, {'0'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'};...
      {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'x'}, {'1'}, {'1'}, {'1'}; ...
      {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'x'}, {'1'}, {'1'}; ...
      {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'x'}, {'1'}; ...
      {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'x'}];
        %define base mask for up, down, left and right
        if done == 0
        handles.tabMorpho.Data = [{'0'}, {'0'}, {'0'}, {'0'}, {'0'}, ...
      {'0'}, {'0'}, {'0'}, {'0'}; {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'},...
      {'0'}, {'0'}, {'0'}; {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'},...
      {'0'}, {'0'}; {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'}, {'0'},...
      {'0'}; {'x'}, {'x'}, {'x'}, {'x'}, {'1'}, {'x'}, {'x'}, {'x'}, {'x'};...
      {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}; ...
      {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}; ...
      {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}; ...
      {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}, {'1'}];
        handles.tabMorpho.Data = flip(handles.tabMorpho.Data);  
        end
    end
        
end
%rotate Masks according to direction button
if handles.bDir1.Value
    handles.tabMorpho.Data = rot90(handles.tabMorpho.Data);
    handles.bDir1.BackgroundColor = [0 0.8 0];

elseif handles.bDir3.Value
    handles.bDir3.BackgroundColor = [0 0.8 0];

elseif handles.bDir6.Value
    handles.tabMorpho.Data = rot90(handles.tabMorpho.Data,2);
    handles.bDir6.BackgroundColor = [0 0.8 0];

elseif handles.bDir8.Value
    handles.tabMorpho.Data = rot90(handles.tabMorpho.Data,3);
    handles.bDir8.BackgroundColor = [0 0.8 0];

elseif handles.bDir2.Value
    handles.bDir2.BackgroundColor = [0 0.8 0];
    
elseif handles.bDir4.Value
    handles.tabMorpho.Data = rot90(handles.tabMorpho.Data);
    handles.bDir4.BackgroundColor = [0 0.8 0];
    
elseif handles.bDir5.Value
    handles.tabMorpho.Data = rot90(handles.tabMorpho.Data,3);
    handles.bDir5.BackgroundColor = [0 0.8 0];
    
elseif handles.bDir7.Value
    handles.tabMorpho.Data = rot90(handles.tabMorpho.Data,2);
    handles.bDir7.BackgroundColor = [0 0.8 0];
    
end


% --- Executes on selection change in Sim.
function popupmenu60_Callback(hObject, eventdata, handles)
% hObject    handle to Sim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Sim contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Sim


% --- Executes during object creation, after setting all properties.
function popupmenu60_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Pixel.
function popupmenu59_Callback(hObject, eventdata, handles)
% hObject    handle to Pixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Pixel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Pixel


% --- Executes during object creation, after setting all properties.
function popupmenu59_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ctPCT.
function checkbox66_Callback(hObject, eventdata, handles)
% hObject    handle to ctPCT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ctPCT


% --- Executes on selection change in Thre.
function popupmenu58_Callback(hObject, eventdata, handles)
% hObject    handle to Thre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Thre contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Thre


% --- Executes during object creation, after setting all properties.
function popupmenu58_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Thre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Perc.
function popupmenu57_Callback(hObject, eventdata, handles)
% hObject    handle to Perc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Perc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Perc


% --- Executes during object creation, after setting all properties.
function popupmenu57_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Perc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Entry.
function popupmenu56_Callback(hObject, eventdata, handles)
% hObject    handle to Entry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Entry contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Entry


% --- Executes during object creation, after setting all properties.
function popupmenu56_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Entry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popMopt.
function popMopt_Callback(hObject, eventdata, handles)
% hObject    handle to popMopt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMopt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMopt


% --- Executes during object creation, after setting all properties.
function popMopt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMopt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on gGray and none of its controls.
function gGray_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to gGray (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);   %call function to add user data

% --- Executes on key press with focus on bSub and none of its controls.
function bSub_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to bSub (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);   %call function to add user data
