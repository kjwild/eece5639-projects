function I = readImageData(filedir,showimage)
%%readImageData Return grayscale intensity values for image.
%   I = readImageData(FILEDIR) reads the image within the file at FILEDIR and
%   returns the grayscale intensities in the matrix I over the same image
%   dimensions.  If FILEDIR is a cell array of T files, then I is a M-by-N-by-T
%   array of the T corresponding M-by-N grayscale images.
%
%   FILEDIR can also be the path to a folder containing the images.
%
%   readImageData(FILEDIR,SHOWIMAGE) also plots the image data with imshow if
%   SHOWIMAGE is TRUE.
%   
%   Contact:        wu.kevi@northeastern.edu
%   Last updated:   February 13, 2023


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
firstImage = im2gray(imread(filedir{1}));
I = zeros(size(firstImage,1),size(firstImage,2),n,'uint8');
I(:,:,1) = firstImage;
for i = 2:n
    I(:,:,i) = im2gray(imread(filedir{i}));
end


% Show images
if showimage
    figure;
    for i = 1:n
        imshow(I{i});
    end
end


end