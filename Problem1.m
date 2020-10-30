% Read Image
fileName = 'AppleTree.png';
I = imread(fileName);
fprintf('Testing Image %s\n', fileName);
figure, image(I), colorbar;
title('Original Image');

%Convert to grayscale image matrix.
IRed = I(:,:,1);
IGreen = I(:,:,2);
IBlue = I(:,:,3);
IGrey = (double(IRed)+double(IGreen)+double(IBlue))/3;

I = uint8(IGrey);

%Store grey values coresspond with its corresponding 
%intensity or count per pixel.
[y,x] = imhist(I); 
figure, imhist(I);
title('Grey Scale Histogram');
ylabel('Intensity');

%Initialize color value of an apple.
appleValue = 0;

%Find mininum count or intensity value that is greater than 0
A = transpose([y x]);
B = A(1,:);
minimumIntensity = min(B(B>0));

%Store color value based on its corresponding
%minimumIntensity value
for i = 1:length(A)
    if A(1,i) == minimumIntensity
        appleValue = A(2, i);
    end
end

[m,n] = size(I);
index = 1;

%Number of x and y coordinates found is equal to
%minimumIntensity or the minimum color count
X = zeros(0, minimumIntensity); 
Y = zeros(0, minimumIntensity);

for i = 1:m
    for j = 1:n 
        if I(i,j) == appleValue
            X(index) = j;
            Y(index) = i;
            fprintf('Apple Coordinates: (x%d, y%d) = (%d, %d)\n',...
                index, index, j,i);
            index = index + 1;
        end
    end
end

%Store all coordinates to AppleCoordinates
AppleCoordinates = transpose([X; Y]);
fprintf('\nApple Coordinates Matrix:\n');
disp(AppleCoordinates);

figure;
subplot(2,2,1), imshow(IRed, 'InitialMagnification', 1600);
title('Red Scale Image');
subplot(2,2,2), imshow(IGreen, 'InitialMagnification', 1600);
title('Green Scale Image');
subplot(2,2,3), imshow(IBlue, 'InitialMagnification', 1600);
title('Blue Scale Image');
subplot(2,2,4), imshow(I, 'InitialMagnification', 1600);
title('Grey Scale Image');

