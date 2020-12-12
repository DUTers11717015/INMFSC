% Serhat Selcuk Bucak, bucakser@msu.edu
function  [W_new, h, A, B, inmfscOBJ] = inmfsc( V_new, W, h, A, B, rdim, sU, maxiter)
%%  
%[W_new, h, A, B] = inmf( V_new, W, h, A, B, rdim, beta, alpha, maxiter)
%INPUTS:
%V_new: new data sample, a coluvector (d x 1)
%W: Mixing Matrix -or matrix of basis vectors- (d x rdim)
%h: initialization for the new encoding vector, a column vector (rdim x 1),
%A: Matrix to store cummulative V*H' 
%B: Matrix to store cummulative H*H'
%rdim: factorization rank
%beta: weighting coefficient for contribution of initial samples (i.e. A=beta*A+alpha*V_new*h';B=beta*B+alpha*h*h')
%alpha: weighting coefficient for contribution of the new sample
%maxiter: maximum number of iterations
%OUTPUTS
%W_new: Updated mixing matrix 
%h: Updated encoding vector
%A, B: Updated A,B matrices

% Dimensions
vdim = size(W,1);
%Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W_new = W;   % Warm start: Use the W obtained from the previous step as initial matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  tmp_T = cputime;

% Start iteration
iter = 0;
 inmfscOBJ=CalculateObj(V_new, W, h,  sU);   
 while(iter<maxiter)
  
    if (iter==maxiter)
        break
    end
    
    iter = iter+1;    
    % Save old values
    %Wold = W_new;
    %Hold = H;
    
    % Compute new W and H 
    h = h.*((W_new)'*V_new)./((W_new)'*(W_new)*h +(3/2)*sU*h.^(0.5)+1e-9); 
    W_new = W_new.*((A+V_new*(h)')./(W_new*(B+(h)*(h)') + 1e-9)); % Add 1e-9 to avoid 0 in the denom.
 
        objhistory = CalculateObj(V_new, W, h,  sU);
        inmfscOBJ = [inmfscOBJ objhistory];
%=======================================================
        fprintf('Saving...\n');
     %   save(fname,'inmfscOBJ');
        fprintf('Done!\n');
%=======================================================
  
end
 elapse = cputime - tmp_T;
A=A+V_new*h';
B=B+h*h';
function obj = CalculateObj(V_new, W_new, h, sU)
 
    First=V_new-W_new*h;
    objF=norm(First,2);
    obj=objF+sU*(norm(h,3/2)^(3/2));%^(3/2)
%     Second=V'*L*V;
%     objS=trace(Second);
%     obj=objF+alpha*objS;
