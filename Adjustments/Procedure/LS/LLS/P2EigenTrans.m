function [A L S] = P2EigenTrans(A1,L1,P1)
%% P2EigenTrans(A1,L1,P1)
%% Function: for non-diag matrix P
%% Reduce the correlation of observations,i.e., tansform to a new coordinate system
 %% inputs:
 % + A1 % the design matrix
 % + L1 % observations
 % + P1 % Diagonal weight matrix
 %% outputs:
 % + A % the design matrix
 % + L % observations
 % + S % The eigenvector matrix of P
%%%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%%
 % A1=[2 6 -4;1 4 -5;6 -1 18];
 % L1=[4;3;2];
 % P1=eye(3);
%% Outputs:
 % A = [2 6 -4;1 4 -5;6 -1 18]
 % L = [4 3 2]
 % S = [1 0 0;0 1 0;0 0 1]
%[A L S] = P2EigenTrans(A1,L1,P1)
[S P] = eig(P1); 
A = S * A1;
L = S * L1;