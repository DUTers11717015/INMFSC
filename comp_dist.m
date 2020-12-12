function [min_max_dist, s] = comp_dist(centr, h)
 % Finds the closest cluster center for instance h

% for j=1:size(centr,2)
%     for i=1:size(centr,1)
%         cdist(i,j)=abs(centr(i,j)-h(i)); % Her clusterin tum bilesenlerine teker teker bak
%     end
% end

hh= h*ones(1,size(centr,2));
cdist = abs(centr-hh);

max_dist=max(cdist);  % Take the max for each cluster
min_max_dist=min(max_dist);  % Take the min of the maxs
s=find(max_dist==min_max_dist); % Take the corresponding cluster index