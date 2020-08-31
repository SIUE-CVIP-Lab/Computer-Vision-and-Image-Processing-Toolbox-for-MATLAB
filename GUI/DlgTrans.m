function varargout = DlgTrans(varargin)
% DLGTRANS MATLAB code for DlgTrans.fig
%      DLGTRANS, by itself, creates a new DLGTRANS or raises the existing
%      singleton*.
%
%      H = DLGTRANS returns the handle to a new DLGTRANS or the handle to
%      the existing singleton*.
%
%      DLGTRANS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DLGTRANS.M with the given input arguments.
%
%      DLGTRANS('Property','Value',...) creates a new DLGTRANS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgTrans_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgTrans_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DlgTrans

% Last Modified by GUIDE v2.5 09-Jul-2020 02:02:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgTrans_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgTrans_OutputFcn, ...
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
%           Latest update date:     12/12/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.3  05/24/2019  14:48:15  jucuell
 % including the icons to extract the histogram, R, G and B band from the
 % selected image.
%
 % Revision 1.2  12/17/2018  10:22:28  jucuell
 % updating menu creation programmatically, callbacks to Main figure and
 % the use of the utilities menus in the Main figure.
%
 % Revision 1.1  12/12/2018  15:23:31  jucuell
 % Initial coding and testing.
 % 
%

% --- Executes just before DlgTrans is made visible.
function DlgTrans_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DlgTrans (see VARARGIN)

% Choose default command line output for DlgTrans
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DlgTrans wait for user response (see UIRESUME)
% uiwait(handles.Trans);

% create figure menus linked to menu functions in CVIPToolbox figure
menu_add_cvip(hObject);
handles.mAna.Visible = 'Off';%hide Analysis menu
handles.mComp.Visible = 'Off';%hide Compression menu
handles.mView.Visible = 'Off';%hide View menu
handles.cDC.Visible = 'Off';


% --- Outputs from this function are returned to the command line.
function varargout = DlgTrans_OutputFcn(hObject, eventdata, handles) 
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
 close(handles.Trans)


% --- Executes on button press in bReset.
function bReset_Callback(hObject, eventdata, handles)
% hObject    handle to bReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%default values for controls
handles.popBlock.Value = 6;
handles.popWBas.Value = 1;
handles.popWDec.Value = 1;
handles.popCutF.Value = 7;
handles.cBlock.Value = 0;
handles.popTFBlock.Value = 7;
handles.popFT.Value = 1;
handles.popBO.Value = 1;
handles.popLF.Value = 7;
handles.popHF.Value = 7;
handles.popAlfa.Value = 2;
handles.popNP.Value = 1;
handles.popNSz.Value = 7;
handles.txtNCol.String = '0';
handles.txtNRow.String = '0';
% handles.popNSz.Value = 7;
% handles.popNSz.Value = 7;
bFFT_Callback(hObject, eventdata, handles)
handles.bFFT.Value = 1;

% --- Executes on button press in bApply.
function bApply_Callback(hObject, eventdata, handles)
% hObject    handle to bApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc                             %clear screen

%changing pointer arrow to watch on cursor
figure_set = findall(groot,'Type','Figure');
set(figure_set,'pointer','watch');

hMain = findobj('Tag','Main');  %get the handle of Main form
%hSHisto = findobj('Tag','mVsaveHis'); %get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = hMain.UserData;         %get image handle
if hNfig == 0 || isempty(hNfig) || ~isfield(hNfig.UserData,'cvipIma')
    errordlg('Please select the image to Process', 'Transforms Error', 'modal');
else
Ima=hNfig.UserData;             %Get image information
InIma = Ima.cvipIma;            %read image data
file = get(hNfig,'Name');       %get image name

%get transforms block size
block = str2double(handles.popBlock.String(handles.popBlock.Value));
if handles.bDCT.Value           %DCT Transform  
    if handles.bTFor.Value      %forward
        Spect = dct_cvip(InIma, block);     %call DCT function
        Name = strcat(file,' > DCT-',num2str(block));
        histo = [211 block];        %update history information
    else                        %inverse
        %ask for spectral DCT info
        [ro,~]=find(Ima.fInfo.history_info==211);
        if ~isempty(ro) %info trans 211
            %block = double(Ima.fInfo.history_info(ro,co+1));  %get used Block size
            Spect = idct_cvip(InIma, block);   %call iDCT function
            Name = strcat(file,' > iDCT-',num2str(block));
            histo = [219 block];
        else                                    %apply inverse transformation
            %show Error info
            errordlg('Selected image does not contain DCT transform information.', ...
                'Transforms Error', 'modal');
            histo = 0;
        end
    end
    
elseif handles.bFFT.Value           %FFT Transform  
    if handles.bTFor.Value          %forward
        Spect = fft_cvip(InIma, block);     %call FFT function
        Name = strcat(file,' > FFT-',num2str(block));
        histo = [212 block];        %update history information
        Ima.fInfo.data_format = 'COMPLEX';      %update image data format
    else                        %inverse
        %ask for spectral FFT info
        [ro,~]=find(Ima.fInfo.history_info==212);
        if ~isempty(ro) %info trans 212
            %block = double(Ima.fInfo.history_info(ro,co+1));  %get used Block size
            Spect = ifft_cvip(InIma, block);   %call iFFT function
            Name = strcat(file,' > iFFT-',num2str(block));
            histo = [220 block];     %update history information
            Ima.fInfo.data_format = 'REAL';      %update image data format
        else                                    %apply inverse transformation
            %show Error info
            errordlg('Selected image does not contain FFT transform information.', ...
                'Transforms Error', 'modal');
            histo = 0;
        end
    end
    
