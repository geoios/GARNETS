 function [T,Y,Z,L,theta,Iteration,RayInf] = InvRayTrace(PF,TT,YY,HH)
 %% InvRayTracing(PF,TT,YY,HH,tag)->inversion problem
 %函数作用：声线跟踪的两类问题
 %%%%%%%%%%%%%%%
 %1、正问题：计算得到传播时间T、水平位移Y、传播深度Z
 %a、已知声速剖面、声源坐标、入射角、传播时间 --> 深度、水平位移
 %b、已知声速剖面、声源坐标、入射角、水平位移 --> 深度、传播时间
 %c、已知声速剖面、声源坐标、入射角、深度 --> 传播时间、水平位移
 %%%%%%%%%%%%%%%%
 %2、反问题：声线跟踪计算入射角theta
 %已知声速剖面、声源坐标、目标点坐标 --> 入射角
 %输入值
 %声速剖面，控制点坐标，接收点坐标（初值），实测时间（后续都已设为0）
 %输出值
 %传播时间T、水平位移Y、传播深度Z


%%%反问题
%[theta] = IncidentAngle(PF, TT,YY,HH,'Tangent'); 
[T,Y,Z,L,theta,Iteration,RayInf] = InAngle(PF,TT,YY,HH); 

%%%正问题
%%% 仅仅当IncidentAngle 中不进行解的检验时才用
% if  T == +inf
%     [T,Y,Z,L] = RayTracing( PF, theta, TT ,  +inf  ,HH  );
% elseif Y == +inf
%     [T,Y,Z,L] = RayTracing( PF, theta, TT ,   YY   ,+inf);
% elseif  H == +inf
%     [T,Y,Z,L] = RayTracing( PF, theta, +inf , YY   ,HH  );
% end



