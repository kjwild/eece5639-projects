function plotFilterResult(I,R,threshold,frame,showOutput)
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
%   plotFilterResult(I,R,THRESHOLD,FRAME) returns only the data corresponding to
%   the FRAME number of I only the 3rd dimension.  If the number of frames is
%   greater than 3, then only one figure is output with DRAWNOW() called.
%   Otherwise, only those frames are output in the corresponding number of
%   figures.
%
%   plotFilterResult(...,SHOWOUTPUT) adjusts which results are shown in the
%   output figure depending on what values are in SHOWOUTPUT.
%       1:  original image
%       2:  response heatmap
%       3:  threshold response
%
%   Contact:        wu.kevi@northeastern.edu
%   Last updated:   February 20, 2023


% Check input
if (nargin < 4) || isempty(frame)
    frame = 1:size(I,3);
end
if (nargin < 5)
    showOutput = 1:3;
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
if (length(frame) > 3)
    doAnimation = true;
    fig = figure;
else
    doAnimation = false;
    fig = cell(1,length(frame));
    fig{1} = figure;
end
% - Time loop
for i = frame
    % -- Montage input buffer
    montageInput = cell(1,3);
    % -- Image data
    imageData = I(:,:,i);
    if any(showOutput == 1)
        montageInput{1} = imageData;
    end
    % -- Heatmap
    if any(showOutput == 2)
        responseColorIdx = reshape(Rnorm(:,:,i),1,[],1); % column index
        responseColorVal = colorValue(responseColorIdx,:); % (M*N)-by-3 RGB
        heatmapMatrix = uint8(reshape(256*responseColorVal,m,n,3));
        montageInput{2} = heatmapMatrix;
    end
    % -- Binary overlay
    if any(showOutput == 3)
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
        montageInput{3} = binaryOverlay;
    end
    % -- Plot
    idx = ~cellfun(@isempty,montageInput);
    montage(montageInput(idx),'Size',[1 length(showOutput)]);
    % -- Auxiliary
    title(['Frame ' num2str(i)]);
    if doAnimation
        drawnow();
    elseif (i ~= frame(end))
        fig{i == frame} = figure;
    end
end


end