elseif handles.bHar.Value==1        %Haar Transform  
    if handles.bTFor.Value==1   %forward
        Spect = haar_cvip(InIma, block);%/block;     %call Haar function
        Name = strcat(file,' > Haar-',num2str(block));
        histo = [215 block];     %update history information
    else                        %inverse
        %ask for spectral Haar info
        [ro,co]=find(Ima.fInfo.history_info==215);
        if ~isempty(ro) %info trans 215
            block = Ima.fInfo.history_info(ro,co+1);  %get used Block size
            Spect = ihaar_cvip(InIma, block);   %call iHaar function
            Name = strcat(file,' > iHaar-',num2str(block));
            histo = [221 block];     %update history information
        else                                    %apply inverse transformation
            %show Error info
            errordlg('Selected image does not contain Haar transform information.', ...
                'Transforms Error', 'modal');
            histo = 0;
        end
    end
    
elseif handles.bWal.Value==1        %Walsh/Hadamard Transform  
    if handles.bTFor.Value==1   %forward
        Spect = walhad_cvip(InIma, block);   %call Walsh/Hadamard function
        Name = strcat(file,' > Walsh/Hadamard-',num2str(block));
        histo = [218 block];     %update history information
    else                        %inverse
        %ask for spectral Walsh info
        [ro,co]=find(Ima.fInfo.history_info==218);
        if ~isempty(ro) %info trans 211
            block = Ima.fInfo.history_info(ro,co+1);  %get used Block size
            Spect = iwalhad_cvip(InIma, block);   %call iWalsh function
            Name = strcat(file,' > iWalsh/Hadamard-',num2str(block));
            histo = [222 block];     %update history information
        else                                    %apply inverse transformation
            %show Error info
            errordlg('Selected image does not contain Walsh transform information.', ...
                'Transforms Error', 'modal');
            histo = 0;
        end                 %apply inverse transformation
    end
    
elseif handles.bWav.Value==1        %Wavelet Transform  
    dec = str2double(handles.popWDec.String(handles.popWDec.Value));
    if handles.popWBas.Value==1   %Haar basis
        if handles.bTFor.Value==1   %forward
            Spect = wavhaar_cvip(InIma, dec);     %call Wavelet - Haar function
            row = size(Spect,1);   %get image size             
            col = size(Spect,2);   %get image size
            Name = strcat(file,' > Wavelet (Haar)-',num2str(dec));  
            histo = [217 dec row col];
        else                        %inverse
            %ask for spectral WavHaar info
            [ro,co]=find(Ima.fInfo.history_info==217);
            if ~isempty(ro) %info trans 217
                dec = Ima.fInfo.history_info(ro,co+1);  %get used Decomposition
                Spect = iwavhaar_cvip(InIma, dec);     %call iWavelet Haar function
                Name = strcat(file,' > iWavelet (Haar)-',num2str(dec));
                histo = [224 dec];     %update history information
            else                                    %apply inverse transformation
                %show Error info
                errordlg(['Selected image does not contain Wavelet-Haar ' ...
                    'transform information.'], 'Transforms Error', 'modal');
                histo = 0;
            end
        end
    else                            %Daub4 Basis
        if handles.bTFor.Value==1   %forward
            Spect = wavdaub4_cvip(double(InIma), dec);     %call Wavelet - Daub4 function
            row = size(Spect,1);   %get image size
            col = size(Spect,2);   %get image size
            Name = strcat(file,' > Wavelet (Daub4)-',num2str(dec));
            histo = [216 dec row col];
        else                        %inverse
             %ask for spectral Wavelet info
            [ro,co]=find(Ima.fInfo.history_info==216);
            if ~isempty(ro) %info trans 211
                dec = Ima.fInfo.history_info(ro,co+1);  %get used Decomposition
                Spect = iwavdaub4_cvip(InIma, dec);     %call iWavelet Haar function
                Name = strcat(file,' > iWavelet (Daub4)-',num2str(dec));
                histo = [223 dec];     %update history information
            else                                    %apply inverse transformation
                %show Error info
                errordlg(['Selected image does not contain Wavelet-Daub4 ' ...
                    'transform information.'], 'Transforms Error', 'modal');
                histo = 0;
            end                   %apply inverse transformation
        end
    end  
    
