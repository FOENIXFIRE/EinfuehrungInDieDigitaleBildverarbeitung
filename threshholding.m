%Vincent Zoechling 11913652
function [threshImage] = threshholding(inputImage, threshFactor)
    
    
    threshhold = threshFactor;
    
    %Creating a matrix at the size of the original image and filling it
    %with zeros
    [m,n] = size(inputImage);
    threshImage = zeros(m,n);

    %Using repmat to compare the RBG values to the threshhold 
    threshold= repmat(threshhold, size(inputImage, 1), size(inputImage, 2), size(inputImage, 3));
    
    %If the value in the inputImage is greater than the threshhold than the
    %according array entry is given the value 1
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