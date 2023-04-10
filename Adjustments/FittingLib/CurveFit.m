function [f res] = CurveFit(S,Par)

if strcmp(Par.tag,'ploy')
    n   = Par.n;
    w   = Par.w;
    p   = Wpolyfit(S(:,1),S(:,2),n,w);
    f   = polyval(p,S(:,1));
    res = f - S(:,2);
end