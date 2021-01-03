function carDetection_opticalFlow (videoName)

clear;
close all;
clc;


% Video2Frames(videoName)
% 
% 
% video = VideoReader(videoName);
% 
% 
%     for count = 1:3:video.NumberOfFrames
%         filename = strcat('Frames/frame', num2str(count), '.jpg');
%         imgFile1 = imread(filename);
%         
%         
%     end

opticFlow =  opticalFlowLK;

% img1 = RGB2Grey('frame1');
% img2 = RGB2Grey('frame11');




img1 = imread('Frames/frame1.jpg'); 
img2 = imread('Frames/frame11.jpg');
    

img1resize = imResize(img1, 0.2, 0.2);
img2resize = imResize(img2, 0.2, 0.2);

img1gray = im2gray(img1resize);
img2gray = im2gray(img2resize);


IThresh = threshholding(img1gray, 130);


for i=1:2
   
    subplot(2,2,1);
    imshow(img1gray);
    
    subplot(2,2,2);
    imshow(img2gray);
    
    subplot(2,2,3);
    imshow(IThresh);
    
    
    flowField = estimateFlow(opticFlow, img1gray);
    %flowField = estiamteFlow(opticFlow, img2gray);
    
    subplot(2,2,4);
    plot(flowField,'DecimationFactor', [10 10],'ScaleFactor',20);
    title('Optical Flow')
%     y1 = flowfield .* conj(flowfield);
%     imshow(y1> mean(y1(:)))
    
end

end

% %%Installation
% 
% %Create reader
% reader = vision.VideoFileReader;
% reader.Filename = 'video1.mov';
% 
% %Create viewer
% viewer = vision.DeployableVideoPlayer;
% 
% %Create optical flow
% optical = opticalFlowLK;
% %optical.OutputValue = 'Horizontal and vertical components in complex form';
% 
% %Display Vector Field
% shapes = vision.ShapeInserter;
% shape.Shape = 'Lines';
% shape.BorderColor = 'white';
% 
% R = 1:4:120; C = 1:4:160;
% [Cv, Rv] = meshgrid(C,R);
% Rv = Rv(:)'; Cv = Cv(:)';
% 
% %%Execution
% reset(reader);
% 
% %Set up for stream
% while ~isDone(reader)
%     I = step(reader);
%     of = step(optical, rgb2gray(I));
%     
%     y1 = of .* conj(of);
%     
%     step(viewThresh, y1> mean(y1(:)));
% end


% %%Clean up
% if exist('frame1.jpg', 'file')==2
%     delete('frame1.jpg')
% end

