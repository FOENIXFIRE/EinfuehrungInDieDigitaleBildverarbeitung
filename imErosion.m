%Kevin Baur 11827180
function [erodedImage] = imErosion(im)
%imErosion reduces the shape of objects in a given image
%  dilation operation removes pixels of the boundaries of objects of an
%  image.
%  In a binary image, a pixel is set to 0 if any of the neighboring pixels
%  have the value 0.
%  Morphological erosion removes islands and small objects so that only substantive objects remain.

%Structuring element
struct = getnhood(strel('diamond',10));

%round
m=floor(size(struct,1)/2);
n=floor(size(struct,2)/2);

%Pad array on all the sides to use struct element accordingly
padA = padarray(im,[m n],1);

%Intialize the matrix result of size im with zeros
result = false(size(im));

for i=1:size(padA,1)-(2*m)
    for j=1:size(padA,2)-(2*n) 
       Temp = padA(i:i+(2*m),j:j+(2*n));
       result(i,j) = min(min(Temp));
    end
end
erodedImage = result;
end
