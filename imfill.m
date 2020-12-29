im = imread('suzuki.png');
im = imresize(im, [480 NaN]);
imgray = rgb2gray(im);
imbin = imbinarize(imgray);
im = edge(imgray, 'sobel');

im = imdilate(im, strel('diamond', 2));
I = im;

hliml = zeros(1,size(I,1)); %rand links horizontalLimitLeft
hlimr = zeros(1,size(I,1)); %rand rechts
vliml = zeros(1,size(I,2)); %rand oben
vlimr = zeros(1,size(I,2)); %rand unten

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


imshow(I);
