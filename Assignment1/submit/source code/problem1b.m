for k=1:5
    imageName=['..\..\data1\','CT_',num2str(k),'.jpg'];
    disp(imageName);
    I=imread(imageName);
    [m,n]=size(I);
    
% compute the PMF
    PMF = zeros(1, 256);
    for i = 1:m
        for j = 1:n
            PMF(I(i,j) + 1) = PMF(I(i,j) + 1) + 1; % I(i,j)为像素的灰度值
        end
    end

% compute the CDF
    CDF = zeros(1, 256);
    CDF(1) = PMF(1);
    for i = 2:256
        CDF(i) = CDF(i - 1) + PMF(i);
    end

    Map=zeros(1,256);
% transfer the CDF to new grey value
    for i = 1:256
        Map(i) = round((CDF(i) - 1) * 255 / (m * n));
    end
    for i = 1:m
        for j = 1:n
            I(i,j) = Map(I(i,j) + 1);
        end
    end
    
% store the images
    storeName=['..\modified images\problem 1b\','CT_',num2str(k),'.jpg'];
    %disp(resI);
    I=uint8(I);
    imwrite(I,storeName);
    plothist(storeName,k);
end

function plothist(storeName,num)
    x=zeros(1,256);
    for j=1:256
        x(j)=j;
    end
   
    img=imread(storeName);
    [m,n] = size(img);
    
    y=zeros(1,256);
    for j = 1:m 
        for k = 1:n
            y(img(j,k)+1)=y(img(j,k)+1)+1; % array index start from 1 so need to plus 1
        end
    end
    %imhist(img);
    saveas(bar(x,y),fullfile('..\modified images\problem 1b',['histogram_' num2str(num) '.jpg']));
end