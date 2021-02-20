% get the image from the binary file
fileID = fopen('..\p2d2');
img = fread(fileID,[600 540000/600]);
img=uint8(img);
imshow(img);
% store the image
storeName=['..\P2_2\','origin','.jpg'];
imwrite(img,storeName);

% do the loop for different sizes
for i=1:4
    result=maxFilter(img,2*i-1);
    result=uint8(result);
    imshow(result);
    % store the image
    storeName=['..\P2_2\','maxFilter_',num2str(2*i-1),'.jpg'];
    imwrite(result,storeName);
end

% a function to implement the maxFilter
function result=maxFilter(img,n)
    [l,w]=size(img);
    % do the padding
    img=padarray(img,[(n-1)/2 (n-1)/2],'symmetric');
    result=zeros(l,w);
    % get the max value
    for i=1+(n-1)/2:l+(n-1)/2
        for j=1+(n-1)/2:w+(n-1)/2
            result(i-(n-1)/2,j-(n-1)/2)=max(max(img(i-(n-1)/2:i+(n-1)/2,j-(n-1)/2:j+(n-1)/2)));
        end
    end    
end