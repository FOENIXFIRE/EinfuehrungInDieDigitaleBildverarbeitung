%Kevin Baur 11827180
%not used, it doesn't work properly
function  [filledImage] = imFill(inputImage)

%resize image to 480 rows, automatic colums
image = imresize(inputImage, [480 NaN]);

%image to gray image
imgray = RGB2Grey(image);

%image to binary image
imbin = Grey2Binary(imgray);

%sobel filter 
image = edge(imgray, 'sobel');

%dilation
image = imDilation(image, strEL(2), 2);

%add zeros to borders
hliml = zeros(1,size(image,1)); %left border horizontalLimitLeft
hlimr = zeros(1,size(image,1)); %right border 
vliml = zeros(1,size(image,2)); %top border
vlimr = zeros(1,size(image,2)); %bottom border

I = image;

for i = 1:size(I,1) %480
       if ~isempty(find([diff(I(i,:)),0]==1,1,'first'))
       hliml(i) = find([diff(I(i,:)),0]==1,1,'first');
       end
       if ~isempty(find([diff(I(i,:)),0]==-1,1,'last'))
       hlimr(i) = find([diff(I(i,:)),0]==-1,1,'last');
       end
end


for i = 1:size(I,2)
        if ~isempty(find([diff(I(:,i));0]==1,1,'first'))
        vliml(i) = find([diff(I(:,i));0]==1,1,'first');
        end
        if ~isempty(find([diff(I(:,i));0]==-1,1,'last'))
        vlimr(i) = find([diff(I(:,i));0]==-1,1,'last');  
        end
end



for i = 1:size(I,1)
       if hliml(i)~=0
           I(i,hliml(i):hlimr(i)) = 1;
       end
end

for i = 1:size(I,2)
        if vliml(i)~=0
           I(1:vliml(i),i) = 0;
           I(vlimr(i):end,i) = 0;
        end
end

filledImage = I;
imshow(I);
end
