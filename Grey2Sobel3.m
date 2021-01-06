function output = Grey2Sobel3(input)
% takes an greyscale image as input
% returns edged as detected by sobel filter
% output image will be eroded by myErode
% 
% e.g.: sobelImg = Grey2Sobel3(img);
%
% source: https://de.mathworks.com/matlabcentral/answers/608136-edge-detection-using-sobel-operator

input = double(input);
[row col] = size(input);
My = [-1 -2 -1;0 0 0;1 2 1];
Mx =[-1 0 1;-2 0 2;-1 0 1];
a3 =zeros(row,col);
for i =1:row-2
    for j=1:col-2
        Gx = sum(sum(Mx.*input(i:i+2, j:j+2)));
        Gy = sum(sum(My.*input(i:i+2, j:j+2)));
        filtered_image(i,j) = sqrt(Gx.^2 + Gy.^2);
    end
end
filtered_image = uint8(filtered_image);
thresholdvalue =100;
output = max(filtered_image,thresholdvalue);
output = Grey2Binary(output);

% se = strel('line',2,90);
% output = imerode(output, se);

output = myErode(output);
output = myErode(output);
output = myErode(output);

end

% https://de.mathworks.com/matlabcentral/answers/608136-edge-detection-using-sobel-operator