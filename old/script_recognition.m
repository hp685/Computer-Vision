

load('ORL_32x32.mat')
load('train_test_orl.mat')
figure(1);
montage(reshape(fea'/255,[32 32 1 400]));

feat = fea';

K  =20; 

im = fea/255; 



%for K = 1:100

    trainset = im(trainIdx,:);
testset = im(testIdx,:);

% Center the training data. 

for i =1:size(trainIdx,1)
    for j = 1:1024
        trainset(i,j) = trainset(i,j) - mean(trainset(i,:));
        mean_val_train(i,j) = mean(trainset(i,:));  
    end
  
end

% Covariance matrix. 
C = trainset'*trainset;



% Eigen Vectors
[v,d] = eigs(C,K);

figure(2); 
montage(reshape(v,[32 32 1 20])); 

% Project the training points in the PCA space
 train_pro = trainset(1:size(trainIdx,1),:) * v;
 
 % Reproject the points to the image space and add the mean to view the
 % original image.
  train_repro = train_pro * v';
  train_repro = train_repro + mean_val_train;  
 figure(3);
 montage(reshape(trainset' + mean_val_train',[32 32 1 280]));
  figure(4);
 montage(reshape(train_repro' ,[32 32 1 280]));
 
 % Center and project the test data into PCA space:
 
 
 % Center
for i =1:size(testIdx,1)
    for j = 1:1024
        testset(i,j) = testset(i,j) - mean(testset(i,:));
        mean_val_test(i,j) = mean(testset(i,:));  
    end
end
% Project
 test_pro = testset(1:size(testIdx,1),:) * v;
 % NearestNeighbor- [labels] contains the indices of the 
[labels] = knnsearch(train_pro,test_pro,'dist','euclidean');

cnt = 0;

for i = 1:size(testIdx,1) 
 if(gnd(testIdx(i)) == gnd(trainIdx(labels(i))))
        cnt = cnt + 1;
 end
end

Accuracy(K) = (cnt/size(testIdx,1)) * 100
%end
%plot(1:K,Accuracy(K));