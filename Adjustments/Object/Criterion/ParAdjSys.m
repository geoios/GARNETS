classdef ParAdjSys < handle
    properties
       ConfigTree;
% Tree.Obs.L   = L;
% Tree.Obs.Num = n;
% Tree.Obs.idx = [1:n]';
% Tree.Mod.Fun = {@LinFun,A};
% Tree.Mod.Stk = diag(ones(n,1));
% Tree.Adj = {@OWLS_Simple};
    end
    methods
        function obj = ParAdjSys(Tree)
          obj.ConfigTree = Tree;
        end
        function res = Adj(obj)
          [L Jac] = obj.ConfigTree.Mod.Fun{1}(obj.ConfigTree.Mod.Fun{2},)
          obj.Adj{1}(obj.Obs.L)
        end
    end
end