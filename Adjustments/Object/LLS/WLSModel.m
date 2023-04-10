classdef WLSModel < WObsModel & LSAlg
    properties
      Nx
      U
      Nxs
      Us
      x
      Qx
      J
      Qv
      Lv
      V
      RSS
      sig
    end
    methods
       function obj = WLSModel(A0,L0,P0,strategy)
           obj = obj@WObsModel(A0,L0,P0);
           obj = obj@LSAlg(strategy);
       end
       function NormEq1(obj)
           [obj.Nx,obj.U] = obj.NormEq(obj.A, obj.L);
       end
       function OLS(obj)        
           obj.Qx = inv(obj.Nx);     
           obj.x  = obj.Qx*obj.U;          
           obj.J  = obj.A * obj.Qx * obj.A';          
           obj.Qv = eye(obj.n) - obj.J;      
           obj.Lv = obj.A * obj.x;       
           obj.V  = obj.L - obj.Lv;       
           obj.RSS = obj.V'*obj.V;  
           obj.sig = sqrt(obj.RSS/(obj.n-obj.m));
       end
    end
end