function vh = GIDW(v,a,h,Hi,q,idxs)

for k = 1 : length(idxs)
    idxk = idxs(k);
    v0   = v(idxk);
    ak   = a(idxk,:);
    dx   = h(idxk) - Hi;
    
   if dx==0; dx = dx + 10^-10; end
   pk(k) = abs(dx)^-q;
   dv = 0;
   for j=1:length(ak)
      dv = dv + ak(j)*dx^j;
   end
      vs(k) = v0 + dv;
end
vh = vs*pk'/sum(pk); 