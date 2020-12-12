function [A] = dim_inc(B);
% Adds a new column and row (both are all zeros vectors) to matrix B

size1=size(B,1);
size2=size(B,2);

A=zeros(size1+1,size2+1);

for i=1:size1
    for j=1:size2
        A(i,j)=B(i,j);
    end
end