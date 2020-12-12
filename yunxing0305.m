clc
clear all
close all
% 预处理
 
% ORL数据集上的AC   
k=[20:10:100];
ORL_ginmfsc=[79.74 84.25 86.34 87.62 88.31 87.96 87.50 88.89 89.93];
ORL_inmfsc=[78.82 84.26 83.45 85.07 85.42 87.38 86.80 87.62 89.12];
ORL_inmf=[78.12 83.56 80.58 84.72 86.92 85.69 88.54 85.76 88.65];
ORL_gnmf=[75.27 80.02 84.49 83.10 85.06 85.53 86.22 86.80 88.43];
ORL_nmf=[67.08 77.50 81.53 82.22 84.03 83.88 84.58 85.27 84.58];
  
figure(1) 

plot(k,ORL_ginmfsc,'--*g',k,ORL_inmfsc,'-+m' ,k,ORL_inmf,'-.o r',k,ORL_gnmf,'- pentagram k',k,ORL_nmf,'- diamond b');
 
xlabel('降维维度k');
ylabel('准确率AC（%）')
legend('GINMFSC','INMFSC','INMF','GNMF','NMF');
title('ORL');


clc
clear all
close all
% 预处理
 
% ORL数据集上的AC   
k=[20:10:100];
COIL_inmfsc1=[71.36 78.88 81.80 83.75 85.64 80.80 84.86 84.58 86.67];
COIL_inmfsc2=[71.80 79.58 82.63 84.33 85.41 82.13 85.83 84.88 87.16];
COIL_inmfsc3=[72.78 79.67 82.77 84.30 85.42 82.14 85.83 84.80 87.17];
COIL_inmf=[67.30 79.02 80.58 83.19 84.69 80.69 84.02 84.72 87.63];
COIL_nmf=[66.25 79.00 79.85 80.25 84.75 80.50 83.01 83.63 85.00];
  
figure(1) 

plot(k,COIL_inmfsc3,'--*m',k,COIL_inmfsc2,'-+g' ,k,COIL_inmfsc1,'-.o r',k,COIL_inmf,'- pentagram k',k,COIL_nmf,'- diamond b');
 
xlabel('降维维度k');
ylabel('准确率AC（%）')
legend('L3/2-INMFSC','L2-INMFSC','L1-INMFSC','INMF','NMF');
title('COIL20');

