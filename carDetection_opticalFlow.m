% Vincent Zoechling 11913652
% Lucio Delen 11827180
function carDetection_opticalFlow (videoName)

close all;
clc;

%%Get Frames
Video2Frames(videoName)

%Setup for blobAnalysis
blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 200);

%Creating a figure to plot the motion vectors overlaying the frame
opticalVectorPlot = figure;
        movegui(opticalVectorPlot);
        hViewPanel = uipanel(opticalVectorPlot,'Position',[0 0 1 1],'Title','Plot of Optical Flow Vectors');
        hPlot = axes(hViewPanel);

%Creating a figure to show the threshhold-image
threshHoldPlot = figure;  

%Creating a figure to show the original image
%For the sake of comparision or in case of much noise in the image. This
%is a seperate plot for the original frame. But note that the image is
%resized so not technically the 'original' image.
originalImgPlot = figure;

%Creating a figure to plot the boxes found in the threshholded image
boxedImgPlot = figure;
       
%Creating an optical flow
opticFlow = opticalFlowHS;

    %Iteration over the frames in steps of size 3
    %numel(dir("Frames"))-2 is used to get the number of frames in the
    %Folder substracting 2 for the navigation files MATLAB is using to
    %navigate between folders
    for count = 1:3:(numel(dir("Frames"))-2)
        
        %Reading in the file from the Frames folder
        filename = strcat('Frames/frame', num2str(count), '.jpg');
        imgFile = imread(filename);
        
        %Resizing the image and converting into grey
        img1resize = imResize(imgFile, 0.2, 0.2);
        img1gray = RGB2Grey(img1resize);
        
       
        
        set(0, 'CurrentFigure', originalImgPlot)
        imshow(img1resize);
        
        
        set(0, 'CurrentFigure', opticalVectorPlot)
        flowField = estimateFlow(opticFlow,img1gray);
        imshow(img1resize);
        hold on
        plot(flowField,'DecimationFactor',[5 5],'ScaleFactor',30,'Parent',hPlot);
        title('Optical Flow');
        hold off
        pause (10^-3)
        
        
        %Getting the magnitude from the opticalFlow object
        imgMag = flowField.Magnitude;
        imgMagThr = threshholding(imgMag, mean(imgMag(:)));
        imgEro = imErosion(imgMagThr,6);


        set(0, 'CurrentFigure', threshHoldPlot)
        imshow(imgEro);
        
        
       %Iterating over the movement-threshhold to find fitting boxes
        bbox = step(blobAnalysis, imgEro);
        boxImg = insertShape(uint8(imgEro),'Rectangle', bbox, 'Color', 'green');
        numBoxes = size(bbox, 1);
        if numBoxes>0
            if bbox(1,3)>80
                disp('Frame:')
                disp(count);
            end
        end
        set(0, 'CurrentFigure', boxedImgPlot)
        imshow(boxImg)
    end



%%Clean up (Delete Frames)

    %numel(dir("Frames"))-2 is used to get the number of frames in the
    %Folder substracting 2 for the navigation files MATLAB is using to
    %navigate between folders
    for deleter = 1:1:(numel(dir("Frames"))-2)

        filename = strcat('Frames/frame', num2str(deleter), '.jpg');
        if exist(filename, 'file')==2
            delete(filename)
        end

    end

end








