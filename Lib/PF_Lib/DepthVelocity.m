function [vel index] = DepthVelocity(profile,depth,tag)
%% DepthVelocity(profile,depth,tag)-> velocity at a given depth
 %% inputs:
  % + profile  %  sound profile
  % + depth  %   the given depth
  % + tag    %   (1) ceil - ;(2) flor - 
 %% outputs
  % + Vel  % the velocity at the given depth

  index = SearchInSeq(profile(:,1),depth,tag);
  
  if index==0; index = index + 1;end
  vel = profile(index,2);
