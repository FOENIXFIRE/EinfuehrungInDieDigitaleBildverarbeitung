function carDetection_opticalFlow (videoName)

clear;
close all;
clc;

%%Get Frames
Video2Frames('video1')


h = figure;
        movegui(h);
        hViewPanel = uipanel(h,'Position',[0 0 1 1],'Title','Plot of Optical Flow Vectors');
        hPlot = axes(hViewPanel);

opticFlow = opticalFlowHS;

    for count = 1:3:(numel(dir("Frames"))-2)
        
        filename = strcat('Frames/frame', num2str(count), '.jpg');
        imgFile = imread(filename);
        img1resize = imResize(imgFile, 0.2, 0.2);
        img1gray = RGB2Grey(img1resize);
        
        IThresh = threshholding(img1gray, 130);
        
        
        imshow(imgFile);
        flowField = estimateFlow(opticFlow,img1gray);
        hold on
        plot(flowField,'DecimationFactor',[10 10],'ScaleFactor',20,'Parent',hPlot);
        title('OPtical Flow');
        hold off
        pause (10^-3)
        
        
        
             
    end



%%Clean up (Delete Frames)
    for deleter = 1:1:(numel(dir("Frames"))-2)

        filename = strcat('Frames/frame', num2str(deleter), '.jpg');
        if exist(filename, 'file')==2
            delete(filename)
        end

    end

end








