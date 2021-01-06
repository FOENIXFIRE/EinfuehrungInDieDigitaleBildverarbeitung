function output = myErode(input)
% takes an image as input
% returns image eroded by a predefined structure element (se)
% 
% e.g.: erodedImg = myErode(img);
%
% source: https://www.imageeprocessing.com/2012/09/image-erosion-without-using-matlab.html


% form of erosion (structure element)
se =[1 1 0];

% add padding (will be romoved later)
paddedImg = padarray(input,[0 1],1);

% create zero matrix of size input 
output=false(size(input));


for i=1:size(paddedImg,1)
    for j=1:size(paddedImg,2)-2
        In=paddedImg(i,j:j+2);
        
        %Find the position of ones in the structuring element
        In1=find(se==1);
        
        %Check whether the elements in the window have the value one in the
        %same positions of the structuring element
        if(In(In1)==1)
        output(i,j)=1;
        end
    end
end
end