%Kevin Baur 11827180
function [croppedImage] = imCrop(inputImage, BBox)
%imCrop cuts the boundingBox of the input Image
%   croppedImage is a nex matrix with the size of the boundingBox, the
%   values of the specific BBox will be overgiven and the output is just
%   the boundigBox itself

%new matrix with size of BBox
croppedImage = zeros(BBox(3), BBox(4), 'uint8');

%start and steps for the loops
x= floor(BBox(2));
x1= BBox(3) + 10;
ystart = floor(BBox(1));
y = floor(BBox(1));
y1 = BBox(4);

%loops to hand over the bounding box values
for i=1:x1
    croppedImage(i) = inputImage(x,y);
    y = ystart;
    for j=1:y1
     croppedImage(i,j) = inputImage(x,y); 
     y = y+1;
   end
   x = x+1;
end
%imshow(croppedImage);
end
