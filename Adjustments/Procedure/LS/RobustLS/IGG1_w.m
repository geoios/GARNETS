function p = IGG1_w(k1,k2,v)
%% IGG1È¨º¯Êý

V = abs(v);
if V == 0
   V = V + 0.00001 
end
if V > k1
   p = 0;
elseif V < k2 
   p = 1;
else
   p = k2 / V;
end