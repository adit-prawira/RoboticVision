clc
clear

image = imread('WhiteDiamond2019.tif');

I=image(:,:,1);

[xc,yc,xmin,xmax,ymin,ymax,a,b,theta1,theta2,area,perim,circularity] = specs(I);

imshow(I)
hold on;
rectangle('Position', [xmin-0.5 ymin-0.5 xmax-xmin+1 ymax-ymin+1], 'EdgeColor', 'r', 'LineWidth', 1)
hold on;
viscircles([xc,yc],0.5)
hold on;
line([xc xc+b*sin(theta1)],[yc yc-b*cos(theta1)])
line([xc xc+a*sin(theta2)],[yc yc-a*cos(theta2)])

xc
yc
area
perim
circularity

