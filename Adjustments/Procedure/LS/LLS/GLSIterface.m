function [A1 L1 P1 N1 U1 AP] = GLSIterface(A,L,PL,x,Px);
%% GLSIterface(A,L,PL,x,Px) 
%% Function: transform it to be an ordinary LS problem
%% inputs:
  % + A  % the design matrix
  % + L  % observations  
  % + Px % weights for parameters with porior
  % + PL % weights of the observations
  % + x  % parameter estimation
 %% outputs
  % + A1 % the design matrix
  % + L  % observations
  % + P1 % Diagonal weight matrix
  % + N1,U1% construct the variables of the method equation
  % + AP 
%[A1 L1 P1 N1 U1 AP] = GLSIterface(A,L,PL,x,Px)
  % Ax = L,  PL  
  % Ix = x0, Px  
%%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%
 % A=[2 6 -4;1 4 -5;6 -1 18];
 % L=[4;3;2];
 % x=[1.3333;0;-0.3333];
 % PL=eye(3);
 % Px=eye(3);
%% Outputs:
 % [A1] = [2 6 -4;1 4 -5;6 -1 18;1 0 0;0 1 0;0 0 1]
 % L1 = [4.000;3.000;2.000;1.333;0;-0.333]
 % P1 = [1 0 0 0 0 0;0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1]
 % N1 = [42 10 95;10 54 -62;95 -62 366]
 % U1 = [24.333;34.000;4.667]
 % AP = [2 1 6;6 4 -1;-4 -5 18]
% [A1 L1 P1 N1 U1 AP] = GLSIterface(A,L,PL,x,Px)
[n,m] = size(A);
A1 = [A;eye(m)];
L1 = [L;x];
P1 = blkdiag(PL,Px);       %% this can be extended to be [PL plx;plx' px]

if nargout==3; return;end  %% Then, to be sloved by LS

[N0 U0 AP] = NormEqWLS(A,L,PL);
N1 = N0 + Px;
U1 = U0 + Px*x;