data = [20.457, 45.578; 12.016, 22.422];
b = bar(data);
ch = get(b,'children');
set(gca,'XTickLabel',{'训练过程','测试过程'})
legend('基于类文档排名的分类算法','结合bigram的类文档排名分类算法');
ylabel('所用时间(单位:秒)');

30.39;15.50;14.58;14.50
figure(1)
data=[30.39;15.50;14.58;14.50];
b = bar(data);
ch = get(b,'children');

set(gca,'XTickLabel',{'nmf','inmf','L2-inmf','inmfsc'})

xlabel('algorithms');
ylabel('The mean running time (/s)');
title('ORL-32');
figure(2)

305.63;154.30;152.84;151.60

data=[305.63;154.30;152.84;151.60];
b = bar(data);
ch = get(b,'children');
set(gca,'XTickLabel',{'nmf','inmf','L2-inmf','inmfsc'})

xlabel('algorithms');
ylabel('The mean running time (/s)');
title('COIL20');

