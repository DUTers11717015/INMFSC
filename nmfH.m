function [U_final, V_final, nIter] = nmfH(X, k, fname)

%一般取alpha=100;


Norm = 2;
NormV = 1;

if min(min(X)) < 0
    error('Input should be nonnegative!');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[mFea,nSmp]=size(X);


%%%%%%%%%%  初始化  %%%%%%%%%%%%
 U = abs(rand(mFea,20));
 V = abs(rand(nSmp,20));
%%%%%%%%%%%%%  归一化  %%%%%%%%%%
 
[U,V] = NormalizeUV(U, V, NormV, Norm);

    tmp_T = cputime;
    
    nIter = 0;
    nmfOBJ=CalculateObj(X, U, V);
    while(nIter<500)
  % ===================== update V ========================
        XU = X'*U;  % mnk or pk (p<<mn)
        UU = U'*U;  % mk^2
        VUU = V*UU; % nk^2
        
%         XU = XU + WV;
%         VUU = VUU + DV;
            XU = XU;
            VUU = VUU;
        
        V = V.*(XU./max(VUU,1e-10));
        %======================== done V =======================
        
        % ===================== update U =======================
        XV = X*V;   % mnk or pk (p<<mn)
        VV = V'*V;  % nk^2
        UVV = U*VV; % mk^2
        
        U = U.*(XV./max(UVV,1e-10)); % 3mk
        %======================= Done U ========================   
        
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

        