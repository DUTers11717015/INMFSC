function main1006(dataset,KClass)
 
%
% main.m 
% GSNMFC
% Graph Sparse Non-negative Matrix Factorization with Hard Constrain for Data Representation(GSNMFC)
% dataset   - 'COIL20'  'PIE_pose27'  'Yale_32' or 'ORL_32'
% rdim = 2 3 4 5 6 7 8 9 10       Ҫ��ԭʼ���ݼ���ѡȡ����������ʵ��

%    
 
tic

% ѭ�� 10 ����ƽ��
HXac=[];    % Ԥ����
HXmi=[];    % Ԥ����

% for h=1:10
for h=1:1
    
%--------------------------------------------------------------------------
%                            Dataset
%--------------------------------------------------------------------------
switch dataset,
  
 case 'CBCL',
     load('CBCL.mat');	
     nClass = length(unique(gnd));
     %fname='GSNMFC-CBCL';
     n=1200;
     
     
% Normalize each data vector to have L2-norm equal to 1  
     fea = NormalizeFea(fea);
 case 'COIL20',
     load('COIL20.mat');	
     nClass = length(unique(gnd));
     fname='INMFSC-COIL';
     n=1000;
     fname_TV='V-NMF-COIL';
     
% Normalize each data vector to have L2-norm equal to 1  
     fea = NormalizeFea(fea);
 
 case 'PIE_pose27',
     load('PIE_pose27.mat');	
     nClass = length(unique(gnd));
     fname='INMFSC-PIE';
     n=2300;
       fname_TV='V-NMF-PIE';
      fea = NormalizeFea(fea);
     
% Normalize each data vector to have L2-norm equal to 1  
   
     
 case 'Yale_32',
     load('Yale_32.mat');	
     nClass = length(unique(gnd));
     fname='INMFSC-Yale';
      fname_TV='V-NMF-Yale';
      fea = NormalizeFea(fea);
% Normalize each data vector to have L2-norm equal to 1 
     fea=NormalizeFea(fea);

 case 'ORL_32',
        load('ORL_32.mat');	
        nClass = length(unique(gnd));
        fname='INMFSC-ORL';
         fname_TV='V-NMF-ORL';
         n=200;
         fea = NormalizeFea(fea);
 
        
% Normalize each data vector to have L2-norm equal to 1 
          
end
p=0.8;
% ����������--- ��ԭ���ݼ���ȡ�� KClass ��Ϊԭʼ�ֽ���� X ---������������ %
  % ѡȡ���ݼ���������Ϊѵ�����ı���Ϊ��p
  [m,n]=size(fea);        % fea ��ά�ȴ�С,���У�m�������ĸ�����n�����ά��
    samNum=m/nClass;           % ÿ�����е�������
    train_samNum=ceil(samNum*p); % ѵ������ÿ��������Ҫȡ����������������С������ȡ��
    
     test_fea=[fea(train_samNum+1:samNum,:)];  % ��������
    test_gnd=[gnd(train_samNum+1:samNum,:)];  % ��Ӧ�ı�ǩ����
    for i=2:nClass
        % ѡȡ��������
        test_fea=[test_fea;fea(samNum*i-train_samNum+1:samNum*i,:)];
        % ѡȡ��Ӧ�ı�ǩ����
        test_gnd=[test_gnd;gnd(samNum*i-train_samNum+1:samNum*i,:)];
    end    
    
    train_fea=[fea(1:train_samNum,:)];  % ��������
    train_gnd=[gnd(1:train_samNum,:)];  % ��Ӧ�ı�ǩ����
    for i=2:nClass
        % ѡȡ��������
        train_fea=[train_fea;fea(samNum*i-(samNum-1):(samNum*i-(samNum-1)+train_samNum-1),:)];
        % ѡȡ��Ӧ�ı�ǩ����
        train_gnd=[train_gnd;gnd(samNum*i-(samNum-1):(samNum*i-(samNum-1)+train_samNum-1),:)];
    end    

X=train_fea';
[m,n]=size(X);  


%%%%%%%%%%  ��ʼ��  %%%%%%%%%%%%
  U = abs(rand(m,KClass));
 V = abs(rand(KClass,n));

maxiter=400;
%%%%%%%%%%  ��ʼ��  %%%%%%%%%%%%

