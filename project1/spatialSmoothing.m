function B = spatialSmoothing(A,h)
%%spatialSmoothing Apply a square filter along the first two spatial dimensions.
%   B = spatialSmoothing(A,H) applies the linear, low-pass averaging filter H to
%   the image matrices A.  If H is a single numeric value, then spatialSmoothing
%   instead applies a non-linear median filter of size H.  The resultant matrix
%   is output B.
%
%   Boundary values are preserved.
%
%   Contact:        wu.kevi@northeastern.edu
%   Last updated:   February 20, 2023


% Size of mask
m = size(h,1);
doMedian = (m == 1);
if doMedian
    m = h;
end


% Image dimensions
dim1 = size(A,1);
dim2 = size(A,2);
edgeSize = (m - 1)/2;
irange = (1 + edgeSize):(dim1 - edgeSize);
jrange = (1 + edgeSize):(dim2 - edgeSize);


% Loop (vectorized across temporal dimension)
B = A;
for i = irange
for j = jrange
    % - Get image segments
    vertdx = (i - edgeSize):(i + edgeSize);
    horzdx = (j - edgeSize):(j + edgeSize);
    imageData = B(vertdx,horzdx,:);
    % - Apply filter, vectorized across time
    if doMedian
        B(i,j,:) = median(imageData,[1 2]);
    else
        B(i,j,:) = sum(h.*imageData,[1 2]);
    end
end
end


end