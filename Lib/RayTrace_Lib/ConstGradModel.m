function [t1,x1,z1,L1,cos_alfa1,c1] = ConstGradModel(cos_alfa0,c0,a,t,x,z)
%% ConstGradModel(cos_alfa0,c0,a,t,x,z)->constant grandient tracing model
%alfa0     = acos(cos_alfa0);    %求入射掠射角
% sin_alfa0 = sin(alfa0);         %求入射掠射角正弦
sin_alfa0 = sqrt(1 - cos_alfa0^2);
P  = cos_alfa0/c0;
IP = 1/P;
R  = -IP/a;
if z < inf
    c1        = a * z + c0;
    cos_alfa1 = P * c1;    %求射出掠射角余弦
%   alfa1     = acos(cos_alfa1);    %求射出掠射角
%   sin_alfa1 = sin(alfa1);         %求出射掠射角正弦
    sin_alfa1 = sqrt(1 - cos_alfa1^2);
    %
    x1 = R * (sin_alfa1 - sin_alfa0);
    %x1 = z/tan((alfa0+alfa1)/2);                                                            %求声线最大可能的水平距离增量
    t1 = (log((1+sin_alfa0)/(1-sin_alfa0)) - log((1+sin_alfa1)/(1-sin_alfa1)))/(2*a);    %求最大可能的传播时间增量
%   t1 = abs(t1);           %保证为正数 
    z1 = z;         %返回实际的深度增量
    L1 = sqrt(x1^2 + z1^2);
    return;
end
if x < inf
    tan0 = sin_alfa0/cos_alfa0;
    %z=x*tan(alfa0);
    z  = x * tan0;
    c1 = c0 + a*z;
    cos_alfa1 = P*c1;    %求射出掠射角余弦
    alfa1 = acos(cos_alfa1);         %求射出掠射角
    %sin_alfa1 = sin(alfa1);         %求出射掠射角正弦
    sin_alfa1 = sqrt(1-cos_alfa1^2);
    % z1 = x*tan(alfa0);                            %求实际达到点的深度增量
    z1 = (c1 - c0)/a;                               %求实际达到点的深度增量
    x1 = x;                     %求实际达到点的水平距离增量
    % t1 = x/cos_alfa0/c0;
    t1 = (log((1+sin_alfa0)/(1-sin_alfa0)) - log((1+sin_alfa1)/(1-sin_alfa1)))/(2*a*c0);    %求最大可能的传播时间增量
    t1 = abs(t1);           %保证为正数 
    L1 = x/cos((alfa0+alfa1)/2);
    return;
end
if t < inf
%等梯度的第一类正问题，即给传播时间，得到深度z，及水平位移x
    t1 = t;         %返回实际的时间增量
    A = log((1+sin_alfa0)/(1-sin_alfa0)) - 2*a*t;
    sin_alfa1 = (exp(A) - 1)/(exp(A) + 1);            %重新求到达掠射角正弦
    cos_alfa1 = sqrt(1-sin_alfa1^2);                  %重新求到达掠射角余弦
    c1 = cos_alfa1/cos_alfa0*c0;                      %求实际到达点的声速

    z1 = (c1 - c0)/a;                            %求实际达到点的深度增量
    x1 = R*(sin_alfa1 - sin_alfa0);
    %x1 = z1*(cos_alfa0+cos_alfa1)/(sin_alfa0 + sin_alfa1);                    %求实际达到点的水平距离增量
    L1 = z1/sin_alfa0; 
end