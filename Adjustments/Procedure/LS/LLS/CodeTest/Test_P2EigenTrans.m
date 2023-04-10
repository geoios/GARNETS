clear all
clc
A1=[2 6 -4;1 4 -5;6 -1 18];
L1=[4;3;2];
P1=eye(3);
[A L S] = P2EigenTrans(A1,L1,P1)
%% Outputs:
% A = [2 6 -4;1 4 -5;6 -1 18]
% L = [4 3 2]
% S = [1 0 0;0 1 0;0 0 1]