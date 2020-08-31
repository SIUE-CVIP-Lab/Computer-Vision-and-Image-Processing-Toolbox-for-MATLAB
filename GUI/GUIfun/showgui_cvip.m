function hFig=showgui_cvip(Ima, Name)
%SHOWGUI_CVIP- Shows a new image on the CVIP Toolbox GUI interface. 
%The function takes an Image, extracts its size information, puts a title
%and adds the image to the current GUI group.
%
% Syntax :
% -------
% h = show_guIma(Ima, Name)
%   
% 
% Input Parameters include :
% ------------------------
%         Ima       Source image to show. 1-band input image of MxN size 
%                   or 3-band input image of MxNx3 size. 
%         Name      Name to show on Image tab.
%
%
% Output Parameter include :  
% ------------------------
%         hGeo      Output handle of operation.
%                                         
%
% Example :
% -------
%                   Ima = input_image();            %open an image
%                   Name = 'Selected Input Image';  %output image name
%                   hFig = showgui_cvip(Ima, Name); %open image in image
%                                                   %viewer
%
% Reference
% ---------
%  1.Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
%  with MATLAB and CVIPtools, 3rd Edition. 

%==========================================================================
%
%           Author:                 Julian Rene Cuellar Buritica
%           Initial coding date:    01/23/2018
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     09/28/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.3  05/25/2019  16:53:31  jucuell
 % menus updating is done by calling the update menus function in the
 % CVIPtoolbox.m file
%
 % Revision 1.2  09/28/2018  17:18:50  jucuell
 % rename from show_guIma to showgui_cvip, modification to handle image
 % structure and to visualize all data type as byte on screen
%
 % Revision 1.1  11/21/2017  15:23:31  jucuell
 % Initial revision:
 % 
%

warning ('off','all');

%image data structure
%Params = parameters scalar or array, Function performed and Image Data
% Stru = struct('Params',{Param},'Function',{Func},'Data',{Data});

hFig=NewFig;                                %call new figure form
hFig.WindowStyle = 'normal';                %set initial window style
set(gcf,'Name',Name,'NumberTitle','off')    %name figure
hFig.UserData = Ima;                       %storage image info

OutIma = Ima.cvipIma;
%check for transform info
trans = Ima.fInfo.history_info(end,1);
%info trans 212 to 218 and 225 to 234
if trans > 210 && trans < 219 || trans > 224 && trans < 236 || trans == 244
   
    if trans == 213
        OutIma = uint8(relative_remap_cvip(OutIma, [0 255]));
    elseif trans == 244
        OutIma = logremap_cvip((OutIma));
    else
        OutIma = logremap_cvip(abs(OutIma));    %log remap tranform info for phase magnitude only image better without abs
    end
    imshow((OutIma));
else
    if isa(OutIma, 'double') && max(OutIma(:)) > 50 && max(OutIma(:)) < 255 && min(OutIma(:)) >= 0
        OutIma = uint8(OutIma);
    elseif isa(OutIma, 'double') && max(OutIma(:)) <= 1 && min(OutIma(:)) >= 0
        OutIma = uint8(OutIma*255);
    elseif isa(OutIma,'logical')
        OutIma = uint8(OutIma.*255);
    elseif isa(OutIma, 'double') 
        OutIma = uint8(relative_remap_cvip(OutIma, [0 255]));
    elseif isa(OutIma, 'uint8') && min(OutIma(:)) > 200
        OutIma = remap_cvip(OutIma, [0 255]);
    else
        OutIma = uint8(OutIma);  
    end
    imshow(OutIma)                          %show image original colors
end
axis('off');
hMain = findobj('Tag','Main');              %get the handle of Main form
if ~isempty(hMain)
    hNfig = get(hMain,'UserData');          %get last image handle
    if hNfig ~= 0                           %check if there is a prev Ima
        figure(hNfig);                      %focus to last image
    end
end 
                
CVIPToolbox('updatemenus');                 %call function to update
%Add figure to group
group = setfigdocked('GroupName','CVIP Toolbox V.3.6','Figure',hFig); 
figure(hFig);                               %focus to new image