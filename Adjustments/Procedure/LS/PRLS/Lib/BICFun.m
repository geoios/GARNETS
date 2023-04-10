function BIC = BICFun(RSS,n,k) 

BIC=n*log(RSS/n)+log(n)*k + n*(log(pi)+1);

%BIC1 = n*log(RSS)+k*log(n) +n*(log(2*pi)+1 - log(n));

%BIC2 = log(RSS^n*n^k) +n*(log(2*pi)+1 - log(n));
%BIC2 = log(sig^n*(n-k)^n*n^k) +n*(log(2*pi)+1 - log(n));
% sig = RSS/(n-k);
% BIC2 = n*log(sig)+log((n-k)^n*n^k) + n*(log(2*pi)+1 - log(n));
end