classdef RLSAlg < LSAlg
    properties
        RStrategy
    end
    methods
        function obj = RLSAlg(strategy,RStrategy)
            obj = obj@LSAlg(strategy);
            obj.RStrategy   = RStrategy;
        end
        function sig = RobustSig(V)
            sig = 1.483 * median(abs(V));
        end
        function P = Reweight(obj,P,V,sig,par)
            v = abs(V)/sig;
            n = length(v);
            for i = 1:n
                s = obj.RStrategy.Reweight(par,v(i));
                P(i) = P(i)*s;
            end
        end
    end
end
