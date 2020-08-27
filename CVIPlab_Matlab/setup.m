function setup()
    [CVIP_root_path,~] = fileparts(mfilename('fullpath'));
    
    addpath(fullfile(CVIP_root_path));
    addpath(fullfile(CVIP_root_path,'CVIP-Toolbox_resources'));
    addpath(fullfile(CVIP_root_path,'CVIPlab_Matlab'));
    addpath(fullfile(CVIP_root_path,'images'));
    addpath(fullfile(CVIP_root_path,'mFiles'));
    
    %create the search database or index for documentation
    builddocsearchdb(fullfile(CVIP_root_path,'mFiles','html'));
    %displays message
    disp('Congratulations!!! CVIP Toolbox is ready to be used.');

end