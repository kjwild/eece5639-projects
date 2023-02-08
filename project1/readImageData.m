function I = readImageData(filedir,showimage)
%%readImageData Return grayscale intensity values for image.
%   I = readImageData(FILEDIR) reads the image within the file at FILEDIR and
%   returns the grayscale intensities in the matrix I over the same image
%   dimensions.  If FILEDIR is a cell array of N files, then I is a cell array
%   of the N corresponding grayscale image data.
%
%   FILEDIR can also be the path to a folder containing the images.
%
%   readImageData(FILEDIR,SHOWIMAGE) also plots the image data with imshow if
%   SHOWIMAGE is TRUE.
%   
%   Contact:        wu.kevi@northeastern.edu
%   Last updated:   February 07, 2023


% Check the format of the input
if ~iscell(filedir) && isfile(filedir)
    filedir = {filedir};
elseif ~iscell(filedir) && isfolder(filedir)
    dircontent = cellstr(ls(filedir));
    dircontent = dircontent(3:end); % first 2 are duds
    filedir = fullfile(filedir,dircontent);
end
if (nargin < 2)
    showimage = false;
end


% Read in image data
n = length(filedir);
I = cell(size(filedir));
for i = 1:n
    I{i} = im2gray(imread(filedir{i}));
end


% Show images
if showimage
    figure;
    for i = 1:n
        imshow(I{i});
    end
end


end