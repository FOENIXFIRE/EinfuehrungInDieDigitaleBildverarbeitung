
function [threshImage] = threshholding(inputImage, threshFactor)

    threshhold = threshFactor;
    [m,n] = size(inputImage);
    threshImage = zeros(m,n);

    for i =1:m
        for j =1:n
            if(inputImage(i,j)>threshhold)
                threshImage(i,j)=1;
            else
                threshImage(i,j)=0;
            end
        end
    end


end