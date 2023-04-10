function [x,sigma,L_est,v,N,Qx,r] = OWLS_Simple(A,L,P)
%% OWLS(A,L)
%% Function:Obtain the LS estimations
%% inputs:
  % + A  %   the design matrix 
  % + L  %   observations    
  % + P  %   weights for parameters with porior 

%% Outputs:
 % x=[6.333 1.000]
 % sigma = 0.5774
 % L_est = [5.333 -4.333 9.667]
 % v = [-0.333 0.333 0.333]
 % N = [6 -9;-9 14]
 % Qx = [4.667 3.000;3.000 2.000]
%[x,sigma,L_est,v,N,Qx,J] = OWLS(A,L,P)
[n,m] = size(A);
[pn,pm] = size(P);
if pn~=pm
   AP = A'.*P';
else
   AP = A'*P;
end
N  = AP*A;
U  = AP*L; %obtain the variables of the method equation

Qx    = inv(N);
x     = Qx * U;
L_est = A*x;
v     = L - L_est; 
if pn~=pm
   vP = v'.*P';
else
   vP = v'*P;
end
r = vP*v;
sigma = r/(n-m);