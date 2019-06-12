
move_left = 300;
move_right = 200;
move_up = 155;


I9 = 255*ones(200,1200,3,'uint8');     % initialise white image



for(i=1:size(CC.PixelIdxList,2))
    
    
        K = CC.PixelIdxList(i);
        
        if( i== 4 || i==6 || i==8)
        
        for(j=1:size(K{1,1},1))
        
        a = K{1,1}(j);                    %calculate the pixel coordinates
        b = rem(a-1,size(I2,1))+1;            %calculate the pixel coordinates
        I9(b,(a-b)/size(I2,1)+1 -move_left ,:) = I4(b,(a-b)/size(I2,1)+1,:);  %translate characters7M2 to the left    
        end
        else
        for(j=1:size(K{1,1},1))
        
        a = K{1,1}(j);                    %calculate the pixel coordinates
        b = rem(a-1,size(I2,1))+1;            %calculate the pixel coordinates
        I9(b-move_up,(a-b)/size(I2,1)+1+move_right ,:) = I4(b,(a-b)/size(I2,1)+1,:);      
        end
            
        end
end
I9 = imresize(I9,2); %scaling two times
imshow(I9);


imwrite(I9,'Q2-9.png');