function group = setfigdocked(varargin)
%   SETFIGDOCKED docks figures at specified positions in group of figures whose
%   structure is defined by parameters GridSize, Spanned Cells, ...
%   This function also allows maximizing and docking groups into MATLAB desktop
%
%   This function runs on MATLAB 7.1 sp3 or higher
%
%   group = setfigdocked('PropertyName1',value1,'PropertyName2',value2,...)
%   PropertyName:
%       - GroupName     name of group need to be generated
%       - GridSize      scalar or vector quantity, defines number of rows
%                       and columns of cell in group
%       - SpanCell      vector or matrix quantity, size n x 4,
%                       [row col occupiedrows occupiedcols]
%                       build an cell at the position (row, col) in group
%                       cell (GridSize) which occupies "occupiedrows"
%                       rows and "occupiedcols" columns
%       - Figure        handle of figure
%       - Figindex      index position of figure in group cell
%       - Maximize      0/1
%       - GroupDocked   0/1
%
%   Examples:
%      Example 1:
%           %creates empty group 'Group of Images'with 2 rows and 3 columns
%           group = setfigdocked('GroupName','Group of Images','GridSize',[2 3]);
%           im1 = imread('cameraman.tif');
%           imshow(im1)
%           group = setfigdocked('GroupName','Group of Images','Figure',gcf);
%           figure; imhist(im1)
%           group = setfigdocked('GroupName','Group of Images','Figure',gcf,'Figindex',4);
%
%           im2 = imread('rice.png');
%           figure; imshow(im2)
%           group = setfigdocked('GroupName','Group of Images','Figure',gcf,'Figindex',2);
%           figure; imhist(im2)
%           group = setfigdocked('GroupName','Group of Images','Figure',gcf,'Figindex',5);
%
%           im3 = imread('eight.tif');
%           figure; imshow(im3)
%           group = setfigdocked('GroupName','Group of Images','Figure',gcf,'Figindex',3);
%           figure; imhist(im3)
%           group = setfigdocked('GroupName','Group of Images','Figure',gcf,'Figindex',6);
%
%
%      Example 2:
%          group = setfigdocked('GroupName','Image and Edges','GridSize',3,'SpanCell',[1 2 2 2]);
%          im1 = imread('cameraman.tif');
%          figure;imshow(im1);set(gcf,'Name','Cameraman','NumberTitle','off')
%          group = setfigdocked('GroupName','Image and Edges','Figure',gcf,'Figindex',2);
%
%          figure; edge(im1,'prewitt');set(gcf,'Name','Prewitt method','NumberTitle','off')
%          group = setfigdocked('GroupName','Image and Edges','Figure',gcf,'Figindex',1);
%
%          figure; edge(im1,'roberts');set(gcf,'Name','Roberts method','NumberTitle','off')
%          group = setfigdocked('GroupName','Image and Edges','Figure',gcf,'Figindex',3);
%
%          figure; edge(im1,'roberts');set(gcf,'Name','Roberts method','NumberTitle','off')
%          group = setfigdocked('GroupName','Image and Edges','Figure',gcf,'Figindex',4);
%
%          figure; edge(im1,'roberts');set(gcf,'Name','Roberts method','NumberTitle','off')
%          group = setfigdocked('GroupName','Image and Edges','Figure',gcf,'Figindex',5);
%
%          figure; edge(im1,'canny');set(gcf,'Name','Canny Method','NumberTitle','off')
%          group = setfigdocked('GroupName','Image and Edges','Figure',gcf,'Figindex',6);
%
%          group = setfigdocked('GroupName','Image and Edges','Maximize',1,'GroupDocked',0);

%
% The author does not accept any responsibility or liability for loss
% or damage occasioned to any person or property through using function,instructions,
% methods or ideas contained herein, or acting or refraining from acting
% as a result of such use. The author expressly disclaim all implied warranties,
% including merchantability or fitness for any particular purpose. There will be
% no duty on the author to correct any errors or defects in the function.
% This function and the documentation are the property of the author and should only
% be used for scientific and educational purposes. All software is provided free and
% it is not supported. The author is, however, happy to receive comments,
% criticism and suggestions to phan@brain.riken.jp

% Programmed and Copyright by Phan Anh Huy
% phan@brain.riken.jp
% $Date: 24/12/2007
% Revision: 14/02/2012
%           23/07/2012, fix error caused by empty jpanel 
%           "Attempt to reference field of non-structure array." 
%
% Note: use "drawnow" before calling setfigdocked to avoid docking empty figure.

%%
dbstop if warning
import java.awt.*;
import java.awt.event.*;
import java.io.IOException;

%% get parameters
[regargs, proppairs]=parseparams(varargin);

invars = proppairs(1:2:end);
listvar = {'figure','groupname', 'gridsize' ,'spancell','figindex','maximize' 'groupdocked';
    'fig' ,'groupname','gridsize','posarr','figind','maximizeflag','grpdockflag'};

for k = 1: numel(invars)
    varind = find(~cellfun(@isempty,strfind(listvar(1,:),lower(invars{k}))));
    if ~isempty(varind)
        eval(sprintf('%s = proppairs{2*%d};',listvar{2,varind},k));
    end
end

%%
desktop = com.mathworks.mde.desk.MLDesktop.getInstance;

%%
if (exist('groupname','var')~=1) || isempty(groupname)
    groupname = 'MyGroup';
end
% if ~desktop.hasGroup(groupname)
group = desktop.addGroup(groupname);    % add new group

% end
desktop.showGroup(groupname,1);
while ~desktop.isGroupShowing(groupname), end

