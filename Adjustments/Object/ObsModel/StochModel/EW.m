classdef EW < MatAnalysis
    properties
      P
      sig
      D
    end
    methods
        function obj = EW(varargin)
           obj.P   = varargin{1};
           if nargin == 2
              obj.sig = varargin{2};
          %% p = ones(n,1)
              obj.D = obj.P.^-1 * obj.sig^2;
           end
        end
    end
end