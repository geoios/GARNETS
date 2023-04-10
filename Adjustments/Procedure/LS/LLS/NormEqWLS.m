function [N U AP] = NormEqWLS(A,L,P)
%% NormEqWLS(A,L,P)
%% Function: Obtain the normal equation
%% inputs:
 % + A % the design matrix
 % + L % observations
 % + P % observation weight matrix
%% outputs:
 % + N , U %construct the variables of the method equation
 % + AP
%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%%
 %  A=[2 6 -4;1 4 -5;6 -1 18];
 %  P=eye(3);
 %  %P(3,:)=[];
 %  L=[4;3;2];
%% Outputs:
 % p==q
 % N=[41 10 95;10 53 -62;95 -62 365]
 % U=[23;34;5]
 % AP=[2 1 6;6 4 -1;-4 -5 18]
 % else
 % N=[4 12 -8;12 36 -24;12 36 -24;-8 -24 16]
 % U=[8;24;-16]
 % AP=[2 0 0;6 0 0;-4 0 0]
% [N U AP] = NormEqWLS(A,L,P)
[p q] = size(P);
[n,m] = size(A);
if p==q
   AP = A'*P;
   N  = AP*A;
   U  = AP*L; %obtain the variables of the method equation
else          % in diagonal matrix case, P becomes a vector p
   for i=1:n
      sp = sqrt(P(i));
      AP0(i,:)  = A(i,:) * sp;
      AP(i,:)   = A(i,:) * P(i);
      LP0(i,:)  = L(i) * sp;
   end
   AP = AP';
   [N,U] = NormEqLS(AP0,LP0); %obtain the variables of the method equation
end