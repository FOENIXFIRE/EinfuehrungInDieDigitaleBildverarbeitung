im = imread('suzuki.png');
im = imresize(im, [480 NaN]);
imgray = rgb2gray(im);
imbin = imbinarize(imgray);
im = edge(imgray, 'sobel');

% function at the end
%%structureElement = [0,0,1,0,0;0,1,1,1,0;1,1,1,1,1;0,1,1,1,0;0,0,1,0,0];
%%B=[0 1 0; 1 1 1; 0 1 0];
%%im = myImdilate(im,structureElement);

%*******************imdilate*********
A=im;
%Structuring element
B = [0,0,1,0,0;0,1,1,1,0;1,1,1,1,1;0,1,1,1,0;0,0,1,0,0]; %%strel, diamond, 2
%%B = strel('diamond', 2)
%%B=[0 1 0; 1 1 1; 0 1 0];
%Pad zeros on all the sides
C=padarray(A,[1 1]);
%Intialize a matrix of matrix size A with zeros
D=false(size(A));
for i=1:size(C,1)-4
    for j=1:size(C,2)-4
        %Perform logical AND operation
        D(i,j)=sum(sum(B&C(i:i+4,j:j+4)));
    end
end
im = D;
%************end imdilate*********

%%im = imdilate(im, B); %kanten hervorheben
im = imfill(im, 'holes');%füllt nummernschild aus
imshow(im);
im = imerode(im, strel('diamond', 10)); % löscht unnötige weiße flächen weg
im = imdilate(im, strel('diamond', 6)); %highlights vertices

%%%%%%%%%%%%%%%%%%%%%%%%


Iprops = regionprops(im,'BoundingBox','Area', 'Image');
area = Iprops.Area;
count = numel(Iprops);
maxa = 7000; %maximale größe logo
mina = 1000; %minimale größe logo
boundingBox = Iprops.BoundingBox;
for i=1:count
   if maxa > Iprops(i).Area && mina < Iprops(i).Area
       maxa = Iprops(i).Area;
       boundingBox = Iprops(i).BoundingBox;
   end
end    


%all above step are to find location of number plate

im = imcrop(imbin, boundingBox); %schneidet nummernschild aus, boundingBox

%resize number plate to 240 NaN
im = imresize(im, [240 NaN]); %vergößern

%clear dust
im = imopen(im, strel('rectangle', [4 4]));

%%imshow(im);
