clear
clc
A=[2 6 -4;1 4 -5;6 -1 18];
L=[4;3;2];
P=eye(3);
RSS = RSSGuass(A,L,P)
%% Outputs:
% N = [41 10 95;10 53 -62;95 -62 365]
% U = [23 34 5]
% RSS = 1.4067