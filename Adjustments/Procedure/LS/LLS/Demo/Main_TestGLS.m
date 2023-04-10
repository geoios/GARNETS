clc
clear all
n = 10;
m = 3;
A = randn(n,m)
x = [1 1 1]';
L = A*x + 0.1* randn(n,1)

%% solve the full eq
[x3,sigma2,L_est2,v3,Px0,Qx3,J] = LS(A,L);

%% solve the first five equation  
A1 = A(1:5,:)
L1 = L(1:5)
[x0,sigma,L_est,v,Px0,Qx,J] = OLS(A1,L1)
%% applying the GLS
A2 = A(6:10,:)
L2 = L(6:10)
PL = eye(5)

[x1,sigma1,L_est1,v1,N,Qx1,J] = GLS(A2,L2,PL,x0,Px0)
% check the parameter
dx = x1-x3

%% check the covarinace information
dq =Qx1 - Qx3

%%dv
dv = v1(1:5) - v3(6:10)

