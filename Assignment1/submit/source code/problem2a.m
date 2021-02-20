%size of the image after processed
si=4
%have 1000 images
for k=1:1000
    imageName=['..\..\data2\','CT_',num2str(k),'.jpg'];
    disp(imageName);
    I=imread(imageName);
    [m,n]=size(I);
    resm=m*si;
    resn=n*si;
    resI=zeros(resm,resn);
    
    % use the nearest neighboring interpolation
    for i=1:resm
        for j=1:resn
            resx=round(i/si);
            resy=round(j/si);
            if(resx<1)
                resx=1;
            end
            if(resy<1)
                resy=1;
            end
            resI(i,j)=I(resx,resy);
        end
    end
    
    % store the image
    storeName=['..\modified images\problem 2a\','CT_',num2str(k),'.jpg'];
    %disp(resI);
    resI=uint8(resI);
    imwrite(resI,storeName);
    %imshow(I);
end