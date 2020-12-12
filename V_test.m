function [V_TE, V_nIter] = V_test(X, U, fname_TV)

%
% ��������������Լ���ϵ������
% ������NMF���������е����ķ�����Ψһ��ͬ�ĵط��Ǳ����������л����� U ʼ���ǲ���ġ�
%

Norm = 2;
NormV = 1;

if min(min(X)) < 0
    error('Input should be nonnegative!');
end


 [Um,Un]=size(U);       % ȡ U ��Un
 [Xm,Xn]=size(X);       % ȡ X ��Xn
 Vm=Xn;
 Vn=Un;
 V=abs(rand(Vm,Vn));    % ������ɳ�ʼ�� V  
 TestOBJ=norm(X-U*V',2);
 iter=0;
 tmp_T = cputime;
 
 for iter=1:300
     V=V.*((X'*U)./(V*U'*U));
     iter=iter+1;
     OBJ=norm(X-U*V',2);
     TestOBJ = [TestOBJ OBJ];
%=======================================================
        fprintf('Saving...\n');
        save(fname_TV,'TestOBJ');
        fprintf('Done!\n');
%=======================================================
 end
 
 elapse = cputime - tmp_T;
 V_nIter=iter;
[U_Nor V_TE] = NormalizeUV(U, V, NormV, Norm);



function [U, V] = NormalizeUV(U, V, NormV, Norm)
    nSmp = size(V,1);
    mFea = size(U,1);
    if Norm == 2
        if NormV
            norms = sqrt(sum(V.^2,1));
            norms = max(norms,1e-10);
            V = V./repmat(norms,nSmp,1);
            U = U.*repmat(norms,mFea,1);
        else
            norms = sqrt(sum(U.^2,1));
            norms = max(norms,1e-10);
            U = U./repmat(norms,mFea,1);
            V = V.*repmat(norms,nSmp,1);
        end
    else
        if NormV
            norms = sum(abs(V),1);
            norms = max(norms,1e-10);
            V = V./repmat(norms,nSmp,1);
            U = U.*repmat(norms,mFea,1);
        else
            norms = sum(abs(U),1);
            norms = max(norms,1e-10);
            U = U./repmat(norms,mFea,1);
            V = V.*repmat(norms,nSmp,1);
        end
    end