% error=5;
for iter=1:maxiter
    U=U.*((X*V')./(U*V*V'));
    V=V.*((U'*X)./(U'*U*V));
    nmfnew=norm(X-U*V,'fro');
    nmfobj=[];
    nmfobj = [nmfobj nmfnew];
%=======================================================
        fprintf('Saving...\n');
        save(fname,'nmfobj');
        fprintf('Done!\n');
%=======================================================
    
end

U_tr=U;
V_tr=V;


%=================== ��ʾ������ =====================%
figure(1)
 switch dataset
     case 'COIL20',
         visual(U_tr,3,5);
          title(fname);
     case 'PIE_pose27',
      %   visual(U_tr,3,5);
         %visual(U,3,9);
          title(fname);
     case 'Yale_32',
         visual(U_tr,3,4);
          title(fname);
     case 'ORL_32',
        % visual(U_tr,3,6);
         visual(V_tr,3,6);
         %visual(U,3,10);
          title(fname);
 end
%=================== ��ʾ���������� ========================%
%  figure(2)
%  %load(fname);
% 
% 
%  plot(nmfobjhistory(2:150));
%   figure(3)
%   plot(inmfscOBJ(2:end));
% 
%  hold on 
%  figure(4) 
%  title(fname);
%  xlabel('Iteration');
%  ylabel('Objective function value')
%  plot(maxiter,nmfobjhistory(2:end),'k-',maxiter,inmfscOBJ(2:end),'b--');


%  
% figure(4) 
%  plot(x,nmfobjhistory,'k-', x,inmfscOBJ,'b--');
%  title(' Plot of nmfobjhistory  inmfscOBJ and its derivative'); 

%  title(fname);
%  xlabel('Iteration');
%  ylabel('Objective function value')
%  legend('INMFSC')

 
%[sp1F,sp12,sp2F,sp22,sp3F,sp32]=sp1(U)
 %  ��������
 
% ������������������������  ����LibSVM���з���  ������������������������������
 
 % ����Ԥ����
        % ���û���������������ݼ���ϵ������
        % ���������󷽳���������ֶ���������������ǲ���NMF����������ʽ���
        % v=v((X'U)./(VU'U));
        % ���У�Xȡȫ�������ݼ�fea��ע����Ҫȡת�ã�
        test_fea=fea;
         test_gnd=gnd;
        [V_TE, V_nIter] = V_test(test_fea', U_tr, fname_TV);        
                
        % =================== ��ʾ���Լ�����ϵ������ V ������������ ========================%
        figure(3)
        load(fname_TV);
        plot(TestOBJ(3:end));
        title(fname_TV);
        xlabel('Iteration');
        ylabel('Objective function');
        
        save('V_TE','V_TE');  % ������Լ���ϵ������
        
 % �ٴν�������Ԥ���������ݹ�һ������0,1��
 % ����ѵ�����������ݣ�V_tr��  [����,������]�� ��ǩ���ݣ�train_gnd��[nClass*train_samNum,1]��
 % ����Ԥ����������ݣ�V_TE��[������������]����ǩ���ݣ�test_gnd   ȡgnd([])ȫ����ǩ����
 
% test_gnd=gnd;
 
% maxpminmaΪmatlab�Դ���ӳ�亯��
    % [train_wine,pstrain] =mapminmax(train_wine');
[V_tr,pstrain]=mapminmax(V_tr');
% ��ӳ�亯���ķ�Χ�����ֱ���Ϊ0��1
pstrain.ymin = 0;
pstrain.ymax = 1;
% ��ѵ��������[0,1]��һ��
    % [train_wine,pstrain] =mapminmax(train_wine,pstrain);
[V_tr,pstrain] =mapminmax(V_tr,pstrain);

% mapminmaxΪmatlab�Դ���ӳ�亯��
[V_TE,pstest] =mapminmax(V_TE');
% ��ӳ�亯���ķ�Χ�����ֱ���Ϊ0��1
pstest.ymin = 0;
pstest.ymax = 1;
% �Բ��Լ�����[0,1]��һ��
[V_TE,pstest] =mapminmax(V_TE,pstest);

% ��ѵ�����Ͳ��Լ�����ת��,�Է���libsvm����������ݸ�ʽҪ��
%V_tr = V_tr';
V_TE = V_TE';

% ����SVM�Էֽ���ϵ���������ѵ����Ԥ��
model=svmtrain(train_gnd,V_tr,'-c 2 -g 0.02');
[predict_label, accuracy] = svmpredict(test_gnd, V_TE, model);


 end

toc
