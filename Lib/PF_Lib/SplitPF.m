function SubProfile = SplitPF(profile,StartDepth,EndDepth)
%% SplitProfile(profile,StartDepth,EndDepth)
%% Function: take a sub profile by the given two depths
%% inputs:
  % + profile     %   sound profile
  % + StartDepth  %   start depth
  % + EndDepth    %   end depth
%% outputs
  % + SubProfile  % sub profile
  
%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%%
%  profile = [0 1500
%                     1 1501
%                     2 1502
%                     3 1503
%                     4 1504]       
% StartDepth = 0.5; StartDepth = 3.5
%% Output:SubProfile = [0  1500.5
%%                     0.5 1501
%%                     1.5 1502
%%                     2.5 1503
%%                     3   1503.5]
% SubProfile = SplitProfile(profile,StartDepth,EndDepth)

if StartDepth < 0 || EndDepth < 0
   warndlg('input depths must be positive number');
   SubProfile = [];
   return
end

[vel StartIndex] = DepthVelocity(profile,StartDepth,'ceil'); % fetch a start point
[vel EndIndex]   = DepthVelocity(profile,EndDepth,'flor');   % fetch a end point
SubProfile       = profile(StartIndex:EndIndex,:);           % fetch the sub profile

h0 = SubProfile(1,1);                                        % the starting depth
dh = StartDepth - h0;
if dh > 0
   a = Grad1(SubProfile(1:2,:),1,1);                           % caculate the sound velocity gradient
   SubProfile(1,2) = SubProfile(1,2) + a * dh;                 % interpolation for the 
   SubProfile(1,1) = StartDepth; 
end
% SubProfile(1,4) = a;
SubProfile(1,3) = SubProfile(2,1) - SubProfile(1,1); 
h0 = SubProfile(end,1);                                         % the starting depth
dh = EndDepth - h0;
if dh <= 0
   a = Grad1(SubProfile(end-1:end,:),1,1);                      % caculate the sound velocity gradient
   SubProfile(end,2) = SubProfile(end,2) + a * dh;              % interpolation for the
   SubProfile(end,1) = EndDepth;
else
   a = Grad1(SubProfile(end-100:end,:),1,1);                      % caculate the sound velocity gradient
   SubProfile(end+1,2) = SubProfile(end,2) + a * dh;              % interpolation for the
   SubProfile(end,1) = EndDepth;
end
SubProfile(:,1) = SubProfile(:,1) - StartDepth;
end



