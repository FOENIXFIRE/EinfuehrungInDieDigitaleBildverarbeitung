function [im] = imDilation(im, strEl, R)
%imDilation Summary of this function goes here
%   Detailed explanation goes here
r = R * 2;
A=im;
%Structuring element
B = strEl;
%Pad zeros on all the sides
C=padarray(A,[1 1]);
%Intialize a matrix of matrix size A with zeros
D=false(size(A));
for i=1:size(C,1)-r
    for j=1:size(C,2)-r
        %Perform logical AND operation
        D(i,j)=sum(sum(B&C(i:i+r,j:j+r)));
    end
end
im = D;
end
