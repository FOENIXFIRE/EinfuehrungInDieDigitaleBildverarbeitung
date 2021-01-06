% Jan König (01007167)
function output = Grey2Sobel3(input)
% takes a greyscale image as input
% returns edges as detected by sobel filter
% output image will be eroded by myErode
% 
% e.g.: sobelImg = Grey2Sobel3(img);
%
% source: https://de.mathworks.com/matlabcentral/answers/608136-edge-detection-using-sobel-operator

% transform to double
input = double(input);

% get size of input image for iteration
[row col] = size(input);

% create filters
My = [-1 -2 -1;0 0 0;1 2 1];
Mx =[-1 0 1;-2 0 2;-1 0 1];

% create working array (size of input image)
a3 =zeros(row,col);

% iterate over input image and use filter to get new image
for i=1:row-2
    for j=1:col-2
        Gx = sum(sum(Mx.*input(i:i+2, j:j+2)));
        Gy = sum(sum(My.*input(i:i+2, j:j+2)));
        filtered_image(i,j) = sqrt(Gx.^2 + Gy.^2);
    end
end

% transform to uint8
filtered_image = uint8(filtered_image);

% process threshold
thresholdvalue = 100;
output = max(filtered_image,thresholdvalue);
output = Grey2Binary(output);

% erode image to smoothen the lines
output = myErode(output);
output = myErode(output);
end
