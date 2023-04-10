classdef EWLS < StrategyLS
    methods
        function [Nx U R]  = NormEq(~, varargin)
            A = varargin{1};
            L = varargin{2};
            Nx = A'*A;
            U  = A'*L;
            R  = L'*L;
        end
        function [Nxs Us]  = NormEqs(~, varargin)
            A = varargin{1};
            L = varargin{2};
            n = size(A,1);
            for i=1:n
                ai = A(i,:);
                Nxs{i} = ai'*ai;
                Us{i}  = ai'*L(i);
            end
        end
        
        function [Qx,J,Qv] = LSGeometry(~,varargin)
            Nx = varargin{1};
            A  = varargin{2};
            Qx = inv(Nx);
            J  = A * Qx * A';
            Qv = eye(n) - J; 
        end
        
        function [x,Qx]    = NormEqSolve(~,Nx,U)        
           [n,m] = size(A);
           Qx    = inv(Nx);
           x     = Qx*U;
        end
        function [Lv,V,RSS,sig] = RSS(~,varargin)
           A  = varargin{1};
           L  = varargin{2};
           x  = varargin{3};
           Lv    = A * x;     
           V     = L - Lv;
           RSS   = V'*V; 
           sig   = sqrt(RSS/(n-m));
        end
        
        function RSS = RSSGuass(~,Nx,U,R)
            Aug = [Nx U; U' R];
            n   = size(Aug,1);
            s   = 0;
            for j = 1:n-1
                for i = 1+s:n-1
                    L = Aug(i+1,j)/Aug(j,j);
                    Aug(i+1,:) = Aug(i+1,:)-L*Aug(j,:);
                end
               s = s+1;
            end
            RSS = Aug(n,n);
        end
        function x = NormEqSolveGauss(~,A,r)        
            %% A = Nx, r = U
            [n,n] = size(A);
            f   = 1; 
            s   = 0;
            dd  = 1;
            sum = 0;
            for j=1:n-1
                for i = 1+s:n-1
                    L = A(i+1,j)/A(j,j);
                    A(i+1,:) = A(i+1,:) - L*A(j,:);
                    r(i+1) = r(i+1) - L*r(j);
                    F(f) = L;
                    f = f+1;
                end
                s = s+1;
            end

            %回代
            x(n) = r(n)/A(n,n);
            for i = n-1:-1:1
                sum = 0;
                for j = i+1:n 
                    sum = sum+A(i,j)*x(j);
                end
                x(i) = (1/A(i,i))*(r(i)-sum);
            end
        end
        
        function [x RSS A F] = RecursiveGuass(~,N,U,R,RSS,Aug,F)

            A = [N U; U' R];
            n = size(A,1);
            F1 = [];
            F2 = 0;

            if nargin == 3  %% 
                s=0;
                for j=1:n-1
                    %q(j)=det(A(j+1:n-1,j+1:n-1))
                    for i=1+s:n-1
                        L=A(i+1,j)/A(j,j);
                        A(i+1,:)=A(i+1,:)-L*A(j,:);
                        F(j,i)=L;
                    end
                    s=s+1;
                end
                x(n-1)=A(n-1,n)/A(n-1,n-1);
                for i=n-2:-1:1
                    sum=0;
                    for j=i+1:(n-1) 
                        sum=sum+A(i,j)*x(j);  
                    end
                    x(i)=(1/A(i,i))*(A(i,n)-sum);
                end
            else
              %% for model selection
                P=[A(n-1,1:n-2) A(n-1,n)];
                Q=P';
                s=0;
                k=1;
                for j=1:n-2
                    for i=1+s:n-2
                        Q(i+1)=Q(i+1)-F(j,i)*Q(j);
                        k=k+1;
                    end
                    s=s+1;
                end

                Aug_new=[Aug(1:n-2,1:n-2) Q(1:n-2) Aug(1:n-2,n-1); ...
                A(n-1,:);...
                Aug(n-1,1:n-2) Q(n-1) Aug(n-1,n-1)];

                A=Aug_new;
                for j=1:n-2
                        L=A(n-1,j)/A(j,j);
                        A(n-1,:)=A(n-1,:)-L*A(j,:);
                        F1(j)=L;
                end

            %%%%%%%%%更新F矩阵
            F2=A(n,n-1)/A(n-1,n-1);

            A(n,n)=A(n,n)-F2*A(n-1,n);

            F=[F(:,1:n-3) F1' F(:,n-2);zeros(1,n-2) F2];

                %回代
                x(n-1)=A(n-1,n)/A(n-1,n-1);
                %
                for i=n-2:-1:1
                    sum=0;
                    for j=i+1:(n-1) 
                        sum=sum+A(i,j)*x(j);
                        %
                    end
                    x(i)=(1/A(i,i))*(A(i,n)-sum);
                    %
                end
            end
            RSS=abs(A(n,n));
            x = x';
        end
    end
end