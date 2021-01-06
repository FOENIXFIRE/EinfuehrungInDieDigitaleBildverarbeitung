function [hist] = MyHist(input)
% takes an greyscale image as input 
% returns histogram of image
% 
% e.g.: hist = MyHist(input);
%
% source: none needed

% create double array 256x1
hist = zeros(256,1);

% iterate over each pixel and fill array
[row col] = size(input);

for i=1:row
    for j=1:col
        temp = input(i,j);   
            
        hist(temp) = hist(temp)+1;
    end
end

end
