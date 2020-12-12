function main2(dataset,KClass,algo)

%
% main.m 
% GSNMFC
% Graph Sparse Non-negative Matrix Factorization with Hard Constrain for Data Representation(GSNMFC)
% dataset   - 'COIL20'  'PIE_pose27'  'Yale_32' or 'ORL_32'
% rdim = 2 3 4 5 6 7 8 9 10       要在原始数据集中选取的类数进行实验

%    
 
tic

% 循环 10 次求平均
HXac=[];    % 预分配
HXmi=[];    % 预分配

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
% 》》》》》--- 从原数据集中取出 KClass 类为原始分解矩阵 X ---《《《《《《 %
  % 选取数据集中数据作为训练集的比例为：p
  [m,n]=size(fea);        % fea 的维度大小,其中，m是样本的个数，n是类的维数
    samNum=m/nClass;           % 每个类中的样本数
    train_samNum=ceil(samNum*p); % 训练集中每个类中所要取得样本数，若遇到小数向上取整
    
     test_fea=[fea(train_samNum+1:samNum,:)];  % 特征数据
    test_gnd=[gnd(train_samNum+1:samNum,:)];  % 相应的标签数据
    for i=2:nClass
        % 选取特征数据
        test_fea=[test_fea;fea(samNum*i-train_samNum+1:samNum*i,:)];
        % 选取相应的标签数据
        test_gnd=[test_gnd;gnd(samNum*i-train_samNum+1:samNum*i,:)];
    end    
    
    train_fea=[fea(1:train_samNum,:)];  % 特征数据
    train_gnd=[gnd(1:train_samNum,:)];  % 相应的标签数据
    for i=2:nClass
        % 选取特征数据
        train_fea=[train_fea;fea(samNum*i-(samNum-1):(samNum*i-(samNum-1)+train_samNum-1),:)];
        % 选取相应的标签数据
        train_gnd=[train_gnd;gnd(samNum*i-(samNum-1):(samNum*i-(samNum-1)+train_samNum-1),:)];
    end    

X=train_fea';
[m,n]=size(X);  


%%%%%%%%%%  初始化  %%%%%%%%%%%%
  U = abs(rand(m,KClass));
 V = abs(rand(KClass,n));
 
 %-------------------------------------------------------------------------
%                            algo —— Binary、HeatKernel and Cosine
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
 W = constructW(train_fea,options);    % 结构体 
options.maxIter = 200;          % 最大迭代次数
options.alpha = 0;            % 默认值100，因为从10——1000变化并不大
% options.alpha=2;

maxiter=200;
%%%%%%%%%%  初始化  %%%%%%%%%%%%
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
% =============================   稀疏约束   ============================ %
sU=0.60; % 定义稀疏系数
sV=[];  % 定义稀疏系数
% =============================   稀疏约束完毕   =======================  %
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
%=================== 显示基矩阵 =====================%
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
%=================== 显示收敛性曲线 ========================%
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

 

 %  聚类性能
 
% 》》》》》》》》》》》》  利用LibSVM进行分类  《《《《《《《《《《《《《《《
 
 % 数据预处理
        % 利用基矩阵求出测试数据集的系数矩阵
        % 由于求解矩阵方程往往会出现多解的情况，所以我们采用NMF基本迭代公式求得
        % v=v((X'U)./(VU'U));
        % 其中，X取全部的数据集fea（注意需要取转置）
%         test_fea=fea;
%         test_gnd=gnd;
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


 end

toc
