classdef StrategyLS < handle
    methods(Abstract)
        NormEq();
        NormEqs();
        LSGeometry();
        NormEqSolve();
        RSS();
        RSSGuass();
        NormEqSolveGauss();
        RecursiveGuass();
    end
end