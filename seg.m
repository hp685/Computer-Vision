

% Please Note: The W section is commented out as it takes long to run.  

 im = imread('baseball.jpg');
%im = imread('tiger.jpg');
baseball = double(im);
%Scaling 
baseball = baseball/255;


count = 1;
for i = 1:size(baseball,1)
    for j = 1:size(baseball,2)
        pixel(count) = baseball(i,j);
        count = count + 1;
    end
end
pixel = pixel';

% Variable declarations

r = 5;
sigma_I =  0.05;
sigma_L = 4;
% for i = 1:20
%     for j = 1:20
%         if(sqrt((i-j)^2) < r)
%             W(i,j) = exp(-1 * (sqrt((pixel(i,1) - pixel(j,1))^2))/(sigma_I^2)) * exp(-1 * (sqrt((i-j)^2))/(sigma_L^2));
%         else
%             W(i,j) = 0;
%         end
%     end
% end

% Pad the matrix before im2col
 base_pad = padarray(baseball,5);
 base_pad = padarray(base_pad',5);
 base_pad = base_pad'; % 198 X 260

BLOCK = 2*r + 1; 
 
%im2col -- uses default 'sliding'
base_col = im2col(base_pad,[BLOCK BLOCK]);

% Small testcase for checking the formula
% clear C
% C=[0 0];
% for ii =1:size(B,1);
% for jj = 1:size(B,2)
% j = 1 + mod((jj-1) , BLOCK) + mod(ii-1,size(A,1)-BLOCK+1);
% i = 1 + floor((jj-1)/BLOCK) + floor((ii-1)/ (size(A,2)-BLOCK+1)); 
% C= [C;i j];
% end
% end


count = 0;
C = [0 0 double(0)];
%memo = zeros(size(base_pad,1)*size(base_pad,2) + 10,size(base_pad,2)*size(base_pad,1)+10);
memo = zeros()
memojj = zeros(121,121);

% Naive Looping -- Shouldve used memoization
%

I_INDEX=0;
J_INDEX=0;

 for ii = 1:size(base_col,2)
     for jj = 1:size(base_col,1)
         for kk = jj + 1:size(base_col,1)
             % Determine the original coordinates from the indices.     
         
             j = 1 + mod((jj-1),BLOCK) + mod(ii-1,(size(base_pad,2)-BLOCK+1));
            i = 1 + floor((jj-1)/BLOCK) + floor((ii-1)/(size(base_pad,2)-BLOCK+1));
             % For kk
              col = 1 + mod((kk-1),BLOCK) + mod(ii-1,(size(base_pad,2)-BLOCK+1));
              row = 1 + floor((kk-1)/BLOCK) + floor((ii-1)/(size(base_pad,2)-BLOCK+1));
                  I_INDEX = (i-1)*size(base_pad,2)+ j   ;     
                     J_INDEX = (row-1)*size(base_pad,2) + col;
                   if(memo(row,col) == 0)  
                     if(sqrt((col-j)^2 + (row - i)^2) < r)
                    % [i j row col]
             
                     aff = double(exp(( -1 * (sqrt((base_pad(i,j) - base_pad(row,col))^2 )) / sigma_I^2 ) + (-1 * (sqrt((col-j)^2 + (row-i)^2)) / sigma_L^2 )));
                     %aff
                     memo(row,col) = 1;
                     %memo(I_INDEX,J_INDEX)=1;
                 
                     C = [C; I_INDEX J_INDEX aff];
                 % end
                  else
                     aff = 0.0;
                     
                     
                   %memo(I_INDEX,J_INDEX) = 1;
                 end
                
            
           
 %         C = [C;i j row col];
         end
     end
 end

save('baseball');
% Make sure the affinities are zero in the padded region. 
for i = 1:size(C,1)
if(C(i,1) >5 && C(i,1)<=193 && C(i,2) >5 &&C(i,2) <=255 ) CC(count,1)=C(i,1); CC(count,2)=C(i,2); CC(count,3)=C(i,3);
count =count + 1;
end
end

%

D = spdiags(W);

A = D^(-1/2)*(D-W)*D^(-1/2);



%W=sparse(ii,jj,hh,MN,MN);
W = sparse(CC(:,1),CC(:,2),CC(:,3));
K=12;

D=spdiags(sum(W,2),[0],size(W,1),size(W,2));
D_1=spdiags(sum(W,2).^(-0.5),[0],size(W,1),size(W,2)); 

A=D_1*(D-W)*D_1;

[VV DD]=eigs(A,K,'SM');
figure(1);colormap(gray);
for i=1:12
subplot(3,4,i), imagesc(reshape(VV(:,i),MN/Imsize,Imsize)), title(['eigs',num2str(i)]);
end


