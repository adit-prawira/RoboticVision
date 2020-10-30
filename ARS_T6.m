I = imread('WhiteMixComplex2019.tif');

%Convert to Grayscale matrix
IRed = I(:,:,1); IGreen = I(:,:,2); IBlue = I(:,:,3);
IGrey = (double(IRed)+double(IGreen)+double(IBlue))/3;
I = uint8(IGrey);
[m,n] = size(I);

%Binarized grayscale matrix
Ibw = uint8(imbinarize(I));

%Label start from 1
label = 1;

%Initialize an empty array to store any taken labels
TAKEN_LABELS  = [];
labelIndex = 1;

%Iterate Ibw matrix
for i = 1:m
    for j = 1:n 
        if(Ibw(i,j) == 1)
            
            %Checking if all  elements surround the 
            %foreground are zero.
            if(Ibw(i, j-1) == 0 && Ibw(i-1, j-1) == 0 &&...
                    Ibw(i-1, j) == 0 && Ibw(i-1, j+1) == 0)
                %Start new label number
                label = label + 1;
                Ibw(i,j) = label;
                
                %Put label in the array that contains any taken label
                TAKEN_LABELS(labelIndex) = label;   %#ok<SAGROW>
                labelIndex = labelIndex + 1;
            end
            
            %Check for label that is connected to the current foreground
            if(isConnected(TAKEN_LABELS, Ibw(i, j-1)) || ...
                    isConnected(TAKEN_LABELS, Ibw(i-1, j-1))||...
                    isConnected(TAKEN_LABELS, Ibw(i-1, j))||...
                    isConnected(TAKEN_LABELS, Ibw(i-1, j+1)))
               
                %Change value of 1 into the specific 
                %label it connected to
                Ibw(i,j) = findConnectedLabel(TAKEN_LABELS, ...
                    Ibw(i, j-1), Ibw(i-1, j-1), ...
                    Ibw(i-1, j), Ibw(i-1, j+1));
            end   
        end
        
        %Skip and move to the next iteration when foreground value is zero.
        if(Ibw(i,j) == 0)
            continue;
        end
        
    end
end

% Initialize an empty array to store any unused labels
UNUSED_LABELS  = [];
unusedLabelIndex = 1;

% Iterate through new Ibw matrix from opposite direction
for i = m:-1:1
    for j = n:-1:1
        % If pixel is part of blob
        if(Ibw(i,j) > 1)
            % If the pixel to the left or above is not zero and not the
            % same as the current pixel, then set it to the current pixel
            if(Ibw(i, j-1) ~= 0 && Ibw(i, j-1) ~= Ibw(i,j))
                Ibw(i,j-1) = Ibw(i,j);
                % Store unused label for later
                if ~any(UNUSED_LABELS == Ibw(i,j-1))
                    UNUSED_LABELS(unusedLabelIndex) = Ibw(i,j-1);
                    unusedLabelIndex = unusedLabelIndex + 1;
                end
            elseif (Ibw(i-1, j) ~= 0 && Ibw(i-1, j) ~= Ibw(i,j))
                Ibw(i-1, j) = Ibw(i,j);
                if ~any(UNUSED_LABELS == Ibw(i-1,j))
                    UNUSED_LABELS(unusedLabelIndex) = Ibw(i-1,j);
                    unusedLabelIndex = unusedLabelIndex + 1;
                end
            end
        end
    end
end

% Initialise output images
OUTPUTS = zeros(m,n,length(TAKEN_LABELS));
j = 1;

%create matrices for each blob
for i = 1:length(TAKEN_LABELS)
    if ~any(UNUSED_LABELS == i)
        OUTPUTS(:,:,j) = fillBlobMatrix(Ibw, TAKEN_LABELS(i));
        j = j + 1;
    end
end

% Plot images
figure;
subplot(j,1,1), imshow(I);
title('Original');
for i = 1:j-1
    subplot(j,1,i+1), imshow(OUTPUTS(:,:,i));
    title(['Blob Number ' num2str(i)]);
end

%Function to fill matrix of a blob
function blobMatrix = fillBlobMatrix(binaryMatrix, label)  
    [m,n] = size(binaryMatrix);
    for i = 1:m
        for j = 1:n
            if(binaryMatrix(i,j) ~= label)
                binaryMatrix(i,j) = 0;
            else
                binaryMatrix(i,j) = 255;
            end
        end
    end
    blobMatrix = binaryMatrix;
end
              
%A Function that return boolean value if there exist a connectivity
function connectionStatus = isConnected(LABELS, currentNumber)
    l = length(LABELS);
    connectionStatus = 0;
    for i = 1:l
        if(currentNumber == LABELS(i))
            connectionStatus = 1;
            break;
        end
    end
end

%A Function that return the number of label the foreground connected to.
function connectedLabel = findConnectedLabel(LABELS, A, B, C, D)
    l = length(LABELS);
    for i = 1:l
        if(A == LABELS(i) || B == LABELS(i) || C == LABELS(i) || ...
                D == LABELS(i))
            connectedLabel = LABELS(i);
            break;
        end
    end
end

