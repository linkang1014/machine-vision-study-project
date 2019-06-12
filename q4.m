

CC = bwconncomp(I2,8); % compute connected structure

I4 = 255*ones(size(I2,1),size(I2,2),3,'uint8'); % initialise white img



for(i=1:size(CC.PixelIdxList,2))           %operate on each connected component
    K = CC.PixelIdxList(i);    
    r = randi([0 255],1,3);                 %random color for each connected structure
    for(j=1:size(K{1,1},1))
        
        a = K{1,1}(j);                    %calculate the pixel coordinates
        b = rem(a-1,size(I2,1))+1;            %calculate the pixel coordinates
        I4(b,(a-b)/size(I2,1)+1,:) = [ r(1),r(2),r(3)];      
    end
end

imshow(I4);
imwrite(I4,'Q2-4.png');
        