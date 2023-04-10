function [T,Y,Z,L,theta,Iteration,RayInf] = InAngle(PF,TT,YY,HH)
%% IncidentAngle(PF,TT,YY,HH,tag)->incident angle inversion
%% To swtich the InAng2f
F0 = [TT,YY,HH];
V  = [inf,inf,inf];
if TT == +inf
    idx0 = 3;
    V(idx0) = HH;
    idx = 2; 
end

if YY == +inf 
    idx0 = 1; 
    V(idx0) = TT; 
    idx = 3; 
end

if HH == +inf
    idx0 = 2; 
    V(idx0) = YY; 
    idx = 1; 
end

Var.PF   = PF;
Var.V    = V;
Var.F0   = F0;
Var.idx  = idx;
Var.idx0 = idx0;

%% handle the optimization problem
InitialScale = InitialInAng(Var);
Var.Initials  = [InitialScale(1),InitialScale(2)];
Var.TermIter  = 20;
Var.Terminate = 10^-4;
[T,Y,Z,L,theta,Iteration,RayInf] = TangentMethod(@InAng2f111,Var);

end
