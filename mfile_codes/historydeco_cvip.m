function txthisto = historydeco_cvip(histo)
% DECOHISTO_CVIP- returns a cell vector with text about the functions
% performed in the history vector
%
%  See also, historyupdate_cvip, vipmwrite2_cvip, vipmread2_cvip,
%  vipmwrite_cvip, vipmread_cvip, btcdeco_cvip, btcenco_cvip.
%
% Reference
% ---------
%  1.Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications
%  with MATLAB and CVIPtools, 3rd Edition. 

%==========================================================================
%
%           Author:                 Julian Rene Cuellar Buritica
%           Initial coding date:    10/15/2018
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     01/21/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% Revision History
%
 % Revision 1.5  11/27/2018  17:59:41  jucuell
 % include btcencol, and btcevec to the list to be used as new functions.
%
 % Revision 1.4  11/27/2018  17:59:41  jucuell
 % Replace function compose for a string containing control characters like
 % the new line (\n)
%
 % Revision 1.3  09/28/2018  17:18:50  jucuell
 % rename from decohisto_cvip to historydeco_cvip, modifications peformed
 % to create text in cell with multiple lines in one cell
%
 % Revision 1.1  10/15/2018  15:32:08  jucuell
 % Initial revision: file creation and listing of CVIP toolbox functions
%

