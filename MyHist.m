% Jan König (01007167)
function [hist] = MyHist(input)
% takes a greyscale image as input 
% returns histogram of image
% 
% e.g.: hist = MyHist(input);
%
% source: none needed

% create double array 256x1
hist = zeros(256,1);

% get size of image/array for iteration
[row col] = size(input);

% iterate over each pixel
for i=1:row
    for j=1:col
        temp = input(i,j);
        
        % this is needed due to matlab starting at index 1 but values for array starting at 0
        temp = temp+1;
        
        % for each value found in image/array raise the appropriate counter by 1
        hist(temp) = hist(temp)+1;
    end
end

end
