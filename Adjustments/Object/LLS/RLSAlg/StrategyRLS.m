classdef StrategyRLS < handle
    methods(Abstract)
        Reweight();
    end
end