function [T1,Y1,Z1,L1,f,RayInf] = InAng2f111(Var)
%% InAng2f(Var)->1-D inverion function
%% Remarks:
 % + The problem is abstracted as f(a) = 0, to be solved by alogrithms on hand
 
PF  = Var.PF;
x   = Var.x; %% the unknown the incident angle
idx = Var.idx;

[T1,Y1,Z1,L1 ts xx zz LL,RayInf] = RayTracing(PF,x,Var.V(1),Var.V(2),Var.V(3));
F = [T1,Y1,Z1];

F0 = Var.F0;
f = F(idx) - F0(idx); %% This equation indexed by idx