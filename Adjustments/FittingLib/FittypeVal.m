function Val = FittypeVal(ft,P,x)

[m2,n2]=size(P);
for j=1:n2
    str = 'P(1)';
    for k=2:n2
        str = [str ',P(' num2str(k) ')'];
    end
    S = ['Val = ft(' str ',x);'];%
    eval(S);
end