txthisto = cell(size(histo,1),1);       %create initial variable
%get the function code and switch according to it
for i=1:size(histo,1)
    funcode = histo(i,1);
    %predefine values for transform filters
    %get original transform info
    if funcode > 224 && funcode < 236
        if histo(i,3) == 212
            type = 'center';
        else
            type = 'uppleft';
        end
    end
    %%CVIP TOOLS OPERATION LIST
    %code   name    parameters
    switch funcode
        % UTILITIES
        % - Arithmetic and Logic
        % add_cvip - 'add two images or add constant to image
        case 001        %addim
            if histo(i,2) < 0
                txthisto(i,1) = {'Adding Selected Images.'};
            else
                txthisto(i,1) = {['Adding ' num2str(histo(i,2)) ...
                    ' To Selected Image.']};
            end
        % subtract_cvip - 'subtract one image from another, or subtract a 
        % constant to image
        case 002        %subim
            if histo(i,2) < 0
                txthisto(i,1) = {'Subtracting Selected Images.'};
            else
                txthisto(i,1) = {['Subtracting ' num2str(histo(i,2)) ...
                    ' To Selected Image.']};
            end
        % and_cvip - 'perform a logical AND operation between two images
        case 003        %andim
            txthisto(i,1) = {'Performing "and_cvip" on Selected Images.'};
        % multiply_cvip - 'multiply two images or multiply an image by a constant
        case 004        %mulim
            if histo(i,2) < 0
                txthisto(i,1) = {'Multiplying Selected Images.'};
            else
                txthisto(i,1) = {['Multiplying Selected Image by: ' ...
                    num2str(histo(i,2))]};
            end
        % not_cvip - 'perform a logical NOT operation on input image
        case 005        %notim
            txthisto(i,1) = {'Performing "not_cvip" on Selected Images.'};
        % divide_cvip - 'divide two images or divide constant to image
        case 006        %divim
            if histo(i,2) < 0
                txthisto(i,1) = {'Dividying Selected Images.'};
            else
                txthisto(i,1) = {['Dividying Selected Image Into ' ...
                    num2str(histo(i,2))]};
            end
        % xor_cvip - 'perform a logical XOR operation between two images
        case 007        %xorim
            txthisto(i,1) = {'Performing "xor_cvip" on Selected Images.'};
        % or_cvip - 'perform a logical OR operation between two images
        case  008       %orim
            txthisto(i,1) = {'Performing "or_cvip" on Selected Images.'};
        % 
        % % - Create (Band)
        % assemble_bands_cvip - assemble the red band, green band and blue band of RGB image
        case 009        %asseb   [r g b]
            txthisto(i,1) =  {'Assembling Selected bands.'};
        % extract_band_cvip - extract the red band or green band or blue band depending up on the band value from the input image
        case 010        %extrb   [band]
            txthisto(i,1) =  {['Extracting band ' num2str(histo(i,2)) ...
                ' from current Image.']};
        % % - Enhance/Convert (Color)
        % ccenhance_cvip - color contrast enhancement algorithm, improves the color of the image
        % 011
        % cct2rgb_cvip - converts CCT color value to RGB color value
        case 012
            if histo(i,2)
                txthisto(i,1) = {'Peforming "cct2rgb_cvip" normalized output.'};
            else
                txthisto(i,1) = {'Peforming "cct2rgb_cvip" no normalized output.'};
            end
        % ipct_cvip - performs the inverse principal components transform in RGB-space
        case 013
            txthisto(i,1) = {'Peforming "ipct_cvip".'};
        % hsl2rgb_cvip - converts an HSL image to the equivalent RGB image
        case 014        %hs2rg   [type]
            if histo(i,2)
                txthisto(i,1) = {'Peforming "hsl2rgb_cvip" normalized output.'};
            else
                txthisto(i,1) = {'Peforming "hsl2rgb_cvip" no normalized output.'};
            end
        % hsv2rgb_cvip - converts Hue-Saturation-Value color value to Red-Green-Blue color value
        case 015
            if histo(i,2)
                txthisto(i,1) = {'Peforming "hsv2rgb_cvip" normalized output.'};
            else
                txthisto(i,1) = {'Peforming "hsv2rgb_cvip" no normalized output.'};
            end
        % lab2rgb_cvip - converts L*a*b* color value to RGB color value
        case 016        %la2rg  [norm]
            if histo(i,2)
                txthisto(i,1) = {'Peforming "lab2rgb_cvip" normalized output.'};
            else
                txthisto(i,1) = {'Peforming "lab2rgb_cvip" no normalized output.'};
            end
        % luminance_cvip - creates a gray-scale image from a color image
        case 017
            txthisto(i,1) = {'Peforming "luminance_cvip".'};
        % lum_average_cvip - creates a gray scale image from a color
        case 018
            txthisto(i,1) = {'Peforming "lum_average_cvip".'};
        % luv2rgb_cvip - converts L*U*V color value to Red-Green-Blue color value
        case 019        %lu2rg  [norm]
            if histo(i,2)
                txthisto(i,1) = {'Peforming "luv2rgb_cvip" normalized output.'};
            else
                txthisto(i,1) = {'Peforming "luv2rgb_cvip" no normalized output.'};
            end
        % pct_cvip - performs the principal components transform in RGB-space
        case 020
            txthisto(i,1) = {'Peforming "pct_cvip".'};
        % rgb2xyz_cvip - converts Red-Green-Blue color value to XYZ chromaticity color value
        case 021        %rg2xy  [norm]
            if histo(i,2)
                txthisto(i,1) = {'Peforming "rgb2xyz_cvip" normalized output.'};
            else
                txthisto(i,1) = {'Peforming "rgb2xyz_cvip" no normalized output.'};
            end
        % rgb2hsl_cvip - converts Red-Green-Blue color value to Hue/Saturation/Lightness color value
        case 022        %rg2hs   [type]
            if histo(i,2)
                txthisto(i,1) = {'Peforming "rgb2hsl_cvip" normalized output.'};
            else
                txthisto(i,1) = {'Peforming "rgb2hsl_cvip" no normalized output.'};
            end
        % rgb2hsv_cvip - converts Red-Green-Blue color value to Hue/Saturation/Value color value
        case 023
            if histo(i,2)
                txthisto(i,1) = {'Peforming "rgb2hsv_cvip" normalized output.'};
            else
                txthisto(i,1) = {'Peforming "rgb2hsv_cvip" no normalized output.'};
            end
        % rgb2cct_cvip - converts Red-Green-Blue color value to CCT, cylindrical coordinate color value
        case 024
            if histo(i,2)
                txthisto(i,1) = {'Peforming "rgb2cct_cvip" normalized output.'};
            else
                txthisto(i,1) = {'Peforming "rgb2cct_cvip" no normalized output.'};
            end
        % rgb2lab_cvip - converts Red-Green-Blue color value to L*a*b* color value
        case 025        %rg2la [norm]
            if histo(i,2)
                txthisto(i,1) = {'Peforming "rgb2lab_cvip" normalized output.'};
            else
                txthisto(i,1) = {'Peforming "rgb2lab_cvip" no normalized output.'};
            end
        % rgb2luv_cvip - converts Red-Green-Blue color value to L*u*v* color value
        case 026        %rg2lu  [norm]
            if histo(i,2)
                txthisto(i,1) = {'Peforming "rgb2luv_cvip" normalized output.'};
            else
                txthisto(i,1) = {'Peforming "rgb2luv_cvip" no normalized output.'};
            end
        % rgb2sct_cvip - converts Red-Green-Blue color value to SCT i.e. spherical coordinate color value
        case 027
            if histo(i,2)
                txthisto(i,1) = {'Peforming "rgb2sct_cvip" normalized output.'};
            else
                txthisto(i,1) = {'Peforming "rgb2sct_cvip" no normalized output.'};
            end
        % sct2rgb_cvip - converts SCT color value to RGB color value
        case 028
            if histo(i,2)
                txthisto(i,1) = {'Peforming "sct2rgb_cvip" normalized output.'};
            else
                txthisto(i,1) = {'Peforming "sct2rgb_cvip" no normalized output.'};
            end
        % % - Conversion of Image Files
        % bin2graycode_cvip - performs a binary code to gray code conversion on an input image
        case 031        %bi2gr   []
            txthisto(i,1) = {'Peforming "bin2graycode_cvip" on Selected Image.'};
        % vipmread_cvip - reads image data from VIPM file
        % case 032
        % halftone_cvip - convert image to binary with halftone technique
        case 033        %halt   [method]
            switch histo(i,2)
                case 1
                    Name = 'Floyd';
                case 2
                    Name = 'Bayer';
                case 3
                    Name = 'Cluster';
                case 4
                    Name = 'Threshold';
            end
            txthisto(i,1) = {['Peforming "halftone_cvip" using ' Name ...
                ' method ']};
        % graycode2bin_cvip - perform gray code to binary code conversion on an input image
        case 034        %gr2bi   []
            txthisto(i,1) = {'Peforming "graycode2bin_cvip".'};
        % vipmwrite_cvip writes image data to the VIPM file
        % case 035
        %  
        % data_type_cvip - Convert the dta type according to the selected Type.
        case 036        %dtype  [Type]
            switch histo(i,2)
                case 1
                    Type = 'BYTE';
                case 2
                    Type = 'SHORT';
                case 3
                    Type = 'INTEGER';
                case 4
                    Type = 'FLOAT';
                case 5
                    Type = 'DOUBLE';
            end
            txthisto(i,1) = {['Converting image data type to ' Type]};
            
        % create_image_cvip - creates black or rgb color images and objects
        case 037
            txthisto(i,1) = {['Creating Object ' num2str(histo(i,2)) ...
                ' using "create_image_cvip".']};
        % % ANALYSIS
        % % - Edge/Line Detection
        % boiecox_ed_cvip - perform a Boie-Cox edge detection on the image
        case 041        % boiec       [variance 0/1 0/1 lowTH highTH 0/1]
            if histo(i,3) == 1
                info = 'With';
            else
                info = 'NO';
            end
            if histo(i,4) == 1
                info2 = 'and';
            else
                info2 = 'and NO';
            end
            txthisto(i,1) = {['Peforming "boiecox_ed_cvip" Variance: '...
                num2str(histo(i,2)) ' ' info ' Hysteresis Thresholding, \n' ...
                info2 ' Thinning Edge, TH factors: ' num2str(histo(i,5))...
                ' - ' num2str(histo(i,6))]};
        % canny_ed_cvip - perform a Canny edge detection on the image
        case 042        % canny       [variance lowTH highTH 0/1]
            txthisto(i,1) = {['Peforming "canny_ed_cvip" Variance: '...
                num2str(histo(i,2)) ', TH factors: ' num2str(histo(i,3))...
                ' - ' num2str(histo(i,4))]};
        % cerchar_ed_cvip - a spatial-multi spectral image edge detection filter
        case 043        % cerch       [0/1]
            if histo(i,2) == 1
                info = 'Applying NOT to Output Image.';
            else
                info = 'to selected Image';
            end
            txthisto(i,1) = {['Peforming "cerchar_ed_cvip", ' info]};
        % frei_chen_ed_cvip - frei-chen filter, 9 basis image masks, edge/line subspace
        case 044        % freic       [SubSpa]
            SubSpa = {'Edge ', 'Line ', 'Average '};
            txthisto(i,1) = {['Peforming "frei_chen_ed_cvip" by ' ...
                'using the projection ' SubSpa{histo(i,2)} 'Subspace.']};
        % harris_corner_cvip - a spatial edge detecting (corner detection) filter
        case 045        % harri       [TH alpha std msup]
            txthisto(i,1) = {['Peforming "harris_corner_cvip" TH: '...
                num2str(histo(i,2)) ', STD: ' num2str(histo(i,3)) ...
                ', Alpha: ' num2str(histo(i,4)) ', and Max. Sup: ' ...
                num2str(histo(i,5))]};
        % kirsch_ed_cvip - perform kirsch edge detection
        case 046        % kirsh
            txthisto(i,1) = {'Peforming "kirsch_ed_cvip" on Selected Image'};
        % laplacian_ed_cvip - performs a Laplacian edge detection
        case 047        % lapla       [0/1/2]
            txthisto(i,1) = {['Peforming "laplacian_ed_cvip", Using ' ...
                'Mask ' num2str(histo(i,2))]};
        % laplacian_gauss_ed_cvip - computes the Laplacian of a Gaussian edge detector
        % 048 lapga
        % marr_hildreth_ed_cvip - performs a Marr Hildreth edge detection on the image
        case 049        % marrh       [sigma delta]
            txthisto(i,1) = {['Peforming "marr_hildreth_ed_cvip" Sigma: '...
                num2str(histo(i,2)) ', and Delta: ' num2str(histo(i,3))]};
        % moravec_corner_cvip - a spatial corner detecting filter
        case 050        % morav       [TH]
            txthisto(i,1) = {['Peforming "moravec_corner_cvip", '...
                'Threshold: ' num2str(histo(i,2))]};
        % pratt_merit_cvip - calculates the Pratt Figure-of-Merit (FOM) for two binary images
        case 051        % pratt [scale]
            txthisto(i,1) = {['Peforming "pratt_merit_cvip", Scale ' ...
                'Factor: 1/' num2str(round(1/histo(i,2)))]};
        % prewitt_ed_cvip - perform prewitt edge detection
        case 052        % prewi       [ksize]
            txthisto(i,1) = {['Peforming "prewitt_ed_cvip", Kernel Size ' ...
                'of ' num2str(histo(i,2))]};
        % pyramid_ed_cvip - perform a pyramid edge detection
        case 053        % pyram
            txthisto(i,1) = {'Peforming "pyramid_ed_cvip" on Selected Image'};
        % roberts_ed_cvip - performs a Roberts edge detection
        case 054        % rober       [0/1]
            if histo(i,2) == 1
                type = '1. Regular gradient';
            else
                type = '2. Roberts gradient';
            end
            txthisto(i,1) = {['Performing "roberts_ed_cvip" using: ' ...
                type]};
        % robinson_ed_cvip - perform a Robinson edge detection
        case 055        % robin
            txthisto(i,1) = {'Peforming "robinson_ed_cvip" on Selected Image'};
        % shen_castan_ed_cvip - perform a Shen-Castan edge detection on the image
        case 056        % shenc       [smooth lowTH highTH 0/1]
            txthisto(i,1) = {['Peforming "shen_castan_ed_cvip",' ...
                    ' Smoothing Factor: ' num2str(histo(i,2)) ', and'...
                    ' TH factors: ' num2str(histo(i,3)) ' - ' ...
                    num2str(histo(i,4))]};
        % sobel_ed_cvip - perform sobel edge detection
        case 057        % sobel       [ksize]
            txthisto(i,1) = {['Performing "sobel_ed_cvip" Kernel Size ' ...
                'of ' num2str(histo(i,2))]};
        % 058 hough       [not implemented]
        % edge_link_filter_cvip
        case 059        % edgel       [dist]
            txthisto(i,1) = {['Performing "edge_link_filter_cvip" ' ...
                'Connect Distance: ' num2str(histo(i,2))]};
        %  
        % % - Geometry
        % copy_paste_cvip - copies a subimage from one image and pastes it to another image
        case 061        %paste [name0? name0? subsrow subscol subheight subwidth destrow ...
                        %     destcol trans]
            if histo(i,8)
                txthisto(i,1) = {['Peforming "copy_paste_cvip"' ...
                    ' with selected images' '\n' 'subimage from row = 1, '...
                    'col = 1 and size of ' num2str(histo(i,4)) ' rows, and ', ...
                    num2str(histo(i,5)) ' cols.' '\n' 'pasted on row ',... 
                    num2str(histo(i,6)) ', and col ' num2str(histo(i,7))...
                    ', Transparent Mode.']};
            else
                txthisto(i,1) = {['Peforming "copy_paste_cvip"' ...
                    ' with selected images' '\n' 'subimage from row = 1, '...
                    'col = 1 and size of ' num2str(histo(i,4)) ' rows, and ', ...
                    num2str(histo(i,5)) ' cols.' '\n' 'pasted on row ',... 
                    num2str(histo(i,6)) ', and col ' num2str(histo(i,7))...
                    ', No Transparent Mode.']};
            end
        % crop_cvip - crop a subimage from an input image
        case 062        %crop        [height width col row]              %applied
