
function [threshImage] = threshholding(inputImage, threshFactor)

    threshhold = threshFactor;
    [m,n] = size(inputImage);
    threshImage = zeros(m,n);

    threshold= repmat(threshhold, size(inputImage, 1), size(inputImage, 2), size(inputImage, 3));
    threshImage(inputImage > threshhold) = 1;
    
    
%%Different Implementation Method    
%     for i =1:m
%         for j =1:n
%             if(inputImage(i,j)>threshhold)
%                 threshImage(i,j)=1;
%             else
%                 threshImage(i,j)=0;
%             end
%         end
%     end


end