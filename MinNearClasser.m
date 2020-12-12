function  [ accu ] = MinNearClasser ( TrainSamples , TestSamples , ClassNum )
%Function      ---实现最近邻分类，输出识别率
%TrainSamples  ---训练样本（列向量），每个类别样本数必须相同
%TestSamples   ---测试样本（列向量）,每个类别样本数必须相同
%ClassNum      ---类别数
%Author        ---周强 南京理工大学603-2教研室 moxibingdao@qq.com
accu = 0;
TrainNum = uint16( size ( TrainSamples , 2 ) / ClassNum );%每类训练样本个数
TestNum = uint16( size ( TestSamples , 2 ) / ClassNum );%每类测试样本个数
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