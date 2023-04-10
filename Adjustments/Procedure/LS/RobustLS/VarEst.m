function sig = VarEst(V,t,type1)

%%% V is the standardized residual, V = V .* sqrt(P)
if nargin == 3
    if strcmp(type1,'Var')
       sig = sqrt(V'*V/t);
    end
    if strcmp(type1,'Med')
      sig = 1.483 * median(abs(V));
    end
    
else
    sig = sqrt(var(V));
end