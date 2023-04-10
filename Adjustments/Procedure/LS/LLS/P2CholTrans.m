function [A L LMat] = P2CholTrans(A1,L1,P)
%% P2CholTrans(A1,L1,P)
%% use cholesky's decomposition to solve symmetric positive definite equations
 %% inputs:
 % + A1 % the design matrix
 % + L1 % observations
 % + P  % Diagonal weight matrix
 %% outputs:
 % + A % the design matrix
 % + L % observations
 % + LMat % the upper triangular matrix, so that LMat*(LMat)'=P
%%%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%%
 % if p==q
 % A1=[2 6 -4;1 4 -5;6 -1 18];
 % L1=[4;3;2];
 % P=eye(3);
 
 % else
 % A1=[2 6 -4;1 4 -5;6 -1 18];
 % L1=[4;3;2];
 % P=eye(3);
 % P(3,:)=[]
 % [A L LMat] = P2CholTrans(A1,L1,P)
%% Outputs:
 % if p==q
 % A = [2 6 -4;1 4 -5;6 -1 18]
 % L = [4 3 2]
 % LMat = [1 0 0;0 1 0;0 0 1]
 
 % else
 % A = [2 6 -4;0 0 0;0 0 0]
 % L = [4 0 0]
 % LMat = [1 0 0]
% [A L LMat] = P2CholTrans(A1,L1,P)

[p,q] = size(P);
if p==q
    LMat = chol(P);
    A = LMat * A1;
    L = LMat * L1;
else
    n = length(L1);
    for i=1:n
        LMat(i,:) = sqrt(P(i));
        A(i,:) = A1(i,:) * LMat(i);
        L(i,:) = L1(i) * LMat(i);
    end
end