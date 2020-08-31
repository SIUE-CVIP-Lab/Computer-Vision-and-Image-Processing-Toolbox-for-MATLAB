function hObject = pop_add_cvip(hObject, eventdata)
%POP_ADD_CVIP Lets the user to type any new value into a pop-up menu on the
%current CVIP GUI. The function takes the Object handle (hObject) and the
%data about the event (eventdata) and according to it adds new data into 
%the pop-up menu. Must be called on function _KeyPressFcn(hObject, ...)
%
% Syntax :
% -------
% handle = pop_add_cvip(hObject, eventdata)
%   
% 
% Input Parameters include :
% ------------------------
%         hObject   handle of the pop-up menu.
%         eventdata data information about the generated event.
%
%
% Output Parameter include :  
% ------------------------
%         hObject   Modified handle information to perform the add function.
%                                         
%
% Example :
% -------
%               %Here we use the callback KeyPressFcn on Mypopup uicontrol
%               %to call the function that enables user type a new value
%
%               function MyPopup_KeyPressFcn(hObject, eventdata, handles)
%               % hObject    handle to MyPopup (see GCBO)
%               pop_add_cvip(hObject, eventdata); %call function to add user data
%
% Reference
% ---------
%  1.Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications 
%  with MATLAB and CVIPtools, 3rd Edition. 

%==========================================================================
%
%           Author:                 Julian Rene Cuellar Buritica
%           Initial coding date:    04/01/2018
%           Latest update date:     09/05/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIPtools Matlab GUI, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.3  10/15/2018  16:42:20  jucuell
 % Include the dot (.) to be a valid character for use as decimal entry
%
 % Revision 1.2  09/05/2018  17:37:58  jucuell
 % start adding revision history. debugging creation of new rows in popup
 % menu and stopping adding info when enter or another key pressed
%
 % Revision 1.1  04/03/2018  09:52:02  jucuell
 % Initial revision: adding more information to popup menus
 % 
%
if ~isempty(hObject.UserData)% && ismember(eventdata.Character, '1234567890')
    if ismember(eventdata.Character, '1234567890.-')
        if hObject.UserData.Edo == 0   %No new data
            hObject.String{hObject.UserData.Pos}=eventdata.Character;
            hObject.UserData.Value = eventdata.Character;
            hObject.UserData.Edo = 1;
        else
            hObject.UserData.Value = [hObject.UserData.Value eventdata.Character];
            hObject.String{end}=hObject.UserData.Value;
        end
        hObject.Value = hObject.UserData.Pos;
    %restart when enter key
    elseif strcmp(eventdata.Key,'return') || strcmp(eventdata.Key,'shift')
        hObject.UserData.Edo = 0;
        hObject.UserData.Value = '';
    elseif strcmp(eventdata.Key,'backspace')
        siza=size(hObject.UserData.Value);
        if siza(2) > 0
            hObject.String{end}=hObject.String{end}(end,1:siza(2)-1);
            hObject.UserData.Value = hObject.String{end};    
        end
    else                            %different key pressed restart
        hObject.UserData.Edo = 0;
        hObject.UserData.Value = '';
    end
else
    %create event structure
    if ismember(eventdata.Character, '1234567890.')
        Siza = size(hObject.String,1)+1;
        hObject.UserData = struct('Edo',1,'Value',eventdata.Character,'Pos',Siza);
        hObject.String{Siza}=eventdata.Character;
        hObject.UserData.Pos = Siza;
    end
end