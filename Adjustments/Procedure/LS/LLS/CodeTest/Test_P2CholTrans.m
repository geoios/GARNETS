clear
clc
% if p==q
% A1=[2 6 -4;1 4 -5;6 -1 18];
% L1=[4;3;2];
% P=eye(3);
% [A L LMat] = P2CholTrans(A1,L1,P)

% else
A1=[2 6 -4;1 4 -5;6 -1 18];
L1=[4;3;2];
P=eye(3);
P(3,:)=[]
[A L LMat] = P2CholTrans(A1,L1,P)
%% Outputs:
% if p==q
% A = [2 6 -4;1 4 -5;6 -1 18]
% L = [4 3 2]
% LMat = [1 0 0;0 1 0;0 0 1]

% else
% A = [2 6 -4;0 0 0;0 0 0]
% L = [4 0 0]
% LMat = [1 0 0]