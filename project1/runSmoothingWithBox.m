%%runSmoothingWithBox Simple 1D time differential on images smoothed by box.
%   This script attempts motion detection on a set of images in two steps:
%       (1) Pre-process images by spatially smoothing with different box
%       filters, then,
%       (2) Compute and threshold response to differential mask.
%
%   Contact:        wu.kevi@northeastern.edu
%   Last updated:   February 20, 2023


% Get image data
imageDir = 'RedChair';
I = readImageData(imageDir);


% Run 1: spatial smoothing with 3-by-3
% - Apply spatial filter
spatialFilter = 1/9*ones(3);
S.Ismooth = spatialSmoothing(I,spatialFilter);
% - Compute temporal derivative response
temporalMask = 0.5*[-1 1 0];
S.R = temporalFilter(S.Ismooth,temporalMask);
% - Set threshold
S.median    = median(S.R(:),'all');
S.sigma     = std(S.R(:),[],'all');
S.threshold = S.median + [-1 inf]*S.sigma;
% - Save results
Run1 = S;
% - Check smoothed image
plotFilterResult(Run1.Ismooth,Run1.R,[],32,1);
plotFilterResult(I,Run1.R,Run1.threshold,32,2:3);
plotFilterResult(Run1.Ismooth,Run1.R,Run1.threshold,192,2);


% Run 2: spatial smoothing with 5-by-5
% - Apply spatial filter
spatialFilter = 1/25*ones(5);
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


% Run 3: spatial smoothing with 15-by-15
% - Apply spatial filter
spatialFilter = 1/225*ones(15);
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


% Results from additional smoothing
plotFilterResult(Run2.Ismooth,Run2.R,[],32,1);
plotFilterResult(Run3.Ismooth,Run3.R,[],32,1);
plotFilterResult(I,Run2.R,Run2.threshold,32,3);
plotFilterResult(I,Run3.R,Run3.threshold,32,3);
plotFilterResult(Run2.Ismooth,Run2.R,Run2.threshold,192,2);
plotFilterResult(Run3.Ismooth,Run3.R,Run3.threshold,192,2);