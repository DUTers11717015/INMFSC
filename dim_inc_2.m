function [A] = dim_inc_2(B);
% adds a new column (all zeros) to matrix B

size1=size(B,1);
size2=size(B,2);

A=zeros(size1,size2+1);

for i=1:size1
    for j=1:size2
        A(i,j)=B(i,j);
    end
end