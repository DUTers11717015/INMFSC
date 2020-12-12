function result = knn(trainx,trainclass,testz,K,type)
%k近邻算法
%trainx表示输入的样本，n个样本向量，每个向量d维度
%trainclass表示输入每个样本所属类别，它为n维列向量
%testz表示测试样本，包含N个样本，每个样本向量d维度
%K表示最近邻的个数
%type表示实际特定的测量距离方式：2维范数表示的是欧氏距离
%1维表示的是绝对距离，就是求绝对值之和

if size(trainx,2) ~= size(testz,2)
    error('训练样本和测试样本的特征维数不一致');
end

%判断K近邻里的K是否可取，通常应该小于测试样本个数的二次根号值
num = length(trainclass);

if(num<K)
    error('k的值太大，超出测试样本的总个数');
end

class = unique(trainclass);
%unique 表示列出数组trainclass不重复的元素，按升序排列，也就是统计训练
%样本里的总的类别种类
N= size(testz,1); % 统计测试样本的个数
result = zeros(N,1); %列出每个测试样本所属类别

if nargin < 5
    type = '2norm';
end
switch   type
    case '2norm'
        for i=1:N  %对每个测试样本进行类别的判定
            dist= sum((trainx-ones(n,1)*testz(i,:)).^2,2);
            [m,index]= sort(dist);
            %m表示测试样本与每个训练样本的欧式距离的升序排列
            %index表示的是 排列之后的序列中每个值 在之前向量中的 索引，也就是位置
            % 根据k近邻，只取 前面 K个 
            histclass= hist(trainclass(index(1:K)),class);
            %把k近邻里的每个训练样本所属类别按，实际总的样本类别种类进行统计，实际统
            %记值表示在每个类别里面含有几个训练样本
            % histclass表示的是  统计值个数
            [c,best] = max(histclass);
            %c表示的是最大值，best表示的是  最大值的位置
            result(i)= class(best);       
            
        end
    case '1norm'
        for i=1:N
            dist= sum(abs((trainx-ones(n,1)*testz(i,:))),2);
            [m,index]= sort(dist);
            histclass= hist(trainclass(index(1:K),class));
            [c,best]=max(histclass);
            result(i)=class(best);
        end
        
    otherwise
        error('Unknown measure function');
end

