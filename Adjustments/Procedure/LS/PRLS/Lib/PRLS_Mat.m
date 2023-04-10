function [x,Q,N,V,r,sig,dQ,dr] = PRLS_Mat(x,Q,N,V,r,sig,A,a,P)
%% recursive LS in the parameter space 
% x : Parameter of funciton model
% Q : Variance of parameter vector x
% Ni: Normal eqation
% V : LS residuals
% r : the weighted sum of squared residuals
% A : New information of the new parameters
%%
[n,m]=size(A);
[~,m1]=size(a);
t = n - m;
% m = length(x);
[pn pm] = size(P);
if pn~=pm
   a_Bar = a.*P;
else
   a_Bar = P*a;
end
N2    = a_Bar'*a;
N12   = A' * a_Bar;

N12Q = -N12'* Q;
q2 = inv(N2 + N12Q * N12);
x2 = q2 * (a_Bar' * V);
%dx = Q * N12 * x2;
dx = N12Q' * x2;
%% state undating
x = x + dx;                                   % old parameter updating
x(m+1:m+m1,:) = x2;                                   % parameter extending

V   = V - A*dx - a * x2;                     % residual updating
dr  = dx' * N * dx - x2' * N2 *x2;

r   = r + dr;        % WSRS
sig = r/(t-1);

N12q = -N12 * q2;
dQ = Q*N12q*N12Q;
Q11  = [Q + dQ Q*N12q]; 
%Q11= [inv(N - N12*q21*N12') -Q*N12*q2];  
Q21  = [q2*N12Q q2];
Q    = [Q11;Q21];                              % variance matrix updating
%N    = [N N12;N12' N2];                        % extending the normal matrix
N(:,m+1:m+m1) = N12;
N12(m+1:m+m1,:) = N2;
N(m+1:m+m1,:) = N12';
%AA = inv(N)
end