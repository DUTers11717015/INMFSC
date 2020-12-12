data = [20.457, 45.578; 12.016, 22.422];
b = bar(data);
ch = get(b,'children');
set(gca,'XTickLabel',{'训练过程','测试过程'})
legend('基于类文档排名的分类算法','结合bigram的类文档排名分类算法');
ylabel('所用时间(单位:秒)');
30.39;15.50;14.58;14.42;14.50

data=[30.39;15.50;14.58;14.42;14.50];
b = bar(data);
ch = get(b,'children');
set(gca,'XTickLabel',{'nmf','gnmf','inmf','inmfsc','ginmfsc'})


xlabel('对比算法');
ylabel('平均运行时间(单位:秒)');
title('ORL');

305.63;154.30;152.84;150.48;151.60
data=[305.63;154.30;152.84;150.48;151.60];
b = bar(data);
ch = get(b,'children');
set(gca,'XTickLabel',{'nmf','gnmf','inmf','inmfsc','ginmfsc'})


xlabel('对比算法');
ylabel('平均运行时间(单位:秒)');
title('COIL20');

12.87;7.68;7.24;6.86;7.04 
data=[12.87;7.68;7.24;6.86;7.04];
b = bar(data);
ch = get(b,'children');
set(gca,'XTickLabel',{'nmf','gnmf','inmf','inmfsc','ginmfsc'})


xlabel('对比算法');
ylabel('平均运行时间(单位:秒)');
title('Yale');
