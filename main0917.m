  load('ORL_32.mat');	
        nClass = length(unique(gnd));
        fname='INMFSC-ORL';
         fname_TV='V-NMF-ORL';
         
         fea = NormalizeFea(fea);
         
          [m,n]=size(fea);        % fea 的维度大小,其中，m是样本的个数，n是类的维数
    samNum=m/nClass;           % 每个类中的样本数
   % train_samNum=ceil(samNum*p); % 训练集中每个类中所要取得样本数，若遇到小数向上取整
    KClass=50;
    train_samNum=3;
    train_fea=[fea(1: train_samNum,:)];  % 特征数据
    train_gnd=[gnd(1: train_samNum,:)];  % 相应的标签数据
    for i=2:nClass
        % 选取特征数据
        train_fea=[train_fea;fea(samNum*i-(samNum-1):(samNum*i-(samNum-1)+train_samNum-1),:)];
        % 选取相应的标签数据
        train_gnd=[train_gnd;gnd(samNum*i-(samNum-1):(samNum*i-(samNum-1)+train_samNum-1),:)];
    end    
    
    test_fea=[fea(train_samNum+2:samNum,:)];  % 特征数据
    test_gnd=[gnd(train_samNum+2:samNum,:)];  % 相应的标签数据
    for i=2:nClass
        % 选取特征数据
        test_fea=[test_fea;fea(samNum*i-train_samNum-2:samNum*i,:)];
        % 选取相应的标签数据
        test_gnd=[test_gnd;gnd(samNum*i-train_samNum-2:samNum*i,:)];
    end    
    

X=train_fea';
[m,n]=size(X);  


%%%%%%%%%%  初始化  %%%%%%%%%%%%
  U = abs(rand(m,KClass));
 V = abs(rand(KClass,n));

maxiter=200;
%%%%%%%%%%  初始化  %%%%%%%%%%%%

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
% =============================   稀疏约束   ============================ %
sU=0.3; % 定义稀疏系数
sV=[];  % 定义稀疏系数
% =============================   稀疏约束完毕   =======================  %
V_new=[];
% tmp_T = cputime;
t=2;
   new_fea=[fea(train_samNum+1:train_samNum+1+t,:)];  % 特征数据
   new_gnd=[gnd(train_samNum+1:train_samNum+1+t,:)];  % 相应的标签数据
 for i=1:nClass-1
        % 选取特征数据
        new_fea=[new_fea;fea(samNum*i+train_samNum+1:samNum*i+train_samNum+1+t,:)];
        % 选取相应的标签数据
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
                
        % =================== 显示测试集中求系数矩阵 V 的收敛性曲线 ========================%
        figure(3)
        load(fname_TV);
        plot(TestOBJ(3:end));
        title(fname_TV);
        xlabel('Iteration');
        ylabel('Objective function');
        
        save('V_TE','V_TE');  % 保存测试集的系数矩阵
        
 % 再次进行数据预处理——数据归一化到【0,1】
 % 进行训练的特征数据：V_tr（  [特征,样本数]） 标签数据：train_gnd（[nClass*train_samNum,1]）
 % 进行预测的特征数据：V_TE（[特征，样本数]）标签数据：test_gnd   取gnd([])全部标签数据
 
% test_gnd=gnd;
 
% maxpminma为matlab自带的映射函数
    % [train_wine,pstrain] =mapminmax(train_wine');
[V_tr,pstrain]=mapminmax(V_tr');
% 将映射函数的范围参数分别置为0和1
pstrain.ymin = 0;
pstrain.ymax = 1;
% 对训练集进行[0,1]归一化
    % [train_wine,pstrain] =mapminmax(train_wine,pstrain);
[V_tr,pstrain] =mapminmax(V_tr,pstrain);

% mapminmax为matlab自带的映射函数
[V_TE,pstest] =mapminmax(V_TE');
% 将映射函数的范围参数分别置为0和1
pstest.ymin = 0;
pstest.ymax = 1;
% 对测试集进行[0,1]归一化
[V_TE,pstest] =mapminmax(V_TE,pstest);

% 对训练集和测试集进行转置,以符合libsvm工具箱的数据格式要求
%V_tr = V_tr';
V_TE = V_TE';

% 利用SVM对分解后的系数矩阵进行训练和预测
model=svmtrain(train_gnd,V_tr,'-c 2 -g 0.02');
[predict_label, accuracy] = svmpredict(test_gnd, V_TE, model);