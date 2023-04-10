classdef Krarup < StrategyRLS
    methods
        function p = Reweight(~,par,v)
            %% µ¤ÂóÈ¨º¯Êı
            k1 = par(1);
            a  = par(2);
            c  = par(3);
            if V < k1
                p = 1;
            else
                p = a*exp(-c*V^2); 
            end
       end
    end
end