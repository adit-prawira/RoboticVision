function output = corners(I)
    
    % Store size of image matrix
    m = size(I,1);
    n = size(I,2);
    
    % Set up output matrix as same size as input
    output = zeros(m,n);
    
    % Convert image matrix to double type for mathematical operations
    doubleImage = double(I);
    
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
            Gx1(i,j) = (-1*doubleImage(i-1,j) + doubleImage(i,j));
            Gx2(i,j) = (-1*doubleImage(i+1,j) + doubleImage(i,j));
            Gy3(i,j) = (-1*doubleImage(i,j-1) + doubleImage(i,j));
            Gy4(i,j) = (-1*doubleImage(i,j+1) + doubleImage(i,j));

            Gxy1(i,j) = (-1*doubleImage(i-1,j-1) + doubleImage(i,j));
            Gxy2(i,j) = (-1*doubleImage(i-1,j+1) + doubleImage(i,j));
            Gxy3(i,j) = (-1*doubleImage(i+1,j-1) + doubleImage(i,j));
            Gxy4(i,j) = (-1*doubleImage(i+1,j+1) + doubleImage(i,j));
        end
    end
    
    % Find absolute values of matrices to remove negative gradients
    Gx1 = sqrt(Gx1.^2);
    Gx2 = sqrt(Gx2.^2);
    Gy3 = sqrt(Gy3.^2);
    Gy4 = sqrt(Gy4.^2);

    Gxy1 = sqrt(Gxy1.^2);
    Gxy2 = sqrt(Gxy2.^2);
    Gxy3 = sqrt(Gxy3.^2);
    Gxy4 = sqrt(Gxy4.^2);
    
    % Find sum of all gradients
    corner = sqrt(Gx1.^2 + Gx2.^2 + Gy3.^2 + Gy4.^2 + Gxy1.^2 + Gxy2.^2 + Gxy3.^2 + Gxy4.^2);
    
    % Loop through each pixel of new matrix to identify corners. Corners
    % are areas where the gradient is high in multiple directions. This is
    % where the pixel values are higher than their surrounding pixels
    for i = 5:m-4
        for j = 5:n-4
            % find maximum pixel value in 3x3 window around current pixel
            maxwind = max([corner(i-1,j-1) corner(i-1,j) corner(i-1,j+1) corner(i,j-1) corner(i,j+1) corner(i+1,j-1) corner(i+1,j) corner(i+1,j+1)]);
            if (corner(i,j) > maxwind)
                % if current pixel value is greater than every pixel
                % surrounding it, then it is a corner
                output(i,j) = 255;
            elseif (corner(i,j) == maxwind) % if pixel is equal to the largest pixel of the current window
                maxtotal = 0;
                % find the largest pixel value within each 3x3 window
                % surrounding the current 3x3 window
                for x = i-3:3:i+3
                    for y = j-3:3:j+3
                        if ~(x == i && y == j)
                            maxtotal = max([maxtotal corner(x-1,y-1) corner(x-1,y) corner(x-1,y+1) corner(x,y-1) corner(x,y) corner(x,y+1) corner(x+1,y-1) corner(x+1,y) corner(x+1,y+1)]);
                        end
                    end
                end
                % if the current pixel is larger than every pixel within
                % the current 9x9 window, excluding the 3x3 window it is
                % in, then it is a corner
                if (corner(i,j) > maxtotal)
                    output(i,j) = 255;
                end
            else
                % every pixel that isn't detected as a corner, is made to
                % be black
                output(i,j) = 0;
            end
        end
    end
    
    % Convert output matrix back to uint8 type to display as image
    output = uint8(output);
    
end