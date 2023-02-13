function plotFilterResult(I,R,threshold,frame)
%%plotFilterResult Animate a series of images representing the filter result.
%   plotFilterResult(I,R,THRESHOLD) takes the M-by-N-by-T array I of grayscale
%   images -- where M and N are the image dimensions and T is the number of
%   images -- and plots:
%       (1) a heatmap of the response R of each pixel in I over time, and,
%       (2) a binary overlay on the original image indicating image detection
%           according to responses that exceed THRESHOLD.
%
%   The heatmap uses the jet RGB colormap.  Green indicates low to no response;
%   red, high negative; and blue, high positive.
%
%   plotFilterResult(I,R,THRESHOLD,FRAME) stops the figure on FRAME.
%
%   Contact:        wu.kevi@northeastern.edu
%   Last updated:   February 13, 2023


% Check input
if (nargin < 4)
    frame = 0;
end


% Generate 256-by-3 colormap for response heatmap
colorValue = jet;


% Get image dimensions
m = size(I,1);
n = size(I,2);


% Normalize response to multiple of 128 for heatmap
minMultiple = min(R,[],'all')/128;
maxMultiple = max(R,[],'all')/128;
newMinValue = sign(minMultiple)*ceil(abs(minMultiple))*128;
newMaxValue = sign(maxMultiple)*ceil(abs(maxMultiple))*128;
scaleFactor = 256/(newMaxValue - newMinValue);
Rnorm = round((R - newMinValue)*scaleFactor) + 1; % normalized values = indices


% Create plot
% - Figure
figure;
% - Time loop
for i = 1:size(I,3)
    % -- Image data
    imageData = I(:,:,i);
    % -- Heatmap
    responseColorIdx = reshape(Rnorm(:,:,i),1,[],1); % column index
    responseColorVal = colorValue(responseColorIdx,:); % (M*N)-by-3 RGB values
    heatmapMatrix = uint8(reshape(256*responseColorVal,m,n,3));
    % -- Binary overlay
    redValues = imageData;
    greenValues = imageData;
    blueValues = imageData;
    switch length(threshold)
        case 1
            motionDetected = (abs(R(:,:,i)) > threshold);
        case 2
            motionDetected = (R(:,:,i) < threshold(1)) ...
                | (R(:,:,i) > threshold(2));
    end
    redValues(motionDetected) = 0;
    greenValues(motionDetected) = 0;
    blueValues(motionDetected) = 255;
    binaryOverlay = reshape([redValues greenValues blueValues],m,n,3);
    % -- Plot
    montage({imageData heatmapMatrix binaryOverlay},'Size',[1 3]);
    % -- Auxiliary
    title(['Frame ' num2str(i)]);
    if any(i == frame)
        keyboard();
    else
        drawnow();
    end
end


end