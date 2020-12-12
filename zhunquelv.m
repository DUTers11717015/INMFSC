%
% SCNMFS算法
% 准确率AC
%

% 准确率AC
%

clc
clear all
close all
% 预处理
 
% ORL数据集上的AC   
k=[20:10:100];
ORL_ginmfsc=[75.48  78.64 79.30 86.62 85.67 85.08 87.89 89.80 88.85];
ORL_inmfsc=[74.28 75.01 78.98 78.62 84.78 86.32 85.86 88.41 85.50];
ORL_inmf=[70.28 74.27 78.43 78.26 80.43 83.69 85.95 86.59 85.06];
ORL_gnmf=[67.19 73.85 78.57 75.16 80.25 81.85 84.70 85.58 84.03];
ORL_nmf=[65.12 68.48 70.16 73.53 75.21 78.99 79.83 82.35 83.61];
  
figure(1) 

plot(k,ORL_ginmfsc,'--*g',k,ORL_inmfsc,'-+m' ,k,ORL_inmf,'-.o r',k,ORL_gnmf,'- pentagram k',k,ORL_nmf,'- diamond b');

xlabel('降维维度k');
ylabel('准确率AC（%）')
legend('GINMFSC','INMFSC','INMF','GNMF','NMF');
title('ORL');
  



% COIL数据集上的准确率
k=[20:10:100];
COIL_GINMFSC=[79.74 84.25 86.34 87.62 88.31 87.96 87.50 88.89 89.93];
COIL_INMFSC=[78.82 84.26 83.45 85.07 85.42 87.38 86.80 87.62 89.12];
COIL_INMF=[78.12 83.56 80.58 84.72 86.92 85.69 88.54 85.76 88.65];
COIL_GNMF=[75.27 80.02 84.49 83.10 85.06 85.53 86.22 86.80 88.43];
COIL_NMF=[67.08 77.50 81.53 82.22 84.03 83.88 84.58 85.27 84.58];

figure(2)
plot(k,COIL_GINMFSC,'--*g',k,COIL_INMFSC,'-+m' ,k,COIL_INMF,'-.o r',k,COIL_GNMF,'- pentagram k',k,COIL_NMF,'- diamond b');

xlabel('降维维度k');
ylabel('准确率AC（%）')
legend('GINMFSC','INMFSC','INMF','GNMF','NMF');
title('COIL');

k=[20:10:100];
Yale_GINMFSC=[70.31 78.90 80.46 82.81 85.94 90.59 87.56 89.84 87.50];
Yale_INMFSC=[66.95 71.30 76.52 79.13 80.86 82.60 81.74 84.35 83.47];
Yale_INMF=[65.21 68.69 75.65 78.26 79.13 83.47 80.86 84.30 82.60];
Yale_GNMF=[64.84 67.96 71.09 75.01 77.34 82.03 79.68 84.37 81.25];
Yale_NMF=[61.76 65.16 68.54 71.91 73.03 77.53 75.28 78.65 80.89];

figure(2)
plot(k,Yale_GINMFSC,'--*g',k,Yale_INMFSC,'-+m' ,k,Yale_INMF,'-.o r',k,Yale_GNMF,'- pentagram k',k,Yale_NMF,'- diamond b');

xlabel('降维维度k');
ylabel('准确率AC（%）')
legend('GINMFSC','INMFSC','INMF','GNMF','NMF');
title('Yale');

