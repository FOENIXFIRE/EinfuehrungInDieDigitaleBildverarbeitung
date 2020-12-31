%Kevin Baur 11827180
function [dilatedImage] = imDilation(im, strEl, R)
%imDilation expands the shapes contained in the input image
%  dilation operation adds pixels to the boundaries of objects of an
%  image. In a binary image,a pixel is set to 1 if any of the neighboring 
%  pixels have the value 1.
%  Morphological dilation makes objects more visible and fills in small holes in objects.

%r is the size of the doubled struct element
r = R * 2;

%Structuring element
struct = strEl;

%Pad array on all the sides to use struct element accordingly
padA=padarray(im,[1 1]);

%Intialize a matrix of matrix size im with zeros
result=false(size(im));
for i=1:size(padA,1)-r
    for j=1:size(padA,2)-r
        %logical AND operation each pixel
        result(i,j) = sum(sum(struct&padA(i:i+r,j:j+r)));
    end
end
dilatedImage = result;
end
