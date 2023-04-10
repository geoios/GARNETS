function [y,Sig_y] = polyPredict(Par,D_Par,x,mu)
x = (x - mu(1))/mu(2);
n = length(Par);
a(:,n) = 1;
for j = n-1:-1:1
    a(:,j) = x.*a(:,j+1);
end
y     = a * Par';
D_y   = a * D_Par*a';
Sig_y = sqrt(D_y);
end  