%Vincent Zoechling 11913652
function [outputImage] = carCropping(inputImage, bboxAuto)

%Resizing the bounding box
scale = 5;
bbox = (bboxAuto);
bboxResized = bboxresize(bbox,scale);


%Drawing the bounding box
annotatedImage = insertShape(inputImage,"rectangle",bboxResized,"LineWidth",5);
imshow(annotatedImage)
title('Resized Image and Bounding Box')


%Cropping the image
outputImage = imcrop(annotatedImage, bboxResized);
imshow(outputImage)


end