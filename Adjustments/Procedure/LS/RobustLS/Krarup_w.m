function p = Krarup_w(k1,v,a,c)
%% µ¤ÂóÈ¨º¯Êı
if V < k1
    p = 1;
else
    p = a*exp(-c*V^2); 
end