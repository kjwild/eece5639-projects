%%runGaussianMask Script to apply simple temporal mask for motion detection.
%   This script computes the response of a series of consecutive images -- i.e.
%   a video -- to a 1D Gaussian mask, then plots where motion is detected
%   based on a threshold on that response.
%
%   Contact:        wu.kevi@northeastern.edu
%   Last updated:   February 20, 2023


% Which image directory?
imageDir = 'RedChair';
I = readImageData(imageDir);


% First run: Gaussian, sigma = 0.5
% - Set mask
S.mask = fspecial('gaussian',[1 3],0.5);
% - Compute response
S.R = temporalFilter(I,S.mask);
% - Process statistics
S.mean   = mean(S.R(:),'all');
S.median = median(S.R(:),'all');
S.sigma  = std(S.R(:),[],'all');
S.min    = min(S.R(:),[],'all');
S.max    = max(S.R(:),[],'all');
% - Save results
Run1 = S;
% - Check result
plotFilterResult(I,Run1.R,Run1.median + [-1 1]*Run1.sigma,32,2);


% Second run: 0.5*[-1 0 1] + Gaussian, sigma = 0.5
% - Set mask
S.mask1 = 0.5*[-1 0 1];
S.mask2 = fspecial('gaussian',[1 3],10);
% - Compute response
S.R1 = temporalFilter(I,S.mask1);
S.R2 = temporalFilter(S.R1,S.mask2);
% - Process statistics
S.mean   = mean(S.R2(:),'all');
S.median = median(S.R2(:),'all');
S.sigma  = std(S.R2(:),[],'all');
S.min    = min(S.R2(:),[],'all');
S.max    = max(S.R2(:),[],'all');
% - Save results
Run2 = S;
% - Check result
plotFilterResult(I,Run2.R2,Run2.median + [-1 1]*Run2.sigma,32,2);
plotFilterResult(I,Run2.R2,Run2.median + [-1 1]*Run2.sigma,32,3);


% Third run: 0.5*[-1 0 1] + Gaussian, sigma = 2
% - Set mask
S.mask1 = 0.5*[-1 0 1];
S.mask2 = fspecial('gaussian',[1 3],2);
% - Compute response
S.R1 = temporalFilter(I,S.mask1);
S.R2 = temporalFilter(S.R1,S.mask2);
% - Process statistics
S.mean   = mean(S.R2(:),'all');
S.median = median(S.R2(:),'all');
S.sigma  = std(S.R2(:),[],'all');
S.min    = min(S.R2(:),[],'all');
S.max    = max(S.R2(:),[],'all');
% - Save results
Run3 = S;
% - Check result
plotFilterResult(I,Run3.R2,Run3.median + [-1 1]*Run3.sigma,32,2);
plotFilterResult(I,Run3.R2,Run3.median + [-1 1]*Run3.sigma,32,3);


% Fourth run: offset 0.5*[-1 1 0] + Gaussian, sigma = 0.5
% - Set mask
S.mask1 = 0.5*[-1 1 0];
S.mask2 = fspecial('gaussian',[1 3],0.5);
% - Compute response
S.R1 = temporalFilter(I,S.mask1);
S.R2 = temporalFilter(S.R1,S.mask2);
% - Process statistics
S.mean   = mean(S.R2(:),'all');
S.median = median(S.R2(:),'all');
S.sigma  = std(S.R2(:),[],'all');
S.min    = min(S.R2(:),[],'all');
S.max    = max(S.R2(:),[],'all');
% - Save results
Run4 = S;
% - Check result
plotFilterResult(I(:,:,2:end),Run4.R2(:,:,1:end-1), ...
    Run4.median + [-1 inf]*Run4.sigma,31,2:3);
plotFilterResult(I(:,:,2:end),Run4.R2(:,:,1:end-1), ...
    Run4.median + [-1 inf]*Run4.sigma,192,2:3);


% Fifth run: offset 0.5*[-1 1 0] + Gaussian, sigma = 2
% - Set mask
S.mask1 = 0.5*[-1 1 0];
S.mask2 = fspecial('gaussian',[1 3],2);
% - Compute response
S.R1 = temporalFilter(I,S.mask1);
S.R2 = temporalFilter(S.R1,S.mask2);
% - Process statistics
S.mean   = mean(S.R2(:),'all');
S.median = median(S.R2(:),'all');
S.sigma  = std(S.R2(:),[],'all');
S.min    = min(S.R2(:),[],'all');
S.max    = max(S.R2(:),[],'all');
% - Save results
Run5 = S;
% - Check result
plotFilterResult(I(:,:,2:end),Run5.R2(:,:,1:end-1), ...
    Run5.median + [-1 inf]*Run5.sigma,31,2:3);
plotFilterResult(I(:,:,2:end),Run4.R2(:,:,1:end-1), ...
    Run5.median + [-1 inf]*Run5.sigma,192,2:3);