classdef IGG1 < StrategyRLS
    methods
        function p = Reweight(~,par,V)
            k1 = par(1);
            k2 = par(2);
            if V == 0
               V = V + 0.00001 
            end
            if V > k1
               p = 0;
            elseif V < k2 
               p = 1;
            else
               p = k2 / V;
            end
        end
    end
end