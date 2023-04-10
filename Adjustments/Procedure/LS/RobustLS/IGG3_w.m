function p=IGG3_w(k1,k2,v)
%% IGG3È¨º¯Êý
V = abs(v);
if V > k1+0.0000001
      p = 0;
   elseif V < k2
      p = 1;
else
      di=(k1-V)/(k1-k2);
      p = k2 / V * di^2;
end