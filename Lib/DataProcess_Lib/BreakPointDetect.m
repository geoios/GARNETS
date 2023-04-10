function BP = BreakPointDetect(S,threshold)

n = length(S);
k = 1;
BP(k) = 1;
for i = 1:n-1
    dT = round(S(i+1) - S(i));
    if abs(dT) > threshold
       k = k + 1;
       BP(k) = i + 1;
    end
end
BP(k+1) = length(S);