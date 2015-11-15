% load video file and separate into frames
path = 'testMedia/lowres_test.mp4';
v = VideoReader(path);
frames = read(v,[1,Inf]);
[rows, cols, ~, numFrames] = size(frames);

%% Testing processing frames into binary images
%im = imread('testMedia/yelloBallTest.jpg');
for i=1:numFrames
    labIm = rgb2lab(frames(:,:,:,i));
    bin(:,:,i) = labIm(:,:,3) >= 30 & labIm(:,:,3) <= 70;
end

%% Display some binary frames
for i = 25:50
   subplot(5,5,i-24);
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