elseif handles.bFFTm.Value==1        %FFT magnitude extraction
    %ask for spectral FFT info
    [ro,co]=find(Ima.fInfo.history_info==212);
    if ~isempty(ro) %info trans 212
        block = Ima.fInfo.history_info(ro,co+1);  %get used Block size
        oIma = ifft_cvip(InIma, block);   %call iFFT function
        histo = [220 block];     %update history information
        Ima.fInfo.data_format = 'REAL';      %update image data format
        Spect = fft_mag_cvip(oIma, block);     %call FFT magnitude function
        histo = historyupdate_cvip(histo,[213 block]);
        if handles.cMIma.Value
            %Normalizes the phase and perform inverse FFT
            ang = zeros(size(Spect));        %angles = 0
            nSpect = Spect.*exp(1i*ang);     %get spectra in complex form
            Spect = ifft_cvip(nSpect, block);      %get the image
            if handles.bITransla.Value      %translate center of image
                Spect = translate_cvip(Spect);
            end
            Name = strcat(file,' > FFT (Mag.)-Image');    
            histo = historyupdate_cvip(histo,[220 block]);
        else
            Name = strcat(file,' > FFT (Mag.)');            
        end
        
    else                                    %apply inverse transformation
        %show Error info
        errordlg('Selected image does not contain FFT transform information.', ...
            'Transforms Error', 'modal');
        histo = 0;
    end
    
elseif handles.bFFTp.Value==1        %FFT phase extraction
    %ask for spectral FFT info
    [ro,co]=find(Ima.fInfo.history_info==212);
    if ~isempty(ro) %info trans 212
        block = Ima.fInfo.history_info(ro,co+1);  %get used Block size
        oIma = ifft_cvip(InIma, block);   %call iFFT function
        histo = [220 block];     %update history information
        Ima.fInfo.data_format = 'REAL';      %update image data format
        Spect = fft_phase_cvip(oIma, block);     %call FFT phase function
        histo = historyupdate_cvip(histo,[214 block]);
        if handles.cPIma.Value
            %Normalizes the magnitude and perform inverse FFT
            mag = ones(size(Spect));        %magnitudes = 1
            nSpect = mag.*exp(1i*Spect);     %get spectra in complex form
            Spect = ifft_cvip(nSpect, block);      %get the image
            Name = strcat(file,' > FFT (Phase)-Image');    
            histo = historyupdate_cvip(histo,[244 block]);
        else
            Name = strcat(file,' > FFT (Phase)');  
        end
        
    else                                    %apply inverse transformation
        %show Error info
        errordlg('Selected image does not contain FFT transform information.', ...
            'Transforms Error', 'modal');
        histo = 0;
    end
            
