classdef IGG3 < StrategyRLS
    methods
        function p = Reweight(~,par,v)
            k1 = par(1);
            k2 = par(2);
            %% IGG3È¨º¯Êý
            V = abs(v);
            if V > k1+0.0000001
                  p = 0;
            elseif V < k2
                  p = 1;
            else  
                  di=(k1-V)/(k1-k2);
                  p = k2 / V * di^2;
            end
       end
    end
end