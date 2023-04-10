function [N U] = FisherInf(A,L)
%% FisherInf(A,L)
%% Function: get the variables with Fisher information
%% inputs:
  % + A  %   the design matrix
  % + L  %   observations  
%% outputs:
  % + N , U % construct the variables of the method equation
%%%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%%
 % A=[2 6 -4;1 4 -5;6 -1 18];
 % L=[4;3;2];
 % [N U] = FisherInf(A,L)
%% Outputs:
 % N(:,:,1)=[4 12 -8;12 36 -24;-8 -24 16]
 % N(:,:,2)=[1 4 -5;4 16 -20;-5 -20 25]
 % N(:,:,3)=[36 -6 108;-6 1 -18;108 -18 324]
 % U=[8 3 12;24 12 -2;-16 -15 36]
%[N U] = FisherInf(A,L)
n = length(L);
for i=1:n
   N(:,:,i) = A(i,:)'*A(i,:); %get three-dimensional matrix N
   U(:,i) = A(i,:)'* L(i)     
end