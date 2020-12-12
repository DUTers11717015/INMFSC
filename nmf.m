function [U_final, V_final] = nmf(X, k, fname)



Norm = 2;
NormV = 1;


if min(min(X)) < 0
    error('Input should be nonnegative!');
end

%——————————————————————————————%
[mFea,nSmp]=size(X);

%================  初始化  =================%
 U = abs(rand(mFea,k));
 % V = abs(rand(nSmp,k));
 V = abs(rand(nSmp,k));

%=============  初始化完成    ================%

%--------------------  归一化  -------------------%
% [U,Z] = NormalizeUV(U, Z, NormV, Norm);

    tmp_T = cputime;
    
    nIter = 0;
    nmfOBJ=CalculateObj(X, U, V);
    
%****************开始迭代*************************%
    while(nIter<500)
          
    
  % ===================== update U ========================%
        XV=X*V;
        UVV=U*V'*V;
        U = U.*(XV./max(UVV,1e-10));
  %======================== done U =========================%
        
  % ===================== update V =======================%
             XU=X'*U;
              VUU=V*U'*U;
        
              V = V.*(XU./max(VUU,1e-10)); % 3mk
  %======================= Done Z ========================%  
        
        nIter = nIter + 1;
      
        objhistory = CalculateObj(X, U, V);
        nmfOBJ = [nmfOBJ objhistory];
        
%=======================================================
        fprintf('Saving...\n');
        save(fname,'nmfOBJ');
        fprintf('Done!\n');
%=======================================================

    end     
        
       elapse = cputime - tmp_T;
       
[U_final,V_final] = NormalizeUV(U, V, NormV, Norm);
%==========================================================================

function obj = CalculateObj(X, U, V)
    
    First=X-U*V';
    objF=norm(First,2);
    obj=objF;
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
 