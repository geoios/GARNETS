function [A L Q] = A2QR(A1,L1)
%% A2QR(A1,L1)
%% Function: Matrix A1 performs the QR decomposition,to solve the stability problem
 %% inputs:
 % + A1 % the design matrix
 % + L1 % observations
 %% outputs:
 % + A % the design matrix
 % + L % observations
 % + Q % cofactor matrix
%%%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%%
 % A1=[2 6 -4;1 4 -5;6 -1 18];
 % L1=[4;3;2]
 % [A L Q] = A2QR(A1,L1)
%% Outputs:
 % A = [-6.403 -1.562 -14.837;0 -7.111 11.978;0 0 -1.186]
 % L = [-3.592 -3.993 0.395]
 % Q = [-0.312 -0.775 -0.549;-0.156 -0.528 0.835;-0.937 0.346 0.044]
%[A L Q] = A2QR(A1,L1)
[Q,A] = qr(A1,0); % QR decomposition
L = Q'*L1;