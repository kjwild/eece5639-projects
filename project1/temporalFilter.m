function R = temporalFilter(I,h)
%%temporalFilter Apply a mask along the third dimension of a matrix array.
%   R = temporalFilter(I,H) computes the response to a 1D mask H applied across
%   the third dimension of an array of matrices I.
%
%   Contact:        wu.kevi@northeastern.edu
%   Last updated:   February 20, 2023


% Size of boundary to ignore
assert(mod(length(h),2) == 1,'Mask must be odd-length.')
bufferSize = floor(length(h)/2);


% Mask over all pixels
mask = repmat(reshape(h,1,1,[]),size(I,1),size(I,2));


% Loop
R = zeros(size(I));
for i = (1 + bufferSize):(size(I,3) - bufferSize)
    % - Get image segment
    imageData = I(:,:,(i - bufferSize):(i + bufferSize));
    % - Obtain response to mask
    imageProd = mask.*double(imageData);
    R(:,:,i) = sum(imageProd,3);
end


end