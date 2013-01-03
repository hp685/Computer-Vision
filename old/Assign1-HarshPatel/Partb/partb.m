im = imread('einstein.jpg');
imshow(im);
imcopy = imresize(im,0.5);
dxx = [1 -2 1];
dyy = dxx';
filter = fspecial('gaussian',19,3);
del_xx = conv2(filter,dxx,'valid');
del_yy = conv2(filter,dyy,'valid');
del_xx = del_xx(1:17,1:17);
del_yy = del_yy(1:17,1:17);
filter_new = del_xx + del_yy;
figure;
mesh(filter_new);


for sigma=3:0.4:15
filter = fspecial('gaussian',6*round(sigma),sigma);
del_xx = conv2(double(filter),double(dxx),'valid');
del_yy = conv2(double(filter),double(dyy),'valid');
sz = min(min(size(del_xx)), min(size(del_yy)));
del_xx = del_xx(1:sz,1:sz);
del_yy = del_yy(1:sz,1:sz);
filter_new = del_xx + del_yy;
I = conv2(double(im),double(filter_new),'same');
I_copy = conv2(double(imcopy),double(filter_new),'same');
out = [I(186,148), sigma*sigma*I(186,148), I_copy(93,74), sigma*sigma*I_copy(93,74),sigma];
save('results_partb.txt','out','-append','-ASCII');
clear del_xx del_yy sz I I_copy
end

set(gcf, 'renderer', 'opengl')
% Plots 
A=load('results_partb.txt');
figure;
plot(A(:,5)/2, A(:,1),'o'), hold on
plot(A(:,5),(A(:,3)),'o');
figure;
plot(A(:,5)/2,A(:,2),'o'), hold on
plot(A(:,5),A(:,4),'o');

[MAX,I] = max(A(:,2));
I
R = A(I,5);
figure, imshow(im);
imellipse(gca,[148 186 R R]);
