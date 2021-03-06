% Comparing the reconstuction error between face and non-face images
% when non-face images are projected into the face space
%
% We consider 300 images from the CIFAR-10 dataset. 

load('data_batch_1.mat');
D = reshape(data,[10000 1024 3]);
Non_Face = rgb2gray(D);
Non_Face = Non_Face(1:300,:);
labels_cifar = labels(1:300,:);
%figure(1);
%montage(reshape(Non_Face',[32 32 1 300]))

load('ORL_32x32.mat');
load('train_test_orl.mat');


feat = fea';

K  =20; 

% Scaling
im = fea/255; 
Non_face = Non_Face/255; 

for K = 1:100

    trainset = im(trainIdx,:);


% Center the training data. 

for i =1:size(trainIdx,1)
    for j = 1:1024
        trainset(i,j) = trainset(i,j) - mean(trainset(i,:));
        mean_val_train(i,j) = mean(trainset(i,:));  
    end
  
end

for i = 1:size(Non_Face,1)
      for j = 1:1024
            NF(i,j) = Non_Face(i,j) - mean(Non_Face(i,:));
            mean_val_NF(i,j) = mean(Non_Face(i,:));
      end
end


% Covariance matrix. 
C = trainset'*trainset;



% Eigen Vectors
[v,d] = eigs(C,K);

% Project the training points in the PCA space
 train_pro = trainset(1:size(trainIdx,1),:) * v;
 NF_pro = double(NF) * v;
 
 % Reproject the points to the image space and add the mean to view the
 % original image.
  train_repro = train_pro * v';
  train_repro = train_repro + mean_val_train;  
  
  NF_repro = NF_pro * v';
  NF_repro = NF_repro + mean_val_NF;
  
  
  % Computing Reconstruction error: 
  RE_Face  = sum(((double(trainset+mean_val_train)) - double(train_repro)).^2,2);
  RE_Non_Face = sum((double(Non_Face) - double(NF_repro)).^2,2);
  
  
  writerObj = VideoWriter('FaceVsNonFaces.avi');
open(writerObj);
  
% Points Plot -- Note that Reconstruction error of non-face images is very
% high and hence we use a sqrt(sqrt()) of the original values in the
% scatter plot. Note also the variance in the non-face images is high
% compared to the face images as one would expect.
hf = figure(2);

scatter(1:size(RE_Non_Face,1),sqrt(sqrt(RE_Non_Face)),3,'r'),hold on
xlabel(int2str(K));
scatter(1:size(RE_Face,1),RE_Face,3,'b');
M(K) = getframe;
writeVideo(writerObj,getframe);
hold off;
refreshdata(hf,'caller');
drawnow

end
Movie(M);