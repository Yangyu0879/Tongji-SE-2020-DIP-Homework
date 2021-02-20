for k=1:5
    imageName=['..\..\data1\','CT_',num2str(k),'.jpg'];
    plothist(imageName,k);
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
            y(img(j,k)+1)=y(img(j,k)+1)+1;
        end
    end
    %k=imhist(img);
    saveas(bar(x,y),fullfile('..\modified images\problem 1a',['histogram_' num2str(num) '.jpg']));
end