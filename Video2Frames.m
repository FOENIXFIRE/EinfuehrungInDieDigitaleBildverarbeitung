% Jan König (01007167)
function Video2Frames(input)
% takes a video (path) and processes it
% Function will save each frame of the given video as a .jpg in the folder "Frames"
%
% folders "VideoFiles" & "Frames" must already be present in working directory
% video file must be of type .mov and be present in "VideoFiles"
%
% e.g.: Video2Frames('video1')
%
% source: none needed

% creating Path to file
filePath = strcat('VideoFiles/', input, '-', '.mov');

% check if file actually exists
if 2==exist(filePath,'file')
    % File exists
    
    % creating video-object
    video = VideoReader(filePath); 
    
    % iterating over each frame and writing each into folder 'Frames' as input-xx.jpg (e.g.: suzuki-23.jpg)
    for img = 1:video.NumberOfFrames
        filename = strcat('Frames/', input, num2str(img), '.jpg');
        tempframe = read(video, img); 
        imwrite(tempframe, filename);
    end

else 
    % File does not exist
     disp('Video2Frames: error, no such file exists');
end
