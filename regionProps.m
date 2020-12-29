function  [found, foundBBox, foundCentroid] = regionProps()
%regionProps Summary of this function goes here
%   Detailed explanation goes here

%Load image
I=imread('suzuki.png');

%Convert to Gray
I= rgb2gray(I);

%Convert to Binary
B=imbinarize(I);
                                                 
%Fill the holes
C=imfill(B,'holes');
                                                   
 %Label the image
[Label,Total]=bwlabel(C,8);

imshow(C); 
for num=1:Total
    [row, col] = find(Label==num);
    
    %Bounding Box
    sx=min(col)-0.5;
    sy=min(row)-0.5;
    breadth=max(col)-min(col)+1;
    len=max(row)-min(row)+1;
    BBox=[sx sy breadth len];
    display(BBox);
    %figure,imshow(I);
    hold on;
    x=zeros([1 5]);
    y=zeros([1 5]);
    x(:)=BBox(1);
    y(:)=BBox(2);
    x(2:3)=BBox(1)+BBox(3);
    y(3:4)=BBox(2)+BBox(4);
    plot(x,y);

    %Find Area
    Obj_area=numel(row);
    display(Obj_area);
    %Find Centroid
    X=mean(col);
    Y=mean(row);
    Centroid=[X Y];
    display(Centroid);
    plot(X,Y,'ro','color','r');
    hold off;

    %find logo BoundingBox
    if X > 200 & Y < 100 & X < 300 & Y > 10
        if Obj_area > 1000 & Obj_area < 7000
            found = num;
            foundBBox = BBox;
            foundCentroid = Centroid;
        end
    end
    
end
