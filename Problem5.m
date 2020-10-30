%%%%%%%%%%%%%%%%% MAIN FUNCTION %%%%%%%%%%%%%%%%%
I = imread('WhiteMix2019.tif');

%Convert to Grayscale matrix
IRed = I(:,:,1); IGreen = I(:,:,2); IBlue = I(:,:,3);
IGrey = (double(IRed)+double(IGreen)+double(IBlue))/3;
I = uint8(IGrey);
[m,n] = size(I);
disp(m);
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
            
            %Check for label that is connected to the current 
            %foreground
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
        
        %Skip and move to the next iteration when foreground value 
        %is zero.
        if(Ibw(i,j) == 0)
            continue;
        end
        
    end
end

%Call function to show all shapes identified within the image 
%and individually labelled. This function will show more or less 
%image depending on how many shapes identified within the analysed 
%image
plotIndividualBlob(Ibw, TAKEN_LABELS);


%%%% COMBINE IMAGES IN A SINGLE PLOT (FOR THE MAIN CASE STUDY) %%%%
%Matrix for individual blob
Ibw2 = fillBlobMatrix(Ibw, 2);
Ibw3 = fillBlobMatrix(Ibw, 3);
Ibw4 = fillBlobMatrix(Ibw, 4);

%Combined all processed images in a single plot
figure;
subplot(2,2,1), imshow(I), axis on;
title('Original');

subplot(2,2,2), imshow(Ibw2), axis on;
title('Blob Number 2');

subplot(2,2,3), imshow(Ibw3), axis on;
title('Blob Number 3');

subplot(2,2,4), imshow(Ibw4), axis on;
title('Blob Number 4');


%%%%%%% ADDITIONAL FUNCTION CREATED FOR THE TASK %%%%%%%

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

%A Function that return the number of label the foreground connected 
%to.
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


%Function to plot individual blob
function plotIndividualBlob(binarizedMatrix, LABELS)
    l = length(LABELS);
    for i = 1:l
        figure, imshow(fillBlobMatrix(binarizedMatrix, ...
            LABELS(i))), axis on;
        title(['Blob Number ' num2str(LABELS(i)) '']);
    end
end

