function [FOMR, FOMG, FOMB] = pratt_merit_cvip( Ideal_img, I2, scale_factor )
% PRATT_MERIT_CVIP - calculates  the pratt figure of merit for two binary images .
%
% Syntax :
% -------
%  [ FOM ] = pratt_merit_cvip( Ideal_img, I2, scale_factor )
%  [ FOMR, FOMG, FOMB ] = pratt_merit_cvip( Ideal_img, I2, scale_factor )
%
% Input Parameters include :
% ------------------------
%
%  Ideal_img:      The ideal edge map obtained by one of the 
%                       well known methods.
% 
%  I2:             Another edge map of the same image.
% 
%  scale_factor:   The scale factor \alpha in the formula of Pratt FOM.
%
%
% Output Parameters include :
% ------------------------
%       
%  FOM:            The Pratt's Figure of Merit. A number in the range
%                  [0,1] where 1 shows a perfect edge for 1-band image.
%  FOMR,FOMG,FOMB: The Pratt's Figure of Merit. A number in the range
%                  [0,1] where 1 shows a perfect edge for 3-band image.
%
%
% Example 1:
% ----------
%                 input_img = imread('Shapes.bmp'); 
%                 % Obtain edges using 2 different method, here Frei-Chen and Roberts
%                 [ Frei, ~ ] = frei_chen_ed_cvip( input_img, 1 );
%                 Type = 2;
%                 Roberts = roberts_ed_cvip(input_img, Type);
%                 % threshold the edge maps
%                 Roberts = Roberts>0;
%                 Frei = Frei > 0;
%                 scale_factor = 1/9;
%                 [ FOM ] = pratt_merit_cvip( Roberts, Frei, scale_factor )
%
% Example 2:
% ----------
%                 input_img = imread('house.jpg'); 
%                 % Obtain edges using 2 different method, here Sobel and Roberts
%                 kernel = 3;
%                 Sobel = sobel_ed_cvip( input_img, kernel);
%                 Type = 1;
%                 Roberts = roberts_ed_cvip(input_img, Type);
%                 % threshold the edge maps
%                 Roberts = threshold_cvip(Roberts,64);
%                 Sobel = threshold_cvip(Sobel,64);
%                 scale_factor = 1/9;
%                 [ FOMR, FOMG, FOMB ] = pratt_merit_cvip( Roberts, Sobel, scale_factor )
%
%
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications 
%    with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================A
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    4/28/2017
%           Latest update date:     04/10/2018
%           Updated by:             Julian Rene Cuellar Buritica
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

    %Checking to make sure the input images are binary
    if size(unique(Ideal_img),1) ~= 2 
        error('Please use a binary image as the first input image.');
    elseif size(unique(I2),1) ~= 2 
        error('Please use a binary image as the second input iamge.');
    end

    mean_ideal = mean(Ideal_img(:));
    mean_new = mean(I2(:));
    
    Ideal_img = Ideal_img > mean_ideal;
    I2 = I2 > mean_new;

    band = size(Ideal_img,3);

    FOMR = 0;
    FOMG = 0;
    FOMB = 0;

    for b = 1:band
        I_I = sum(sum(Ideal_img(:,:,b)));
        I_F = sum(sum(I2(:,:,b)));

        I_N = max(I_I, I_F);
        FOM = 0;
        for i=1:I_F
            d = dist_calc(Ideal_img(:,:,b), I2(:,:,b), i);
            denum = 1 + (scale_factor*(d^2));
            FOM = FOM + (1/denum);
        end
        if b == 1
            FOMR = FOM/I_N;
        elseif b == 2
            FOMG = FOM/I_N;
        else
            FOMB = FOM/I_N;
        end
    end
end

function d = dist_calc(Ideal_img, I2, i)
    [r,c] = find(I2 > 0);
    r0 = r(i);
    c0 = c(i);

    [rI,cI] = find(Ideal_img > 0);

    R = rI - r0;
    C = cI - c0;

    d = metric(R,C, 1);
    d = min(d(:));
end

function m = metric(R,C, option)

    switch option
        case 1 %City block
            m = abs(R)+ abs(C);
        case 2  % Chessboard
            m = max(abs(R),abs(C)); 
        case 3  %Euclidean
            m = sqrt((R.^2) + (C.^2));
    end
end
% AUTHOR
% Copyright (C) 2017 CVIP Lab, SIUE - by Scott E Umbaugh, Deependra Mishra
% and Julian Rene Cuellar Buritica.