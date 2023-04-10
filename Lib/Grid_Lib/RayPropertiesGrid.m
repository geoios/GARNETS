function PF = RayPropertiesGrid(PF,theta,PFcol,MaxAngle)
%% RayTracing(PF,theta,T,Y,H)->Direct tracing problem
%函数作用：声线跟踪核心函数，逐层计算每层传播时间、深度、水平位移
%输入值
%声速剖面、入射角、控制点、实测时间、水平位移、目标点深度（初值）
%输出值
%传播时间T、水平位移Y、深度Z
SumHorizontal   = 0;
PropagationTime = 0;
H = PF(end,1);
m = size(PF,1);  %得到声速剖面的数据点数
%% Ray tracing
cos_alfa0   = sin(theta);     % cos(G_theta);          %入射掠射角余弦
PF(1,PFcol) = cos_alfa0;
V = [inf,inf,inf];
for i = 1 : m-1
    c0 = PF(i,2); 
    z  = PF(i,3);  
    a  = PF(i,4);
    [t1,x1,z1,L1,cos_alfa0]  = SingleLayerTracing(cos_alfa0,c0,a,+inf,+inf,z);
    SumHorizontal            = SumHorizontal + x1;
    PropagationTime          = PropagationTime + t1;
%     PF(i+1,PFcol)            = SumHorizontal;
%     PF(i+1,PFcol+MaxAngle)   = PropagationTime; 
%     PF(i+1,PFcol+2*MaxAngle) = cos_alfa0; 
    PF(i+1,PFcol)            = cos_alfa0;
    PF(i+1,PFcol+MaxAngle)   = SumHorizontal;
    PF(i+1,PFcol+2*MaxAngle) = PropagationTime;
end
