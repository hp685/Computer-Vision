
function [current_max, updated_inliers, q_new,INDICES] = RANSAC(descriptor1,descriptor2,location1,location2,image1,image2)
% RES is a matrix of closest neighbors 
%BEGIN RANSAC
r = 10; % Threshold radius
current_max =0;

[RES,IND] = pdist2(descriptor2,descriptor1,'euclidean','Smallest',2); % Euclidean distance measure
RES=RES';
IND= IND';

select = zeros(size(RES,1),1);
count =0;

for i = 1:size(RES,1)
RATIOS(i,1) = RES(i,1)/RES(i,2);
    if(RATIOS(i,1) < 0.9)
         select(i,1) = 1;
         count = count+1; 
    end
end


INDICES=zeros(count,1);
count = 0;
for i = 1:size(RES,1)
    if(select(i) == 1)
        count = count+1;
        INDICES(count,1)=IND(i,1);
        INDICES(count,2)=i;
    end
end
INDICES;

 inliers=zeros(1300,5);

for N = 1:200 %1:size(descriptor1,1) %N - The number of fitting-iterations
% Compute the indices for each point in image 1 that should map to image 2 
%BEGIN FITTING

P1 = randi(size(INDICES,1),1);
P2 = randi(size(INDICES,1),1);
P3 = randi(size(INDICES,1),1);
% Solve the equations for the tranformation parameters q
A = [location1(INDICES(P1,2),1),location1(INDICES(P1,2),2),0,0,1,0;0,0,location1(INDICES(P1,2),1),location1(INDICES(P1,2),2),0,1; location1(INDICES(P2,2),1),location1(INDICES(P2,2),2),0,0,1,0; 0,0,location1(INDICES(P2,2),1),location1(INDICES(P2,2),2),0,1; location1(INDICES(P3,2),1),location1(INDICES(P3,2),2),0,0,1,0; 0,0,location1(INDICES(P3,2),1),location1(INDICES(P3,2),2),0,1];
b = [location2(INDICES(P1,1),1),location2(INDICES(P1,1),2),location2(INDICES(P2,1),1),location2(INDICES(P2,1),2),location2(INDICES(P3,1),1),location2(INDICES(P3,1),2)]';
q = A\b;

num_inliers = 1;

% Compute the inliers with the new transformation parameters
    for i = 1:size(INDICES,1)
        B = [location1(INDICES(i,2),1),location1(INDICES(i,2),2),0,0,1,0; 0 0 location1(INDICES(i,2),1),location1(INDICES(i,2),2),0,1];
        [points_n] = (B*q)'; %Compute the coordinates of where the point from image1 maps to image2
        d_x = location2(INDICES(i,1),1) - points_n(1,1);
        d_y = location2(INDICES(i,1),2) - points_n(1,2);
        if( d_x^2 + d_y^2 < r^2) % Distance function as described in the question 
            %Add the point to the set of inliers
              inliers(num_inliers,:) = [location1(INDICES(i,2),1),location1(INDICES(i,2),2),location2(INDICES(i,1),1),location2(INDICES(i,1),2),i];
              num_inliers=num_inliers + 1;
        end
    end
    
    if(num_inliers > current_max)
           current_max = num_inliers;
           updated_inliers = inliers(1:current_max,:);
            q_new = q;    
           
    end
 updated_inliers

end % END RANSAC-FITTING
 
 
q = q_new;
H = [q(1,1),q(2,1),q(5,1); q(3,1),q(4,1),q(6,1); 0,0,1];
transformed_image = imtransform(image1,maketform('affine',H'));
imshow(transformed_image);

