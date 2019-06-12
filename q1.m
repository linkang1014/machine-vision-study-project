close all;
clear all;

I = imread('charact2.bmp');
I = rgb2gray(I);

imshow(I);
imwrite(I,'Q2-1.png')
