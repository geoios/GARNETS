classdef LM < MatAnalysis
    properties
      A
      n
      m
    end
    methods
        function obj = LM(A)
           obj.A = A;
           [obj.n obj.m] = size(A);
        end
        function L = x2L(obj,x)
           % a is one of A rows or A
           L = obj.A * x;
        end
    end
end