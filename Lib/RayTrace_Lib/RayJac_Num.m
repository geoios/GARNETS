function [ei,t,AddInf] = RayJac_Num(KnownPoint,UnknownPoint,PF)
% KnownPoint   待定点
% UnknownPoint 控制点
[t,Y,Z,L,theta,Iteration,RayInf] = P2PInvRayTrace(KnownPoint,UnknownPoint,PF);
LastLayerAngel = asin(RayInf.alfae);
% LastVelocity   = RayInf.ce;
cos_beta      = (KnownPoint(1) - UnknownPoint(1))/Y;
sin_beta      = (KnownPoint(2) - UnknownPoint(2))/Y;
cos_alfa      = cos(LastLayerAngel);
sin_alfa      = sin(LastLayerAngel);

ei(1) = sin_alfa * cos_beta;
ei(2) = sin_alfa * sin_beta;
ei(3) = cos_alfa;

AddInf.cos_azi = cos_beta;
AddInf.sin_azi = sin_beta;
AddInf.cos_zen = cos_alfa;
AddInf.sin_zen = sin_alfa;
AddInf.cx      = RayInf.ce;  

end