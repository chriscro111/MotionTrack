% load video file and separate into frames
path = 'testMedia/lowres_2balls.mp4';
% path = 'testMedia/lowres_test.mp4';
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
    se = strel('disk',2);   % size needs to proportional to resolutipon
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
    if i > 1
        dist1 = abs(sqrt((avgX^2-centers(i-1,1,1)^2)+(avgY^2-centers(i-1,2,1)^2)));
        dist2 = abs(sqrt((avgX^2-centers(i-1,1,2)^2)+(avgY^2-centers(i-1,2,2)^2)));
        dist3 = abs(sqrt((avgX^2-centers(i-1,1,3)^2)+(avgY^2-centers(i-1,2,3)^2)));
        if dist1 < dist2 && dist1 < dist3
            centers(i,1,1) = avgX;
            centers(i,2,1) = avgY;
        elseif dist2 < dist3 
            centers(i,1,2) = avgX;
            centers(i,2,2) = avgY;
        else
            centers(i,1,3) = avgX;
            centers(i,2,3) = avgY;
        end
    else
       centers(i,1,1) = avgX;
       centers(i,2,1) = avgY; 
    end
   end
   if blob2Count > 0
    avgX = blob2X / blob2Count;
    avgY = blob2Y / blob2Count;
    if i > 1
        dist1 = abs(sqrt((avgX^2-centers(i-1,1,1)^2)+(avgY^2-centers(i-1,2,1)^2)));
        dist2 = abs(sqrt((avgX^2-centers(i-1,1,2)^2)+(avgY^2-centers(i-1,2,2)^2)));
        dist3 = abs(sqrt((avgX^2-centers(i-1,1,3)^2)+(avgY^2-centers(i-1,2,3)^2)));
        if dist1 < dist2 && dist1 < dist3
            centers(i,1,1) = avgX;
            centers(i,2,1) = avgY;
        elseif dist2 < dist3 
            centers(i,1,2) = avgX;
            centers(i,2,2) = avgY;
        else
            centers(i,1,3) = avgX;
            centers(i,2,3) = avgY;
        end
    else
       centers(i,1,2) = avgX;
       centers(i,2,2) = avgY; 
    end
   end
   if blob3Count > 0
    avgX = blob3X / blob3Count;
    avgY = blob3Y / blob3Count;
    if i > 1
        dist1 = abs(sqrt((avgX^2-centers(i-1,1,1)^2)+(avgY^2-centers(i-1,2,1)^2)));
        dist2 = abs(sqrt((avgX^2-centers(i-1,1,2)^2)+(avgY^2-centers(i-1,2,2)^2)));
        dist3 = abs(sqrt((avgX^2-centers(i-1,1,3)^2)+(avgY^2-centers(i-1,2,3)^2)));
        if dist1 < dist2 && dist1 < dist3
            centers(i,1,1) = avgX;
            centers(i,2,1) = avgY;
        elseif dist2 < dist3 
            centers(i,1,2) = avgX;
            centers(i,2,2) = avgY;
        else
            centers(i,1,3) = avgX;
            centers(i,2,3) = avgY;
        end
    else
       centers(i,1,3) = avgX;
       centers(i,2,3) = avgY; 
    end
   end
end

%% display center
for i = 1:25
   subplot(5,5,i);
   imshow(bin(:,:,i));
   hold on;
   plot(round(centers(i,1,1)),round(centers(i,2,1)),'r.','MarkerSize',10);
   plot(round(centers(i,1,2)),round(centers(i,2,2)),'b.','MarkerSize',10);
end
%% some kind of plot/animation showing position over time for each ball??