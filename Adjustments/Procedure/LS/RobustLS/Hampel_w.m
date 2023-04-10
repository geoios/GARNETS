function p=Hampel_w(c,b,a,v)
%% µ¤ÂóÈ¨º¯Êı
V = abs(v);
if V > c
    p = 0;
elseif V > b
    p = a * (c-V)/(c-b) / V;
else
    if V > a
       p = a/V;
    else
       p = 1;
    end
end