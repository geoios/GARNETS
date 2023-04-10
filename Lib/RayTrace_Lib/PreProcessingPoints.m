function [S,R] = PreProcessingPoints(S,R)

% The z coordinates of points are negtive in the local coordinate system
if S(3) < 0; S(3) = -S(3); end
if R(3) < 0; R(3) = -R(3); end

% when processing the seafloor points, the sound source may be from the bottom
if R(3) < S(3)
    %warndlg('end depth < start depth ! two points have been exchanged');
    R0 = R; R = S; S = R0;
end