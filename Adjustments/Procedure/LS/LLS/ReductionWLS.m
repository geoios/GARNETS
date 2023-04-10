function [x,sigma,L_est,v,N,Qx,J,A1,L1] = ReductionWLS(A,L,P)
%% ReductionWLS(A,L,P)
%% Function:Obtain the LS estimations
 %% inputs:
  % + A % the design matrix
  % + L % obsevations 
  % + P % weights for parameters with porior information
 %% outputs
  % + LSopt.x   % LS parameter estimaton
  % + LSopt.sig % variance of unit weight
  % + LSopt.L_est % approximation of L 
  % + LSopt.v   % LS residual
  % + LSopt.N   % A'PA,weight matrix of parameters 
  % + LSopt.Qx  % cofactor matrix of parameters
  % + LSopt.J   % 
  % + A1 % the design matrix
  % + L1 % observations
%%%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%%
 % A=[1 -1;-1 2;2 -3];
 % L=[5;-4;10];
 % P=eye(3);
%% Outputs:
 % x=[6.333 1.000]
 % sigma = 0.5774
 % L_est = [5.333 -4.333 9.667]
 % v = [-0.333 0.333 0.333]
 % N = [6 -9;-9 14]
 % Qx = [4.667 3.000;3.000 2.000]
 % J = [0.667 0.333 0.333;0.333 0.667 -0.333;0.333 -0.333 0.667]
 % A1 = [1 -1;-1 2;2 -3]
 % L1 = [5 -4 10]
% [x,sigma,L_est,v,N,Qx,J,A1,L1] = ReductionWLS(A,L,P)
  [A1 L1 LMat] = P2CholTrans(A,L,P); %% not a direct way, be slow; P ->L'*L-->B=L*A;-->B'*L'*L*B; such taht the sigma is invariant under the Chol decomposition
  if nargout < 5;
      [x,sigma,L_est,v]        = LS(A1,L1);
  else
      [x,sigma,L_est,v,N,Qx,J] = LS(A1,L1);
  end