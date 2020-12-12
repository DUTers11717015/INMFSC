

%COIL_l2inmf=[71.80 79.58 82.63 84.33 85.41 82.13 85.83 84.88 87.16];
%COIL_inmf=[67.30 79.02 80.58 83.19 84.69 80.69 84.02 84.72 87.63];
%COIL_nmf=[66.25 79.00 79.85 80.25 84.75 80.50 83.01 83.63 85.00];





%
% INMFSC算法
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
ORL_inmfsc=[73.88 78.98 81.21 81.85 82.17 85.35 87.36 85.66 83.50];
ORL_l2inmf=[73.24 79.30 80.89 81.80 82.45 83.75 87.36 85.66 83.81];
ORL_inmf=[74.00 76.50 78.01 79.10 79.50 80.02 82.51 83.50 81.00];
ORL_nmf=[73.25 75.00 76.25 77.25 78.63 79.50 81.01 82.03 79.35];
  
figure(1) 

plot(k,ORL_inmfsc,'--*g',k,ORL_l2inmf,'-.o r',k,ORL_inmf,'- pentagram k',k,ORL_nmf,'- diamond b');
xlabel('r');
ylabel('AC (\%)')
legend('INMFSC','L2-INMF','INMF','NMF');
title('ORL-32');
  
% COIL数据集上的准确率
k=[20:10:100];
COIL_INMFSC=[72.78 79.67 82.77 84.30 85.42 82.14 85.83 84.80 87.17];
COIL_l2INMF=[71.80 79.58 82.63 84.33 85.41 82.13 85.83 84.88 87.16];
COIL_INMF=[67.30 79.02 80.58 83.19 84.69 80.69 84.02 84.72 87.63];
COIL_NMF=[66.25 79.00 79.85 80.25 84.75 80.50 83.01 83.63 85.00];

figure(2)
plot(k,COIL_INMFSC,'--*g',k,COIL_l2INMF,'-.o r',k,COIL_INMF,'- pentagram k',k,COIL_NMF,'- diamond b');
xlabel('r');
ylabel('AC (\%)')
legend('INMFSC','L2-INMF','INMF','NMF');
title('COIL20');



