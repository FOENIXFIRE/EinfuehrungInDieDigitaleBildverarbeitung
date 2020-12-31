%Kevin Baur 11827180
function [croppedImage] = logo_position()
%function gets a selected frame of a video, finds the position of the
%brand and returns a cropped image of the logo
%  you can find details of each function int the function itself

%just to test the frame(image) will be initializied here
%inputImage = imread('suzuki.png');
inputImage = imread('skoda.jpg');

%image resized on 480 rows and imresize calculates automatically the colums
image = imresize(inputImage, [480 NaN]);

%image to gray image
imgray = RGB2Grey(image);

%image to binary image
imbin = Grey2Binary(imgray);

%filter edges with sobel filter
image = edge(imgray, 'Sobel');
%image = Grey2Sobel(imgray);

%highlites the edges
image = imDilation(image, strEL(2), 2);

%fills closed surfaces
image = imfill(image, 'holes');%füllt flächen aus

%reduces the surfaces
%im = imerode(im, strel('diamond', 10)); % löscht unnötige weiße flächen weg
image = imErosion(image);

%highlites the edges
image = imDilation(image, strEL(6), 6);

%%%%%%%%%%%%%%%%%%%%%%%%

%returns the boundingBox of the logo
boundingBox = regionProps(image);

%cuts the boundingBox out of the binary image
croppedImage = imcrop(imbin, boundingBox);

%for testing show the croppped logo
imshow(croppedImage);
end

