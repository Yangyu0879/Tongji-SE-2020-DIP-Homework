
for k=1:5
    imageName=['..\..\data1\','CT_',num2str(k),'.jpg'];
    disp(imageName);
    I=imread(imageName);
    [m,n]=size(I);
    % comput the gamma-nonlinearity mapping
    c=1;
    r=0.17;
    for i=1:m
        for j=1:n
            I(i,j)=c*(double(I(i,j))/255)^r*255;
        end
    end
    disp(I);
    storeName=['..\modified images\problem 1d\','CT_',num2str(k),'.jpg'];
    I=uint8(I);
    imwrite(I,storeName);
    
    
    imageName=['..\..\data1\','CT_',num2str(k),'.jpg'];
    disp(imageName);
    I=imread(imageName);
    [m,n]=size(I);
    % comput the gamma-nonlinearity mapping
    c=1;
    r=1.57;
    for i=1:m
        for j=1:n
            I(i,j)=c*double(I(i,j))^r;
        end
    end
    disp(I);
    storeName=['..\modified images\problem 1d\','CT_',num2str(k),'_adjusted','.jpg'];
    I=uint8(I);
    imwrite(I,storeName);
    
    %imshow(I);
end