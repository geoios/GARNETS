classdef LSAlg < handle
    properties
        Strategy
    end
    methods
        function obj = LSAlg(strategy)
            obj.Strategy = strategy;
        end
        function [Nx,U] = NormEq(obj,varargin)
            [Nx,U] = obj.Strategy.NormEq(varargin);
        end
        function [Nxs,Us] = NormEqs(obj,varargin)
            [Nxs,Us] = obj.Strategy.NormEqs(varargin);
        end
        function [Qx,J,Qv] = LSGeometry(obj,varargin)
            [Qx,J,Qv] = obj.Strategy.LSGeometry(obj,varargin);
        end
        function [x,Qx] = NormEqSolve(obj,Nx,U)
            [x,Qx] = obj.Strategy.NormEqSolve(Nx,U);
        end
        function [Lv,V,RSS,sig] = RSS(obj,varargin)
            [Lv,V,RSS,sig] = obj.Strategy.RSS(varargin);
        end
        function RSS = RSSGuass(obj,Nx,U,R)
            RSS = obj.Strategy.RSSGuass(Nx,U,R);
        end
        function x = NormEqSolveGauss(obj,A,r)
            x = obj.Strategy.NormEqSolveGauss(A,r);
        end
        function [x RSS A F] = RecursiveGuass(N,U,R,RSS,Aug,F)
            [x RSS A F] = obj.Strategy.RecursiveGuass(N,U,R,RSS,Aug,F);
        end
    end
end