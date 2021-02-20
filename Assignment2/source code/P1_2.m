% set the parameter
sigma=1
n=3

% get the image from the binary file
fileID = fopen('..\p1');
img = fread(fileID,[600 540000/600]);
img=uint8(img);
imshow(img);
% store the image
storeName=['..\P1_2\','origin','.jpg'];
imwrite(img,storeName);
% use the Gaussian filter with my function
myResult=gaussConv(img,sigma,n);
myResult=uint8(myResult);
imshow(myResult);
% store the image
storeName=['..\P1_2\','gaussConv','.jpg'];
imwrite(myResult,storeName);

% use the Gaussian filter with imfilter
imfilterResult=imfilter(img,fspecial('gaussian',[5 5],1),'conv');
imfilterResult=uint8(imfilterResult);
imshow(imfilterResult);
% store the image
storeName=['..\P1_2\','imfilter','.jpg'];
imwrite(imfilterResult,storeName);

% produce the 1D gaussian filter
function gauss1DFilter=gauss(sigma,n)
    gauss1DFilter=zeros(1,2*n-1);
    for i=1 : n*2-1
        gauss1DFilter(i) = exp(-(i-n)^2/(2*sigma^2))/(sigma*sqrt(2*pi));
    end 
    % normalized
    gauss1DFilter=gauss1DFilter/sum(gauss1DFilter);
end

% produce the 2D gaussian filter by 1D filter
function gauss2DFilter=gauss2d(sigma,n)
    gauss2DFilter=gauss(sigma,n)'*gauss(sigma,n);
end

% blur the noise
function result=gaussConv(image,sigma,n)
    gauss2DFilter=gauss2d(sigma,n);
    result=conv2(image,gauss2DFilter,'same');
end