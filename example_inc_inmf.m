% Create sample data with 3 clusters
V=[[1; 1; 3]*ones(1,50) [1; 3; 1]*ones(1,50) [3; 1; 1]*ones(1,50)];
V = V + rand(size(V));
plot3(V(1,:),V(2,:),V(3,:),'b+')
grid on

% Execute the incremental algorithm (inc-INMF)
[hata, H, label, min_max, centr] = inc_inmf(V(:,1:150), V(:,1:10),1, 1, 2.5, 0.5);
