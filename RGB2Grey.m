% Jan König (01007167)
function [greyImage] = RGB2Grey(input)
% takes an rgb image and returns a grey image
% e.g.: greyImage = RGB2Grey(input);
%
% source: none needed
    
% split into seperate color channels and convert each to double
r = input(:,:,1);
g = input(:,:,2);
b = input(:,:,3);
r = double(r);
g = double(g);
b = double(b); 

% determine grey value for coresponding rgb-values (which is the average of
% the color channels' values)
greyImage = r+g+b;
greyImage = greyImage/3;

% convert to uint8 which will be returned by function
greyImage = uint8(greyImage);
end
