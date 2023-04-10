classdef IGG8 < StrategyRLS
    methods
        function p = Reweight(~,par,v)
            %% IGG8权函数,新提出
            k1 = par(1);
            k2 = par(2);
            c  = par(3);
            V = abs(v);
            if V > k1
               p = 0;
            elseif V < k2 
               p = 1;
            else
               p = c^(k2-V); 
          end
       end
    end
end