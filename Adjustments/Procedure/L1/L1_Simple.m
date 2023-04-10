function [x,V,v,sig] = L1_Simple(A,L,P)
%%
% A 设计矩阵
% L 观测向量
% P 权阵

[n,m]=size(A);
mm = eye(n);
pp = sqrt(diag(P)');
c = [zeros(1,2*m),pp,pp];
% c=[zeros(1,2*m),ones(1,2*n)];
a = [A,A,-mm,-mm];

b = L;
D = 0;delta = 0;

Sim = simplex_0828(a,b,c,D,delta);

x = Sim.X(:,1:m) - Sim.X(:,m+1:2*m);
v = Sim.X(:,2*m+1+n:2*m+2*n) - Sim.X(:,2*m+1:2*m+n);
L_Est = A * x';
V = L - L_Est;
Res2 = V'*V;
sig = sqrt(Res2/(n-m));

end
