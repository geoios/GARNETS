function R2 = RotationMatrixR2_New(h,p,r)
Rh = [cos(h) -sin(h) 0
      sin(h) cos(h)  0
      0      0       1];

Rp = [cos(p) 0 sin(p)        %cos(p) 0 -sin(p) 
      0      1    0
      -sin(p) 0 cos(p)];     %sin(p) 0 cos(p)

Rr = [1    0      0
      0 cos(r) -sin(r)
      0 sin(r) cos(r)];

R2 = Rh * Rp * Rr;
end

