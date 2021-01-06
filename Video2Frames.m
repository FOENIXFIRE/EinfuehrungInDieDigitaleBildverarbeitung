function Video2Frames(fileName)
% takes the name of a video and processes it. Function will save each frame 
% of the given video as a .jpg in the folder "Frames"

% Vorbedingungen: 
% folders "VideoFiles" & "Frames" need to be present in working directory
% video file must be .mp4 and file must be present in "VideoFiles"


filePath = strcat('VideoFiles/', fileName, '.mov');
if 2==exist(filePath,'file')
    % File exists.
    
    video = VideoReader(filePath); 
    
    % iterating each frame and writing it to Frames/ as framex.jpg
    for img = 1:video.NumberOfFrames
        filename = strcat('Frames/frame', num2str(img), '.jpg');
        tempframe = read(video, img); 
        imwrite(tempframe, filename);
    end

else 
    % File does not exist.
     disp('Video2Frames: error, no such file exists');
end

