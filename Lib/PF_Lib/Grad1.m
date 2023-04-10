function [a,f0] = Grad1(S,pc,ord)
%% ProfileGrad(PF)->Produce sound gradient
%%For generalized IDW method
 %+pc, central point index;
 %+S = [+ + + pc + + +];
 %+ord, order
[n,m] = size(S);
t = S(:,1);
f = S(:,2);

f0 = f(pc);
t0 = t(pc);
k  = 0;
for i=1:n
    if i~= pc
       k = k + 1;
       dt(k) = t(i) - t0;
       df(k,:) = f(i) - f0;
       for j=1:ord
           A(k,j) = dt(k)^j;
           %A(k,j) = dt(k)^j/factorial(j);
       end
    end
end
a = LS(A,df);

