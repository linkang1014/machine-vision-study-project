clear all;
close all;
I2 = imread('./denoise/pre2.png');

nhood = [1;1;1;1;1;1;1;1;1;1];
SE = strel('arbitrary',nhood);      %define Structuring element
I2 = imerode(I2,SE);                %erode vertically

for i =1:2
    nhood = [1;1];
SE = strel('arbitrary',nhood);      %define Structuring element
I2 = imerode(I2,SE);                 %erode vertically
end

nhood = [1,1,1,1,1;1,1,1,1,1];
SE = strel('arbitrary',nhood);      %define Structuring element
I2 = imdilate(I2,SE);                %erode horizontally

for i=1:2
nhood = [1;1];
SE = strel('arbitrary',nhood);      %define Structuring element
I2 = imdilate(I2,SE);                %erode horizontally
end

imshow (I2);
imwrite(I2,'Q2-2.png');