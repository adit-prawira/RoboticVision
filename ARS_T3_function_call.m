clc
clear

square = imread('WhiteSquare2019.tif');
square = square(:,:,1);
squarecorners = corners(square);

rectangle = imread('WhiteRectangle2019.tif');
rectangle = rectangle(:,:,1);
rectanglecorners = corners(rectangle);

diamond = imread('WhiteDiamond2019.tif');
diamond = diamond(:,:,1);
diamondcorners = corners(diamond);

triangle = imread('WhiteTriangle2019.tif');
triangle = triangle(:,:,1);
trianglecorners = corners(triangle);

figure(1);
subplot(1,2,1);
imshow(square);
title("Original Image");
subplot(1,2,2);
imshow(squarecorners);
title("Corners");

% figure(2);
% subplot(1,2,1);
% imshow(rectangle);
% title("Original Image");
% subplot(1,2,2);
% imshow(rectanglecorners);
% title("Corners");
% 
% figure(3);
% subplot(1,2,1);
% imshow(diamond);
% title("Original Image");
% subplot(1,2,2);
% imshow(diamondcorners);
% title("Corners");
% 
% figure(4);
% subplot(1,2,1);
% imshow(triangle);
% title("Original Image");
% subplot(1,2,2);
% imshow(trianglecorners);
% title("Corners");



