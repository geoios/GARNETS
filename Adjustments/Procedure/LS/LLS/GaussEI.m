function x = GaussEI(A0,L,P)
%% GaussEI(A0,L,P)
%% Function:use the Guass elimination to caculate parameter estimation
%% inputs:
 % + A0 % the design matrix
 % + L  % observations
 % + P  % observation weight matrix
%% outputs:
 % + x   %   parameter estimation
%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%%
 % nargin == 2
 % A0=[2 6 -4;1 4 -5;6 -1 18];
 % L=[4;3;2];
 % else
 % A=[2 6 -4;1 4 -5;6 -1 18];
 % L=[4;3;2]; 
 % P=eye(3);
 %% Outputs:
 % x=[1.3333;0;-0.3333]
% x = GaussEI(A0,L,P)
if nargin == 2; [A,r] = NormEqLS(A0,L);     %If the number of inputs is two,can use the NormEqLS,otherwise can use NormEqWLS
else          ; [A,r] = NormEqWLS(A0,L,P);  end

[n,n] = size(A); %determine the initial values of each parameter
f   = 1; 
s   = 0;
dd  = 1;
sum = 0;
for j=1:n-1      %After elimination,the equations are transformed into upper triangular equations
    for i=1+s:n-1
        L=A(i+1,j)/A(j,j);
        A(i+1,:)=A(i+1,:)-L*A(j,:);
        r(i+1)=r(i+1)-L*r(j);
        F(f)=L;
        f=f+1;
    end
    s=s+1;
end

%execute the reverse process
x(n) = r(n)/A(n,n);

for i=n-1:-1:1
    sum=0;
    for j=i+1:n 
        sum=sum+A(i,j)*x(j);
    end
    x(i)=(1/A(i,i))*(r(i)-sum);
end