data = [20.457, 45.578; 12.016, 22.422];
b = bar(data);
ch = get(b,'children');
set(gca,'XTickLabel',{'ѵ������','���Թ���'})
legend('�������ĵ������ķ����㷨','���bigram�����ĵ����������㷨');
ylabel('����ʱ��(��λ:��)');
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
