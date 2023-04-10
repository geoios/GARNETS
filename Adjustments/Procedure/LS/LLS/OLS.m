function [x,sigma,L_est,v,N,Qx,J] = OLS(A,L)
%% OLS(A,L)
%% Function:Obtain the LS estimations
%% inputs:
  % + A  %   the design matrix 
  % + L  %   observations  
 %% outputs
  % + LSopt.x   % LS parameter estimation  
  % + LSopt.v   % LS residual 
  % + LSopt.sig % variance of unit weight 
  % + LSopt.L_est % approximation of L
  % + LSopt.N   % A'PA,weight matrix of parameters
  % + LSopt.Qx  % cofactor matrix of parameters
  % + LSopt.J   % --
%%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%%
 %A=[1 -1;-1 2;2 -3];
 %L=[5;-4;10];
 %[x,sigma,L_est,v,N,Qx,J] = OLS(A,L)
%% Outputs:
 % x=[6.333 1.000]
 % sigma = 0.5774
 % L_est = [5.333 -4.333 9.667]
 % v = [-0.333 0.333 0.333]
 % N = [6 -9;-9 14]
 % Qx = [4.667 3.000;3.000 2.000]
 % J = [0.667 0.333 0.333;0.333 0.667 -0.333;0.333 -0.333 0.667]
%[x,sigma,L_est,v,N,Qx,J] = LS(A,L)
[n,m] = size(A);  
N     = A'*A;              %fetch the information matrix of the parameters
Qx    = inv(N);            %fetch the cofactor matrix of parameters
C     = Qx * A';           
x     = C  * L;            %obtain the parameters to be estimated
L_est = A*x;               %get an approximation of L
v     = L - L_est;         %get the residual
sigma = sqrt(v'*v/(n-m));  %obtain the unit weight median error
J     = A * C;