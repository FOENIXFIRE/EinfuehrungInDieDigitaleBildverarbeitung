function [outputImage] = imResize(im, scalerow, scalecolum)
%   Detailed explanation goes here

%initializations:
inputImage = im;
scale = [scalerow scalecolum];                                %scalefactor [rows colums]
oldSize = size(inputImage);                   %size of your image
newSize = max(floor(scale.*oldSize(1:2)),1);  %compute the new image size

%upsampled set of indices:

rowIndex = min(round(((1:newSize(1))-0.5)./scale(1)+0.5),oldSize(1));
colIndex = min(round(((1:newSize(2))-0.5)./scale(2)+0.5),oldSize(2));

%index old image to get new image:
outputImage = inputImage(rowIndex,colIndex,:);

imshow(outputImage);

end
