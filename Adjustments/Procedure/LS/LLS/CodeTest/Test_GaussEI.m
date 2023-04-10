clear all;clc
% nargin == 2
A0=[2 6 -4;1 4 -5;6 -1 18];
L=[4;3;2];
x = GaussEI(A0,L)
%% else
% A0=[2 6 -4;1 4 -5;6 -1 18];
% L=[4;3;2];
% P=eye(3);
% x = GaussEI(A0,L,P)
 %% Outputs:
 % x=[1.3333;0;-0.3333]