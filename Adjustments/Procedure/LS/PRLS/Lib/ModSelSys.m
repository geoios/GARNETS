function [x Q V rs sigs TrQs drs RMS MRMS PRMS dsigs BIC Ts MSEs] = ModSelSys(A,L,P,BaseFunIdx)

[n,m] = size(A);
[x,sig,L_est,V,N,Q,r] = OWLS_Simple(A(:,1:BaseFunIdx),L,P);
%x(1,:) = x1;
rs(1) = r;
sigs(1) = sig;
RMS(1) = trace(Q) * sig;
MSE(1) = RMS(1);
TrQs(1) = trace(Q);
BIC(1) = BICFun(r,n,1) 
for i = BaseFunIdx+1 : m
    r1   = r;
    sig1 = sig;
    idx  = i; %% 等价于全部
    [x,Q,N,V,r,sig,dQ,dr,Eval] = ParSysEval(x,Q,N,V,r,sig,A(:,1:i-1),A(:,i),P,idx);
    rs(i)   = r;
    sigs(i) = sig;
    TrQs(i) = trace(Q);
    
    drs(i)  = Eval.drs;
    RMS(i)  = trace(Eval.RMS);
    MRMS(i) = Eval.MRMS;
    PRMS(i) = Eval.PRMS;
    dsigs(i) = Eval.dsig;
    BIC(i)  = Eval.BIC;
    Ts(i) = Eval.T;
    MSEs(i) = Eval.MSE;
end