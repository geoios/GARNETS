function [x,Q,N,V,r,sig,dQ,dr,Eval] = ParSysEval(x,Q,N,V,r,sig,A,z,P,idx)
[n,m] = size([A z]);
r1 = r;
sig1 = sig;
Q1 = Q;
D1 = Q*sig;
[n n] = size(D1);
[x,Q,N,V,r,sig,dQ,dr] = PRLS_Mat(x,Q,N,V,r,sig,A,z,P);
Eval.drs  = r/r1 -1;
Eval.RMS  = Q * sig;

Eval.MRMS = trace(inv(D1) * Eval.RMS(1:n,1:n))/n - 1;
Eval.PRMS = trace(inv(Q1)*Q(1:n,1:n))/n -1;%trace(inv(Q1)*dQ)/n;
Eval.BIC  = BICFun(r,n,m);
Eval.dsig = sig/sig1-1;
Eval.T = trace(Eval.RMS(n+1,n+1) - x(n+1)*x(n+1)'*sig/sig1);
Eval.MSE = trace(D1) + x(n+1)'*x(n+1);
end