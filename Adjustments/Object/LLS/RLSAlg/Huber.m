classdef Huber < StrategyRLS
    methods
        function p = Reweight(~,k1,v)
            %% Huber È¨º¯Êı
            V = abs(v);
            if V > k1
               p = k1/V;
            else
               p = 1;
            end
       end
    end
end