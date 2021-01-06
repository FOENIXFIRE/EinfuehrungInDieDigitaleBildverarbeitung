% Jan König (01007167)
function [binaryImage] = Grey2Binary(input)
% takes an greyscale image as input 
% returns binary image by using otsu-thresholding with 2 classes (fixed)
% 
% e.g.: binaryImage = Grey2Binary(input);
%
% source: https://blogs.mathworks.com/steve/2016/06/14/image-binarization-otsus-method/?from=jp


% compute ideal threshold using a histogram 
x = MyHist(input);
histLength = length(x);
p = x / sum(x);
omega = cumsum(p);
mu = cumsum(p .* (1:histLength)');
mu_t = mu(end);

% maximizing sigma_b_squared (as otsu suggests)
sigma_b_squared = (mu_t * omega - mu).^2 ./ (omega .* (1 - omega));

% chosing the highest such value as ideal k for the threshold
[~,threshold] = max(sigma_b_squared);

% convert image to binary using k as threshold
input(input < threshold) = 0; 
input(input >= threshold) = 1; 

% create output and convert to double
binaryImage = double(input);
end
