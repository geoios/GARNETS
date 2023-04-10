classdef IWLS < EWLS
    methods
        function [Nxs Us Rs] = NormEqs(~,varargin)
            A = varargin{1};
            L = varargin{2};
            P = varargin{3}; 
            [n m] = size(A);
            for i=1:n
                ai = A(i,:);
                Nxs{i} = ai'*P(i)*ai;
                Us{i}  = ai'*P(i)*L(i);
                Rs{i}  = L(i)*P(i)*L(i);
            end
        end
        function [Nx U R]   = NormEq(obj,varargin)
            A = varargin{1};
            L = varargin{2};
            P = varargin{3}; 
            [n m] = size(A);
            [Nxs Us] = obj.NormEqs(A,L,P);
            Nx = Nxs{1};
            U  = Us{1};
            R  = Rs{1}
            for i=2:n
              Nx = Nx +  Nxs{i};
              U  = U  +  Us{i};
              R  = R  +  Rs{i};
            end
        end
    end
end