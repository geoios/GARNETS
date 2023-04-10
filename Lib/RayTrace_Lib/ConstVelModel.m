function [t1, x1, z1,L1,cos_alfa1,c0] = ConstVelModel(cos_alfa0,c0,a,t,x,z)
%% ConstVelModel(cos_alfa0,c0,a,t,x,z)
%% Function：constant velocity tracing model

alfa0 = acos(cos_alfa0);      %求入射掠射角
if x < +inf
    tan_alfa0 = tan(alfa0);
    z1 = x*tan_alfa0 ;
    t1 = x/cos_alfa0/c0;
    x1 = x;
    L1 = sqrt(x1^2 + z1^2);
    cos_alfa1 = cos_alfa0;
    return;
elseif t < +inf
    sin_alfa0 = sin(alfa0);         %求入射掠射角正弦
    t1 = t;                         %返回实际的时间增量
    z1 = sin_alfa0*t1*c0;   
    x1 = z1/tan(alfa0);             %返回实际的水平距离增量
    L1 = sqrt(x1^2 + z1^2);
    cos_alfa1 = cos_alfa0;
    return;
elseif z < +inf
    sin_alfa0 = sin(alfa0);       %求入射掠射角正弦
    temp = z/sin_alfa0;
    t1 = temp/c0;                 %返回实际的时间增量
    x1 = temp*cos_alfa0;          %返回实际的水平距离增量
    z1 = z;                       %返回实际的深度增量
    cos_alfa1 = cos_alfa0;
    L1 = sqrt(x1^2 + z1^2);
end