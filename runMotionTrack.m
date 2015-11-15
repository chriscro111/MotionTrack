% load video file and separate into frames
path = 'testMedia/53601da914442f9b28000001-b30-600.mp4';
v = VideoReader(path);
frames = read(v,[1,Inf]);
% process each frame into a binary image with the balls in the foreground
%% Testing processing frames into binary images
im = imread('testMedia/yelloBallTest.jpg');
labIm = rgb2lab(im);
bin = zeros(size(labIm,1),size(labIm,2));
bin = labIm(:,:,3) >= 30 & labIm(:,:,3) <= 70;
imshow(bin);

    
% segment image with labels for each group of pixels corresponding to a
% ball

% calculate the centers of each group of pixels

% some kind of plot/animation showing position over time for each ball??