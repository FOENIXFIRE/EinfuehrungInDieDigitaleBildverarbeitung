function [cannyImage] = Grey2Canny(input)
% takes an greyscale image as input 
% returns edges as detected by canny filter
% 
% e.g.: cannyImage = Grey2Canny(input);
%
% source: https://de.mathworks.com/matlabcentral/fileexchange/46859-canny-edge-detection

% set thresholds (low and high) 
lowerThreshold = 0.075;
higherThreshold = 0.175;

% 1. Convolution with Gaussian Filter Coefficient
gaussFilter = [2 4 5 4 2; 4 9 12 9 4; 5 12 15 12 5;4 9 12 9 4; 2 4 5 4 2 ];
gaussFilter = 1/159.* gaussFilter;

gaussImage=conv2(input, gaussFilter, 'same');

% 2. Convolution with Canny Filter for Horizontal and Vertical orientation
horConFilter = [-1 0 1; -2 0 2; -1 0 1];
verConFilter = [1 2 1; 0 0 0; -1 -2 -1];

horFilteredImage = conv2(gaussImage, horConFilter, 'same');
verFilteredImage = conv2(gaussImage, verConFilter, 'same');

% 3. Calculating directions using atan2
arah = atan2 (verFilteredImage, horFilteredImage);
arah = arah*180/pi;
pan=size(gaussImage,1);
leb=size(gaussImage,2);

% 4.1 making negative directions positive 
for i=1:pan
    for j=1:leb
        if (arah(i,j)<0) 
            arah(i,j)=360+arah(i,j);
        end;
    end;
end;
arah2=zeros(pan, leb);

% 4.2 Adjusting directions to nearest 0, 45, 90, or 135 degree
for i = 1  : pan
    for j = 1 : leb
        if ((arah(i, j) >= 0 ) && (arah(i, j) < 22.5) || (arah(i, j) >= 157.5) && (arah(i, j) < 202.5) || (arah(i, j) >= 337.5) && (arah(i, j) <= 360))
            arah2(i, j) = 0;
        elseif ((arah(i, j) >= 22.5) && (arah(i, j) < 67.5) || (arah(i, j) >= 202.5) && (arah(i, j) < 247.5))
            arah2(i, j) = 45;
        elseif ((arah(i, j) >= 67.5 && arah(i, j) < 112.5) || (arah(i, j) >= 247.5 && arah(i, j) < 292.5))
            arah2(i, j) = 90;
        elseif ((arah(i, j) >= 112.5 && arah(i, j) < 157.5) || (arah(i, j) >= 292.5 && arah(i, j) < 337.5))
            arah2(i, j) = 135;
        end;
    end;
end;

% 5.1 Calculate magnitude
magTemp = (horFilteredImage.^2) + (verFilteredImage.^2);
magnitude = sqrt(magTemp);
BW = zeros (pan, leb);

% 5.2 Non-Maximum Supression
for i=2:pan-1
    for j=2:leb-1
        if (arah2(i,j)==0)
            BW(i,j) = (magnitude(i,j) == max([magnitude(i,j), magnitude(i,j+1), magnitude(i,j-1)]));
        elseif (arah2(i,j)==45)
            BW(i,j) = (magnitude(i,j) == max([magnitude(i,j), magnitude(i+1,j-1), magnitude(i-1,j+1)]));
        elseif (arah2(i,j)==90)
            BW(i,j) = (magnitude(i,j) == max([magnitude(i,j), magnitude(i+1,j), magnitude(i-1,j)]));
        elseif (arah2(i,j)==135)
            BW(i,j) = (magnitude(i,j) == max([magnitude(i,j), magnitude(i+1,j+1), magnitude(i-1,j-1)]));
        end;
    end;
end;
BW = BW.*magnitude;

% 6. Hysteresis Thresholding
lowerThreshold = lowerThreshold * max(max(BW));
higherThreshold = higherThreshold * max(max(BW));
T_res = zeros (pan, leb);
for i = 1  : pan
    for j = 1 : leb
        if (BW(i, j) < lowerThreshold)
            T_res(i, j) = 0;
        elseif (BW(i, j) > higherThreshold)
            T_res(i, j) = 1;
            
        %Using 8-connected components
        elseif ( BW(i+1,j)>higherThreshold || BW(i-1,j)>higherThreshold || BW(i,j+1)>higherThreshold || BW(i,j-1)>higherThreshold || BW(i-1, j-1)>higherThreshold || BW(i-1, j+1)>higherThreshold || BW(i+1, j+1)>higherThreshold || BW(i+1, j-1)>higherThreshold)
            T_res(i,j) = 1;
        end;
    end;
end;

% set outputImage to uint8
cannyImage = uint8(T_res.*255);
end