classdef Koch < StrategySRLS
    methods
        function r = Struct(~,J,q)
            n = size(J,1);
            for i=1:n
                r(i) = (1 - J(i,i))^(q/2);
            end
            rd = mean(r);
            r = r/rd;
        end
    end
end