elseif handles.pTF.Visible      %transform Filters
    trans = Ima.fInfo.history_info(:,1);       %ask for spectral info
    if isempty(trans) ||  (trans>210 & trans<219) == 0 %no spectral info
        %show Error info
        errordlg('Selected image does not contain transform information.', ...
            'Transforms Error', 'modal');
        histo = 0;
    else                    %apply inverse transformation
        %get original transform info
        if trans == 212
            type = 'center';
        else
            type = 'uppleft';
        end
 
        if trans == 216 || trans == 217         %wav haar or daub4
            block = Ima.fInfo.history_info(end,3:4);
        else
            block = Ima.fInfo.history_info(end,2);
        end
        fc = str2double(handles.popCutF.String(handles.popCutF.Value));
        DC = handles.cDC.Value;
        
        if handles.bLPF.Value==1        %Low Pass Filter
            if handles.popFT.Value == 1 %ideal filter
                Spect = ideal_low_cvip(InIma, block,type,DC,fc);%call LPF ideal
                Name = strcat(file,' > LPF (Ideal)',num2str(fc));
                histo = [225 block trans fc];%update history
            else                        %Butterworth filter
                ord = str2double(handles.popBO.String(handles.popBO.Value));
                Spect = butterworth_low_cvip(InIma, block,type, DC, ord, fc);
                Name = [file,' > LPF (Butter)(' num2str(fc) ',' num2str(ord) ')'];
                histo = [230 block trans ord fc];%update history
            end
            
        elseif handles.bHPF.Value==1        %High Pass Filter
            if handles.popFT.Value == 1 %ideal filter
                Spect = ideal_high_cvip(InIma, block,type,DC,fc);%call HPF ideal
                Name = strcat(file,' > HPF (Ideal)',num2str(fc));
                histo = [226 block trans fc];
            else                        %Butterworth filter
                ord = str2double(handles.popBO.String(handles.popBO.Value));
                Spect = butterworth_high_cvip(InIma, block, type,DC, ord, fc);
                Name = [file,' > HPF (Butter)(' num2str(fc) ',' num2str(ord) ')'];
                histo = [231 block trans ord fc];%update history
            end
            
        elseif handles.bBPF.Value==1 	%Band Pass Filter
            %get Low and High cutoff Freq.
            fcl = str2double(handles.popLF.String(handles.popLF.Value));    
            fch = str2double(handles.popHF.String(handles.popHF.Value));
            if handles.popFT.Value == 1 %ideal filter
                %call BPF ideal function
                Spect = ideal_bandpass_cvip(InIma, block,type,DC,fcl, fch);
                Name = strcat(file,' > BPF (Ideal)',num2str(fcl),'-',num2str(fch));
                histo = [227 block trans fcl fch];
            else                        %Butterworth filter
                ord = str2double(handles.popBO.String(handles.popBO.Value));
                %call Butter function
                Spect = butterworth_bandpass_cvip(InIma, block,type,DC,ord, fcl, fch);
                Name = strcat(file,' > BPF (Butter)',num2str(fcl),'-',num2str(fch));
                histo = [232 block trans ord fcl fch];
            end
        
        elseif handles.bBRF.Value==1 	%Band Reject Filter
            %get Low and High cutoff Freq.
            fcl = str2double(handles.popLF.String(handles.popLF.Value));
            fch = str2double(handles.popHF.String(handles.popHF.Value));
            if handles.popFT.Value == 1 %ideal filter
                %call BRF ideal function
                Spect = ideal_bandreject_cvip(InIma, block,type,DC,fcl, fch);
                Name = strcat(file,' > BRF (Ideal)',num2str(fcl),'-',num2str(fch));
                histo = [228 block trans fcl fch];
            else                        %Butterworth filter
                ord = str2double(handles.popBO.String(handles.popBO.Value));
                %call Butter function
                Spect = butterworth_bandreject_cvip(InIma, block,type,DC,ord, fcl, fch);
                Name = strcat(file,' > BRF (Butter)',num2str(fcl),'-',num2str(fch));
                histo = [233 block trans ord fcl fch];
            end
            
        elseif handles.bHFE.Value==1 	%High Freq. Emphasis Filter
            %get High cutoff Freq.
            fch = str2double(handles.popHF.String(handles.popHF.Value));
            ord = str2double(handles.popBO.String(handles.popBO.Value));
            alfa = str2double(handles.popAlfa.String(handles.popAlfa.Value));
            
            [m,n,d] = size(InIma);
            H = butterworth_h_cvip( 'high', [m n] , type, DC, ord ,fch );
            H = H + alfa;
            Spect = InIma.*repmat(H,[1 1 d]);

            %Spect1 = log(1+abs(Spect));          %use abs to compute the magnitude (handling imaginary) and use log to brighten display
            Name = [file,' > High Freq. Emphasis(' num2str(fch) ',' ...
                num2str(alfa) ',' num2str(ord) ')'];
            histo = [234 2 trans m ord fch; 235 block trans fch alfa ord];
            
        elseif handles.bNotch.Value==1        %Notch Filter
            zone = handles.bAdd.UserData; %structure for zones
            if strcmp(zone,'NO')    %there arent defined zones%%%JOJO CON ESTO!!!
                %show Error info
                errordlg('There is Not point information for this operation.', 'Transforms Error', 'modal');
            else
                NP = handles.popNP.UserData - 1;                                 %Number of points
                Inter = 0;           %interactive mode
                Spect = notch_filter_cvip(InIma,zone,NP,Inter);
                %Spect1 = log(1+abs(Spect));          %use abs to compute the magnitude (handling imaginary) and use log to brighten display
                Name = [file,' > Notch (' num2str(NP) ')'];
                histo = [244 NP];   %update history
            end

        end
        
        %ALWAYS save history
        Ima.fInfo.history_info = historyupdate_cvip(Ima.fInfo.history_info,histo);  
        if histo(1) ~= 0 
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
            [row,col,band]=size(Spect);            %get new image size
            %update image information
            Ima.fInfo.no_of_bands=band;             
            Ima.fInfo.no_of_cols=col;              
            Ima.fInfo.no_of_rows=row;
            %update image structure
            Ima.cvipIma = Spect;   %read image data
            Ima.fInfo.cvip_type = 'cvip_double';  %update image data format
            showgui_cvip(Ima, Name);
        end
        
        %call corresponding inverse fn
        if trans == 211
            Spect = idct_cvip(Spect, block);       %call iDCT function
            histo = [219 block];
            Name = strcat(Name,' > iDCT');
        elseif trans == 212
            Spect = ifft_cvip(Spect, block);       %call iFFT function
            Name = strcat(Name,' > iFFT');
            histo = [220 block];
        elseif strcmp(hNfig.UserData.Function,'haar')
            Spect = ihaar_cvip(Spect, block);      %call iHaar function
            Name = strcat(Name,' > iHaar');
            histo = [221 block];
        elseif strcmp(hNfig.UserData.Function,'walsh')
            Spect = iwalhad_cvip(Spect, block);    %call iWalHad function
            Name = strcat(Name,' > iWalHad');
            histo = [222 block];
        elseif strcmp(hNfig.UserData.Function,'waveD') 
            %call iWavelet Daub4 function
            Spect = iwavdaub4_cvip(Spect, hNfig.UserData.Params(3));  
            Name = strcat(Name,' > iWavDaub');
            histo = [223 block];
        else
            %call iWavelet Haar function
            Spect = iwavhaar_cvip(Spect, hNfig.UserData.Params(3));   
            Name = strcat(Name,' > iWavHaar');
            histo = [224 block];
        end
    end
    
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

%changing pointer watch back to arrow on cursor
set(figure_set,'pointer','arrow');


% --- Executes on selection change in popBlock.
function popBlock_Callback(hObject, eventdata, handles)
% hObject    handle to popBlock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popBlock contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popBlock


% --- Executes during object creation, after setting all properties.
function popBlock_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popBlock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on button press in bWav.
function bWav_Callback(hObject, eventdata, handles)
% hObject    handle to bWav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bWav
%show and hide object
handles.pTrans.Visible = 'On';
handles.pTF.Visible = 'Off';
handles.lblBlock.Visible = 'Off';
handles.popBlock.Visible = 'Off';
handles.lblWav.Visible = 'On';
handles.popWDec.Visible = 'On';
handles.popWBas.Visible = 'On';
handles.cDC.Visible = 'Off';


