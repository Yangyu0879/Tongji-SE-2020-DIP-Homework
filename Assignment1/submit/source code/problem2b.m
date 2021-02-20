si=4%size of the image after processed
%have 1000 images
for k=1:1000
    imageName=['..\..\data2\','CT_',num2str(k),'.jpg'];
    disp(imageName);
    I=imread(imageName);
    [m,n]=size(I);
    resm=m*si;
    resn=n*si;
    resI=zeros(resm,resn);
    
    % do loop
    for i=1:resm
        for j=1:resn
            tx=i/si;
            ty=j/si;
            tdx=tx-floor(tx);
            tdy=ty-floor(ty);
            Q11x=tx-tdx;
            Q11y=ty-tdy;
            if(Q11x<1)% get 4 pixels nearby
                Q11x=1;
            end
            if(Q11y<1)
                Q11y=1;
            end
            if(Q11x==256)
                Q11x=255;
            end
            if(Q11y==256)
                Q11y=255;
            end
            Q12x=Q11x;
            Q12y=Q11y+1;
            Q21x=Q11x+1;
            Q21y=Q11y;
            Q22x=Q11x+1;
            Q22y=Q11y+1;
            %compute the unkonwn pixels
            resI(i,j)=tdx*tdy*I(Q11x,Q11y)+(1-tdx)*tdy*I(Q12x,Q12y)+tdx*(1-tdy)*I(Q21x,Q21y)+(1-tdy)*(1-tdx)*I(Q22x,Q22y);
        end
    end
    %store the images
    storeName=['..\modified images\problem 2b\','CT_',num2str(k),'.jpg'];
    %disp(resI);
    resI=uint8(resI);
    imwrite(resI,storeName);
    %imshow(I);
end