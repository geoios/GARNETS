function [x1,Q1,C1 rs sigs TrQs drs RMS MRMS PRMS dsigs BIC] = GrossDetectSys(A,L,P,K,Fun)

[x,sig,L_est,V,N,Q,r] = OWLS_Simple(A,L,P);
[n m] = size(A);
C = combntns(1:n,K);
C1= C;
[nc,m]= size(C);
idx = m;
for i=1:nc
    z = Fun(n,C(i,:));
    [x1,Q1,N1,V1,r1,sig1,dQ,dr,Eval] = ParSysEval(x,Q,N,V,r,sig,A,z,P,idx);
    ie = x1(end-K+1:end)/sig1;
    C1(i,K+1:K+K+1) = [ie' norm(ie)];
    rs(i) = r1;
    sigs(i) = sig1;
    TrQs(i) = trace(Q);
    
    drs(i)  = Eval.drs;
    RMS{i}  = Eval.RMS;
    MRMS(i) = Eval.MRMS;
    PRMS(i) = Eval.PRMS;
    dsigs(i) = Eval.dsig;
    BIC(i)  = Eval.BIC;

    Ts(i) = Eval.T;

end