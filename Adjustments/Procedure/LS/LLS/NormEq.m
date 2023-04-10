function [N,U,AP] = NormEq(A,L,P)
%% NormEq(A,L,P)
%% Function: Obtain the normal equation
%% inputs:
 % + A % the design matrix
 % + L % observations
 % + P % observation weight matrix
%% outputs:
 % + N , U %construct the variables of the method equation
 % + AP
%%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%%
 % nargin == 2
 % A=[2 6 -4;1 4 -5;6 -1 18];
 % L=[4;3;2];
 % [N,U,AP] = NormEq(A,L)
 
 % else
 % A=[2 6 -4;1 4 -5;6 -1 18];
 % L=[4;3;2];
 % P=eye(3);
 % [N,U,AP] = NormEq(A,L,P)
%% Outputs:
 % nargin == 2
 % N = [41 10 95;10 53 -62;95 -62 365]
 % U = [23;34;5]

 % else
 % N = [41 10 95;10 53 -62;95 -62 365]
 % U = [23;34;5]
 % AP = [2 1 6;6 4 -1;-4 -5 18]
%[N,U,AP] = NormEq(A,L,P)
if nargin == 2
   [N,U] = NormEqLS(A,L); % 此处表达式出错，调用函数NormEqLS不能输出AP
   AP = [];
else
   [N,U,AP] = NormEqWLS(A,L,P);
end