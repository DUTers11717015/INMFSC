function [U_final, V_final, nIter] = gsnmfc(X, k, W,options,gndSmpNum, A, sU, sV, fname)

%   *   ===============================================  *  %

maxIter = [];       % ����������
if isfield(options, 'maxIter')
    maxIter = options.maxIter;
end

alpha = 1;

if isfield(options,'alpha')     % ���û��ֵ
    alpha = options.alpha;
end

Norm = 2;
NormV = 1;

if min(min(X)) < 0
    error('Input should be nonnegative!');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[mFea,nSmp]=size(X);

KClass=k;
SmpClass=KClass;        % ����������
NumLab=gndSmpNum;       % ����������

W = alpha*W;
DCol = full(sum(W,2));
D = spdiags(DCol,0,speye(size(W,1)));
L = D - W;

% bSuccess.bSuccess = 1;
% selectInit = 1;

% -------------   ��ʼ��   ----------
    U = abs(rand(mFea,k));
%   V = abs(rand(nSmp,k));
    Z = abs(rand(nSmp+SmpClass-NumLab,k));
    V=A*Z;
% ��һ��
   [U,V] = NormalizeUV(U, V, NormV, Norm);    
% ------------- ��ʼ�����  ---------
    
% ***  ========================================================== ** %
    tmp_T = cputime;
    nIter = 0;
    gsnmfcOBJ=CalculateObj(X, U, V, L, sU);
    
%****************��ʼ����*************************%
    while(nIter<maxIter)
        
  % <<<<<<<<<<<<<<<<<<<   ��ϡ��   >>>>>>>>>>>>>>>>>>>>>>%
  
  % ===================== update U ========================%
        XV=X*V;
        UVV=U*V'*V-sU*U;
        U = U.*(XV./max(UVV,1e-10));
        % U = U.*(XV./UVV);
  %======================== done U =========================%
        
  % ============  ��һ�� U  =============== %
        vec=sum(U);
        [uM,uN]=size(U);
        uU=repmat(vec,uM,1);
        U=U./uU;
        
  % ===================== update Z =======================%
              FZ=A'*X'*U+A'*W*V;
              FM=A'*V*U'*U+A'*D*V;
        
              Z = Z.*(FZ./max(FM,1e-10)); % 3mk
  %======================= Done Z ========================%  
        
        nIter = nIter + 1;
        V=A*Z;
     
        gsnmfcOBJ=CalculateObj(X, U, V, L, sU);
        gsnmfcOBJ = [gsnmfcOBJ gsnmfcOBJ];
        
%=======================================================
        fprintf('Saving...\n');
        save(fname,'gsnmfcOBJ');
        fprintf('Done!\n');
%=======================================================
% [U_final,V_final] = NormalizeUV(U, V, NormV, Norm);
    end     
        
 elapse = cputime - tmp_T;
       
 [U_final,V_final] = NormalizeUV(U, V, NormV, Norm);
%==========================================================================

function obj = CalculateObj(X, U, V, L, sU)
    
    First=X-U*V';
    objF=norm(First,2);
    TuF= trace(V'*L*V);     % ��Ϊǰ���Ѿ���W=alpha*W�ˣ��Ҹ��ݼ������ʣ��˴����ٳ�alpha
    obj=objF+TuF-sU*(norm(U,'fro')^2);
%     Second=V'*L*V;
%     objS=trace(Second);
%     obj=objF+alpha*objS;


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

        