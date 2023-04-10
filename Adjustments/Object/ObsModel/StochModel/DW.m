classdef DW < EW & MatAnalysis
    methods
        function obj = DW(varargin)
           obj.P   = varargin{1};
           if nargin == 2
              obj.sig = varargin{2};
              obj.D = obj.pinv(obj.P) * obj.sig^2;
           end
        end
    end
end