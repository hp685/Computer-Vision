clear;
%Load data 
image_points=importdata('sfm_points.mat');
figure(1);
for i= 1:10
subplot(2,5,i), plot(image_points(1,:,i),image_points(2,:,i),'b *'), title(['Frame: ',num2str(i),])  
end

%Compute the translations 
for i= 1:10
%Find the centroids of the frames--cf
cf(1,i)=mean(image_points(1,:,i));
cf(2,i)=mean(image_points(2,:,i));
%Subtract the centered points-- cp from the centroids
cp(1,:,i)=image_points(1,:,i)-cf(1,i);
cp(2,:,i)=image_points(2,:,i)-cf(2,i);
end
for i= 1:10
W(2*i-1:2*i,1:600)=[cp(1,:,i);cp(2,:,i)];
end
%Singular value decomposition for W
[U,S,V]=svd(W);
% find the camera locations
M=U(:,1:3)*S(1:3,1:3);
world_points=V(:,1:3)
figure(2);
plot3(world_points(:,1),world_points(:,2),world_points(:,3), 'r *');
t=cf;
t(:,1)
M(1:2,:)
world_points(1:10,:)