if (exist('grpdockflag','var')==1)
    try
        javaMethod('setGroupDocked',desktop,groupname,grpdockflag)
    catch
        desktop.setGroupDocked(groupname,grpdockflag)
    end
end

%% Set gridsize and spanning
try
    jpanel = [];
    while isempty(jpanel)
        jpanel = javaMethod('getGroupContainer',desktop,groupname);
    end
catch me
    while 1
        jpanel = desktop.getGroupContainer(groupname);
        pause(0.1);
        if isa(jpanel,'com.mathworks.widgets.desk.DTDocumentContainer') || ...
                isa(jpanel,'com.mathworks.mwswing.desk.DTDocumentContainer')
            break
        end
    end
end

%tilepane = jpanel.getComponent(1) ; %% com.mathworks.widgets.desk.DTTiledPane
tilepane = findjobj(jpanel,'Name','DesktopTiledPane');

if (exist('gridsize','var')==1) && ~isempty(gridsize)
    if numel(gridsize) ==1
        gridsize(2) = gridsize(1);
    end
    % check com.mathworks.widgets.desk.DTTiledPane
    if ~isa(tilepane,'com.mathworks.widgets.desk.DTTiledPane') && ...
            ~isa(tilepane,'com.mathworks.mwswing.desk.DTTiledPane')
        try
            grpframe = javaMethod('getInternalFrame',group);
        catch
            grpframe = group.getInternalFrame;
        end
        
        %TopBottomButton = findjobj(grpframe,'property',{'Name','SplitTopBottomButton'});
        TopBottomButton = findjobj(grpframe,'Name','SplitTopBottomButton');
        
        TopBottomButton.setMnemonic('A');
        robot = Robot;
        grpdockflag =desktop.isGroupDocked(groupname);
        if grpdockflag
            desktop.setGroupDocked(groupname,0);
        end
        
        while 1
            dbstop if error 
            jpanel.requestFocus(true);     % Focus on Dock
            
            robot.setAutoDelay(50);
            robot.keyPress(KeyEvent.VK_ALT);
            robot.setAutoDelay(50);
            robot.keyPress(KeyEvent.VK_A);
            robot.setAutoDelay(50);
            robot.keyRelease(KeyEvent.VK_A);
            robot.setAutoDelay(50);
            robot.keyRelease(KeyEvent.VK_ALT);
            robot.setAutoDelay(100);
            pause(0.3)
            tilepane = jpanel.getComponent(1) ; %% com.mathworks.widgets.desk.DTTiledPane
            if isa(tilepane,'com.mathworks.widgets.desk.DTTiledPane') || ...
                    isa(tilepane,'com.mathworks.mwswing.desk.DTTiledPane')
                break
            end
        end
        if grpdockflag
            desktop.setGroupDocked(groupname,1);
        end
    end
    if isa(tilepane,'com.mathworks.widgets.desk.DTTiledPane') || ...
            isa(tilepane,'com.mathworks.mwswing.desk.DTTiledPane')
        while 1
            try
                javaMethod('setGridSize',tilepane,java.awt.Dimension(gridsize(2),gridsize(1)));
            catch
                tilepane.setGridSize(java.awt.Dimension(gridsize(2),gridsize(1)));
            end
            pause(0.1)
            dim = tilepane.getGridSize;
            if (dim.width == gridsize(2)) && (dim.height == gridsize(1))
                break
            end
        end
        
        %% spanning cells
        if (exist('posarr','var')==1) && ~isempty(posarr)
            for pos = posarr'
                pos(1:2) = pos(1:2)-1;
                if pos(3)>1
                    for k = 1:pos(4)
                        tilepane.setRowSpan(pos(1),pos(2)+k-1,pos(3)) %span row
                        pause(0.3)
                    end
                end
                tilepane.setColumnSpan(pos(1),pos(2),pos(4))    %% span column
                jpanel.updateUI;pause(0.3)
            end
        end
        tilepane.setCloseButtonsEnabled(0)      %
    end
    %%
end
%%
if (exist('maximizeflag','var')==1) && maximizeflag==1
    try
        desktop.setGroupMaximized(groupname,1)  % maximize group
    catch
        group.getInternalFrame.getTopLevelAncestor.setMaximized(1);
    end
end
%% add figure
if (exist('figind','var')==1) && ~isempty(figind)
    if isa(tilepane,'com.mathworks.widgets.desk.DTTiledPane') || ...
            isa(tilepane,'com.mathworks.mwswing.desk.DTTiledPane')
        %jpanel.requestFocus(true);     % Focus on Dock
        while ~isempty(javaMethodEDT('getComponentInTile',tilepane,(figind-1)))
            tilepane.remove(figind-1);
            pause(0.1)
        end
        while (tilepane.getSelectedTile ~= (figind-1))      
            tilepane.setSelectedTile(figind-1);
            pause(0.1);
        end
    end
end
% fig = figure;
if (exist('fig','var')==1) && ~isempty(fig)
    warning('off')
    set(get(fig,'javaframe'), 'GroupName',groupname);
    warning('on')
    set(fig,'WindowStyle','docked');
end

%%
try
    jpanel.updateUI;
catch
end


function obj = findjobj(parent,field,value)
obj = [];
try
    comp = parent.getComponents;
    for k = 1:numel(comp)
        if isequal(get(comp(k),field),value)
            obj = comp(k);
            break
        else
            obj = findjobj(comp(k),field,value);
            if ~isempty(obj)
                break
            end
        end
    end
catch
end