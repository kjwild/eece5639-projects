%%runSimpleMask Script to apply simple temporal mask for motion detection.
%   This script computes the response of a series of consecutive images -- i.e.
%   a video -- to a simple temporal mask, then plots where motion is detected
%   based on a threshold on that response.
%
%   Contact:        wu.kevi@northeastern.edu
%   Last updated:   February 13, 2023


% Set run configurations
imageDir = 'RedChair';
% mask     = 0.5*[-1 0 1];
mask     = 0.5*[-1 1 0];


% Read image data
I = readImageData(imageDir);


% Compute response
R = temporalFilter(I,mask);


% Process statistics
disp(['# Results for ' imageDir]);
dI = diff(double(I),[],3);
fprintf('\tAbsolute pixel change, mean:    %6.2f\n',mean(abs(dI(:)),'all'));
fprintf('\t                       median:  %6.2f\n',median(abs(dI(:)),'all'));
fprintf('\t                       1-sigma: %6.2f\n',std(abs(dI(:)),0,'all'));
fprintf('\tResponse, mean:    %6.2f\n',mean(abs(R(:)),'all'));
fprintf('\t          median:  %6.2f\n',median(abs(R(:)),'all'));
fprintf('\t          1-sigma: %6.2f\n',std(abs(R(:)),0,'all'));


% Set threshold
% threshold = median(R(:),'all') + [-1 1]*std(R(:),0,'all');
threshold = [-inf median(R(:),'all') + std(R(:),0,'all')];


% Plot results
plotFilterResult(I,R,threshold,[32 190]);


% Adjust plot
fig = gcf;
t = title('');
ax = gca;
    ax.Units = 'pixels';
    ax.Position(4) = 340;
x = xlabel(['(a)' repmat(' ',1,38) '(b)' repmat(' ',1,38) '(c)']);
    x.FontSize = 28;
    x.HorizontalAlignment = 'left';
    x.Position = [295 490];