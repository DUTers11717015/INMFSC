function [ loc ] = FindMinLoc ( X , V)
loc=1;
mindis=10000000.0;
for i=1:size(X,2)
    if ( norm(X(:,i)-V) <= mindis )
        loc=i;
        mindis = norm(X(:,i)-V);
    end;
end;