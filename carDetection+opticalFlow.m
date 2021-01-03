function 

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


