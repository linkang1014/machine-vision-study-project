%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%clear 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all;
fid=fopen('charact1.txt');  %open the txt
data=fscanf(fid,'%s');   %read the information from the txt in form of character string
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Q1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A1=zeros(64);   %create the white matrix
for i=1:64
    for j=1:64
        A1(i,j)=base2dec(data((j-1)*64+i),32);  %convert the string number strn of the specified base into its decimal equivalent
    end
end
A1=A1'/32;     %transform the number to the form of 0-1 in order to imwrite gray image correctly
imwrite(A1,'Q1-1.png');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Q2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A2=zeros(64); %create the white matrix
for i=1:64    %use thresholding to convert the gray image to black-white image
    for j=1:64
        if A1(i,j)>0
            A2(i,j)=1;
        else
            A2(i,j)=0;
        end
    end
end
imwrite(A2,'Q1-2.png');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Q3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
b_vb=zeros(64);%create vertical boundary matrix matrix
b_hb=zeros(64);%create horizontal boundary matrix
A3=ones(64);%create the white matrix
for i = 1:64
    for j = 1:64       
        if j<64 
            b_vb(i,j) = A2(i,j+1) - A2(i,j) ; %vertical boundary matrix
        end
        if i<64
            b_hb(i,j) = A2(i+1,j) - A2(i,j) ; %horizontal boundary matrix
        end

        if (b_vb(i,j)==0 & b_hb(i,j)==0)%judge the whole boundary
        else
            A3(i,j) = 0;
        end           
    end
end
imwrite(A3,'Q1-3.png');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Q4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cal = bwconncomp(A2);                                  %use the bwconncomp to segment the image
A4=255*ones(size(A2,1),size(A2,2),3,'uint8');          %create the basic matrix
for i=1:Cal.NumObjects
    Group=Cal.PixelIdxList(i);
    r = randi([0 255],1,3);                            %random color
    for j=1:size(Group{1,1},1)
        a = Group{1,1}(j);                             %calculate the pixel coordinates
        b = rem(a-1,size(A2,1))+1;                     %calculate the pixel coordinates
        A4(b,(a-b)/size(A2,1)+1,:) = [ r(1),r(2),r(3)];%random color for each connected structure
    end  
end
imwrite(A4,'Q1-4.png');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Q5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
center=regionprops(Cal,'Centroid');%find the centroid of each componments as the rotation center           
A5 = 255*ones(size(A2,1),size(A2,2),3,'uint8');
rotation1 = pi/2;%rotate angle 90 degrees clockwise;
for k=1:size(center,1)
    t=rotation1;
    xx = center(k).Centroid(1);%horizontal coordinates of centroid   
    yy = center(k).Centroid(2);%vertical coordinates of centroid 
    R = [cos(t) -sin(t) xx-cos(t)*xx+sin(t)*yy; sin(t) cos(t) yy-sin(t)*xx-cos(t)*yy; 0 0 1];  %compute rotation matrix
    K = Cal.PixelIdxList(k);
    for j=1:size(K{1,1},1)
        a = K{1,1}(j);
        b = rem(a,size(A2,2));
        temp = [(a-b)/size(A2,2);b; 1];      %in homogeneous coordinates
        temp = R*temp;                       %apply rotation transformation
        A5(floor(temp(2)),floor(temp(1)),:) =   A4(b,(a-b)/size(A2,2),:);       %assign the info of A4 to A5
    end
end
imwrite(A5,'Q1-5.png');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Q6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A6 = 255*ones(size(A2,1),size(A2,2),3,'uint8');
rotation2 = -pi/6;    %%rotate angle 30 degrees counterclockwise;
for k=1:size(center,1)
    t=rotation2;
    xx = center(k).Centroid(1);   
    yy = center(k).Centroid(2);
    R = [cos(t) -sin(t) xx-cos(t)*xx+sin(t)*yy; sin(t) cos(t) yy-sin(t)*xx-cos(t)*yy; 0 0 1];  %compute rotation matrix
    K = Cal.PixelIdxList(k);
    for j=1:size(K{1,1},1)
        a = K{1,1}(j);
        b = rem(a,size(A2,2));
        temp = [(a-b)/size(A2,2);b; 1];      %in homogeneous coordinates
        temp = R*temp;                       %apply affine transformation
        A6(floor(temp(2)),floor(temp(1)),:) =   A4(b,(a-b)/size(A2,2),:);       %assign the info of A4 to A6
    end
end
imwrite(A6,'Q1-6.png');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Q7
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
erosion_7_1=[1 1 1];
SE=strel('arbitrary',erosion_7_1);
A7=imerode(A2,erosion_7_1);%erode the horizontal pixel
erosion_7_2=[1;1];
SE=strel('arbitrary',erosion_7_2);
A7=imerode(A7,erosion_7_2);%erode the vertical pixel
erosion_7_3=[1 1;1 1];
SE=strel('arbitrary',erosion_7_3);
temp=imerode(A7,erosion_7_3);
A7=A7-temp; %erode the other pixel
A7=bwmorph(A7,'bridge'); %connect one pixel blank
imwrite(A7,'Q1-7.png');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Q8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vertical_distance = 28;%define the distance between the first horizontal and the second line
horizontal_move = 10;%define the hroizontal move to stagger the componments
A8 = 255*ones(32,70,3,'uint8');
for i=1:2:size(Cal.PixelIdxList,2)
    K = Cal.PixelIdxList(i);              
    for j=1:size(K{1,1},1)
        a=K{1,1}(j);                    
        b=rem(a,size(A2,2));           
        A8(b,(a-b)/size(A2,2),:)=A4(b,(a-b)/size(A2,2),:);%define the new martix for new sequence
    end
end
for i=2:2:size(Cal.PixelIdxList,2)
    K=Cal.PixelIdxList(i);              
    for j=1:size(K{1,1},1)
        a=K{1,1}(j);                    
        b=rem(a,size(A2,2));            
        A8(b-vertical_distance,(a-b)/size(A2,2)+horizontal_move,:)=A4(b,(a-b)/size(A2,2),:); %move the 123 right and upward to insert into the blank between ABC
    end
end
A8=imresize(A8,3);
imwrite(A8,'Q1-8.png');
