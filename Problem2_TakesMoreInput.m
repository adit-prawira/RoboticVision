I = imread('cameraman.tif');
 
figure, imshow(I), axis on; title('Original');
 
%Task 1: Rotate image by 30 degree.
askAngle = 'Enter angle (Degree):\n';

degree = input(askAngle);
 
%Store size of image
[Ly, Lx] = size(I);
 
Irotate = zeros(Ly,Lx);

%Guard for any rotation input that exceed 360 
if(degree > 360)
    degree = degree - 360*fix(degree/360);
end

%Guards for negatives angle of rotation or clockwise rotation
if(degree < 0)
    if(degree < -360)
        degree = degree + 360*(fix(abs(degree/360)));
    end
    degree = degree + 360;
end


if degree > 90
    degree2 = degree - 90*fix(degree/90);
    ls = Lx /(cosd(degree2) + sind(degree2));
    
    %Algorithm for any rotation between 90-180 degree
    if(degree > 90 && degree < 180)
        Tx = abs(ls*cosd(degree));
        Ty = Ly;
    end
    
    %Algorithm for any rotation between 180-270 degree
    if(degree > 180 && degree <= 270)
        Tx = Lx;
        Ty = abs(ls*sind(90-degree));
    end
    
    %Algorithm for any rotation between 270-360 degree
    if(degree > 270 && degree <= 360)
        Tx = abs(ls*cosd(90-degree));
        Ty = 0;
    end
    
%Algorithm for any rotation between 0-90 degree
else
    ls = Lx /(cosd(abs(degree)) + sind(abs(degree)));
    Tx = 0;
    Ty = ls*sind(degree);
end

%New image scale for any rotated 
Sx = ls/Lx;
Sy = ls/Ly;  

%Loop for any geometric transformation made on the original 
%image 
for i = 1:Ly
    for j = 1:Lx
        irotate = round(Sy*(-j*sind(degree) + i*cosd(degree)) + Ty);
        jrotate = round(Sx*(j*cosd(degree) + i*sind(degree)) + Tx);
        
        if(irotate > 0) && (irotate <= Ly) ...
                && (jrotate > 0 ) && (jrotate <= Lx)
            Irotate(irotate, jrotate) =  I(i,j);
        end
    end
end

Irotate = uint8(Irotate);
figure, imshow(Irotate), axis on;
title('Rotated');
 
 
%Task 2: Shrink Image by Half

%Ask scale input to shrink image
askShrinkScale = ...
    'How many times you want to shrink the image? ';
scale = input(askShrinkScale);

fprintf('--> Shrinked Image Scale is (1 : %.2f)\n', scale);

%Re-scale image to new smaller scale
Sx = 1/scale;
Sy = 1/scale;

%Size of matrix will change depends on input
Ishrink = zeros(round(Ly/scale),round(Lx/scale));

%Loop for any smaller scale transformation made on the 
%original image
for i = 1:Ly
    for j = 1:Lx
        ishrink = round(Sx*i);
        jshrink = round(Sy*j);
        
        if(ishrink > 0) && (ishrink <= round(Ly*Sy) ...
                && (jshrink > 0 ) && (jshrink <= round(Lx*Sx)))
            Ishrink(ishrink, jshrink) =  I(i,j);
        end
    end
end
 
Ishrink = uint8(Ishrink);
figure, imshow(Ishrink), axis on;
title('Shrinked');
 
 
%Task 3: Expand Image by double

%Ask scale input to expand image
askExpandScale = ...
    'How many times you want to expand the image? ';
scale = input(askExpandScale);
fprintf('--> Expanded Image Scale is (%.2f : 1)\n', scale);

%Size of matrix will change depends on new expanded image size
Iexpand = zeros(scale*Ly, scale*Lx);

%Loop for any scale expansion transformation made on the 
%original image 
for i = 1:scale*Ly
    for j = 1:scale*Lx
        iexpand = round(scale*i);
        jexpand = round(scale*j);
        
        if(iexpand > 0) && (iexpand <= scale*Ly) ...
                && (jexpand > 0 ) && (jexpand <= scale*Lx)
            Iexpand(iexpand, jexpand) =  I(i,j);
        end
    end
end

%Loop for any scale expansion transformation made on the 
%original image 
for i = 1:scale*Ly
    for j = 1:scale*Lx
        iexpand = round(scale*i);
        jexpand = round(scale*j);
        
        %Guard 
        if(iexpand > 0) && (iexpand <= scale*Ly) ...
                && (jexpand > 0 ) && (jexpand <= scale*Lx)
            Iexpand(iexpand, jexpand) =  I(i,j);
        end
    end
end



%Filling Black Pixels at the nearest existing non-zero colour 
%neighbourhood

RefilledIexpand = Iexpand;

%Convolution
for i = 2:size(Iexpand,1)-1
    for j = 2:size(Iexpand,2)-1
        
        %Iterate Iexpand by per 6x6 matrix
        tempMatrix = Iexpand(i-1:i+1,j-1:j+1);
        
        %Guard to check if the mid value tempMatrix is 0 
        %(Black Pixel) and making sure that it is surround 
        %by a non-zero color
        tempSum = sum(tempMatrix(:));
        if(tempMatrix(5)== 0 && tempSum ~= 0 )
            
            %Array of non-zero element index position number
            NonZeroIndexPos = find(tempMatrix~=0);
            
            %Array contains distances of non-zero elements from 
            %the mid element's position
            DistanceFromMidElement = abs(NonZeroIndexPos-5);
            
            %Ignore the actual distance values and take array of 
            %its actual index position number
            [~,distanceIndexPost] = sort(DistanceFromMidElement);
            
            %Fill the black pixel by the non-zero value from the mid
            %element's nearest neighbor.
            RefilledIexpand(i,j) = tempMatrix(NonZeroIndexPos(...
                distanceIndexPost(1)));
        end
    end
end

%Change values of Iexpand with filled black pixels matrix 
Iexpand = uint8(RefilledIexpand);
figure, imshow(Iexpand), axis on; title('Expanded');
 
%Comparison of output images with the orignal image
figure;
subplot(2,2,1), imshowpair(I, Irotate), axis on;
title('Original Vs Rotated');
subplot(2,2,2), imshowpair(I, Ishrink), axis on;
title('Original Vs Shrinked');
subplot(2,2,[3, 4]), imshowpair(I, Iexpand), axis on;
title('Original Vs Expanded ');
        
