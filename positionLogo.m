im = imread('suzuki.png');
im = imresize(im, [480 NaN]);

imgray = RGB2Grey(im);

imbin = Grey2Binary(imgray);
%%imbin = imbinarize(imgray);

im = edge(imgray, 'sobel');

%%im = imDilation(im, strEL(2), 2);
im = imdilate(im, strel('diamond', 2)); %kanten hervorheben

im = imfill(im, 'holes');%füllt nummernschild aus


%%im = imerode(im, strel('diamond', 10)); % löscht unnötige weiße flächen weg
im = imErosion(im);

imshow(im);

%%im = imdilate(im, strel('diamond', 6)); %highlights vertices
im = imDilation(im, strEL(6), 6);

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
