%%runDifferentThreshold Motion detection.
%   This script attempts motion detection on a set of images in two steps:
%       (1) Pre-process images by spatially smoothing with Gaussian filter, and,
%       (2) Compute and threshold response to differential mask.
%
%   Contact:        wu.kevi@northeastern.edu
%   Last updated:   February 20, 2023


% Get image data
imageDir = 'RedChair';
I = readImageData(imageDir);


% Run 1: spatial smoothing, sigma 0.5, 3-by-3
% - Apply spatial filter
spatialFilter = fspecial('gaussian',3,2);
S.Ismooth = spatialSmoothing(I,spatialFilter);
% - Compute temporal derivative response
temporalMask = 0.5*[-1 1 0];
S.R = temporalFilter(S.Ismooth,temporalMask);
% - Get statistics
S.median = median(S.R(:),'all');
S.sigma  = std(S.R(:),[],'all');
% - Save results
Run1 = S;
% - Plot results at different thresholds
plotFilterResult(I,Run1.R,Run1.median + [-1 inf]*Run1.sigma,32,3);
plotFilterResult(I,Run1.R,Run1.median + [-2 inf]*Run1.sigma,32,3);
plotFilterResult(I,Run1.R,Run1.median + [-4 inf]*Run1.sigma,32,3);
plotFilterResult(I,Run1.R,Run1.median + [-8 inf]*Run1.sigma,32,3);