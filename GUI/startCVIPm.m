%Scrip to start CVIPTools Matlab
warning ('off','all');
clear all;
clc
%Call CVIPToolbox figure and get its handle
h = CVIPToolbox;
%Dock menu on empty frame
group = setfigdocked('GroupName','CVIP Toolbox V.3.5','Figure',h, ...
    'Maximize', 0, 'GroupDocked', 0);
clear;