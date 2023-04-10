clc
clear all

%%%王爱生文献
A1 = [2.62 -0.89 -2.29;
     -2.46 -1.32 -0.33;
     -0.16 2.21  2.62;
     -2.62 0.89  0.17;
     2.33  2.6   -2.6;
     0.29 -3.49  2.45;
     -0.9  3.49  0];
%%%观测权阵
DL = [4 2 2 -2 -1 -1 0;
       2 4 2 -1 -2 -1 0;
       2 2 4 -1 -1 -2 0;
      -2 -1 -1 4 2 2 1;
      -1 -2 -1 2 4 2 -1;
      -1 -1 -2 2 2 4 0;
       0  0  0 1 -1 0 4;];
PL = inv(DL);
%%观测数据
L1 = [-10.3553 -8.2364 18.5117 -0.4790 -3.7101 4.7635 7.5630]';
%% ordinary LS
[x0 sig0,Lest0,v0,N,Qx,J] = OWLS(A1,L1,PL);


 %%%加粗差前
[A L LMat] = P2CholTrans(A1,L1,PL);
InVLMat = inv(LMat);

[x sig,Lest,v] = LS(A,L);
%% check the parameters
ds = sig - sig0
dx = x0 - x;
dv = inv(LMat)*v - v0;
%% check the estimated obs
dL = Lest0 - inv(LMat)*Lest;

%%Remarks:
% + CholTrans may be useful in study the robust estimation for dependent observations
% + CholTrans may be useful to data snooping problem, compare to the FisherInfDecom