% --- Executes on button press in bWal.
function bWal_Callback(hObject, eventdata, handles)
% hObject    handle to bWal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bWal
%show and hide object
handles.pTrans.Visible = 'On';
handles.pTF.Visible = 'Off';
handles.lblBlock.Visible = 'On';
handles.popBlock.Visible = 'On';
handles.lblWav.Visible = 'Off';
handles.popWDec.Visible = 'Off';
handles.popWBas.Visible = 'Off';
handles.cDC.Visible = 'Off';

% --- Executes on selection change in popWBas.
function popWBas_Callback(hObject, eventdata, handles)
% hObject    handle to popWBas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popWBas contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popWBas


% --- Executes during object creation, after setting all properties.
function popWBas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popWBas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popWDec.
function popWDec_Callback(hObject, eventdata, handles)
% hObject    handle to popWDec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popWDec contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popWDec


% --- Executes during object creation, after setting all properties.
function popWDec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popWDec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bHar.
function bHar_Callback(hObject, eventdata, handles)
% hObject    handle to bHar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bHar
%show and hide object
handles.pTrans.Visible = 'On';
handles.pTF.Visible = 'Off';
handles.lblBlock.Visible = 'On';
handles.popBlock.Visible = 'On';
handles.lblWav.Visible = 'Off';
handles.popWDec.Visible = 'Off';
handles.popWBas.Visible = 'Off';
handles.cDC.Visible = 'Off';


% --- Executes on button press in bFFT.
function bFFT_Callback(hObject, eventdata, handles)
% hObject    handle to bFFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bFFT
%show and hide object
handles.pTrans.Visible = 'On';
handles.pTF.Visible = 'Off';
handles.lblBlock.Visible = 'On';
handles.popBlock.Visible = 'On';
handles.lblWav.Visible = 'Off';
handles.popWDec.Visible = 'Off';
handles.popWBas.Visible = 'Off';
handles.cDC.Visible = 'Off';


% --- Executes on button press in bDCT.
function bDCT_Callback(hObject, eventdata, handles)
% hObject    handle to bDCT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bDCT
%show and hide object
handles.pTrans.Visible = 'On';
handles.pTF.Visible = 'Off';
handles.lblBlock.Visible = 'On';
handles.popBlock.Visible = 'On';
handles.lblWav.Visible = 'Off';
handles.popWDec.Visible = 'Off';
handles.popWBas.Visible = 'Off';
handles.cDC.Visible = 'Off';


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


% --- Executes on button press in bLPF.
function bLPF_Callback(hObject, eventdata, handles)
% hObject    handle to bLPF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bLPF
%Show and hide controls
handles.pTrans.Visible = 'Off';
handles.pTF.Visible = 'On';
handles.lblCF.Visible = 'On';
handles.popCutF.Visible = 'On';
handles.lblFT.Visible = 'On';
handles.popFT.Visible = 'On';
handles.cBlock.Value = 0;
handles.cBlock.Visible = 'On';
handles.popTFBlock.Visible = 'On';
handles.popTFBlock.Enable = 'Off';
handles.lblBO.Visible = 'Off';
handles.popBO.Visible = 'Off';
handles.lblLHF.Visible = 'Off';
handles.popLF.Visible = 'Off';
handles.popHF.Visible = 'Off';
handles.lblAlfa.Visible = 'Off';
handles.popAlfa.Visible = 'Off';
handles.lblHCF.Visible = 'Off';
handles.lblNP.Visible = 'Off';
handles.popNP.Visible = 'Off';
handles.txtNCol.Visible = 'Off';
handles.txtNRow.Visible = 'Off';
handles.popNSz.Visible = 'Off';
handles.bAdd.Visible = 'Off';
handles.bRedo.Visible = 'Off';
handles.cDC.Visible = 'On';


% --- Executes on selection change in popCutF.
function popCutF_Callback(hObject, eventdata, handles)
% hObject    handle to popCutF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popCutF contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popCutF


% --- Executes during object creation, after setting all properties.
function popCutF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popCutF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cBlock.
function cBlock_Callback(hObject, eventdata, handles)
% hObject    handle to cBlock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cBlock
if hObject.Value
    handles.popTFBlock.Enable = 'On';
else
    handles.popTFBlock.Enable = 'Off';
end
    

% --- Executes on selection change in popTFBlock.
function popTFBlock_Callback(hObject, eventdata, handles)
% hObject    handle to popTFBlock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popTFBlock contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popTFBlock


% --- Executes during object creation, after setting all properties.
function popTFBlock_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popTFBlock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popFT.
function popFT_Callback(hObject, eventdata, handles)
% hObject    handle to popFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popFT contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popFT
if hObject.Value == 1
    handles.lblBO.Visible = 'Off';
    handles.popBO.Visible = 'Off';
else
    handles.lblBO.Visible = 'On';
    handles.popBO.Visible = 'On';
end

% --- Executes during object creation, after setting all properties.
function popFT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popBO.
function popBO_Callback(hObject, eventdata, handles)
% hObject    handle to popBO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popBO contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popBO


