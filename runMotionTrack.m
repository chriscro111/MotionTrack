% load video file and separate into frames
path = 'testMedia/lowres_test.mp4';
v = VideoReader(path);
frames = read(v,[1,Inf]);
[rows, cols, ~, numFrames] = size(frames);

%% Testing processing frames into binary images
%im = imread('testMedia/yelloBallTest.jpg');
% manually select threshold
labIm = rgb2lab(frames(:,:,:,1));
thresh = threshTool(labIm(:,:,3));
for i=1:numFrames
    labIm = rgb2lab(frames(:,:,:,i));
    bin(:,:,i) = labIm(:,:,3) >= thresh;
    se = strel('disk',2);  
    bin(:,:,i) = imerode(bin(:,:,i),se);
    bin(:,:,i) = imdilate(bin(:,:,i),se);
    bin(:,:,i) = imdilate(bin(:,:,i),se);
end

%% Display some binary frames
figure(1);
clf;
for i = 1:25
   subplot(5,5,i);
   imshow(bin(:,:,i));
end

%% segment image with labels for each group of pixels corresponding to a
% ball
labels = zeros(rows, cols, 1, numFrames);
numBlobs = zeros(numFrames, 1);
for i = 1:numFrames
    [labels(:, :, i), numBlobs(i)] = bwlabel(bin(:, :, i));
end

%% calculate the centers of each group of pixels

%% some kind of plot/animation showing position over time for each ball??