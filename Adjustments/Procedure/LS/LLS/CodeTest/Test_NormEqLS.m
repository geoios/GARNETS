clear all;clc
A=[2 6 -4;1 4 -5;6 -1 18];
L=[4;3;2];
[N U] = NormEqLS(A,L)
%% Outputs:
 % N=[41 10 95;10 53 -62;95 -62 365]
 % U=[23;34;5]