% --- Executes during object creation, after setting all properties.
function popBO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popBO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bBPF.
function bBPF_Callback(hObject, eventdata, handles)
% hObject    handle to bBPF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bBPF
%Show and hide controls
handles.pTrans.Visible = 'Off';
handles.pTF.Visible = 'On';
handles.lblCF.Visible = 'Off';
handles.popCutF.Visible = 'Off';
handles.lblFT.Visible = 'On';
handles.popFT.Visible = 'On';
handles.cBlock.Value = 0;
handles.cBlock.Visible = 'On';
handles.popTFBlock.Visible = 'On';
handles.popTFBlock.Enable = 'Off';
handles.lblBO.Visible = 'Off';
handles.popBO.Visible = 'Off';
handles.lblLHF.Visible = 'On';
handles.popLF.Visible = 'On';
handles.popHF.Visible = 'On';
handles.lblAlfa.Visible = 'Off';
handles.popAlfa.Visible = 'Off';
handles.lblHCF.Visible = 'On';
handles.lblNP.Visible = 'Off';
handles.popNP.Visible = 'Off';
handles.txtNCol.Visible = 'Off';
handles.txtNRow.Visible = 'Off';
handles.popNSz.Visible = 'Off';
handles.bAdd.Visible = 'Off';
handles.bRedo.Visible = 'Off';
handles.cDC.Visible = 'On';


% --- Executes on selection change in popLF.
function popLF_Callback(hObject, eventdata, handles)
% hObject    handle to popLF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popLF contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popLF


% --- Executes during object creation, after setting all properties.
function popLF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popLF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popHF.
function popHF_Callback(hObject, eventdata, handles)
% hObject    handle to popHF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popHF contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popHF


% --- Executes during object creation, after setting all properties.
function popHF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popHF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bBRF.
function bBRF_Callback(hObject, eventdata, handles)
% hObject    handle to bBRF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bBRF
%Show and hide controls
handles.pTrans.Visible = 'Off';
handles.pTF.Visible = 'On';
handles.lblCF.Visible = 'Off';
handles.popCutF.Visible = 'Off';
handles.lblFT.Visible = 'On';
handles.popFT.Visible = 'On';
handles.cBlock.Value = 0;
handles.cBlock.Visible = 'On';
handles.popTFBlock.Visible = 'On';
handles.popTFBlock.Enable = 'Off';
handles.lblBO.Visible = 'Off';
handles.popBO.Visible = 'Off';
handles.lblLHF.Visible = 'On';
handles.popLF.Visible = 'On';
handles.popHF.Visible = 'On';
handles.lblAlfa.Visible = 'Off';
handles.popAlfa.Visible = 'Off';
handles.lblHCF.Visible = 'On';
handles.lblNP.Visible = 'Off';
handles.popNP.Visible = 'Off';
handles.txtNCol.Visible = 'Off';
handles.txtNRow.Visible = 'Off';
handles.popNSz.Visible = 'Off';
handles.bAdd.Visible = 'Off';
handles.bRedo.Visible = 'Off';
handles.cDC.Visible = 'On';


% --- Executes on button press in bHPF.
function bHPF_Callback(hObject, eventdata, handles)
% hObject    handle to bHPF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bHPF
%Show and hide controls
handles.pTrans.Visible = 'Off';
handles.pTF.Visible = 'On';
handles.lblCF.Visible = 'On';
handles.popCutF.Visible = 'On';
handles.lblFT.Visible = 'On';
handles.popFT.Visible = 'On';
handles.cBlock.Value = 0;
handles.cBlock.Visible = 'On';
handles.popTFBlock.Visible = 'On';
handles.popTFBlock.Enable = 'Off';
handles.lblBO.Visible = 'Off';
handles.popBO.Visible = 'Off';
handles.lblLHF.Visible = 'Off';
handles.popLF.Visible = 'Off';
handles.popHF.Visible = 'Off';
handles.lblAlfa.Visible = 'Off';
handles.popAlfa.Visible = 'Off';
handles.lblHCF.Visible = 'Off';
handles.lblNP.Visible = 'Off';
handles.popNP.Visible = 'Off';
handles.txtNCol.Visible = 'Off';
handles.txtNRow.Visible = 'Off';
handles.popNSz.Visible = 'Off';
handles.bAdd.Visible = 'Off';
handles.bRedo.Visible = 'Off';
handles.cDC.Visible = 'On';


% --- Executes on button press in bHFE.
function bHFE_Callback(hObject, eventdata, handles)
% hObject    handle to bHFE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bHFE
%Show and hide controls
handles.pTrans.Visible = 'Off';
handles.pTF.Visible = 'On';
handles.lblCF.Visible = 'Off';
handles.popCutF.Visible = 'Off';
handles.lblFT.Visible = 'Off';
handles.popFT.Visible = 'Off';
handles.cBlock.Value = 0;
handles.cBlock.Visible = 'On';
handles.popTFBlock.Visible = 'On';
handles.popTFBlock.Enable = 'Off';
handles.lblBO.Visible = 'On';
handles.popBO.Visible = 'On';
handles.lblLHF.Visible = 'Off';
handles.popLF.Visible = 'Off';
handles.popHF.Visible = 'On';
handles.lblAlfa.Visible = 'On';
handles.popAlfa.Visible = 'On';
handles.lblHCF.Visible = 'On';
handles.lblNP.Visible = 'Off';
handles.popNP.Visible = 'Off';
handles.txtNCol.Visible = 'Off';
handles.txtNRow.Visible = 'Off';
handles.popNSz.Visible = 'Off';
handles.bAdd.Visible = 'Off';
handles.bRedo.Visible = 'Off';
handles.cDC.Visible = 'On';


