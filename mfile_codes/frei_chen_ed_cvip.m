function [ M , cos_theta] = frei_chen_ed_cvip( input_img, subspace )
% FREI_CHEN_ED_CVIP - performs edge detection on the input image with masks, in which masks 
% are unique they form a complete set of basis vectors.Any 3*3 subimage
% can be represented as a weighted sum of the nine Frei-chen masks.
% These weights are found by projecting 3*3 subimage on to each of these masks.
% 
% Frie-chen masks can be grouped in to a set of four masks for an edge
% subspace,four masks for a line subspace,and one mask for an average subspace.
% These subspaces can be broken down in to gradient,ripple,line and laplacian subspace.
%
% Syntax :
% -------
%  [ M , cos_theta] = frei_chen_ed_cvip( input_img, subspace )
%
% Input parameters include :
% ------------------------
%             'input_img'        The input image. Can be multiband.
%
%              'subspace'       '1' for edge subspace.
%                               '2' for line subspace.
%                               '3' for average subspace.
%
%
% output Parameters include :
% -------------------------
%
%  [ M , cos_theta]     output image after  frei_chen edge detection.
%
% Example :
% -------
%          input_img = imread('butterfly.tif');
%         [ M, cos_th ] = frei_chen_ed_cvip( input_img, 1 );
%         [ M, cos_th ] = frei_chen_ed_cvip( input_img, 2 );
%         [ M, cos_th ] = frei_chen_ed_cvip( input_img, 3 );
%         figure;imshow(input_img);title('Input Image');
%         figure; imshow(remap_cvip(M ),[]);title('Output Image after frei chen edge detection');
%         figure; imshow(remap_cvip(cos_th ));title('Output Image after frei chen edge detection');
% 
%         
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    7/11/2017
%           Latest update date:     7/14/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================
    [m,n,d] = size(input_img);
    cos_theta = zeros(m,n,d);
    M = zeros(m,n,d);
    for k=1:d
        I = double(input_img(:,:,k));
        I_Ts = proj_frei(I);
        [M(:,:,k),cos_theta(:,:,k)] = extract_sub(I_Ts, subspace);
    end
end

function I_frei = proj_frei(I)
% returns the projection image of I into the 9 subspaces of frei-chen
% I is assumed to be one band image
% I_frei is of size:  m x n x 9

%% Definition of the Base vectors
band = 1;
r= sqrt(2);
Frei_chen_Base(:,:,1) = (0.5/r)*[1  r  1;
                         0  0  0;
                         -1 -r -1];
                     
Frei_chen_Base(:,:,2) = (0.5/r)*[1  0  -1;
                                 r  0  -r;
                                 1  0  -1];
                             
Frei_chen_Base(:,:,3) = (0.5/r)*[0  -1  r;
                                 1   0  -1;
                                 -r  1  0];
                             
                             
                             
Frei_chen_Base(:,:,4) = (0.5/r)*[r  -1  0;
                                 -1  0  1;
                                 0   1 -r];
                             
Frei_chen_Base(:,:,5) = (0.5)*[0   1  0;
                                 -1  0 -1;
                                 0   1 0];
                             
Frei_chen_Base(:,:,6) = (0.5)*[-1  0  1;
                                0  0  0;
                                1  0 -1];
                             
                            
                            
Frei_chen_Base(:,:,7) = (1/6)*[1  -2  1;
                               -2  4  -2;
                                1 -2  1];                             
                             
                           
Frei_chen_Base(:,:,8) = (1/6)*[-2  1  -2;
                                1  4  1;
                                -2 1 -2];
                             
Frei_chen_Base(:,:,9) = (1/3)*[1  1  1;
                             1  1  1;
                             1  1 1];
                     
[m,n,~] = size(I);



%% Compute the inner product
I_NW = I([1,1:m-1],[1,1:n-1],band);
I_W = I(:,[1,1:n-1],band);
I_SW = I([2:m,m],[1,1:n-1],band);
I_S = I([2:m,m],:,band);
I_SE = I([2:m,m],[2:n,n], band);
I_E = I(:,[2:n,n], band);
I_NE = I([1,1:m-1],[2:n,n], band);
I_N = I([1,1:m-1],:, band);

I_frei = zeros(m,n,9);
for dim=1:9;
    Base = Frei_chen_Base(:,:,dim);
    I_frei(:,:,dim) = Base(1,1)*I_NW + Base(2,1)*I_W + Base(3,1)*I_SW + Base(3,2)*I_S + Base(3,3)*I_SE + Base(2,3)*I_E + Base(1,3)*I_NE + Base(1,2)*I_N + Base(2,2)*I(:,:,band);
end

end

function [M, cos_theta] = extract_sub(I_frei_chen, choice)

    I_s = I_frei_chen.^2;
    S = sum(I_s ,3);
    switch choice
        case 1  % edge sub
            M = I_s(:,:,1) + I_s(:,:,2) + I_s(:,:,3) + I_s(:,:,4);
            cos_theta = sqrt(M./S);
            
        case 2  % line sub
            M = I_s(:,:,5) + I_s(:,:,6) + I_s(:,:,7) + I_s(:,:,8);
            cos_theta = sqrt(M./S);
            
        case 3  % max
            M1 = I_s(:,:,1) + I_s(:,:,2) + I_s(:,:,3) + I_s(:,:,4);
            cos_theta1 = sqrt(M1./S);

            M2 = I_s(:,:,5) + I_s(:,:,6) + I_s(:,:,7) + I_s(:,:,8);
            cos_theta2 = sqrt(M2./S);

            cos_theta = max(cos_theta2,cos_theta1);
            M = max(M1,M2);

    end
    
end