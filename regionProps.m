%Kevin Baur 11827180
function  [foundBBox] = regionProps(inputImage)
%regionProps labels the filled surfaces, sets a boundingBox around them
%and returns the boundigBox of the logo
%   with labelling every surface gets a number, then every labelled surface
%   gets surrounded with a boundingBox. The best matching boundingBox gets
%   returned and it will be the logo of the car.
                                                   
%label the image
[Label,Total]=bwlabel(inputImage,8);  %Total = labelled surfaces

%for testing
%imshow(image); 

%goes throught all labelled surfaces and calculates every BoundingBox, then
%checks if its the logo with object_area and position in the inputImage
for num=1:Total
    [row, col] = find(Label==num);
    
    %To find Bounding Box
    sx=min(col)-0.5;
    sy=min(row)-0.5;
    breadth=max(col)-min(col)+1;
    len=max(row)-min(row)+1;
    
    BBox=[sx sy breadth len];
    
    %calc all edges
    x=zeros([1 5]);
    y=zeros([1 5]);
    x(:)=BBox(1); %x
    y(:)=BBox(2); %y
    x(2:3)=BBox(1)+BBox(3); %breatdth
    y(3:4)=BBox(2)+BBox(4); %len
    
    %Find Area
    Obj_area=numel(row);
    
    %Find Centroid
    X=mean(col);
    Y=mean(row);
    Centroid=[X Y];
    
    %display(BBox); 
    %plot(x,y);
    %plot(X,Y,'ro','color','r');
    

    %checking if it could be logo
    if X > 200 & Y < 300 & X < 700 & Y > 10
        if Obj_area > 300 & Obj_area < 7000
            found = num;
            %make boundingBox larger for better crop
            BBox(1) = BBox(1)-13; %left side
            BBox(2) = BBox(2)-6; %bottom
            BBox(3) = BBox(3)+25;
            BBox(4) = BBox(4)+45;
            foundBBox = BBox;           %BBox of logo
            foundCentroid = Centroid;   %Centroid of the logo
        end
    end
end
