function out_mat = iwavdaub4_cvip( img,dec )
% IWAVDAUB4_CVIP - perform inverse wavelet transform based on Daubechies wavelet.
%
% Syntax :
% ------
% out_mat = iwavdaub4_cvip( img, dec )
%
% Input Parameters Include :
% ------------------------
%
%  'img'           The wavlet image which is grayscale or RGB depending on
%                   the original image.
%
%  'dec'           The decomposition level. The same value as the forward
%                   transform must be used.
%                   An integer greater than or equal to 1.
%
% Output Parameter Include :
% -------------------------
%
%  'out_mat'       The inverse wavelet transform of the _img_ using Daubechies 4
%                   wavelet coefficients. Is an image of type double.
%                   
% Example :
% -------
%                     a = imread('butterfly.tif');
%                     b = double(a);
%                     dec = 2;
%                     w = wavdaub4_cvip(b,dec);
%                     S = log(1+abs(w));    % This is a good way to remap
%                     S = remap_cvip(S);      % the output of most of the  
%                     figure;imshow(a);title('Input Image');
%                     figure;imshow(S,[]);title('Output image after wavdaub4 transform')  % tranforms for display. 
%                     out_mat= iwavdaub4_cvip(w,dec);
%                     figure; imshow(hist_stretch_cvip(out_mat,0,1,0,0),[]);title('Output image after inverse wavdaub4 transform');    % b
%                     % is of type double, so it requires histstretch_cvip for
%                     % remapping.
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    6/3/2017
%           Latest update date:     6/9/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

[~,~,d] = size(img);
out_mat = zeros(size(img));
for band=1:d
    x= img(:,:,band);
    [m,n,~] = size(x);
    m= m/ (2^(dec));
    n = n/ (2^(dec));

    for i=1:dec
        m = m*2;
        n = n*2;
        xx = x(1:m,1:n);
    %     hor = one_level_wav(x);
    %     y = one_level_wav(hor.').';
        ver = one_level_iwd(xx.');
        y = one_level_iwd(ver.');

        x(1:m,1:n) = y;


    end
    out_mat(:,:,band) = x;

end

end


function old = one_level_iwd(x)
p0 = (1+sqrt(3))/4;
p1 = (3+sqrt(3))/4;
p2 = (3-sqrt(3))/4;
p3 = (1-sqrt(3))/4;

[~,siz,~] = size(x);

    old = x(:,1:siz);
    sum_old = old(:,1:siz/2);
    diff_old = old(:,siz/2 + 1:end);
    
    alr = [sum_old(:,end) sum_old];
    alr = alr(:,1:end-1);
    
    bll = [diff_old diff_old(:,1)];
    bll = bll(:,2:end);
    
    

    
    old(:,1:2:siz-1) = p0*sum_old + p1*diff_old + p2*alr + p3*bll;
    old(:,2:2:siz) = p1*sum_old + (-p0)*diff_old + p3*alr + (-p2)*bll;
    
%     old(:,1:2:siz-1) = p1*sum_old + (-p0)*diff_old + p3*alr + (-p2)*bll;
%     old(:,2:2:siz) = p0*sum_old + p1*diff_old + p2*alr + p3*bll;
    

end