world = load('world.txt');
image = load('image.txt');
% Convert to Homogeneous form 
world_H = [world;1,1,1,1,1,1,1,1,1,1];
image_H = [image;1,1,1,1,1,1,1,1,1,1];


A = [0,0,0,0, -1*world_H(:,1)', image_H(2,1)*world_H(:,1)'; 1*(world_H(:,1)'),0,0,0,0,-image_H(1,1)*world_H(:,1)']; 

% Form matric C from Cp = 0
for i = 2:10
C = [0,0,0,0, -1*world_H(:,i)', image_H(2,i)*world_H(:,i)'; 1*(world_H(:,i)'),0,0,0,0,-image_H(1,i)*world_H(:,i)'];
A = [A;C];
end

%Perform SVD
[U,S,V] = svd(A);

P = V(1:12,12);
P = reshape(P,4,3);
P = P'

cross_product = cross(image_H,P*world_H)
% Gives all zeros verifying the projection matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Camera Center from method 1--svd
[UP,SP,VP] = svd(P);
Camera_Center1 = VP(1:3,4)./VP(4,4)

% Camera Center from method 2--qr
[q,K]=qr(P(:,1:3)); 
  Rt=inv(K)*P;
  R=-Rt(:,1:3);
  t=Rt(:,4);
  Camera_Center2=inv(R)*t