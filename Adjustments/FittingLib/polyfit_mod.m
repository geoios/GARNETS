function [p,RSS1,RSS2, RSS3 ,r,Aug F tt21] = polyfit_mod(x,y,n,Aug,F,RSS1)

if ~isequal(size(x),size(y))
    error('MATLAB:polyfit:XYSizeMismatch',...
          'X and Y vectors must be the same size.')
end

x = x(:);
y = y(:);

% Construct Vandermonde matrix.
V(:,1) = ones(length(x),1,class(x));
for j = 2:n
   V(:,j) = x.*V(:,j-1);
end
%%%%%%%%%%%%сп╢Щ╦д╫Ь%%%%%%%%%%
Aug_V=[V y];
Aug_org=Aug_V'*Aug_V;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RSS3=det(Aug_org)/det(V'*V);


% [Q,R]=qr(Aug_org)
tt1=toc;
if n==2
    [p Aug F RSS1] = Ga_El(Aug_org);

    %[p Aug F RSS1] = Gauss_e(Aug_org,ones(n+1));
    
else
    [p Aug F RSS1] = Ga_El(Aug_org,Aug,F,RSS1) ;
    %[p Aug F RSS1] = Gauss_e(Aug_org,ones(n+1));
end
tt2=toc;
tt21=tt2-tt1;

xx=inv(V'*V)*V'*y;
rr = y - V*xx;
RSS3=rr'*rr;

p=p(1:n);
p=p';
r = y - V*p;
p = p.';          % Polynomial coefficients are row vectors by convention.

% 
RSS2=r'*r;