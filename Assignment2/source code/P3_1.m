% get the image
imageName=['..\P1_2\','imfilter','.jpg'];
img=imread(imageName);

% produce a sharpen filter
laplacianFilter=[0 -1 0;-1 5 -1;0 -1 0];

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
imshow(result,[]);
% store the image
storeName=['..\P3_1\','sharpenFilter','.jpg'];
imwrite(result,storeName);