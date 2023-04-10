function [y,Sig_y] = PFGrid2IncidentAngle(x,Data,p)
Different = abs(Data(:,1) - x);                       % 计算拟合数据与待拟合值之差
W = 1 ./ (Different);                                 % 计算拟合数据的权

[Par,S,mu] = Wpolyfit(Data(:,1),Data(:,2),p,W);       % 计算拟合参数
Dx = S.Qx * S.sig;
[y,Sig_y] = polyPredict(Par,Dx,x,mu);                 % 计算插值点   


% [Par,S,mu] = polyfit(Data(:,1),Data(:,2),p);     % 计算拟合参数
% [y, ~]     = polyval(Par,x,S,mu);


end

