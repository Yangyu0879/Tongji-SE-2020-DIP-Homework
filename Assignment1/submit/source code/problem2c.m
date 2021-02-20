si=4;%size of the image after processed

%have 1000 images
for k=1:1000
    imageName=['..\..\data2\','CT_',num2str(k),'.jpg'];%the path of the data
    disp(imageName);
    I=imread(imageName);
    [m,n]=size(I);
    
    %resize the image to ensure 16 pixels around
    a=I(1,:);
    c=I(m,:);     
    b=[I(1,1),I(1,1),I(:,1)',I(m,1),I(m,1)];
    d=[I(1,n),I(1,n),I(:,n)',I(m,n),I(m,n)];
    a1=[a;a;I;c;c];
    b1=[b;b;a1';d;d];
    I=b1';
    I1=double(I);
    
    % create the matrix of the result
    resm=m*si;
    resn=n*si;
    resI=zeros(resm,resn);
    
    %do loops to transfer the pixels
    for i=1:resm
        u=i/si-floor(i/si);% get the fractional part along the x axie
        i1=floor(i/si)+2;
        A=[sw(1+u) sw(u) sw(1-u) sw(2-u)];% create the matrix of parameters
        for j=1:resn
            v=j/si-floor(j/si);% get the fractional part along the y axie
            j1=floor(j/si)+2;
            C=[sw(1+v);sw(v);sw(1-v);sw(2-v)];% create the matrix of parameters
            B=[I1(i1-1,j1-1) I1(i1-1,j1) I1(i1-1,j1+1) I1(i1-1,j1+2)
               I1(i1,j1-1)   I1(i1,j1)   I1(i1,j1+1)   I1(i1,j1+2)
               I1(i1+1,j1-1) I1(i1+1,j1) I1(i1+1,j1+1) I1(i1+1,j1+2)
               I1(i1+2,j1-1) I1(i1+2,j1) I1(i1+2,j1+1) I1(i1+2,j1+2)];% matrix of 16 pixels
            resI(i,j)=(A*B*C);
        end
    end
    
    storeName=['..\modified images\problem 2c\','CT_',num2str(k),'.jpg'];
    %disp(resI);
    resI=uint8(resI);
    imwrite(resI,storeName);
    %imshow(I);
end


function A=sw(w1)
%w1: the parameters
    w=abs(w1);
    a=-0.5;
    if w<1&&w>=0
        A=1-(a+3)*w^2+(a+2)*w^3;
    elseif w>=1&&w<2
        A=a*w^3-5*a*w^2+(8*a)*w-4*a;
    else
        A=0;
    end
end