% --- Executes on button press in bNotch.
function bNotch_Callback(hObject, eventdata, handles)
% hObject    handle to bNotch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bNotch
%Show and hide controls
handles.pTrans.Visible = 'Off';
handles.pTF.Visible = 'On';
handles.lblCF.Visible = 'Off';
handles.popCutF.Visible = 'Off';
handles.lblFT.Visible = 'Off';
handles.popFT.Visible = 'Off';
handles.cBlock.Value = 0;
handles.cBlock.Visible = 'Off';
handles.popTFBlock.Visible = 'Off';
handles.popTFBlock.Enable = 'Off';
handles.lblBO.Visible = 'Off';
handles.popBO.Visible = 'Off';
handles.lblLHF.Visible = 'Off';
handles.popLF.Visible = 'Off';
handles.popHF.Visible = 'Off';
handles.lblAlfa.Visible = 'Off';
handles.popAlfa.Visible = 'Off';
handles.lblHCF.Visible = 'Off';
handles.lblNP.Visible = 'On';
handles.popNP.Visible = 'On';
handles.txtNCol.Visible = 'On';
handles.txtNRow.Visible = 'On';
handles.popNSz.Visible = 'On';
handles.bAdd.Visible = 'On';
handles.bRedo.Visible = 'On';
handles.popCutF.Visible = 'Off';
handles.popFT.Visible = 'Off';
handles.popLF.Visible = 'Off';
handles.cDC.Visible = 'Off';


% --- Executes on selection change in popAlfa.
function popAlfa_Callback(hObject, eventdata, handles)
% hObject    handle to popAlfa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popAlfa contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popAlfa


% --- Executes during object creation, after setting all properties.
function popAlfa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popAlfa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popNP.
function popNP_Callback(hObject, eventdata, handles)
% hObject    handle to popNP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popNP contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popNP
%get info from previous points
if hObject.Value == 1
    handles.bAdd.Enable = 'On';     %add more points
else                                %recover points info
    handles.txtNCol.String = num2str(handles.bAdd.UserData.X(hObject.Value-1));
    handles.txtNRow.String = num2str(handles.bAdd.UserData.Y(hObject.Value-1));
    nums = str2num(char(handles.popNSz.String));
    index = find(nums == handles.bAdd.UserData.R(hObject.Value-1));
    handles.popNSz.Value = index(1);
end

% --- Executes during object creation, after setting all properties.
function popNP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popNP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtNCol_Callback(hObject, eventdata, handles)
% hObject    handle to txtNCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtNCol as text
%        str2double(get(hObject,'String')) returns contents of txtNCol as a double


% --- Executes during object creation, after setting all properties.
function txtNCol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtNCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtNRow_Callback(hObject, eventdata, handles)
% hObject    handle to txtNRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtNRow as text
%        str2double(get(hObject,'String')) returns contents of txtNRow as a double


% --- Executes during object creation, after setting all properties.
function txtNRow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtNRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popNSz.
function popNSz_Callback(hObject, eventdata, handles)
% hObject    handle to popNSz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popNSz contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popNSz


% --- Executes during object creation, after setting all properties.
function popNSz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popNSz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0, ...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bAdd.
function bAdd_Callback(hObject, eventdata, handles)
% hObject    handle to bAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
x = str2double(handles.txtNCol.String); % [100  125];	
y = str2double(handles.txtNRow.String); %  [112 112];
r = str2double(handles.popNSz.String(handles.popNSz.Value)); %  [10 10];
hMain = findobj('Tag','Main');              %get the handle of Main form
if ~isempty(hMain)
    hNfig = get(hMain,'UserData');          %get last image handle
    if strcmp(hNfig.UserData,'NO')
        %show Error info
        errordlg('Selected image does not contain transform information.',...
            'Transforms Error', 'modal');
    else
        [row, col, ~] = size(hNfig.UserData.cvipIma);
        %check object sizes
        if (x-r) < 1 || (x+r) > col || (y-r) < 1 || (y+r) > row
            %show Error info
            errordlg('Provided radius exceeds image dimensions.', ...
                'Transforms Error', 'modal');
        else        %add point
            if strcmp(hObject.UserData,'NO') %start Notch points storage
                hObject.UserData = struct('X',{x},'Y',{y},'R',{r}); %structure for zones
                handles.popNP.UserData = 2;
                handles.popNP.String(handles.popNP.UserData,1) = '1';
                handles.popNP.Value = handles.popNP.UserData;
            else
                hObject.UserData.X = [hObject.UserData.X x];
                hObject.UserData.Y = [hObject.UserData.Y y];
                hObject.UserData.R = [hObject.UserData.R r];
                handles.popNP.UserData = handles.popNP.UserData + 1;
                handles.popNP.String(handles.popNP.UserData,1) = num2str(...
                    handles.popNP.UserData - 1);
                handles.popNP.Value = handles.popNP.UserData;
            end
            hObject.Enable = 'Off';
        end
    end
