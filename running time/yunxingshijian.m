data = [20.457, 45.578; 12.016, 22.422];
b = bar(data);
ch = get(b,'children');
set(gca,'XTickLabel',{'训练过程','测试过程'})
legend('基于类文档排名的分类算法','结合bigram的类文档排名分类算法');
ylabel('所用时间(单位:秒)');
30.39;14.50;15.00
figure(1)
data=[30.39;14.50;15.00];
b = bar(data);
ch = get(b,'children');
set(gca,'XTickLabel',{'nmf','inmf','inmfsc'})

xlabel('Algorithms');
ylabel('The mean running time (\s) ');
title('ORL-32');


figure(2)
305.63;151.60;154.30
data=[305.63;151.6;154.30];
b = bar(data);
ch = get(b,'children');
set(gca,'XTickLabel',{'nmf','inmf','inmfsc'})

xlabel('Algorithms');
ylabel('The mean running time (\s) ');
title('COIL20');
