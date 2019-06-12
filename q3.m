


nhood = [0,1,0;1,1,1;0,1,0];
SE = strel('arbitrary',nhood);     %define Structuring element
I3 = imerode(I2,SE);                %erode 


I3 = I2-I3;                         %erosion-boundary extraction
I3 = 1-I3;


imshow (I3);
imwrite(I3,'Q2-3.png');