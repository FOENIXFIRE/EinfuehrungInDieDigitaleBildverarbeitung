%Kevin Baur 11827180
function [outputImage] = imResize(inputImage, scalerow, scalecolum)
%imResize resizes the image on given rows and scales

%initializations
scale = [scalerow scalecolum];                %scalefactor [rows colums]
oldSize = size(inputImage);                   %size of the image
newSize = max(floor(scale.*oldSize(1:2)),1);  %compute the new image size

%upsampled set of indices
rowIndex = min(round(((1:newSize(1))-0.5)./scale(1)+0.5),oldSize(1));
colIndex = min(round(((1:newSize(2))-0.5)./scale(2)+0.5),oldSize(2));

%index old image to get new image
outputImage = inputImage(rowIndex,colIndex,:);
end

