function [x1,sigma,L_est,v,P,Qx] = RobLS(A,L,P,RobPar)

[n,m] = size(A);
[p,q] = size(P);
if nargin == 3
   [x,sigma,L_est,v,N,Qx,J] = LS(A,L);
   P = ones(n,1);
   x1 = x;
   return;
end
if p==q %% correlation case
   [x,sigma,L_est,v,N,Qx,J,A,L] = ReductionWLS(A,L,P);
   P = ones(n,1);
else %% dependent case
   [x,sigma,L_est,v,N,Qx,J] = WLS(A,L,P);
end
P0 = P;
for i=1:RobPar.UpperIter

    sig = VarEst(v,n-m,RobPar.Var);

    if isfield(RobPar,'Type1');  
        RobPar.J = J;  
    end
    if isfield(RobPar,'Type2');  
        P = EquvWeight(v,P0,sig,RobPar);
    end
    
    if isfield(RobPar,'Type1');  
        [x1,sigma,L_est,v,N,Qx,J] = WLS(A,L,P);
    else
        [x1,sigma,L_est,v,N,Qx,J] = WLS(A,L,P)       ;
    end
    
    dx = x - x1;
    if norm(dx) < RobPar.Termination; break; end
    x = x1;
    if sigma>100
        pause
    end
end