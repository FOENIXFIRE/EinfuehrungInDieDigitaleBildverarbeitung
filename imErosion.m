function [im] = imErosion(im)
%imErosion Summary of this function goes here
%   Detailed explanation goes here
A = im;

%Structuring element
B = getnhood(strel('diamond',10));

m=floor(size(B,1)/2);
n=floor(size(B,2)/2);
%Pad array on all the sides
C=padarray(A,[m n],1);

%Pad array with ones on both sides
%%C = padarray(A,[0 1],1);
%Intialize the matrix D of size A with zeros
D = false(size(A));
for i=1:size(C,1)-(2*m)
    for j=1:size(C,2)-(2*n)
       
        Temp=C(i:i+(2*m),j:j+(2*n));
       
        D(i,j)=min(min(Temp));
    end
end
im = D;
end

