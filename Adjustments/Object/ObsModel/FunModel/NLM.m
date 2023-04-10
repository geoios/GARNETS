classdef NLM < LM & NLAnalysis
    properties
       % A contains all knowns including x
%        A
%        n
%        m

       XIdx
       AIdx
       fxs
       Jxs
       Hxs
    end
    methods
        %abc = NLM([1 2],'fx = x(3)*x(1) + x(4)*x(2)',fax,x,a)
        function obj = NLM(eq,fx,x,a,XIdx,A)
           obj    = obj@LM(A);  %% the nonlinear fun fame
           obj    = obj@NLAnalysis(eq,fx,[x a]);  %% the nonlinear fun fame
           
           obj.XIdx = XIdx;
           obj.AIdx =  setdiff([1 : length(obj.x)],obj.XIdx);
           
           for i=1:obj.n
              obj.fxs{i}  = obj.F(obj.fx,obj.x(obj.AIdx),obj.A(i,:));
              obj.Jxs{i}  = obj.Jacobi(obj.fxs{i},obj.x(obj.XIdx));
              obj.Hxs{i}  = obj.Jacobi(obj.Jxs{i},obj.x(obj.XIdx));
           end
        end
        function L = x2L(obj,x0)
           for i = 1:obj.n
               L(i,:) = obj.F(obj.fxs{i},obj.x(obj.XIdx),x0);
           end
        end
        function J = x2J(obj,x0)
           for i = 1:obj.n
               J(i,:) = obj.F(obj.Jxs{i},obj.x(obj.XIdx),x0);
           end
        end
        function H = x2H(obj,x0)
           for i = 1:obj.n
               H(i,:,:) = obj.F(obj.Hxs{i},obj.x(obj.XIdx),x0);
           end
        end
    end
end