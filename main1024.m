function main2(dataset,KClass,algo)

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
p=0.6;
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
 
 %-------------------------------------------------------------------------
%                            algo ���� Binary��HeatKernel and Cosine
%-------------------------------------------------------------------------
options = [];

switch algo,
    case 'Binary',
        options.WeightMode = 'Binary';
        
        switch dataset,
            case 'COIL20',
                rand('twister',5489);
                fname='GCNMFS-coil';
            case 'PIE_pose27',
                rand('twister',5489);
                fname='GCNMFS-pie';
            case 'Yale_32',
                % rng('default');
                fname='GCNMFS-yale';
            case 'ORL_32',
                rng('default');
                fname='GCNMFS-orl';
        end
        
    case 'HeatKernel',
        options.WeightMode = 'HeatKernel';
        
        switch dataset,
            case 'COIL20',
                rand('twister',5489);
                fname='GCNMFS-coil';
            case 'PIE_pose27',
                rand('twister',5489);
                fname='GCNMFS-pie';
            case 'Yale_32',
            %    rng('default');
                fname='GCNMFS-yale';
            case 'ORL_32',
                rng('default');
                fname='GCNMFS-orl';
        end

    case 'Cosine',
        options.WeightMode = 'Cosine';
        
        switch dataset,
            case 'COIL20',
                rand('twister',5489);
                fname='GNMF-Cosine-coil';
            case 'PIE_pose27',
                rand('twister',5489);
                fname='GNMF-Cosine-pie';
            case 'Yale_32',
                rng('default');
                fname='GNMF-Cosine-yale';
            case 'ORL_32',
                rng('default');
                fname='GNMF-Cosine-orl';
        end
end
 W = constructW(train_fea,options);    % �ṹ�� 
options.maxIter = 200;          % ����������
options.alpha = 0;            % Ĭ��ֵ100����Ϊ��10����1000�仯������
% options.alpha=2;

maxiter=200;
%%%%%%%%%%  ��ʼ��  %%%%%%%%%%%%
Norm = 2;
NormV = 1;
%W = alpha*W;
DCol = full(sum(W,2));
D = spdiags(DCol,0,speye(size(W,1)));
L = D - W;

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


A=X(:,1:n)*V';
B=V*V';
v=V(:,end); % Warm start for h
U_new = U;  
iter = 0;
maxiter=200;
% =============================   ϡ��Լ��   ============================ %
sU=0.60; % ����ϡ��ϵ��
sV=[];  % ����ϡ��ϵ��
% =============================   ϡ��Լ�����   =======================  %
 V_new=[];
% tmp_T = cputime;


for i=n+1:size(X,2)
    X_new=X(:,i);
     while(iter<maxiter)
  
    if (iter==maxiter)
        break
    end
     W_new= constructW(X_new',options);   
    DCol = full(sum(W_new,2));
    D_new = spdiags(DCol,0,speye(size(W_new,1)));
    L_new = D_new - W_new;
    iter = iter+1;     
    % Save old values
    %Wold = W_new;
    %Hold = H;
    
    % Compute new W and H 
%   v = v.*((U_new)'*X_new)./((U_new)'*(U_new)*v+1e-9); 
  v = v.*((U_new)'*X_new+alpha *v*W_new(:,end))./((U_new)'*(U_new)*v+alpha *v*D_new(:,end)+(3/4)*sU*v.^(0.5)+1e-9); 
%  v = v.*((U_new)'*X_new)./((U_new)'*(U_new)*v +sU+1e-9); 
%  v = v.*((U_new)'*X_new)./((U_new)'*(U_new)*v +sU*v+1e-9); 
    U_new = U_new.*((A+X_new*(v)')./(U_new*(B+(v)*(v)') + 1e-9)); % Add 1e-9 to avoid 0 in the denom.
  
  
%=======================================================
        fprintf('Saving...\n');
     %   save(fname,'inmfscOBJ');
        fprintf('Done!\n');
%=======================================================
     end
     V_new=[V_new v]
%[U_new, v, A, B, inmfscOBJ] = inmfsc( X_new, U, v, A, B,  KClass , sU, maxiter);
% V_store(:,i-n)=v; %Just for demonstration
end  
% elapse = cputime - tmp_T;
 %A=A+U_new*v';
 % B=B+v*v';
U_tr=U_new;
V_tr=[V V_new];
save('V_tr','V_tr');
save('U_tr','U_tr');
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
         visual(U_tr,3,5);
          title(fname);
     case 'ORL_32',
         visual(U_tr,3,6);
         % visual(V_tr,3,8);
         %visual(U,3,10);
          title(fname);
 end
%=================== ��ʾ���������� ========================%
%  figure(2)
%  %load(fname);

[sp1F,sp12,sp2F,sp22,sp3F,sp32]=sp1(U_tr);
%[sp1F,sp12,sp2F,sp22,sp3F,sp32]=sp1(V_tr);
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

 

 %  ��������
 
% ������������������������  ����LibSVM���з���  ������������������������������
 
 % ����Ԥ����
        % ���û���������������ݼ���ϵ������
        % ���������󷽳���������ֶ���������������ǲ���NMF����������ʽ���
        % v=v((X'U)./(VU'U));
        % ���У�Xȡȫ�������ݼ�fea��ע����Ҫȡת�ã�
%         test_fea=fea;
%         test_gnd=gnd;
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
