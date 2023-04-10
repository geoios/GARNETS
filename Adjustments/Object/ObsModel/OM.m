classdef OM < Log & MatAnalysis & ErrorAnalysis
    properties
       L
       FM
       SM
    end
    methods
        function obj = OM(FM,SM,L)
            obj.FM = FM;
            obj.SM = SM;
            obj.L  = L;
        end
        function [te Les] = Error(obj,x)
          Les = obj.FM.x2L(x);
          te  = obj.L - Les;
        end
        
        function [FM SM L LMat] = IWM2EWM(obj)
              %% independent to equal weight model
                LMat  = sqrt(obj.SM.P);
                for i = 1:obj.FM.n
                    A(i,:)  = obj.A(i,:) * LMat(i);
                    L(i)    = obj.L(i)   * LMat(i);
                end
                
            FM   = LM(A);
            n    = obj.FM.n;
            SM   = EW(ones(n,1));
           %% [ToDo sig transform]
        end
        function [FM SM L LMat] = DWM2EWM(obj)
            LMat = obj.chol(obj.SM.P);
            A    = LMat * obj.A;
            L    = LMat * obj.L;
            
            FM   = LM(A);
            n    = obj.FM.n;
            SM   = EW(ones(n,1));
           %% [ToDo sig transform]
        end
        function [FM SM L S] = DWM2IWM(obj)
            [S P] = eig(obj.P);
            A = S * obj.FM.A;
            L = S * obj.FM.L;
            
            FM   = LM(A);
            SM   = IW(P);
        end
     end
end
