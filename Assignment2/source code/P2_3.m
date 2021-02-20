% get the image from the binary file
fileID = fopen('..\p2d3');
img = fread(fileID,[600 540000/600]);
img=uint8(img);
imshow(img);
% store the image
storeName=['..\P2_3\','origin','.jpg'];
imwrite(img,storeName);

% do the loop for different sizes
for i=1:4
    n=2*i-1;
    % do the medianFilter
    result=ordfilt2(img,(n*n+1)/2,ones(n,n));
    result=uint8(result);
    imshow(result);
    % store the image
    storeName=['..\P2_3\','medianFilter_',num2str(n),'.jpg'];
    imwrite(result,storeName);
end
