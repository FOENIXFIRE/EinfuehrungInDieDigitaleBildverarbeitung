function carDetection_opticalFlow (videoName)

close all;
clc;

%%Get Frames
Video2Frames(videoName)


opticalVectorPlot = figure;
        movegui(opticalVectorPlot);
        hViewPanel = uipanel(opticalVectorPlot,'Position',[0 0 1 1],'Title','Plot of Optical Flow Vectors');
        hPlot = axes(hViewPanel);

threshHoldPlot = figure;  

originalImgPlot = figure;
        
        
opticFlow = opticalFlowHS;

    for count = 1:3:(numel(dir("Frames"))-2)
        
        filename = strcat('Frames/frame', num2str(count), '.jpg');
        imgFile = imread(filename);
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
        
        
        
        imgMag = flowField.Magnitude;
        imgMagThr = threshholding(imgMag, mean(imgMag(:)));
        imgEro = imErosion(imgMagThr,6);
%       imgEro = imErosion(imgMagThr);

        set(0, 'CurrentFigure', threshHoldPlot)
          imshow(imgEro);
        
        
        
             
    end



%%Clean up (Delete Frames)
    for deleter = 1:1:(numel(dir("Frames"))-2)

        filename = strcat('Frames/frame', num2str(deleter), '.jpg');
        if exist(filename, 'file')==2
            delete(filename)
        end

    end

end








