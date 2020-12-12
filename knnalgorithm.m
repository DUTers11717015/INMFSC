function result = knn(trainx,trainclass,testz,K,type)
%k�����㷨
%trainx��ʾ�����������n������������ÿ������dά��
%trainclass��ʾ����ÿ���������������Ϊnά������
%testz��ʾ��������������N��������ÿ����������dά��
%K��ʾ����ڵĸ���
%type��ʾʵ���ض��Ĳ������뷽ʽ��2ά������ʾ����ŷ�Ͼ���
%1ά��ʾ���Ǿ��Ծ��룬���������ֵ֮��

if size(trainx,2) ~= size(testz,2)
    error('ѵ�������Ͳ�������������ά����һ��');
end

%�ж�K�������K�Ƿ��ȡ��ͨ��Ӧ��С�ڲ������������Ķ��θ���ֵ
num = length(trainclass);

if(num<K)
    error('k��ֵ̫�󣬳��������������ܸ���');
end

class = unique(trainclass);
%unique ��ʾ�г�����trainclass���ظ���Ԫ�أ����������У�Ҳ����ͳ��ѵ��
%��������ܵ��������
N= size(testz,1); % ͳ�Ʋ��������ĸ���
result = zeros(N,1); %�г�ÿ�����������������

if nargin < 5
    type = '2norm';
end
switch   type
    case '2norm'
        for i=1:N  %��ÿ�������������������ж�
            dist= sum((trainx-ones(n,1)*testz(i,:)).^2,2);
            [m,index]= sort(dist);
            %m��ʾ����������ÿ��ѵ��������ŷʽ�������������
            %index��ʾ���� ����֮���������ÿ��ֵ ��֮ǰ�����е� ������Ҳ����λ��
            % ����k���ڣ�ֻȡ ǰ�� K�� 
            histclass= hist(trainclass(index(1:K)),class);
            %��k�������ÿ��ѵ������������𰴣�ʵ���ܵ���������������ͳ�ƣ�ʵ��ͳ
            %��ֵ��ʾ��ÿ��������溬�м���ѵ������
            % histclass��ʾ����  ͳ��ֵ����
            [c,best] = max(histclass);
            %c��ʾ�������ֵ��best��ʾ����  ���ֵ��λ��
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

