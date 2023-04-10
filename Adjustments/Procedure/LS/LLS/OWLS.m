function [x,sigma,L_est,v,N,Qx,J] = OWLS(A,L,P)
%% OWLS(A,L)
%% Function:Obtain the LS estimations
%% inputs:
  % + A  %   the design matrix 
  % + L  %   observations    
  % + P  %   weights for parameters with porior 
 %% outputs
  % + LSopt.x   % LS parameter estimation 
  % + LSopt.v   % LS residual 
  % + LSopt.sig % variance of unit weight 
  % + LSopt.L_est % approximation of L
  % + LSopt.N   % A'PA,weight matrix of parameters
  % + LSopt.Qx  % cofactor matrix of parameters
  % + LSopt.J   % --
%%%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%%
%  A=[1 -1;-1 2;2 -3];
%  L=[5;-4;10]
%  P=eye(3);
%  [x,sigma,L_est,v,N,Qx,J] = OWLS(A,L,P)
%% Outputs:
 % x=[6.333 1.000]
 % sigma = 0.5774
 % L_est = [5.333 -4.333 9.667]
 % v = [-0.333 0.333 0.333]
 % N = [6 -9;-9 14]
 % Qx = [4.667 3.000;3.000 2.000]
 % J = [0.667 0.333 0.333;0.333 0.667 -0.333;0.333 -0.333 0.667]
%[x,sigma,L_est,v,N,Qx,J] = OWLS(A,L,P)
[n,m] = size(A);
[N U AP] = NormEqWLS(A,L,P); % use the NormEqWLS
Qx    = inv(N);
C     = Qx * AP;
x     = Qx * U;
L_est = A*x;
v     = L - L_est; 
[p,q] = size(P);
if p==q
   vpv = v'*P*v;
else
   vpv = 0;
   for i=1:length(P)
       vpv = vpv + v(i)*P(i)*v(i);
   end
end
sigma = sqrt(vpv/(n-m));
J     = A * C;