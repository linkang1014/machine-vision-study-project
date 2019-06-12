

S = regionprops(CC,'Centroid');

I6 = 255*ones(size(I2,1),size(I2,2),3,'uint8');  % initialise white img

t = -pi/6;    %set the angle of rotation

for(k=1:size(S,1))
    
    xx = S(k).Centroid(1);
    yy = S(k).Centroid(2);
    
    R = [cos(t) -sin(t) xx-cos(t)*xx+sin(t)*yy; sin(t) cos(t) yy-sin(t)*xx-cos(t)*yy; 0 0 1];  %compute rotation matrix
    
   
    K = CC.PixelIdxList(k);
    for(j=1:size(K{1,1},1))
        a = K{1,1}(j);                        %calculate the pixel coordinates
        b = rem(a-1,size(I2,1))+1;            %calculate the pixel coordinates
        
        temp = [ (a-b)/size(I2,1)+1;b; 1];    %in homogeneous coordinates
        temp = R*temp;                        % apply affine transformation
        
        I6(floor(temp(2)),floor(temp(1)),:) =   I4(b,(a-b)/size(I2,1)+1,:);       %assign the info of I4 to I6
        
    end
    
end


imshow(I6);
imwrite(I6,'Q2-6.png');
    