function [t1, x1, z1,L1,cos_alfa1,c1] = SingleLayerTracing(cos_alfa0,c0,a,t,x,z)
%% SingleLayerTracing(cos_alfa0,c0,a,t,x,z)
%% Function: ray tracing of a single layer

V = [+inf,+inf,+inf];
if z < inf; V(3) = z; end
if t < inf; V(1) = t; end
if x < inf; V(2) = x; end

if a == 0      %%等声速 
    [t1,x1,z1,L1,cos_alfa1,c1] = ConstVelModel(cos_alfa0,c0,a,V(1),V(2),V(3));
else           %%等梯度
    [t1,x1,z1,L1,cos_alfa1,c1] = ConstGradModel(cos_alfa0,c0,a,V(1),V(2),V(3));
end