%%runSimpleMask Script to apply simple temporal mask for motion detection.
%   This script computes the response of a series of consecutive images -- i.e.
%   a video -- to a simple temporal mask, then plots where motion is detected
%   based on a threshold on that response.
%
%   Contact:        wu.kevi@northeastern.edu
%   Last updated:   February 13, 2023


% Which image directory?
imageDir = 'RedChair';
I = readImageData(imageDir);


% Statistics on absolute changes in pixel values across time (for curisoity)
dI = diff(double(I),[],3);
dpixelMean   = mean(abs(dI(:)),'all');
dpixelMedian = median(abs(dI(:)),'all');
dpixelSigma  = std(abs(dI(:)),0,'all');
dpixelMax    = max(abs(dI(:)),[],'all');


% First run: 0.5*[-1 0 1]
% - Set mask
S.mask = 0.5*[-1 0 1];
% - Compute response
S.R = temporalFilter(I,S.mask);
% - Process statistics (mind the sign; it corresponds to the mask sign)
S.mean   = mean(S.R(:),'all');
S.median = median(S.R(:),'all');
S.sigma  = std(S.R(:),[],'all');
S.min    = min(S.R(:),[],'all'); % aka negative direction extreme
S.max    = max(S.R(:),[],'all'); % aka positive direction extreme
% - Save results
Run1 = S;


% Post-processing for Run 1
% - Frame 32 (obvious motion)
plotFilterResult(I,Run1.R,[],32,1);
% - Response for frame 32
plotFilterResult(I,Run1.R,[],32,2);
% - Threshold for frame 32, in both temporal directions
plotFilterResult(I,Run1.R,Run1.median + [-1 1]*Run1.sigma,32,3);
% - Frame 190 motion detection from flicker noise
plotFilterResult(I,Run1.R,Run1.median + [-1 1]*Run1.sigma,190,1:3);
fig = gcf;
t = title('');
ax = gca;
    ax.Units = 'pixels';
    ax.Position(4) = 340;
x = xlabel(['(a)' repmat(' ',1,38) '(b)' repmat(' ',1,38) '(c)']);
    x.FontSize = 28;
    x.HorizontalAlignment = 'left';
    x.Position = [295 490];
% - Frame 60 (convergence as motion slows down)
plotFilterResult(I,Run1.R,[],60,1);
plotFilterResult(I,Run1.R,[],60,2);
plotFilterResult(I,Run1.R,Run1.median + [-1 1]*Run1.sigma,60,3);


% Second run: 0.25*[1 1 0 -1 -1]
% - Set mask
S.mask = 0.25*[1 1 0 -1 -1];
% - Compute response
S.R = temporalFilter(I,S.mask);
% - Process statistics (mind the sign; it corresponds to the mask sign)
S.mean   = mean(S.R(:),'all');
S.median = median(S.R(:),'all');
S.sigma  = std(S.R(:),[],'all');
S.min    = min(S.R(:),[],'all'); % aka negative direction extreme
S.max    = max(S.R(:),[],'all'); % aka positive direction extreme
% - Set threshold
threshold = S.median + [-1 1]*S.sigma;
% - Save results
Run2 = S;
% - Check Frame 32 output
plotFilterResult(I,Run2.R,threshold,32,2);


% Third run: 0.5*[-1 1 0]
% - Set mask
S.mask = 0.5*[-1 1 0];
% - Compute response
S.R = temporalFilter(I,S.mask);
% - Process statistics (mind the sign; it corresponds to the mask sign)
S.mean   = mean(S.R(:),'all');
S.median = median(S.R(:),'all');
S.sigma  = std(S.R(:),[],'all');
S.min    = min(S.R(:),[],'all'); % aka negative direction extreme
S.max    = max(S.R(:),[],'all'); % aka positive direction extreme
% - Set threshold
threshold = S.median + [-1 inf]*S.sigma;
% - Save results
Run3 = S;
% - Check Frame 32 output
plotFilterResult(I,Run3.R,threshold,32,2);
plotFilterResult(I,Run3.R,threshold,32,3);