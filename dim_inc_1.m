function [A] = dim_inc_1(B);
% adds a new row (all zeros) to matrix B


size1=size(B,1);
size2=size(B,2);

A=zeros(size1+1,size2);

for i=1:size1
    for j=1:size2
        A(i,j)=B(i,j);
    end
end