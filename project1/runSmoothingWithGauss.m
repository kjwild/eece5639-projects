%%runSmoothingWithGauss Simple 1D time differential, smoothed by Gaussian.
%   This script attempts motion detection on a set of images in two steps:
%       (1) Pre-process images by spatially smoothing with different Gaussian
%       filters, then,
%       (2) Compute and threshold response to differential mask.
%
%   Contact:        wu.kevi@northeastern.edu
%   Last updated:   February 20, 2023


% Get image data
imageDir = 'RedChair';
I = readImageData(imageDir);


% Run 1: spatial smoothing, sigma 0.5, 3-by-3
% - Apply spatial filter
spatialFilter = fspecial('gaussian',3,0.5);
S.Ismooth = spatialSmoothing(I,spatialFilter);
% - Compute temporal derivative response
temporalMask = 0.5*[-1 1 0];
S.R = temporalFilter(S.Ismooth,temporalMask);
% - Set threshold
S.median  = median(S.R(:),'all');
S.sigma   = std(S.R(:),[],'all');
S.threshold = S.median + [-1 inf]*S.sigma;
% - Save results
Run1 = S;


% Run 2: spatial smoothing, sigma 0.5, 15-by-15
% - Apply spatial filter
spatialFilter = fspecial('gaussian',15,0.5);
S.Ismooth = spatialSmoothing(I,spatialFilter);
% - Compute temporal derivative response
temporalMask = 0.5*[-1 1 0];
S.R = temporalFilter(S.Ismooth,temporalMask);
% - Set threshold
S.median  = median(S.R(:),'all');
S.sigma   = std(S.R(:),[],'all');
S.threshold = S.median + [-1 inf]*S.sigma;
% - Save results
Run2 = S;


% Results from increasing Gaussian size
% - Smoothed images
plotFilterResult(Run1.Ismooth,Run1.R,[],32,1);
plotFilterResult(Run2.Ismooth,Run2.R,[],32,1);
% - Motion detections
plotFilterResult(I,Run1.R,Run1.threshold,32,3);
plotFilterResult(I,Run2.R,Run2.threshold,32,3);
% - Impact on noise
plotFilterResult(Run1.Ismooth,Run1.R,Run1.threshold,192,2);
plotFilterResult(Run2.Ismooth,Run2.R,Run2.threshold,192,2);


% Run 3: spatial smoothing, sigma 2, 3-by-3
% - Apply spatial filter
spatialFilter = fspecial('gaussian',3,2);
S.Ismooth = spatialSmoothing(I,spatialFilter);
% - Compute temporal derivative response
temporalMask = 0.5*[-1 1 0];
S.R = temporalFilter(S.Ismooth,temporalMask);
% - Set threshold
S.median  = median(S.R(:),'all');
S.sigma   = std(S.R(:),[],'all');
S.threshold = S.median + [-1 inf]*S.sigma;
% - Save results
Run3 = S;


% Run 4: spatial smoothing, sigma 10, 15-by-15
% - Apply spatial filter
spatialFilter = fspecial('gaussian',15,10);
S.Ismooth = spatialSmoothing(I,spatialFilter);
% - Compute temporal derivative response
temporalMask = 0.5*[-1 1 0];
S.R = temporalFilter(S.Ismooth,temporalMask);
% - Set threshold
S.median  = median(S.R(:),'all');
S.sigma   = std(S.R(:),[],'all');
S.threshold = S.median + [-1 inf]*S.sigma;
% - Save results
Run4 = S;


% Results from increasing Gaussian sigma
% - Smoothed images
plotFilterResult(Run3.Ismooth,Run3.R,[],32,1);
plotFilterResult(Run4.Ismooth,Run4.R,[],32,1);
% - Motion detections
plotFilterResult(I,Run3.R,Run3.threshold,32,3);
plotFilterResult(I,Run4.R,Run4.threshold,32,3);
% - Impact on noise
plotFilterResult(Run3.Ismooth,Run3.R,Run3.threshold,192,2);
plotFilterResult(Run4.Ismooth,Run4.R,Run4.threshold,192,2);