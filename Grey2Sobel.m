% Jan König (01007167)
function [sobelImage] = Grey2Sobel(greyImage)
% takes a greyscale image as input
% returns edges as detected by sobel filter
% output image will be eroded by myErode
% 
% e.g.: sobelImg = Grey2Sobel(img);
%
% source: https://www.geeksforgeeks.org/matlab-image-edge-detection-using-sobel-operator-from-scratch/

% convert image to double
greyImage = double(greyImage);

% pre-allocate the output matrix with zeros
sobelImage = zeros(size(greyImage));

% create Masks
Mx = [-1 0 1; -2 0 2; -1 0 1]; 
My = [-1 -2 -1; 0 0 0; 1 2 1]; 

% iterate over image
for i = 1:size(greyImage, 1) - 2 
    for j = 1:size(greyImage, 2) - 2 
  
        % Gradient approximations 
        Gx = sum(sum(Mx.*greyImage(i:i+2, j:j+2))); 
        Gy = sum(sum(My.*greyImage(i:i+2, j:j+2))); 
                 
        % Calculate magnitude of vector 
        sobelImage(i+1, j+1) = sqrt(Gx.^2 + Gy.^2); 
    end
end

% convert double Image to uint8
sobelImage = uint8(sobelImage);

% thresholding on sobelImage
thresholdValue = 100; % varies between [0 255] 
temp = max(sobelImage, thresholdValue); 
temp(sobelImage == round(thresholdValue)) = 0; 
temp = im2bw(temp);

% write temp to output image
sobelImage = temp;

% further erode image for smoother lines
sobelImage = myErode(sobelImage);
sobelImage = myErode(sobelImage);
end