end 


% --- Executes on button press in bRedo.
function bRedo_Callback(hObject, eventdata, handles)
% hObject    handle to bRedo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.bAdd.UserData = 'NO';
handles.popNP.Value = 1;
handles.popNP.String = '(New)';
handles.txtNCol.String = '0';
handles.txtNRow.String = '0';
handles.popNSz.Value = 7;
handles.bAdd.Enable = 'On';


% --------------------------------------------------------------------
function mFile_Callback(hObject, eventdata, handles)
% hObject    handle to mFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
function mView_Callback(hObject, eventdata, handles)
% hObject    handle to mView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mComp_Callback(hObject, eventdata, handles)
% hObject    handle to mComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mComp_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mCpre_Callback(hObject, eventdata, handles)
% hObject    handle to mCpre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mCpre_Callback',hObject,eventdata,guidata(hObject))

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
CVIPToolbox('mClossy_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mCpost_Callback(hObject, eventdata, handles)
% hObject    handle to mCpost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mCpost_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mVfi_Callback(hObject, eventdata, handles)
% hObject    handle to mVfi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mVfi_Callback',hObject,eventdata,guidata(hObject));

% --------------------------------------------------------------------
function mViHis_Callback(hObject, eventdata, handles)
% hObject    handle to mViHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mViHis_Callback',hObject,eventdata,guidata(hObject));

% --------------------------------------------------------------------
function mVhisto_Callback(hObject, eventdata, handles)
% hObject    handle to mVhisto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mVhisto_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mVSpec_Callback(hObject, eventdata, handles)
% hObject    handle to mVSpec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mVSpec_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mVBand_Callback(hObject, eventdata, handles)
% hObject    handle to mVBand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mVBand_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mVBred_Callback(hObject, eventdata, handles)
% hObject    handle to mVBred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mVBred_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mVBgre_Callback(hObject, eventdata, handles)
% hObject    handle to mVBgre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mVBgre_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mVBlue_Callback(hObject, eventdata, handles)
% hObject    handle to mVBlue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mVBlue_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mVsfftp_Callback(hObject, eventdata, handles)
% hObject    handle to mVsfftp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mVsfftp_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mVsfftm_Callback(hObject, eventdata, handles)
% hObject    handle to mVsfftm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mVsfftm_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mVsLog_Callback(hObject, eventdata, handles)
% hObject    handle to mVsLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mVsLog_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mVvimaHis_Callback(hObject, eventdata, handles)
% hObject    handle to mVvimaHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mVvimaHis_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mVsaveHis_Callback(hObject, eventdata, handles)
% hObject    handle to mVsaveHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mVsaveHis_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mVsLall_Callback(hObject, eventdata, handles)
% hObject    handle to mVsLall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mVsLall_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mVsLred_Callback(hObject, eventdata, handles)
% hObject    handle to mVsLred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mVsLred_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mVsLgre_Callback(hObject, eventdata, handles)
% hObject    handle to mVsLgre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mVsLgre_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mVsLblu_Callback(hObject, eventdata, handles)
% hObject    handle to mVsLblu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mVsLblu_Callback',hObject,eventdata,guidata(hObject))

% --- Executes on key press with focus on popNSz and none of its controls.
function popNSz_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popNSz (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);        %call function to add user data


% --- Executes on key press with focus on popAlfa and none of its controls.
function popAlfa_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popAlfa (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);        %call function to add user data


% --- Executes on key press with focus on popHF and none of its controls.
function popHF_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popHF (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);        %call function to add user data


% --- Executes on key press with focus on popLF and none of its controls.
function popLF_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popLF (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);        %call function to add user data


% --- Executes on key press with focus on popBO and none of its controls.
function popBO_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popBO (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);        %call function to add user data


% --- Executes on key press with focus on popTFBlock and none of its controls.
function popTFBlock_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popTFBlock (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

pop_add_cvip(hObject, eventdata);        %call function to add user data


% --- Executes on key press with focus on popCutF and none of its controls.
function popCutF_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popCutF (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);        %call function to add user data


% --- Executes on key press with focus on popWDec and none of its controls.
function popWDec_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popWDec (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);        %call function to add user data


% --- Executes on key press with focus on popBlock and none of its controls.
function popBlock_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popBlock (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
pop_add_cvip(hObject, eventdata);       %call function to add user data


% --- Executes on button press in cPIma.
function cPIma_Callback(hObject, eventdata, handles)
% hObject    handle to cPIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cPIma
if hObject.Value        %hide and show text with function description
    handles.text12.Visible = 'On';
else
    handles.text12.Visible = 'Off';
end


% --- Executes on button press in cMIma.
function cMIma_Callback(hObject, eventdata, handles)
% hObject    handle to cMIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cMIma
if hObject.Value        %hide and show text with function description
    handles.text13.Visible = 'On';
    handles.bItrans.Visible = 'On';
else
    handles.text13.Visible = 'Off';
    handles.bItrans.Visible = 'Off';
end


% --- Executes on button press in cDC.
function cDC_Callback(hObject, eventdata, handles)
% hObject    handle to cDC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cDC


% --- Executes on button press in bFFTp.
function bFFTp_Callback(hObject, eventdata, handles)
% hObject    handle to bFFTp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bFFTp
