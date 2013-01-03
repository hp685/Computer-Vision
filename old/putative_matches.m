
function RES = putative_matches(descriptor1,descriptor2)
for i = 1:size(descriptor1,1)
    for j = 1:size(descriptor2,1);
       RES(i,j) = sqrt(sum((descriptor1(i,:)-descriptor2(j,:)).^2));
    end
end
%RES_N=sort(RES,2,'descend'); %Sorts each row in descending order. 

