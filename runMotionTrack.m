% load video file and separate into frames
clear;
path = 'testMedia/2ballspeedtest.mp4';
% path = 'testMedia/lowres_test.mp4';
v = VideoReader(path);
frames = read(v,[1,Inf]);
clear v;
[rows, cols, ~, numFrames] = size(frames);

%% Testing processing frames into binary images
%im = imread('testMedia/yelloBallTest.jpg');
% manually select threshold
labIm = rgb2lab(frames(:,:,:,5));
thresh = threshTool(labIm(:,:,3));
for i=1:numFrames
    labIm = rgb2lab(frames(:,:,:,i));
    bin(:,:,i) = labIm(:,:,3) >= thresh;
    se = strel('disk',4);   % size needs to proportional to resolutipon
    bin(:,:,i) = imerode(bin(:,:,i),se);
    bin(:,:,i) = imdilate(bin(:,:,i),se);
    bin(:,:,i) = imdilate(bin(:,:,i),se);
end

%% Display some binary frames
% figure(1);
% clf;
% for i = 1:25
%    subplot(5,5,i);
%    imshow(bin(:,:,i));
% end

%% segment image with labels for each group of pixels corresponding to a
% ball
labels = zeros(rows, cols, 1, numFrames);
blobCount = zeros(numFrames, 1);
for i = 1:numFrames
    [labels(:, :, i), blobCount(i)] = bwlabel(bin(:, :, i));
end

%% calculate the centers of each group of pixels
numBlobs = mode(blobCount);
centers = zeros(numFrames, 2, numBlobs);
dist = zeros(numBlobs);
coords = zeros(numBlobs, 2);
% compute first center
for b = 1:numBlobs
    [y, x] = find(labels(:,:,b) == b);
    x = sum(x) / length(x);
    y = sum(y) / length(y);
    centers(1, 1, b) = x;
    centers(1, 2, b) = y;
end
for i = 2:numFrames
    % compute centers
    for b = 1:numBlobs
        [y, x] = find(labels(:,:,i) == b);
        x = sum(x) / length(x);
        y = sum(y) / length(y);
        coords(b, 1) = x;
        coords(b, 2) = y;
    end
    % compute distances
    for b = 1:numBlobs
    for b2 = 1:numBlobs
        dist(b, b2) = (centers(i-1, 1, b) - coords(b2, 1))^2 + (centers(i-1, 2, b) - coords(b2, 2))^2;
    end
    end
    % compute matching centers
    for b = 1:numBlobs
        [~, ind] = min(dist(b, :), [], 2);
        dist(:, ind) = Inf;
        centers(i, 1, b) = coords(ind, 1);
        centers(i, 2, b) = coords(ind, 2);
    end
end

% %% display center
% figure(2);
% for i = 1:25
%    subplot(5,5,i);
%    imshow(bin(:,:,i));
%    hold on;
%    plot(round(centers(i,1,1)),round(centers(i,2,1)),'r.','MarkerSize',10);
%    plot(round(centers(i,1,2)),round(centers(i,2,2)),'b.','MarkerSize',10);
% end

%% Plot positions on frames
figure(3);
clf;
markers = ['r' 'b' 'g'];
for i = 1:numFrames
    imshow(frames(:,:,:,i));
    hold on;
    for b = 1:blobCount(i)
        plot(centers(i,1,b),centers(i,2,b),[markers(b) '.'],'MarkerSize',20);
    end
    drawnow;
    hold off;
end
