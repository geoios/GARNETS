function [N U] = NormEqLS(A,L)
%% NormEqLS(A,L)
%% Function: Obtain the normal equation
%% inputs:
 % + A  % the design matrix
 % + L  % observations
%% outputs:
 % + N , U %construct the variables of the method equation
%%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%%
 % A=[2 6 -4;1 4 -5;6 -1 18];
 % L=[4;3;2];
%% Outputs:
 % N=[41 10 95;10 53 -62;95 -62 365]
 % U=[23;34;5]
%[N U] = NormEqLS(A,L)
N = A'*A;
U = A'*L;
