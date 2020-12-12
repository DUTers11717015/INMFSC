 load('ORL_32.mat');	
        nClass = length(unique(gnd));
        fname='INMFSC-ORL';
        b=200;
        fea = NormalizeFea(fea);
        X= fea';
[m,n]=size(X);  
KClass=50;
%%%%%%%%%%  ��ʼ��  %%%%%%%%%%%%
  U = abs(rand(m,KClass));
 V = abs(rand(KClass,b));

maxiter=200;
%%%%%%%%%%  ��ʼ��  %%%%%%%%%%%%

% error=5;
for iter=1:maxiter
    U=U.*((X(:,1:b)*V')./(U*V*V'));
    V=V.*((U'*X(:,1:b))./(U'*U*V));
    nmfnew=norm(X(:,1:b)-U*V,'fro');
    nmfobj=[];
    nmfobj = [nmfobj nmfnew];
%=======================================================
        fprintf('Saving...\n');
        save(fname,'nmfobj');
        fprintf('Done!\n');
%=======================================================
    
end
U1=U;
train_gnd=gnd(1:b,:);
V1=V;

A=X(:,1:b)*V';
B=V*V';
v=V(:,end); % Warm start for h
U_new = U;  
iter = 0;
maxiter=200;
% =============================   ϡ��Լ��   ============================ %
sU=0.3; % ����ϡ��ϵ��
sV=[];  % ����ϡ��ϵ��
% =============================   ϡ��Լ�����   =======================  %
V_new=[];

X1=X(:,b+1:end);

for i=1:size(X1,2)
    X_new=X1(:,i);
       while(iter<maxiter)
  
    if (iter==maxiter)
        break
    end
    
    iter = iter+1;    
    % Save old values
    %Wold = W_new;
    %Hold = H;
    
    % Compute new W and H 
    v = v.*((U_new)'*X_new)./((U_new)'*(U_new)*v +sU+1e-9); 
    U_new = U_new.*((A+X_new*(v)')./(U_new*(B+(v)*(v)') + 1e-9)); % Add 1e-9 to avoid 0 in the denom.
%=======================================================
        fprintf('Saving...\n');
     %   save(fname,'inmfscOBJ');
        fprintf('Done!\n');
%=======================================================
    end

    V_new=[V_new v]; %Just for demonstration
end  

U2=U_new;
V2=V_new;
test_gnd=gnd(b:end,:);
save('V2','V2');
save('U2','U2');
%=================== ��ʾ������ =====================%
figure(1)

   
         visual(U,3,6);
         %visual(U,3,10);
          title(fname);

 result = knn(V1,train_gnd,V2,10,2)
  % [ accu ] = MinNearClasser ( V1 , V2 , 20 )