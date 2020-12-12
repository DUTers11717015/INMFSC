% inc_comp'den farkli olarak burda h'ler arasindaki oklit uzakligina degil, h bilesenlerinin ayri ayri uzakliklarina bakilir.

%Serhat Selcuk Bucak, bucakser@msu.edu
function [hata, H, label, min_max, centr] = inc_inmf(V, Vinit, beta, alpha, thr_rec, thr_h)
%INPUT
% thr_h: threshold for making a decision (for starting a new cluster) w.r.t. h
% thr_rec: threshold for making a decision (for starting a new cluster) w.r.t. reconstruction error of the recent instance
% beta, alpha: weighting coefficients
% V : Data matrix, each column is a data instance
% Vinit: the first part of data that needs to be processed before
% incremental algorithm

% OUTPUT
% hata: reconstruction errors
% H : Matrix that store vectors h that correspond to each data instance
% label : cluster assingments
% min_max : for each instance, the distance to the closest cluster center
% centr: matrix that stores cluster centers


fprintf('....Training Phase.....\n');

rdim=1;
[W, H] = nmf(Vinit,rdim, 0, 100); % start with 1 cluster (this assumption can be changed according to data, i.e. start with 3 clusters, but this also requires changing the lines 23-40)
vdim=size(W,1);
samples=size(Vinit,2);
A=Vinit*H';
B=H*H';
recons=W*H;
rank=size(H,1);
rec_err = frame_hata(Vinit,recons);
ind=[];
ind2=[];
label=[];
hata=[];
centr(:,1)=mean(H,2);
centr(:,1)=centr(:,1)/sum(centr(:,1));

sample_num(1)=size(Vinit,2);  % Number of instances in each cluster

minss=0;

for i=1:size(V,2)
    
%     fopen('all'); % List all open files
%     fclose('all'); % Close all open files  
    
    fprintf('Processing frame no [%d]\n', i);
    v=V(:,i);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [h] = nmf_h(v, W, rdim, 0, 40);
    h2=h;
    proj_err = frame_hata(v,W*h);
    [min_max_dist, s] = comp_dist(centr, h/sum(h));
    s=s(end);
    min_max(i)=min_max_dist;

    if(min_max_dist>thr_h | proj_err>thr_rec)   % add a new cluster
        rdim=rdim+1;
        h=[h2;1];
        [H] = dim_inc_1(H);
        A=dim_inc_2(A);
        W=[W v];
        B=dim_inc(B);
        centr=dim_inc_1(centr);
        maxiter = 50; % 50 should be sufficient, but can be changed
        [W, h, A, B] = inmf(v, W, h, A, B, rdim, beta, alpha, maxiter);
        proj_err = frame_hata(v,W*h);
        H = [H h];
        centr=[centr h/sum(h)];
        sample_num=[sample_num 1]; % the new cluster ha sone instance to start with
        label=[label rdim];
    else % no need to add a new cluster
        maxiter = 50; % 50 should be sufficient, but can be changed
        [W, h, A, B] = inmf(v, W, h, A, B, rdim, beta, alpha, maxiter);
        recons=W*h;
        H = [H h];
        centr(:,s)=((centr(:,s)*sample_num(s))+h/sum(h))/(sample_num(s)+1);          % cluster center is updated
        label=[label s]; 
    end
    hata=[hata proj_err];
end