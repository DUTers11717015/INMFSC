  load('ORL_32.mat');	
        nClass = length(unique(gnd));
        fname='INMFSC-ORL';
         fname_TV='V-NMF-ORL';
         
         fea = NormalizeFea(fea);
         
          [m,n]=size(fea);        % fea ��ά�ȴ�С,���У�m�������ĸ�����n�����ά��
    samNum=m/nClass;           % ÿ�����е�������
   % train_samNum=ceil(samNum*p); % ѵ������ÿ��������Ҫȡ����������������С������ȡ��
    KClass=50;
    train_samNum=3;
    train_fea=[fea(1: train_samNum,:)];  % ��������
    train_gnd=[gnd(1: train_samNum,:)];  % ��Ӧ�ı�ǩ����
    for i=2:nClass
        % ѡȡ��������
        train_fea=[train_fea;fea(samNum*i-(samNum-1):(samNum*i-(samNum-1)+train_samNum-1),:)];
        % ѡȡ��Ӧ�ı�ǩ����
        train_gnd=[train_gnd;gnd(samNum*i-(samNum-1):(samNum*i-(samNum-1)+train_samNum-1),:)];
    end    
    
    test_fea=[fea(train_samNum+2:samNum,:)];  % ��������
    test_gnd=[gnd(train_samNum+2:samNum,:)];  % ��Ӧ�ı�ǩ����
    for i=2:nClass
        % ѡȡ��������
        test_fea=[test_fea;fea(samNum*i-train_samNum-2:samNum*i,:)];
        % ѡȡ��Ӧ�ı�ǩ����
        test_gnd=[test_gnd;gnd(samNum*i-train_samNum-2:samNum*i,:)];
    end    
    

X=train_fea';
[m,n]=size(X);  


%%%%%%%%%%  ��ʼ��  %%%%%%%%%%%%
  U = abs(rand(m,KClass));
 V = abs(rand(KClass,n));

maxiter=200;
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


A=X(:,1:n)*V';
B=V*V';
v=V(:,end); % Warm start for h
U_new = U;  
iter = 0;
maxiter=200;
% =============================   ϡ��Լ��   ============================ %
sU=0.3; % ����ϡ��ϵ��
sV=[];  % ����ϡ��ϵ��
% =============================   ϡ��Լ�����   =======================  %
V_new=[];
% tmp_T = cputime;
t=2;
   new_fea=[fea(train_samNum+1:train_samNum+1+t,:)];  % ��������
   new_gnd=[gnd(train_samNum+1:train_samNum+1+t,:)];  % ��Ӧ�ı�ǩ����
 for i=1:nClass-1
        % ѡȡ��������
        new_fea=[new_fea;fea(samNum*i+train_samNum+1:samNum*i+train_samNum+1+t,:)];
        % ѡȡ��Ӧ�ı�ǩ����
        new_gnd=[new_gnd;gnd(samNum*i+train_samNum+1:samNum*i+train_samNum+1+t,:)];
 end    
 X1=new_fea';
 train_gnd=[train_gnd' new_gnd']';
for i=1:size(X1,2)
    X_new=X1(:,i);
     while(iter<maxiter)
  
    if (iter==maxiter)
        break
    end
    
    iter = iter+1;    
    % Save old values
    %Wold = W_new;
    %Hold = H;
    
    % Compute new W and H 
    v = v.*((U_new)'*X_new)./((U_new)'*(U_new)*v +(3/2)*sU*v.^(0.5)+1e-9); 
    U_new = U_new.*((A+X_new*(v)')./(U_new*(B+(v)*(v)') + 1e-9)); % Add 1e-9 to avoid 0 in the denom.
   
    
%=======================================================
        fprintf('Saving...\n');
     %   save(fname,'inmfscOBJ');
        fprintf('Done!\n');
%=======================================================
    end
    V_new=[V_new  v];
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