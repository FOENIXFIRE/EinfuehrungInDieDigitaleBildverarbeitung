% Jan Koenig (01007167)
function Video2Frames(input)
% takes a video-object and processes it
% Function will save each frame of the given video as a .jpg in the folder "Frames"
%
% folders "VideoFiles" & "Frames" must be present in working directory
% video file must be of type .mov and be present in "VideoFiles
%
% e.g. Video2Frames('suzuki');
%
% source: none needed

% creating Path to file
filePath = strcat('VideoFiles/', input, '.mov');

% File exists.
video = VideoReader(filePath); 
    
% iterating over each frame and writing it to Frames/ as framex.jpg
for img = 1:video.NumberOfFrames
    filename = strcat('Frames/', input, '-', num2str(img), '.jpg');
    tempframe = read(video, img); 
    imwrite(tempframe, filename);
end

end
