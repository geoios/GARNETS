function [x,sigma,L_est,v,N,Qx,J] = GLS(A,L,PL,x,Px)
%% GLS(A,L)
%% Function:Obtain the LS estimations
%% inputs:
  % + A  % the design matrix
  % + L  % observations  
  % + Px % weights for parameters with porior
  % + PL % weights of the observations
  % + x  % parameter estimation
 %% outputs
  % + LSopt.x   % LS parameter estimation  
  % + LSopt.v   % LS residual 
  % + LSopt.sig % variance of unit weight 
  % + LSopt.L_est % approximation of L
  % + LSopt.N   % A'PA,weight matrix of parameters
  % + LSopt.Qx  % cofactor matrix of parameters
  % + LSopt.J   % --
%%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%
 % A=[2 6 -4;1 4 -5;6 -1 18];
 % L=[4;3;2];
 % x=[1;0;-0.5];
 % PL=eye(3);
 % Px=eye(3);
%% Outputs:
 % x = [1.172;0.096;-0.276]
 % sigma = 0.308
 % L_est = [4.023;2.935;1.975;1.172;0.096;-0.276]
 % v = [-0.023;0.066;0.026;-0.172;-0.096;-0.225]
 % N = [42 10 95;10 54 -62;95 -62 366]
 % Qx = [0.592 -0.355 -0.219;-0.355 0.236 0.132;-0.217 0.132 0.081]
 % J = [0.709 0.403 0.045 -0.92 0.177 0.042;0.403 0.395 -0.074 0.241 -0.072 -0.088;
 % 0.045 -0.074 0.988 0.058 0.012 0.036;-0.092 0.241 0.058 0.592 -0.355 -0.214;
 % 0.177 -0.072 0.012 -0.355 0.236 0.132;0.043 -0.088 0.036 -0.214 0.132 0.081]
% [x,sigma,L_est,v,N,Qx,J] = GLS(A,L,PL,x,Px)
[n,m] = size(A);
[A1 L1 P1 N U AP] = GLSIterface(A,L,PL,x,Px); % can use the GLSIterface

Qx    = inv(N);
x     = Qx * U;
L_est = A1 * x;
v     = L1 - L_est;

RSS   = v(1:n)'*PL*v(1:n) + v(n+1:n+m)'*Px*v(n+1:n+m); % can be obtained V
sigma = sqrt(RSS);

AP1   = [AP Px];
J     = A1 * Qx * AP1;