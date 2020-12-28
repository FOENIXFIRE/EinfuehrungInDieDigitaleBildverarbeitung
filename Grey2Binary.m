function [binaryImage] = Grey2Binary(inputImg)
% this function uses otsu-thresholding with N = 2 classes (fixed)
% e.g.: newImg = Grey2Binary(testImage);

% k is the ideal threshold

% image must be greyscale!

% compute k = ideal threshold using a histogram 
counts = imhist(inputImg);
L = length(counts);
p = counts / sum(counts);
omega = cumsum(p);
mu = cumsum(p .* (1:L)');
mu_t = mu(end);

sigma_b_squared = (mu_t * omega - mu).^2 ./ (omega .* (1 - omega));

[~,k] = max(sigma_b_squared);

% convert image to binary using k as threshold
inputImg(inputImg < k) = 0; 
inputImg(inputImg >= k) = 1; 

% create output while converting to double
binaryImage = double(inputImg);
end


%%kevins version
