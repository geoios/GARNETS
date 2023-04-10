function vel = MeanVel(profile)
%% MeanVel(profile)
%% Function: Caculate the weighted average velocity
 %% inputs:
  % + profile  %   sound profile
 %% outputs
  % + MeanVelocity  % mean speed
  
%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%%
%  profile = [0 1500
%             1 1501
%             2 1502
%             3 1503
%             4 1504]       

%% Output: profile = 1500 + (0.5+1.5+2.5+3.5)/4 = 1502
% vel = MeanVel(profile)


h = profile(:,1); %% depth
v = profile(:,2); %% sound speed
dh = zeros(size(h,1)-1,1);
dv = zeros(size(h,1)-1,1);
%% add for test branch
%% new for test branch
for i=1:size(h,1)-1
    dh(i,:) = h(i+1)-h(i);
    dv(i,:) = (v(i+1) + v(i))/2;
end
vel = dh'*dv/(h(end)-h(1));