% Serhat Selcuk Bucak, bucakser@msu.edu

function [hata] = frame_hata(V,T)
% calculates the column-wise Euclidean distance between V and T

frame_number=size(V,2);
sizes=size(V,1);
% for i=1:frame_number
%     hata(i)=(sum((V(:,i)-T(:,i)).^2))/(sizes);
% end

hata = sum((V-T).^2,1)/sizes;
