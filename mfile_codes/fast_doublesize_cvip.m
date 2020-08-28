%%%...................Fast Double Size..........
%%%The main aim of the function is to zoom the image with a faster rate with
%%%sharp luminance and without discontinuties
%%%The algorithm is a locally adaptive zooming algorithm
%Reference
%--------------------------------------------------------------------------
%%.....A locally adaptive zooming algorithm for digital images
%%%     S. Battiato, G. Gallo, F. Stanco*
%%%     Dipartimento di Matematica ed Informatica, Universita` di Catania, Viale A. Doria 6, Catania 95125, Italy

%==========================================================================
%
%           Author:                 Hridoy Biswas
%           Initial coding date:    10/01/2019
%           Latest update date:     10/29/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2017-2018 Scott Umbaugh and SIUE
%
%==========================================================================

%--------------------------------------------------------------------------
%% 1st Stage 
%Enlarging the image
function [ output ] =fast_doublesize_cvip( input) 
[row, column, band]=size(input);
k=row*2-1;
l=column*2-1;

enlarged_image = ones(k,l,band)*(-1);

for xx = 1:row
    for yy = 1:column
        
        rr = xx*2-1 ;
        cc = yy*2-1 ;
        
        enlarged_image(rr,cc,:) = input(xx,yy,:);
        
        
    end
end
%%
% 1st row
for i=1:column-1
    enlarged_image(1,2*i,:) = input(1,i,:);
end

% last row
for i=1:column-1
    enlarged_image(k,2*i,:) = input(row,i,:);
end
%%
%1st column
for i=1:row-1
    enlarged_image(2*i,1,:) = input(i,1,:);
end
% last column

for i=1:row-1
    enlarged_image(2*i,l,:) = input(i,column,:);
end


%new_image = imresize(input,[k l]);
%new=zeros(k,l,b);
Tone=200;
Ttwo=45;
%% 2nd  stage
%Filling the holes
for bb = 1:band
    for i=2:2:k-1
       for j=2:2:l-1
        a = enlarged_image(i-1,j-1,bb);
        b= enlarged_image(i-1,j+1,bb);
        c = enlarged_image(i+1,j-1,bb);
        d = enlarged_image(i+1,j+1,bb);
        %x = new_image(i+1,j+1,:);

        if range(a)&&range(b)&&range(c)&&range(d) < Tone
            enlarged_image(i,j,bb)=(a+b+c+d)/4;%x
        elseif abs(a-d)>Ttwo && abs(a-d)>(abs(b-c)+80)
            enlarged_image(i,j,bb)=(b+c)/2;%x
        elseif abs(b-c)>Ttwo && abs(b-c)>(abs(a-d)+80)
            enlarged_image(i,j,bb)=(a+d)/2;%x
        elseif abs(a-d)>Tone && abs(b-c)>Tone && (a-d)*(b-c)>0
            enlarged_image(i-1,j,bb)=(a+b)/2;%H1
            enlarged_image(i+1,j,bb)=(c+d)/2;%H2
        elseif abs(a-d)>Tone && abs(b-c)>Tone && (a-d)*(b-c)<0
            enlarged_image(i,j-1,bb)=(a+c)/2;%V1
            enlarged_image(i,j+1,bb)=(b+d)/2;%V2
        end 
      end
   end
end
%% 3rd stage

for bb = 1:band
    for i=2:k-1
        for j=2:l-1
            if(rem(i+j,2)==1)&& (enlarged_image(i,j,bb)~=-1)
                
                a= enlarged_image(i-1,j,bb);
                b=enlarged_image(i+1,j,bb);
                x1 =enlarged_image(i,j+1,bb);
                x2 =enlarged_image(i,j-1,bb);
                
                    if (x1==-1)||(x2==-1 )
                        if abs(a-b)<Tone
                        enlarged_image(i,j,bb)=(a+b)/2;%value of p
                        end
                    end

    %         if isnumeric(enlarged_image(i+1,j,bb)) && isnumeric(enlarged_image(i+1,j+2,bb))
                if (x1~=-1) && (x2~=-1)
                    if abs(a-b)>Ttwo && abs(a-b)>(abs(x1-x2)+50)
                        enlarged_image(i+1,j+1,bb)=(x1+x2)/2;%value of p
                    elseif abs(x1-x2)>Ttwo && abs(x1-x2)>(abs(a-b)+50)
                        enlarged_image(i+1,j+1,bb)=(a+b)/2;%value of p
                    end
                end
            
            end
        end
    end
end
%%
for bb = 1:band
    for i=2:k-1
        for j=2:l-1
            if(rem(i+j,2)==1)&& (enlarged_image(i,j,bb)~=-1)
                a= enlarged_image(i,j-1,bb);
                b=enlarged_image(i,j+1,bb);
                x1 =enlarged_image(i-1,j,bb);
                x2 =enlarged_image(i+1,j,bb);
                if (x1==-1)||(x2==-1 )
                        if abs(a-b)<Tone
                        enlarged_image(i,j,bb)=(a+b)/2;%value of p
                        end
                end

    %         if isnumeric(enlarged_image(i+1,j,bb)) && isnumeric(enlarged_image(i+1,j+2,bb))
                if (x1~=-1) && (x2~=-1)
                    if abs(a-b)>Ttwo && abs(a-b)>(abs(x1-x2)+50)
                        enlarged_image(i+1,j+1,bb)=(x1+x2)/2;%value of p
                    elseif abs(x1-x2)>Ttwo && abs(x1-x2)>(abs(a-b)+50)
                        enlarged_image(i+1,j+1,bb)=(a+b)/2;%value of p
                    end
                end
            
            end
        end
    end
end
%% Final Stage Rebinning
%%
%modified
q=8;
m=256/q;
bins=zeros(1,256);% the maximum number of bins/ basket can be 256
%if q=1, this matrix will contain the median value of each bins
%of course there will be lots of zero values at the end
for i=1:m
    start=q*(i-1);
    ending=q*i-1;
    median=round((start+ending)/2);% you can also use celi()
    bins(1,i)=median;
end

%only the pixels which have not been updated
% should be updated
% not all the pixels
% considering x as a centre pixel, if its co ordinate is (i,j)
% then coordinate of A(i-1, j-1), top left
% B(i-1,j+1), top right
% c(i+1,j-1), Bottom left
% d(i+1,j+1), Bottom right
for bb=1:band
    for i=2:2:k-1
        
        for  j=2:2:l-1
            x=enlarged_image(i,j,bb);
            if x==-1
                a = enlarged_image(i-1,j-1,bb);  
                b = enlarged_image(i-1,j+1,bb);
                c = enlarged_image(i+1,j-1,bb);
                d = enlarged_image(i+1,j+1,bb);
                
 % if you put three dot(.) then you can continue your code 
 %in next line, it will be considered as a single line
                
                a_median=bins(1,ceil(a/q+.1));
                b_median=bins(1,ceil(b/q+.1));
                c_median=bins(1,ceil(c/q+.1));
                d_median=bins(1,ceil(d/q+.1));
                enlarged_image(i,j,bb)...     
                = round((a_median+b_median+c_median+d_median)/4);
            end
            
        end
    end


    for i=2:k-1
        for j=2:l-1
            if rem(i+j,2)==1 && enlarged_image(i,j,bb)==-1
                a= enlarged_image(i-1,j,bb);
                b=enlarged_image(i+1,j,bb);
                x1 =enlarged_image(i,j+1,bb);
                x2 =enlarged_image(i,j-1,bb);
            
                a_median=bins(1,ceil(a/q+.1));
                b_median=bins(1,ceil(b/q+.1));
                x1_median=bins(1,ceil(x1/q+.1));
                x2_median=bins(1,ceil(x2/q+.1));
       
                enlarged_image(i,j,bb)=(a+b+x1+x2)/4;
            end
        end
    end

    for i=2:k-1
        for j=2:l-1
            if rem(i+j,2)==1 && enlarged_image(i,j,bb)==-1
                a= enlarged_image(i,j-1,bb);
                b=enlarged_image(i,j+1,bb);
                x1 =enlarged_image(i-1,j,bb);
                x2 =enlarged_image(i+1,j,bb);
            
                a_median=bins(1,ceil(a/q+.1));
                b_median=bins(1,ceil(b/q+.1));
                x1_median=bins(1,ceil(x1/q+.1));
                x2_median=bins(1,ceil(x2/q+.1));
       
                enlarged_image(i,j,bb)=(a+b+x1+x2)/4;
            end
        end
    end
end
%%
%copy_and_add_last_column
enlarged_image=[enlarged_image ,enlarged_image(:,end,:)];
%%
%copy_and_add_last_row
final_enlarged_image=cat(1,enlarged_image, enlarged_image(end,:,:));
%%
% adding .1 and ceiling every value so that no value is 0
% otherwise indexing will create a problem
% but side effect is we can't get pure black pixel, meaning pixel value 0
% will not be found in the matrix "make_every_value_round"
% also if any pixel value is already 256, then also it will create a
% problem
make_every_value_round=ceil(final_enlarged_image+.1);
output=im2uint8(make_every_value_round,'indexed');
end

%solution:
%   final_image=final_enlarged_image(final_enlarged_image<1)+1;
%   corrected_enlarged_image=reshape(final_image,[k,l,band])
%   make_every_value_round=round(corrected_enlarged_image)


