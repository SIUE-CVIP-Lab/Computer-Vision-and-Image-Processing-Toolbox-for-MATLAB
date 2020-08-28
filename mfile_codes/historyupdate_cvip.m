function newhisto = historyupdate_cvip(oldhisto, histo)
% UPDATEHIST_CVIP- Updates image's history with the new performed operation
% The function puts the new operation in the last row of the history data
%
%  See also, historydeco_cvip, vipmread2_cvip, vipmwrite2_cvip,
%  vipmwrite_cvip, vipmread_cvip, btcdeco_cvip, btcenco_cvip,
%
% Reference 
% ---------
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications 
%     with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Julian Rene Cuellar Buritica
%           Initial coding date:    09/28/2018
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     09/28/2018
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.1  09/28/2018  15:23:31  jucuell
 % Initial revision: function creation and initial testing in geometry
 % operations
 % 
%
    %check if operation is first element in history
    if isempty(oldhisto) || strcmp(oldhisto,'none')
        %history with 1 operation and 9 parameters
        newhisto = zeros(size(histo,1),10);     
        for i=1:size(histo,1)
            newhisto(i,1:size(histo,2)) = histo(i,:);
        end
    else
        %add a new history vector
        newhisto = zeros(size(oldhisto,1)+size(histo,1),10);
        newhisto(1:end-size(histo,1),1:size(oldhisto,2)) = oldhisto;
        for i=1:size(histo,1)
            newhisto(i+size(oldhisto,1),1:size(histo,2)) = histo(i,:);
        end
    end

end