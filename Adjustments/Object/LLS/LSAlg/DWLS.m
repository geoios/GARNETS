classdef DWLS < IWLS
    methods
        function [Nx U R]   = NormEq(~,varargin)
            A = varargin{1};
            L = varargin{2};
            P = varargin{3}; 
            Nx = A'*P*A;
            U  = A'*P*L;
            R  = L'*P*L; 
        end
        function [Nxs Us] = NormEqs(~,varargin)
            % [ToDo]
            A = varargin{1};
            L = varargin{2};
            P = varargin{3}; 
            n = size(A,1);
            for i=1:n
                ai = A(i,:);
                Nxs{i} = ai'*ps(i)*ai;
                Us{i}  = ai'*ps(i)*L(i);
            end
        end
    end
end