function [xc,yc,xmin,xmax,ymin,ymax,a,b,theta1,theta2,area,perim,circularity] = specs(I)

    % Store size of image matrix
    m = size(I,1);
    n = size(I,2);

    % Convert image matrix to double type for mathematical operations
    doubleImage = double(I);

    % Declare max and min edges of shape
    xmin = m;
    xmax = 0;
    ymin = n;
    ymax = 0;
    
    % Loop through pixels from top to bottom. Once it finds a white square,
    % it stores pixel as minimum y value and breaks loop
    inShape = 0;
    for i = 1:m
        for j = 1:n
            if doubleImage(i,j) == 255
                inShape = 1;
                ymin = i;
                break
            end
            if inShape == 1
                break
            end
        end
        if inShape == 1
            break
        end
    end

    % Loop through pixels from bottom to top. Once it finds a white square,
    % it stores pixel as maximum y value and breaks loop
    inShape = 0;
    for i = m:-1:1
        for j = 1:n
            if doubleImage(i,j) == 255
                inShape = 1;
                ymax = i;
                break
            end
            if inShape == 1
                break
            end
        end
        if inShape == 1
            break
        end
    end

    % Loop through pixels from left to right. Once it finds a white square,
    % it stores pixel as minimum x value and breaks loop
    inShape = 0;
    for j = 1:n
        for i = 1:m
            if doubleImage(i,j) == 255
                inShape = 1;
                xmin = j;
                break
            end
            if inShape == 1
                break
            end
        end
        if inShape == 1
            break
        end
    end

    % Loop through pixels from right to left. Once it finds a white square,
    % it stores pixel as maximum x value and breaks loop
    inShape = 0;
    for j = n:-1:1
        for i = 1:m
            if doubleImage(i,j) == 255
                inShape = 1;
                xmax = j;
                break
            end
            if inShape == 1
                break
            end
        end
        if inShape == 1
            break
        end
    end
    
    % Convert image matrix to binary (1 for white, 0 for black)
    binaryImage = doubleImage > 0;
    binaryImage = double(binaryImage);

    % Declare moments
    m00 = 0;
    m01 = 0;
    m10 = 0;
    m11 = 0;
    m20 = 0;
    m02 = 0;
    
    % Loop through binary image matrix to find moments
    for i = 1:m
        for j = 1:n
            m00 = m00 + binaryImage(i,j);
            m01 = m01 + i*binaryImage(i,j);
            m10 = m10 + j*binaryImage(i,j);
            m11 = m11 + i*j*binaryImage(i,j);
            m20 = m20 + (j^2)*binaryImage(i,j);
            m02 = m02 + (i^2)*binaryImage(i,j);
        end
    end

    % Use moments to find centroid x and y value
    xc = m10/m00;
    yc = m01/m00;
    
    % Store area value
    area = m00;

    % Use moment equations to find J matrix
    u11 = m11 - xc*m01;
    u20 = m20 - xc*m10;
    u02 = m02 - yc*m01;
    J = [u20 u11;u11 u02];
    
    % Find eigen values of J matrix and store in lamda variables
    lamda = eig(J);
    lamda1 = max(lamda(:));
    lamda2 = min(lamda(:));

    % Find axes lengths
    a = 2*sqrt(lamda1/m00);
    b = 2*sqrt(lamda2/m00);

    % Find eigenvector of J matrix
    [V,D] = eig(J);

    % Find eigenvector for largest eigenvalue
    lamda1Index = find(lamda == lamda1);

    % Find axis angles
    theta1 = atan(V(2,lamda1Index)/V(1,lamda1Index));
    theta2 = theta1 + pi/2;
    
    % Declare edge detection masks
    Gx1 = zeros(m,n);
    Gx2 = zeros(m,n);
    Gy3 = zeros(m,n);
    Gy4 = zeros(m,n);

    Gxy1 = zeros(m,n);
    Gxy2 = zeros(m,n);
    Gxy3 = zeros(m,n);
    Gxy4 = zeros(m,n);
    
    % Loop through every pixel in image and apply horizontal, vertical and
    % diagonal masks to find areas of high gradient within the image. This
    % will essentially detect all the edges in the image
    for i = 2:m-1
        for j = 2:n-1
            Gx1(i,j) = (-1*binaryImage(i-1,j) + binaryImage(i,j));
            Gx2(i,j) = (-1*binaryImage(i+1,j) + binaryImage(i,j));
            Gy3(i,j) = (-1*binaryImage(i,j-1) + binaryImage(i,j));
            Gy4(i,j) = (-1*binaryImage(i,j+1) + binaryImage(i,j));

            Gxy1(i,j) = (-1*doubleImage(i-1,j-1) + doubleImage(i,j));
            Gxy2(i,j) = (-1*doubleImage(i-1,j+1) + doubleImage(i,j));
            Gxy3(i,j) = (-1*doubleImage(i+1,j-1) + doubleImage(i,j));
            Gxy4(i,j) = (-1*doubleImage(i+1,j+1) + doubleImage(i,j));
        end
    end
    
    % Find sum of gradients. The absolute values are not found here so as
    % to remove all negative gradients in the next step. It essentially
    % avoids doubling the perimeter.
    edges = Gx1 + Gx2 + Gy3 + Gy4 + Gxy1 + Gxy2 + Gxy3 + Gxy4;
    
    % Convert edge matrix to binary
    edges = edges > 0;

    % Declare perimeter variable
    perim = 0;

    % Loop through edge matrix to count edge pixels and find total
    % perimeter
    for i = 1:m-1
        for j = 1:n-1
            if edges(i,j)
                perim = perim + 1;
            end
        end
    end

    % Find circularity
    circularity = (4*pi*m00)./(perim.^2);
    
end