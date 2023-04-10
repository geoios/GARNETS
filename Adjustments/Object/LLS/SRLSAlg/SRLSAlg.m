classdef SRLSAlg < RLSAlg
    properties
        SStrategy
    end
    methods
        function obj = SRLSAlg(strategy,RStrategy,SStrategy)
            obj = obj@RLSAlg(strategy,RStrategy);
            obj.SStrategy   = SStrategy;
        end
        function r = Struct(obj,J,par)
            r = obj.SStrategy.Struct(J,par);
        end
        function par = Restructure(~,par,ri)
           %% 
            par = ri * par;
        end
        function P = Reweight(obj,P,V,sig,par)
            v = abs(V)/sig;
            n = length(v);
            for i = 1:n
                par = obj.Restructure(par, r(i));
                s   = obj.RStrategy.Reweight(par,v(i));
                P(i) = P(i)*s;
            end
        end
    end
end