%             txthisto(i,1) = compose2(['Peforming crop_cvip from coordinates: \n' ...     %%Introduced R2016b
%                 'Row = ' num2str(histo(i,5)) ', col = ' num2str(histo(i,4)) ...
%                 ' height of ' num2str(histo(i,2)) ' rows, and width of ' ...
%                 num2str(histo(i,3)) ' cols.']);
        
            txthisto(i,1) = {['Peforming crop_cvip from coordinates: \n' ...     %%Introduced R2016b
                'Row = ' num2str(histo(i,5)) ', col = ' num2str(histo(i,4)) ...
                ' height of ' num2str(histo(i,2)) ' rows, and width of ' ...
                num2str(histo(i,3)) ' cols.']};
        % enlarge_cvip - enlarges image to a user-specified size
        case 063        %enlar       [Row Col]
            txthisto(i,1) = {['Performing "enlarge_cvip" to get an ' ...
                'Image with ' num2str(histo(i,2)) ' rows ,and ' ...
                num2str(histo(i,3)) ' cols.']};
        % rotate_cvip - rotate the given image by an angle specified by the user (Range 1 ~ 360 degrees)
        case 064        %rotat   [ang]
            txthisto(i,1) = {['Performing "rotate_cvip" with an ' ...
                'Angle of ' num2str(histo(i,2)) ' Degrees.']};
        % shrink_cvip - shrinks the given image by a factor specified by the user (Range 0.1 ~ 1)
        case 065        %shrin   [factor]
            txthisto(i,1) = {['Performing "shrink_cvip" with a ' ...
                'Factor of ' num2str(histo(i,2)) '.']};
        % spatial_quant_cvip - reduce the image size using spatial quantization methods
        case 066    %spaq        [Row Col Met]
            txthisto(i,1) = {['Peforming "spatial_quant_cvip" on '...
                'Selected Image' '\n' 'to get Image with ' num2str(histo(i,2))...
                ' rows and ' num2str(histo(i,3)) ' cols, using Method: ' ...
                num2str(histo(i,4))]};
        % translate_cvip - Translates or moves the entire image or part of the image
        case 067        %trans       [right down wrap gray]
            if histo(i,4) > 256
                txthisto(i,1) = {['Peforming "translate_cvip" '...
                    'on Selected Image' '\n' 'by ' num2str(histo(i,2)) ...
                    ' rows and ' num2str(histo(i,3)) ' cols, wrapping image '...
                    'around.']};
            else
                txthisto(i,1) = {['Peforming "translate_cvip" '...
                    'on Selected Image' '\n' 'by ' num2str(histo(i,2)) ...
                    ' rows and ' num2str(histo(i,3)) ' cols, wrapping around '...
                    'with Graylevel of ' num2str(histo(i,4))]};
            end
        % zoom_cvip - zoom an entire image or a part of the image by a factor specified by the user (Range 1 ~ 10)
        case 068        %zoom        [zone fact 0/1 col row width height]
            zones = [{'Upper-Left'}; {'Upper-Right'}; {'Lower-Left'}; 
                {'Lower-Right'}; {'All Image'}];
            method = [{'Zero Order Hold'}; {'Linear Interpolation'}];
            if histo(i,2)==0
                txthisto(i,1) = {['Peforming "zoom_cvip" to '...
                    'Selected Image by ' num2str(histo(i,3)) ' using ' ...
                    method{histo(i,4)+1} '\n' 'From row ' num2str(histo(i,5))...
                    ' and col ' num2str(histo(i,6)) ', with Height: ' ...
                    num2str(histo(i,7)) ' rows, and Width: ' ...
                    num2str(histo(i,8)) ' cols.']};
            else
                txthisto(i,1) = {['Peforming "zoom_cvip" to '...
                    'Zone "' zones{histo(i,2)} '" by ' num2str(histo(i,3)) ...
                    ' using ' method{histo(i,4)+1}]};
            end
        
        % % ENHACEMENT
        % % - Histogram
        % get_hist_image_cvip - Displays the histogram of an input image
        case 071    %dhist      
            txthisto(i,1) = {'Peforming "get_hist_image_cvip" on Selected Image'};
        % gray_linear_cvip -performs linear graylevel modification
        case 072    %glin   [mfun]
            txthisto(i,1) = {'Peforming "gray_linear_cvip" on Selected Image'};
        % histeq_cvip - performs histogram equalization on an input image
        case 073        %hiequ	[0-2]
            txthisto(i,1) = {['Performing "histeq_cvip" to band ' ...
                num2str(histo(i,2))]};
        % hist_create_cvip - creates histogram of an image
        % 074
        % hist_spec_cvip - perform histogram specification of an input image
        % 075
        % hist_shrink_cvip - shrinks a histogram of input image
        % 076 hishr	[Llim Hlim]
        % hist_slide_cvip - slides a histogram of an input image
        % 077 hisli	[0/1 amount]
        % local_histeq_cvip - histogram equalization on block-by-block basis
        % 078 loequ	[0-3 Blk]
        % hist_stretch_cvip - stretches a histogram of an input image
        case 079        %histr	[Llim Hlim Lper Hper]
            txthisto(i,1) = {['Peforming "hist_stretch_cvip" with: \n'...
                'Low lim = ' num2str(histo(i,2)) ', High lim = ' ...
                num2str(histo(i,3)),' Low Clip = ' num2str(histo(i,4)) ...
                ', and High Clip = ' num2str(histo(i,5))]};
        % unsharp_cvip - performs unsharp masking algorithm
        case 080       %usharp     [sLow sHigh lClip hClip]
        	txthisto(i,1) = {['Peforming "unsharp_cvip" with: \n'...
                'Low lim = ' num2str(histo(i,2)) ', High lim = ' ...
                num2str(histo(i,3)),' Low Clip = ' num2str(histo(i,4)) ...
                ', and High Clip = ' num2str(histo(i,5))]};  
        % 
        % % Mapping
        % remap_cvip - remaps the data range of input image
        case 081        %remap   [range0 range1]
            if histo(i,3) == 0
                txthisto(i,1) = {['Peforming "remap_cvip" according to ' ...
                    ' the image range.']};
            else
                txthisto(i,1) = {['Peforming "remap_cvip" in the range ' ...
                    num2str(histo(i,2)) ' to ' num2str(histo(i,3))]};
            end
        % condremap_cvip - performs conditional remapping, user specified range and data type
        % 082
        % logremap_cvip - performs logarithmic remapping of an iamge data
        case 083        %lremap     [band]
            if histo(i,2) == 0
                txt = 'All Bands';
            else
                txt = ['Band ' num2str(histo(i,2))];
            end
            txthisto(i,1) = {['Peforming "logremap_cvip" to ' txt]};
        % relative_remap_cvip - relative remapping of an image data
        case 084        %relm   [lLim hLim]
             if histo(i,3) == 0
                txthisto(i,1) = {['Peforming "relative_remap_cvip" according to ' ...
                    ' the image range.']};
            else
                txthisto(i,1) = {['Peforming "relative_remap_cvip" in the range ' ...
                    num2str(histo(i,2)) ' to ' num2str(histo(i,3))]};
            end
        % gray_levelmap_cvip - perform gray level mapping using 5 defined functions
        case 085        %glmap  [mFun]
            ftxt = {''};
            for j=1:3
                switch histo(i,j+1)
                    case 1
                        txt = 'Trapezoid, ';
                    case 2
                        txt = 'Positive Step, ';
                    case 3
                        txt = 'Negative Step, ';
                    case 4
                        txt = 'Positive Slope, ';
                    case 5
                        txt = 'Negative Slope, ';
                end
                ftxt = {[ftxt{1} txt]};
            end
            txthisto(i,1) = {['Peforming "gray_levelmap_cvip" using the ' ...
                '\nmapping functions: ' ftxt{1}]};
        % 
        % % ANALYSIS
        % % Segmentatio (Morphological)
        % morphclose_cvip - perform morphological closing of a grayscale or color image
        case 091        %mphclose   [kType kSize kArgs]
            switch histo(i,2)
                case 1
                    txt = ['Circle SE of Size ' num2str(histo(i,3))];
                case 2
                    txt = ['Square SE of Size ' num2str(histo(i,3)) ...
                        ' and side ' num2str(histo(i,4))];
                case 3
                    txt = ['Rectangle SE of Size ' num2str(histo(i,3)) ...
                        ' and size (' num2str(histo(i,4)) ',' ...
                        num2str(histo(i,4)) ')'];
                case 4
                    txt = ['Cross SE of Size ' num2str(histo(i,3)) ...
                        ' Thickness ' num2str(histo(i,4)) ', and Cross size ' ...
                        num2str(histo(i,4))];
            end
            txthisto(i,1) = {['Peforming "morphclose_cvip" by using ' ...
                txt]};
        % morphdilate_cvip - perform morphological dilation of a grayscale or color image
        case 092        %mphdil     [kType kSize kArgs]
            switch histo(i,2)
                case 1
                    txt = ['Circle SE of Size ' num2str(histo(i,3))];
                case 2
                    txt = ['Square SE of Size ' num2str(histo(i,3)) ...
                        ' and side ' num2str(histo(i,4))];
                case 3
                    txt = ['Rectangle SE of Size ' num2str(histo(i,3)) ...
                        ' and size (' num2str(histo(i,4)) ',' ...
                        num2str(histo(i,4)) ')'];
                case 4
                    txt = ['Cross SE of Size ' num2str(histo(i,3)) ...
                        ' Thickness ' num2str(histo(i,4)) ', and Cross size ' ...
                        num2str(histo(i,4))];
            end
            txthisto(i,1) = {['Peforming "morphdilate_cvip" by using ' ...
                txt]};
        % morpherode_cvip - perform morphological erosion of a gray scale or color image
        case 093        %mphero     [kType kSize kArgs]
            switch histo(i,2)
                case 1
                    txt = ['Circle SE of Size ' num2str(histo(i,3))];
                case 2
                    txt = ['Square SE of Size ' num2str(histo(i,3)) ...
                        ' and side ' num2str(histo(i,4))];
                case 3
                    txt = ['Rectangle SE of Size ' num2str(histo(i,3)) ...
                        ' and size (' num2str(histo(i,4)) ',' ...
                        num2str(histo(i,4)) ')'];
                case 4
                    txt = ['Cross SE of Size ' num2str(histo(i,3)) ...
                        ' Thickness ' num2str(histo(i,4)) ', and Cross size ' ...
                        num2str(histo(i,4))];
            end
            txthisto(i,1) = {['Peforming "morpherode_cvip" by using ' ...
                txt]};
        % morphitermod_cvip - perform morphological iterative based modification as defined a set of surrounds, a logical operation and the number of iterations of a binary image
        case 094        %mphiter    [Sur1 Sur2 n bool handles.cRot.Value]
            bool = [{'0'} {'!a'} {'ab'} {'a+b'} {'a^b'} {'!ab'} {'a!b'}];
            rot = {', with No rotation', ', with rotation'};
            txthisto(i,1) = {['Peforming "morphitermod_cvip", Surrounds: ' ...
                dec2bin(histo(i,2)) dec2bin(histo(i,3)) ', Iterations: ' ...
                num2str(histo(i,4)) ',\nBoolean: ' bool{histo(i,5)+1} ...
                rot{histo(i,6)+1}]};
        % morphopen_cvip - perform morphological opening of a grayscale or color image
        case 095        %mphopen    [kType kSize kArgs]
            switch histo(i,2)
                case 1
                    txt = ['Circle SE of Size ' num2str(histo(i,3))];
                case 2
                    txt = ['Square SE of Size ' num2str(histo(i,3)) ...
                        ' and side ' num2str(histo(i,4))];
                case 3
                    txt = ['Rectangle SE of Size ' num2str(histo(i,3)) ...
                        ' and size (' num2str(histo(i,4)) ',' ...
                        num2str(histo(i,4)) ')'];
                case 4
                    txt = ['Cross SE of Size ' num2str(histo(i,3)) ...
                        ' Thickness ' num2str(histo(i,4)) ', and Cross size ' ...
                        num2str(histo(i,4))];
            end
            txthisto(i,1) = {['Peforming "morphopen_cvip" by using ' ...
                txt]};
        % morph_thinning_cvip - perform morphological thinning of a binary image
        case 096        %mphthin  [mSize]
            txthisto(i,1) = {['Peforming "morph_thinning_cvip" by using ' ...
                'Mask of size ' num2str(histo(i,2))]};
        % morph_skeleton_cvip - perform morphological skeletonization of a binary image
        case 097        %mphske  [mSize Iter conn met]
            conn = {'4 diag mask', '4 horiz/vert mask', '8 horiz/vert/diag mask'};
            met = {'AND Method', 'Sequential Method'};
            txthisto(i,1) = {['Peforming "morph_skeleton_cvip" by using ' ...
                'Mask of size ' num2str(histo(i,2)) ', Iterations: ' ...
                num2str(histo(i,3)) ', \nConnectivity: ' ...
                conn{histo(i,4)+1} ', ' met{histo(i,5)+1}]};
        % morph_hitmiss_cvip - perform morphological hit-miss transform of a binary image
        case 098       %mphhit  [mSize]
            txthisto(i,1) = {['Peforming "morph_hitmiss_cvip" by using ' ...
                'Mask of size ' num2str(histo(i,2))]};
        % thinskel_mask_cvip - creates N*N size thinning filter or mask
        % case 099
        % structel_cvip - creates structuring element or kernel
        % case 100
        % rotmask_cvip - rotate an 2-D mask or filter by given angle (in degree)
        % 101
        %  
        % % RESTORATION
        % % - Noise
        % gamma_noise_cvip - add gamma noise to an image
        % case 102
        % gau13ssian_noise_cvip - add gaussian noise to an image
        % case 104
        % neg_exp_noise_cvip - add negative-exponential noise to an image
        % case 105
        % rayleigh_noise_cvip - add Rayleigh noise to an image
        % case 106
        % salt_pepper_noise_cvip - add speckle (salt-and-pepper) noise to an noise
        % case 107
        % uniform_noise_cvip - add uniform noise to an image
        % case 108
        %  
        % 
        % % - Objective Fidelity Metrics
        % rms_error_cvip - calculates the root-mean-squared-error between two images
        case 111
            txthisto(i,1) = {'Peforming "rms_error_cvip" to current images'}; 
        % peak_snr_cvip - computes the peak signal-to-noise ratio between two images
        case 112
            txthisto(i,1) = {['Peforming "peak_snr_cvip" with: '...
                num2str(histo(i,2)) ' Gray levels']};
        % snr_cvip - calculates the signal-to-noise ratio between two images
        case 113
        	txthisto(i,1) = {'Peforming "snr_cvip" to current images'}; 
        % % ANALYSIS
        % % - Pattern Classification: Classification Algorithms
        % k_nearest_neighbor_cvip - reads test and training files of feature vectors and creates output file for classification using k-nearest neighbor classification method
        % case 116
        % nearest_centroid_cvip - reads test and training files of feature vectors and creates output file for classification using nearest centroid classification method
        % case 117
        % nearest_centroid_set_cvip - reads test and training files of feature vectors and calculates centroids for each class
        % case 118
        % nearest_neighbor_cvip - reads test and training files of feature vectors and creates output file for classification using nearest neighbor classification method
        % case 119
        %  
        % 
        % % - Pattern Classification: Distance/Similarity Metrics
        % city_block_cvip - calculates the city block distance between two feature vectors
        % case 120
        % euclidean_distance_cvip - calculates the Euclidean distance between two feature vectors
        % case 121
        % maximum_value_metric_cvip - calculates the maximum value distance between two feature vectors
        % case 122
        % minkowsi_distance_cvip - calculates the Minkowski distance between two feature vectors
        % case 123
        % pattern_city_block_cvip - takes two csv files as input, test and training set, then calculates the city block distance metric by comparing each vector in the test set to each in the training set
        % case 124
        % pattern_euclidean_cvip - takes two csv files as input, test and training set, then calculates the Euclidean distance metric by comparing each vector in the test set to each in the training set
        % case 125
        % pattern_maximum_cvip - takes two csv files as input, test and training set, then calculates the maximum value distance metric by comparing each vector in the test set to each in the training set
        % case 126
        % pattern_minkowski_cvip - takes two csv files as input, test and training set, then calculates the minkowski distance metric by comparing each vector in the test set to each in the training set
        % case 127
        % pattern_tanimoto_cvip - takes two csv files as input, test and training set, then calculates the Tanimoto similarity metric by comparing each vector in the test set to each in the training set
        % case 128
        % pattern_vector_inner_product_cvip - takes two csv files as input, test and training set, then calculates the normalized vector inner product metric by comparing each vector in the test set to each in the training set
        % case 129
        % tanimoto_metric_cvip - calculates the Tanimoto similarity metric between two feature vectors
        % case 130
        % vector_inner_product_cvip - calculates the normalized vector inner product similarity metric between two feature vectors
        % case 131
        %  
        % % - Pattern Classification: Feature Extraction
        % area_cvip - calculates the area in pixels of a binary object
        % case 141
        % aspect_cvip - finds the aspect ratio of a binary object of interest on the labeled image
        % case 142
        % central_moments_cvip - returns the centralmoment of order( p + q) of a binary object
        % case 143
        % centroid_cvip - finds the centroid of a binary object
        % case 144
        % cooccurence_cvip - calculates the gray level co-occurrence matrices for an image
        % case 145
        % euler_cvip - finds the Euler number of a binary object
        % case 146
        % feature_objects_cvip - extracts features from a group of objects in a single image and a single image mask for the objects, output is a csv file
        % case 147
        % feature_images_cvip - extracts features from a group of images, where each image contains one object of interest, and uses corresponding mask images, output is a csv file
        % case 148
        % hist_feature_cvip - calculates the 5 first order histogram features for an object
        % case 149
        % irregular_cvip - calculates the irregularity ratio of a binary object
        % case 150
        % label_cvip - labels objects based on 6-connectivity, NW/SE diagonal
        case 151    %label
            txthisto(i,1) = {'Peforming "label_cvip" process'};
        % orientation_cvip - calculates the axis of least second moment for a binary object
        % case 152
        % perimeter_cvip - calculates perimeter of a binary object
        % case 153
        % projection_cvip - extracts horizontal and vertical projections of a binary object
        % case 154
        % rst_invariant - calculates the 7 RST-invariant features defined in Table 6.1
        % case 155
        % texture_features_cvip - Gray level co-occurence matrix based texture features of an image
        % case 156
        % thinness_cvip - calculate the thinness ratio of a binary object
        % case 157
        % spectral_features_cvip - extracts spectral features based on Fourier transform and ring and sector power
        % case 158
        %  
        % % - Pattern Classification: Normalization Methods
        % min_max_norm_cvip - applies min-max normalization to set of feature vectors in a matrix
        % case 159
        % pattern_min_max_norm_cvip - two csv files are input, training and test sets, and returns new csv files with the feature vectors normalized with min-max normalization 
        % case 160
        % pattern_snd_norm_cvip - two csv files are input, training and test sets, and returns new csv files with the feature vectors normalized with standard normal density (snd) normalization
        % case 161
        % pattern_range_norm_cvip - two csv files are input, training and test sets, and returns new csv files with the feature vectors normalized with range normalization
        % case 162
        % pattern_softmax_norm_cvip - two csv files are input, training and test sets, and returns new csv files with the feature vectors normalized with softmax scaling normalization
        % case 163
        % pattern_unit_vector_norm_cvip - two csv files are input, training and test sets, and returns new csv files with the feature vectors normalized with unit vector normalization
        % case 164
        % range_norm_cvip - normalizes a set of feature vector values in a matrix based on the range of each feature
        % case 165
        % softmax_cvip - applies softmax normalization to set of feature vectors in a matrix
        % case 166
        % snd_norm_cvip - applies standard normal density normalization to a set of feature vectors in a matrix
        % case 167
        % unit_vector_norm_cvip - applies unit vector normalization to set of feature vectors in a matrix
        % case 168
        % 
        % % ANALYSIS
        % % - Segmentation
        % autothreshold_cvip - perform automatic thresholding of an image
        case 171        % auTH   [Lim]
            txthisto(i,1) = {['Peforming "autothreshold_cvip" with Limit: ' ...
                num2str(histo(i,2))]};
        % fuzzyc_cvip - perform Fuzzy c-Means clustering based image segmentation
        case 172       %fuzzy  [var]
             txthisto(i,1) = {['Peforming "fuzzyc_cvip" Kernel Variance ' ...
                num2str(histo(i,2))]};
        % gray_quant_cvip - perform gray level quantization of an image
        case 173        % grayq   [Lvl]
            txthisto(i,1) = {['Peforming "gray_quant_cvip" with Graylevel ' ...
                num2str(histo(i,2))]};
        % hist_thresh_cvip- perform adaptive thresholding segmentation
        case 174        % hisTH   [PCT]
            gray = {'RGB to Grayscale'; 'PCT'};
            txthisto(i,1) = {['Peforming "hist_thresh_cvip" Using ' ...
                gray{histo(i,2)+1}]};
        % igs_cvip - perform improved gray scale (IGS) quantization on an image
        case 175        %igsgq   [Lvl]
            txthisto(i,1) = {['Peforming "igs_cvip" with Graylevel ' ...
                num2str(histo(i,2))]};
        % median_cut_cvip - perform image segmentation using median cut method
        case 176        % mediaC    [Colors]
            txthisto(i,1) = {['Peforming "median_cut_cvip" with ' ...
                num2str(histo(i,2)) ' Colors.']};
        % otsu_cvip - perform Otsu thresholding segmentation on an image
        case 177        % otsu  []
            txthisto(i,1) = {'Performing otsu_cvip on selected Image'};
        % pct_median_cvip - perform image segmentation using PCT/median cut algorithm
        case 178        % pctm  [Colors]
            txthisto(i,1) = {['Performing "pct_median_cvip" with ' ...
                num2str(histo(i,2)) ' Colors.']};
        % sct_split_cvip - perform Sphere Coordinate Transform(SCT)/Center color segmentation
        case 179        % SCTc  [NumCA NumCB mOpt]
            if histo(i,4) == 1
                txt = 'RGB';
            else
                txt = 'SCT';
            end
            txthisto(i,1) = {['Performing "sct_split_cvip" with Colors' ...
                ' along axes A: ' num2str(histo(i,2)) ', axes B: ' ...
                 num2str(histo(i,3)) ', Mean in domain: ' txt]};
        % split_merge_cvip - perform split and merge segmentation on an image
        case 180    	% splitm    [N test Arg]
            test = {'Loc. Mean Vs Global', 'Loc. Std. Vs Global', ...
                ['Variance, TH: ' num2str(histo(i,4))]};
            txthisto(i,1) = {['Performing "split_merge_cvip", Entry level: ' ...
                num2str(histo(i,2)) ', Homogeneity test: ' ...
                test{histo(i,3)}]};
        % threshold_cvip - perform binary threshold on an image
        case 181
            txthisto(i,1) = {['Performing "threshold_cvip" at level = '...
                num2str(histo(i,2))]};
        % 
        % % RESTORATION
        % % - Spatial Filters: Adaptive Filters
        % ace2_filter_cvip - adaptive contrast and enhancement filter
        % 186
        % adaptive_contrast_cvip- adaptive contrast filter, adapts to local gray level statistics
        % 187
        % ad_filter_cvip - anisotropic diffusion filter
        % 188
        % adapt_median_filter_cvip - a ranked-order based adaptive median filter
        case 189
            txthisto(i,1) = {['Performing "adapt_median_filter_cvip" with ' ...
                'a maximum mask size:' num2str(histo(i,2))]};
        % exp_ace_filter_cvip - performs an exponential ACE filter
        % 190
        % improved_mmse_filter_cvip - perform improved adaptive minimum mean squared error filter
        % 191
        % kuwahara_filter_cvip - an edge preserving, smoothing filter
        % 192
        % log_ace_filter_cvip - performs a log ACE filter operation
        % 193
        % mmse_filter_cvip - minimum mean squared error restoration filter
        % 194
        %  
        % % - Spatial Filters: Mean Filters
        % arithmetic_mean_cvip - perform an arithmetic mean averaging filter
        case 195        %amean   [size]
            txthisto(i,1) = {['Performing "arithmetic_mean_cvip" with mask size: ' ...
                num2str(histo(i,2))]};
        % contra_mean_cvip - perform a contra-harmonic mean filter
        % 196
        % geometric_mean_cvip - performs a geometric mean filter
        % 197
        % harmonic_mean_cvip - performs a harmonic mean filter
        % 198
        % raster_deblur_mean_cvip - raster deblurring filter
        % 199
        % yp_mean_cvip - performs a Yp mean filter
        % 200
        %  
        % % - Spatial Filters: Miscellaneous
        % 201
        % convolve_filter_cvip - convolves an image with a user specified convolution mask
        case 202        %convf   [mask]
            txthisto(i,1) = {'Aplying "convolve_filter_cvip"'};
        % difference_filter_cvip - performs a difference/emboss filter
        % 203
        % gaussmask_cvip
        case 204        %gausm   [size]
            txthisto(i,1) = {['Creating "Gaussian mask" of size: ' ...
                num2str(histo(i,2))]};
        case 205        %centerwm   [size]
            txthisto(i,1) = {['Creating "Center-Weighted" mask of size: ' ...
                num2str(histo(i,2))]}; 
        case 169        %avgm  [size]
            txthisto(i,1) = {['Creating "Average mask" of size: ' ...
                num2str(histo(i,2))]}; 
        % 
        % % - Spatial Filters: Order Filters
        % alpha_filter_cvip - perform an alpha-trimmed mean filter
        % 206
        % maximum_filter_cvip - performs a maximum filter
        % 207
        % median_filter_cvip - performs a fast histogram-method median filter
        case 208        %mfilt  [mask]
            txthisto(i,1) = {['Performing "median_filter_cvip" with mask size: ' ...
                num2str(histo(i,2))]};
        % midpoint_filter_cvip - performs a midpoint filter
        % 209
        % minimum_filter_cvip - performs a minimum filter on an image
        % 210
        % 
        % % ANALYSIS
        % % - Transform
        % dct_cvip - perform block-wise discrete cosine transform
        case 211        %dct     [Blk]
            txthisto(i,1) = {['Performing "dct_cvip" on Selected Image '...
                'with a Block size of: ' num2str(histo(i,2))]};
        % fft_cvip - performs fast Fourier transform
        case 212        %fft     [0/1 Blk]
             txthisto(i,1) = {['Performing "fft_cvip" on Selected Image '...
                'with a Block size of: ' num2str(histo(i,2))]};
        % fft_mag_cvip - extract magnitude of Fourier spectrum
        case 213        %efftm       
            txthisto(i,1) = {['Extracting magnitude of Fourier spectrum from'...
                    ' Selected Image ']};
        % fft_phase_cvip - extract phase of Fourier spectrum
        case 214        %efftp   
            txthisto(i,1) = {['Extracting phase of Fourier spectrum from'...
                    ' Selected Image ']};
        % haar_cvip - perform forward Haar transform
        case 215        %haar        [0/1 Blk]
            txthisto(i,1) = {['Performing "haar_cvip" on Selected Image '...
                'with a Block size of: ' num2str(histo(i,2))]};
        % wavdaub4_cvip - perform forward wavelet transform based on Daubechies wavelet
        case 216        %wavdau [dec row col]
            txthisto(i,1) = {['Performing "wavdaub4_cvip" on Selected Image '...
                'with a Decomposition of: ' num2str(histo(i,2))]};
        % wavhaar_cvip - perform forward wavelet transform based on Haar wavelet
        case 217        %wavhar [dec row col]
            txthisto(i,1) = {['Performing "wavhaar_cvip" on Selected Image '...
                'with a Decomposition of: ' num2str(histo(i,2))]};
        % walhad_cvip - perform forward Walsh/Hadamard transform
        case 218        %walsh       [0/1 Blk]      
             txthisto(i,1) = {['Performing "walhad_cvip" on Selected Image '...
                'with a Block size of: ' num2str(histo(i,2))]};
        % idct_cvip - perform inverse discrete cosine transform
        case 219
             txthisto(i,1) = {['Performing "idct_cvip" on Selected Image '...
                'with a Block size of: ' num2str(histo(i,2))]};
        % ifft_cvip - performs inverse Fourier transform
        case 220
             txthisto(i,1) = {['Performing "ifft_cvip" on Selected Image '...
                'with a Block size of: ' num2str(histo(i,2))]};
        % ihaar_cvip - perform inverse Haar transform
        case 221
            txthisto(i,1) = {['Performing "ihaar_cvip" on Selected Image '...
                'with a Block size of: ' num2str(histo(i,2))]};
        % iwalhad_cvip - perform inverse Walsh/Hadamard transform
        case 222
            txthisto(i,1) = {['Performing "iwalhad_cvip" on Selected Image '...
                'with a Block size of: ' num2str(histo(i,2))]};
        % iwavdaub4_cvip - perform inverse wavelet transform based on Daubechies wavelet
        case 223
            txthisto(i,1) = {['Performing "iwavdaub4_cvip" on Selected Image '...
                'with a Decomposition of: ' num2str(histo(i,2))]};
        % iwavhaar_cvip - perform inverse wavelet transform based on Haar wavelet
        case 224
            txthisto(i,1) = {['Performing "iwavhaar_cvip" on Selected Image '...
                'with a Decomposition of: ' num2str(histo(i,2))]};
        %  
        % % - Transform Filters: Standard
        % ideal_low_cvip - perform ideal lowpass filter
        case 225        %ilpf    [block type fc]
            txthisto(i,1) = {['Aplying "ideal_low_cvip" to Selected Image, '...
                'Block Size: ' num2str(histo(i,2)) ', Type:' type ...
                ', and cFreq: ' num2str(histo(i,4))]};
        % ideal_high_cvip - perform ideal highpass filter
        case 226        % ihpf    [block type fc]
            txthisto(i,1) = {['Aplying "ideal_high_cvip" to Selected Image, '...
                'Block Size: ' num2str(histo(i,2)) ', Type:' type ...
                ', and cFreq: ' num2str(histo(i,4))]};
        % ideal_bandpass_cvip - perform ideal bandpass filter
        case 227        % ibpf    [block type Lcutoff Hcutoff]
            txthisto(i,1) = {['Aplying "ideal_bandpass_cvip" to Selected '...
                'Image, \nBlock Size: ' num2str(histo(i,2)) ', Type:' type ...
                ', LowcFreq: ' num2str(histo(i,4)) ', HighcFreq: ' ...
                num2str(histo(i,5))]};
        % ideal_bandreject_cvip - perform ideal bandreject filter
        case 228        % ibrf    [block type Lcutoff Hcutoff]
            txthisto(i,1) = {['Aplying "ideal_bandreject_cvip" to Selected '...
                'Image, \nBlock Size: ' num2str(histo(i,2)) ', Type:' type ...
                ', LowcFreq: ' num2str(histo(i,4)) ', HighcFreq: ' ...
                num2str(histo(i,5))]};
        % ideal_h_cvip - returns the frequency response of ideal filters
        % 229
        % butterworth_low_cvip - perform Butterworth lowpass filter
        case 230        %blpf    [block type ord fc]
            txthisto(i,1) = {['Aplying "butterworth_low_cvip" to '...
                'Selected Image \nBlock Size: ' num2str(histo(i,2)) ...
                ', Type: ' type ', Order: ' num2str(histo(i,4)) ...
                ' and cFreq: ' num2str(histo(i,5))]};
        % butterworth_high_cvip - perform Butterworth highpass filter
        case 231        % bhpf   [block type ord fc]
            txthisto(i,1) = {['Aplying "butterworth_high_cvip" to '...
                'Selected Image \nBlock Size: ' num2str(histo(i,2)) ...
                ', Type: ' type ', Order: ' num2str(histo(i,4)) ...
                ' and cFreq: ' num2str(histo(i,5))]};
        % butterworth_bandpass_cvip - perform Butterworth bandpass filter
        case 232        %bbpf    [block type ord Lcutoff Hcutoff]
            txthisto(i,1) = {['Aplying "butterworth_bandpass_cvip" to '...
                'Selected Image \nBlock Size: ' num2str(histo(i,2)) ...
                ', Type: ' type ', Order: ' num2str(histo(i,4)) ...
                ', LowcFreq: ' num2str(histo(i,5)) ', HighcFreq: ' ...
                num2str(histo(i,6))]};
        % butterworth_bandreject_cvip - perform Butterworth bandreject filter
        case 233        % bbrf    [block type ord Lcutoff Hcutoff]
            txthisto(i,1) = {['Aplying "butterworth_bandreject_cvip" to '...
                'Selected Image \nBlock Size: ' num2str(histo(i,2)) ...
                ', Type: ' type ', Order: ' num2str(histo(i,4)) ...
                ', LowcFreq: ' num2str(histo(i,5)) ', HighcFreq: ' ...
                num2str(histo(i,6))]};
        % butterworth_h_cvip - returns the frequency response of butterworth filters
        case 234        % bHighF    [ftype type block n fl fh]
            ftype = {'Low', 'High', 'bPass', 'bReject'};
            if histo(i,2) > 2
                f = ['LowcFreq: ' num2str(histo(i,6)) ', HighcFreq: ' ...
                num2str(histo(i,7))];
            else
                f = ['cFreq: ' num2str(histo(i,6))];
            end
            txthisto(i,1) = {['Aplying a ' ftype{histo(i,2)} ' "butterworth_h_cvip"'...
                ' to Selected Image \nBlock Size: ' num2str(histo(i,4)) ...
                ', Type: ' type ', Order: ' num2str(histo(i,5)) ...
                ', ' f]};
        % highfreqemphasis_cvip - perform high frequency emphasis filter
        case 235        % hfetf   [block cutoff alfa order)]
            txthisto(i,1) = {['Aplying "highfreqemphasis_cvip" to '...
                'Selected Image \nBlock Size: ' num2str(histo(i,2)) ...
                ', cFreq: ' num2str(histo(i,3)) ', Order: ' num2str(histo(i,5)) ...
                ', Alpha: ' num2str(histo(i,4))]};
        % homomorphic_cvip - performs homomorphic filtering on an input
        % 236
        % h_image_cvip - create a mask image according to the size and type
        case 237        %hima   [type hei wid]
            txthisto(i,1) = {['Creating blur mask using "h_image_cvip" '...
                'Type: ' num2str(histo(i,2)) ', Height: ' num2str(histo(i,3))...
                ', and Width: ' num2str(histo(i,4))]};
        %  
        % % - Transform Filters: Restoration
        % geometric_mean_xformfilter_cvip - performs the geometric mean restoration filter
        % 241 geome
        % inverse_xformfilter_cvip - performs the inverse restoration frequency domain filter
        % 242 inver
        % least_squares_filter_cvip - performs the least squares restoration filter
        % 243
        % notch_filter_cvip - 'performs the notch frequency domain filter
        case 244        % notch   [nZones]
            txthisto(i,1) = {['Aplying "notch_filter_cvip" to '...
                'Selected Image with: ' num2str(histo(i,2)) ...
                ',Filter Points.']};
        % parametric_wiener_filter_cvip - performs the parameter Wiener restoration filter
        % 245 pawie
        % power_spect_eq_filter_cvip - power spectrum equalization frequency domain restoration filter
        % 246
        % simple_wiener_filter_cvip - performs the simple Wiener restoration filter
        % 247
        % wiener_filter_cvip - performs the Wiener restoration filter
        % 248
        % 
        % % COMPRESSION
        % % - Lossless
        % 
        % 251
        % 
        % 
        % % - Lossy
        % btcdeco_cvip - performs the decodification of Block truncation Coding algorithm
        % 261 btcd
        % btcenco_cvip - performs the codification using Block truncation Coding algorithm
        case 262        %btce    [Blk]
            txthisto(i,1) = {['Encoding Image Information using ' ...
                '"btcenco_cvip" with a Block Size: ' num2str(histo(i,2))]};
        % 263 mlbtc
        % 264 pmbtc
        % 
        % 272 traco
        otherwise
            txthisto(i,1) = {['No information to decode for function # ' num2str(funcode)]};

    end
end

end