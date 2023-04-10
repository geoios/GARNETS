function [T,Y,Z,L ts xx zz LL,RayInf] = RayTracing(PF,theta,T,Y,H)
%% RayTracing(PF,theta,T,Y,H)
%% Functions：Acoustic ray tracking core function, calculating the propagation time, depth, and horizontal displacement of each layer
%% inputs:
  % + PF          %   sound profile
  % + theta       %   Angle of incidence
  % + T           %   Travel time
  % + Y           %   Horizontal displacement
  % + H           %   Depth
%% outputs
  % + T           %   Total ray Travel time
  % + Y           %   Horizontal displacement
  % + Z           %   Depth of spread
  % + L           %   Slope distance
  % + ts          %   Travel time of each layer
  % + xx          %   Horizontal displacement of each layer
  % + zz          %   Depth of each layer
  % + LL          %   Slope distance of each layer
  
  %%%%%%%%% Test Code %%%%%%%%%%%%%%%%%
%  PF = [0 1500
%                     1 1500.5
%                     2 1501.3
%                     3 1502.6
%                     4 1503.4];
%theta = 50/180*pi;T=+inf;Y=+inf;H=3;
%% outputs:T=0.003113643232476
%%        Y=3.583754697486602
%%        Z=3
%%        L=4.673683957073880
%%       ts=[0.001037221993599,0.001037412072985,0.001039009165893]
%%        xx=[1.192234549231017,1.193486578738757,1.198033569516829]
%%        zz=[1,1,1]
%%        LL=[1.556092301966075,1.557051795987691,1.560539859120115]
% [T,Y,Z,L ts xx zz LL] = RayTracing(PF,theta,T,Y,H)

if H < 0; warndlg('input depths must be positive number');%Determine if the input depth is positive
   T=0,Y=0,Z=0,L=0, ts=0, xx=0, zz=0, LL=0; return
end
[m col]   = size(PF);  %得到声速剖面的数据点数
%% For H > H max
HM  = PF(end,1); %Maximum depth of sound velocity profile
dM = H - HM; %Difference between input depth and maximum depth
if dM > 0
   c0 = PF(end,2); %Speed of sound at maximum depth
   a = Grad1(PF(end-5:end,:),1,1);  %%Calculate the gradient of the last ten values of the sound velocity profile
   %a1 = (PF(end,2)-PF(end-1,2))/(PF(end,1)-PF(end-1,1));
   PF(end+1,1:2) = [H c0+a*dM]; %Calculate the speed of sound at the input depth
   if col == 4;  PF(end-1,3) = dM; end
end
[m col]   = size(PF);  %得到声速剖面的数据点数
%% Ray tracing
cos_alfa0 = sin(theta);     %cos(G_theta);          %Height angle cosine

V = [inf,inf,inf];
for i = 1 : m-1
    c0 = PF(i,2);
    if col==2
       z = PF(i+1,1)-PF(i,1);
       a = Grad1(PF(i:i+1,:),1,1); %% for the terminated layer, it should be PF(i-1:i,:).
    else
       z = PF(i,3);  a = PF(i,4);
    end
    
    if i == 1
        RayInf.alfa0 = cos_alfa0;
        RayInf.c0 = c0;
        P00 = RayInf.alfa0/RayInf.c0;    % **********检核**********
    end
    
    cos_alfa00 = cos_alfa0;
    [t1, x1, z1,L1,cos_alfa0,cv] = SingleLayerTracing(cos_alfa0,c0,a,+inf,+inf,z);% ray tracing of a single layer
    LL(i) = L1; ts(i) = t1; xx(i) = x1; zz(i) = z1;
    
    diff(i) = cos_alfa0/cv -  RayInf.alfa0/RayInf.c0;  % ********检核********
    
    
  %最后一层
  if     H < inf       % Regarding the Depth as the cut-off condition
    TotalZ = sum(zz); 
    if TotalZ >= H ; V(3) = H - (TotalZ - zz(i)); end;                      % Calculate the propagation depth of the last layer
  elseif T < inf       % Regarding the time as the cut-off condition
    TotalT = sum(ts); if TotalT >= T;  V(1) = T - (TotalT - ts(i));  end;    % Calculate the travel time of the last layer
  else   Y < inf       % Regarding the Horizontal displacement as the cut-off condition
    TotalX = sum(xx); if TotalX >= Y;  V(2) = Y - (TotalX - xx(i));  end;    % Calculate the Horizontal displacement of the last layer
  end
  %
  if min(V) < inf       % Determine whether the last layer of sound trace calculation is needed
      [t1, x1, z1,L1,cos_alfa1,c1] = SingleLayerTracing(cos_alfa00,c0,a,V(1),V(2),V(3)); % ray tracing of last layer
      LL(i) = L1; ts(i) = t1; xx(i) = x1; zz(i) = z1;
     break;
  end
end

r = exist('cos_alfa1');
if r~=1
    pause
end

RayInf.alfae = cos_alfa1;
RayInf.ce = c1;
T = sum(ts);                          %% Total travel time
Y = sum(xx);                          %% Total horizontal displacement
Z = sum(zz);                          %% Total depth
L = sum(LL);                          %% Total propagation distance
