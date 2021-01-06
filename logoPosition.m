%Kevin Baur 11827180
function [croppedImage] = logoPosition(inputImage)
%function gets a selected frame of a video, finds the position of the
%brand and returns a cropped image of the logo
%  you can find details of each function int the function itself

%just to test, the frame(image) will be initializied here
%inputImage = imread('toyota.png');
%inputImage = imread('suzuki.png');

%image resized on 480 rows and imresize calculates automatically the colums
inputImage = imresize(inputImage, [480 NaN]);

%image to gray image
imgray = RGB2Grey(inputImage);

%filter edges with sobel filter
%image = edge(imgray, 'Sobel');
image = Grey2Canny(imgray);

%highlight the edges
image = imDilation(image, strEL(1), 1);

%fills closed surfaces
image = imfill(image, 'holes');

%reduces the surfaces
%image = imerode(image, strel('diamond', 10));
image = imErosion(image, 10);

%highlites the edges
image = imDilation(image, strEL(6), 6);

%%%%%%%%%%%%%%%%%%%%%%%%

%returns the boundingBox of the logo
boundingBox = regionProps(image);

%cuts the boundingBox out of the input image
croppedImage = imCrop(imgray, boundingBox);

%image resized on 480 rows and imresize calculates automatically the colums
croppedImage = imresize(croppedImage, [480 NaN]);

%image to binary image
croppedImage = Grey2Binary(croppedImage);

%for testing show the croppped logo
imshow(croppedImage);
end
