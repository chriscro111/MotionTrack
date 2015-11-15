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

for i=1:size(labels,4)
   blob1X = 0;
   blob1Y = 0;
   blob2X = 0;
   blob2Y = 0;
   blob3X = 0;
   blob3Y = 0;
   blob1Count = 0;
   blob2Count = 0;
   blob3Count = 0;
   for j=1:size(labels,1)
      for k=1:size(labels,2)
          if labels(j,k,1,i) > 0
              switch labels(j,k,1,i)
                  case 1
                      blob1X = blob1X + k;
                      blob1Y = blob1Y + j;
                      blob1Count = blob1Count + 1;
                  case 2
                      blob2X = blob2X + k;
                      blob2Y = blob2Y + j;
                      blob2Count = blob2Count + 1;
                  case 3
                      blob3X = blob3X + k;
                      blob3Y = blob3Y + j;
                      blob3Count = blob3Count + 1;
              end
          end
      end
   end
   if blob1Count > 0
    avgX = blob1X / blob1Count;
    avgY = blob1Y / blob1Count;
    centers(i,1,1) = avgX;
    centers(i,2,1) = avgX;
   end
   if blob2Count > 0
    avgX = blob2X / blob2Count;
    avgY = blob2Y / blob2Count;
    centers(i,1,2) = [avgX avgY];
    centers(i,2,2) = [avgX avgY];
   end
   if blob3Count > 0
    avgX = blob3X / blob3Count;
    avgY = blob3Y / blob3Count;
    centers(i,1,3) = [avgX avgY];
    centers(i,2,3) = [avgX avgY];
   end
end

%% display center
for i = 1:25
   subplot(5,5,i);
   imshow(bin(:,:,i));
   hold on;
   plot(centers(i,1,1),centers(i,2,1),'r.','MarkerSize',10);
end
%% some kind of plot/animation showing position over time for each ball??