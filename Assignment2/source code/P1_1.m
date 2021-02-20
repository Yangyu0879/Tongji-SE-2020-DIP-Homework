% get the image from the binary file
fileID = fopen('..\p1');
% the size of the image is 600*800
img = fread(fileID,[600 540000/600]);
img=uint8(img);
imshow(img);

% store the image
storeName=['..\P1_1\','origin','.jpg'];
imwrite(img,storeName);

% do the loop toget the best blurring effect
for n=3:9
    % produce the filter
    filter=ones(n)/n^2;
    % use the correlation 
    filterImg=filter2(filter,img,'same');
    filterImg=uint8(filterImg);
    % store the image 
    storeName=['..\P1_1\','filter_',num2str(n),'.jpg'];
    imwrite(filterImg,storeName);
    % use the convolution 
    convImg=conv2(img,filter,'same');
    convImg=uint8(convImg);
    % store the image d    
    storeName=['..\P1_1\','conv_',num2str(n),'.jpg'];
    imwrite(convImg,storeName);
end


