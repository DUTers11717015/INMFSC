data = [20.457, 45.578; 12.016, 22.422];
b = bar(data);
ch = get(b,'children');
set(gca,'XTickLabel',{'ѵ������','���Թ���'})
legend('�������ĵ������ķ����㷨','���bigram�����ĵ����������㷨');
ylabel('����ʱ��(��λ:��)');
30.39;15.50;14.58;14.42;14.50

data=[30.39;15.50;14.58;14.42;14.50];
b = bar(data);
ch = get(b,'children');
set(gca,'XTickLabel',{'nmf','gnmf','inmf','inmfsc','ginmfsc'})


xlabel('�Ա��㷨');
ylabel('ƽ������ʱ��(��λ:��)');
title('ORL');

305.63;154.30;152.84;150.48;151.60
data=[305.63;154.30;152.84;150.48;151.60];
b = bar(data);
ch = get(b,'children');
set(gca,'XTickLabel',{'nmf','gnmf','inmf','inmfsc','ginmfsc'})


xlabel('�Ա��㷨');
ylabel('ƽ������ʱ��(��λ:��)');
title('COIL20');

12.87;7.68;7.24;6.86;7.04 
data=[12.87;7.68;7.24;6.86;7.04];
b = bar(data);
ch = get(b,'children');
set(gca,'XTickLabel',{'nmf','gnmf','inmf','inmfsc','ginmfsc'})


xlabel('�Ա��㷨');
ylabel('ƽ������ʱ��(��λ:��)');
title('Yale');
