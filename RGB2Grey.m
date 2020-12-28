function [greyImage] = RGB2Grey(imageName)
% takes an rgb image and returns a grey image
% takes the name of an image as a string!
% e.g.: newImg = RGB2Grey('testImage');

% image must be present in folder Frames
% image must be a .jpg

filePath = strcat('Frames/', imageName, '.jpg');

if 2==exist(filePath,'file')
    % File exists.
    
    image = imread(filePath);
    %extrag color channels and convert to double
    r = image(:,:,1);
    g = image(:,:,2);
    b = image(:,:,3);
    r = double(r);
    g = double(g);
    b = double(b); 

    %find grey value for coresponding rgb-values
    greyImage = r+g+b;
    greyImage = greyImage/3;
    greyImage = uint8(greyImage);
    % greyImage = greyImage/255  

else 
    % File does not exist.
     disp('RGB2Grey: error, no such file exists');

end


%%kevins version

function [greyImage] = RGB2Grey(image)
% takes an rgb image and returns a grey image
% takes the name of an image as a string!
   
    %extrag color channels and convert to double
    r = image(:,:,1);
    g = image(:,:,2);
    b = image(:,:,3);
    r = double(r);
    g = double(g);
    b = double(b); 

    %find grey value for coresponding rgb-values
    greyImage = r+g+b;
    greyImage = greyImage/3;
    greyImage = uint8(greyImage);
    % greyImage = greyImage/255  

end
