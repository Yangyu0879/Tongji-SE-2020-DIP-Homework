
%problem 1c
mytiles=16;
clipLimit=0.56;

for k=1:5
    imageName=['..\..\data1\','CT_',num2str(k),'.jpg'];
    disp(imageName);
    I=imread(imageName);
    [m,n]=size(I);
    % use the ClAHE function to transfer the image
    I=CLAHE(I,110,clipLimit);
    %store the images
    
    storeName=['..\modified images\problem 1c\','CT_',num2str(k),'.jpg'];
    %transform
    I=uint8(I);
    imwrite(I,storeName);
    
    %histogram
    plothist(I,k); 
    
end

function result = CLAHE(img,W,clipLimit)
% img: input image
% W: window size W*W
% T: histogram threshold
% result: output image

    % zero padding
    [height, width] = size(img);
    padRow = W - mod(height,W);
    padCol = W - mod(width,W);
    padRowPre  = floor(padRow/2); % get the width of border
    padRowPost = ceil(padRow/2);  % get the width of border
    padColPre  = floor(padCol/2); % the same as above
    padColPost = ceil(padCol/2);  % the same as above
    T=330*330*clipLimit/5;
    
    % resize the image
    padSrc = padarray(img,[padRowPre padColPre ],'symmetric','pre');
    padSrc = padarray(padSrc,[padRowPost padColPost],'symmetric','post');
    [heightPad,widthPad] = size(padSrc);

    % get tiles and use the HE for each one
    numTiles(1) = heightPad/W;      % raws
    numTiles(2) = widthPad/W;       % columns
    tileMappings = cell(numTiles);  % CDF for each tile
    imgCol = 1;
    for col = 1:numTiles(2)
        imgRow = 1;
        for row = 1:numTiles(1)
            tile = padSrc(imgRow:imgRow+W-1,imgCol:imgCol+W-1);% get the tile
            tileHist = getclipHist(tile,T);       % clip the histogram
            tileMapping = pixel_map(tileHist,W);  % CDF for each tile
            tileMappings{row,col} = tileMapping;
            imgRow = imgRow + W; 
        end
        imgCol = imgCol + W;
    end

    % use the bi-linear neighboring interpolation and transfer
    
    resultImg = img;
    resultImg(:) = 0;

    %transfer the each tile
    pixelTileRow = 1;
    for i=1:numTiles(1) + 1
        if i == 1                   
            imgTileHeight = W/2; 
            mapTileRows = [1 1];
        elseif i == numTiles(1)+1   
            imgTileHeight = W/2;
            mapTileRows = [numTiles(1) numTiles(1)];
        else                        
            imgTileHeight = W; 
            mapTileRows = [i-1, i]; 
        end
        pixelTileCol = 1;
        for j=1:numTiles(2) + 1
            if j == 1                   
                imgTileWidth = W/2;
                mapTileCols = [1, 1];
            elseif j == numTiles(2)+1   
                imgTileWidth = W/2;
                mapTileCols = [numTiles(2), numTiles(2)];
            else
                imgTileWidth = W;
                mapTileCols = [j-1, j];
            end
       
            ulMapTile = tileMappings{mapTileRows(1), mapTileCols(1)}; %get the CDF
            urMapTile = tileMappings{mapTileRows(1), mapTileCols(2)};
            blMapTile = tileMappings{mapTileRows(2), mapTileCols(1)};
            brMapTile = tileMappings{mapTileRows(2), mapTileCols(2)};
        
            normFactor = imgTileHeight * imgTileWidth; 
            subImage = padSrc(pixelTileRow:pixelTileRow+imgTileHeight-1,pixelTileCol:pixelTileCol+imgTileWidth-1);
            sImage = uint8(zeros(size(subImage)));
            for m = 0:imgTileWidth-1                % x
                inverseI = imgTileWidth - m;        % 1-x
                for n = 0:imgTileHeight-1           % y
                    inverseJ = imgTileHeight - n;   % 1-y
                    val = subImage(n+1,m+1);
                    sImage(n+1, m+1) = (inverseJ*(inverseI*ulMapTile(val+1)+m*urMapTile(val+1))+n*(inverseI*blMapTile(val+1)+m*brMapTile(val+1)))/normFactor;
                end
            end
            resultImg(pixelTileRow:pixelTileRow+imgTileHeight-1,pixelTileCol:pixelTileCol+imgTileWidth-1) = sImage;
            pixelTileCol = pixelTileCol + imgTileWidth;
        end
        pixelTileRow = pixelTileRow + imgTileHeight;
    end
    
    result= resultImg(padRowPre:padRowPre+height-1,padColPre:padColPre+width-1);
    

end


function clipHist = getclipHist(img, T)
% T:threshold
% img:image

    GRAY_LENGTH = 256;
    
    % compute the over part
    hist = GetHist(img);% get the count
    over = 0;
    for i = 1:GRAY_LENGTH
        if hist(i,1) > T
            over = over + (hist(i,1) - T);
        end
    end
    avgIncrease = floor(over/GRAY_LENGTH);

    % clip and allocate
    clipHist = hist;
    for i = 1:GRAY_LENGTH
        if hist(i) > T                      % hist(i) > T
            clipHist(i) = T;    
        elseif hist(i) + avgIncrease > T    % hist(i) + avgIncrease > T
            clipHist(i) = T;
            over = over - (hist(i,1) + avgIncrease - T);
        else                                % hist(i) + avgIncrease < T
            clipHist(i) = hist(i) + avgIncrease;
            over = over - avgIncrease;      % over substracts avgIncrease 
        end
    end

    % reallocate
    while(over > 0)
        for i = 1:GRAY_LENGTH
            if clipHist(i) + 1 <= T && over > 0
                clipHist(i) = clipHist(i) + 1;
                over = over - 1;
            end
        end
    end
end

function newPixelVal = pixel_map(hist,W)
%hist: tilehist
%W: window size
    GRAY_LENGTH = 256;
    prob = hist / (W * W);
    accum = zeros(GRAY_LENGTH,1);
    accum(1,1)=prob(1,1);
    for i = 2:GRAY_LENGTH
        accum(i,1) = accum(i-1,1) + prob(i,1);
    end    
    newPixelVal = floor(accum * (GRAY_LENGTH-1));
end

function count=GetHist(img)
% GetHist - get the image histogram
% img:input image
% count:count the number of grayscale
    count = zeros(256,1);

    % compute the PMF
    [height, width] = size(img);
        for i = 1:height  
            for j = 1:width
                count(img(i,j)+1, 1) = count(img(i,j)+1, 1) + 1;
            end
        end
    
end

function plothist(img,num)
    x=zeros(1,256);
    for j=1:256
        x(j)=j;
    end
   
    %img=imread(storeName);
    [m,n] = size(img);
    
    y=zeros(1,256);
    for j = 1:m 
        for k = 1:n
            y(img(j,k)+1)=y(img(j,k)+1)+1; % array index start from 1 so need to plus 1
        end
    end
    saveas(bar(x,y),fullfile('..\modified images\problem 1c',['histogram_' num2str(num) '.jpg']));
end

