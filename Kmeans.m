function Kmeans(dataset)
% 原始数据聚类
switch dataset,
  
 case 'COIL20',
     load('COIL20.mat');	
     nClass = length(unique(gnd));
% Normalize each data vector to have L2-norm equal to 1 
%     fea = NormalizeFea(fea); 
 
 case 'PIE_pose27',
     load('PIE_pose27.mat');	
     nClass = length(unique(gnd));
% Normalize each data vector to have L2-norm equal to 1 
%     fea = NormalizeFea(fea); 
     
 case 'Yale_32',
     load('Yale_32.mat');	
     nClass = length(unique(gnd));
% Normalize each data vector to have L2-norm equal to 1 
%     fea = NormalizeFea(fea); 

 case 'ORL_32',
        load('ORL_32.mat');	
        nClass = length(unique(gnd));
% Normalize each data vector to have L2-norm equal to 1 
%     fea = NormalizeFea(fea); 
end

label=litekmeans(fea,nClass,'Replicates',20);
MIhat=MutualInfo(gnd,label);
disp(['Clustering in the original space. MIhat: ',num2str(MIhat)]);