function  [ accu ] = MinNearClasser ( TrainSamples , TestSamples , ClassNum )
%Function      ---ʵ������ڷ��࣬���ʶ����
%TrainSamples  ---ѵ������������������ÿ�����������������ͬ
%TestSamples   ---������������������,ÿ�����������������ͬ
%ClassNum      ---�����
%Author        ---��ǿ �Ͼ�����ѧ603-2������ moxibingdao@qq.com
accu = 0;
TrainNum = uint16( size ( TrainSamples , 2 ) / ClassNum );%ÿ��ѵ����������
TestNum = uint16( size ( TestSamples , 2 ) / ClassNum );%ÿ�������������
right=zeros(1,size(TestSamples,2));
for i=1:ClassNum
    for j=1:TestNum
        Loc = FindMinLoc( TrainSamples , TestSamples(:,(i-1)*TestNum+j) );
        if ( ( Loc >= ( i - 1 ) * TrainNum + 1 ) & ( Loc <= i * TrainNum ) )
            accu = accu + 1;
            right(1,(i-1)*TestNum+j)=1;
        end;
    end;
end;
right;
accu = accu/size ( TestSamples , 2 );