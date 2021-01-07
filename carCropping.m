%Vincent Zoechling 11913652
function [outputImage] = carCropping(inputImage, bboxAuto)

%
scale = 5;
bbox = bboxAuto;
bboxResized = bboxresize(bbox,scale);

% imgGrey = RGB2Grey(inputImage);
% imgFilter = medfilt2(imgGrey);
% imgFilter2 = medfilt2(imgFilter);
% imgFilter3 = medfilt2(imgFilter2)
% imgCanny = Grey2Canny(imgFilter3);


annotatedImage = insertShape(inputImage,"rectangle",bboxResized,"LineWidth",5);
imshow(annotatedImage)
title('Resized Image and Bounding Box')

outputImage = imcrop(annotatedImage, bboxResized);
imshow(outputImage)




end