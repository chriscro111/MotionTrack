% load video file and separate into frames
path = 'testMedia/VID_20151115_100007984.mp4';
v = VideoReader(path);
frames = read(v,[1,Inf]);
% process each frame into a binary image with the balls in the foreground
%% Testing processing frames into binary images
%im = imread('testMedia/yelloBallTest.jpg');
for i=1:size(frames,4)
    labIm = rgb2lab(frames(:,:,:,i));
    bin(:,:,i) = labIm(:,:,3) >= 30 & labIm(:,:,3) <= 70;
end

%% Display some binary frames
for i = 1:25
   subplot(5,5,i);
   imshow(bin(:,:,i));
end

% segment image with labels for each group of pixels corresponding to a
% ball

% calculate the centers of each group of pixels

% some kind of plot/animation showing position over time for each ball??