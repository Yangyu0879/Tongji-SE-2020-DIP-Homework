% get the image from the binary file
fileID = fopen('..\p3');
img = fread(fileID,[600 540000/600]);
img=uint8(img);
imshow(img);
% store the image
storeName=['..\P3_2\','origin','.jpg'];
imwrite(img,storeName);

% do the LoG operation
gaussianFilter=fspecial('log',[3 3],0.3);
imfilterResult=imfilter(img,gaussianFilter);
imfilterResult=uint8(imfilterResult);
imshow(imfilterResult);
% store the image
storeName=['..\P3_2\','logFilter','.jpg'];
imwrite(imfilterResult,storeName);

% produce a sharpen filter
laplacianFilter=[-1 -1 -1;-1 8 -1;-1 -1 -1];

[l,w]=size(img);
% do the padding
img=padarray(img,[1 1],'symmetric');
img=double(img);
result=zeros(l,w);
% do the sharpen
for i=2:l+1
    for j=2:w+1
        result(i-1,j-1)=sum(sum(img(i-1:i+1,j-1:j+1).*laplacianFilter));
    end
end    

result=uint8(result);
imshow(result);
% store the image
storeName=['..\P3_2\','laplacianFilter','.jpg'];
imwrite(result,storeName);







