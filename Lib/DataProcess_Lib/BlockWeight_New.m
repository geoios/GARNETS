function  Mu = BlockWeight_New(BlockTime,Mu2,WeightType)
%% ++ Input
% BlockTime; 分段时间差
% Mu2:系数
% WeightType:权定义类型
%% ++ Output
% Mu; 时间分段权
BlockNum = length(BlockTime) + 1;
if WeightType == 1
    Mu1 = ones(BlockNum-1,1);

else
    if WeightType == 2       % 权分配（时间差）
        Weight = BlockTime./sum(BlockTime);
        Mu1    = repelem(Mu1,3);
    elseif WeightType == 3   % 权分配（时间差倒数）
        Weight = 1./BlockTime;
        Mu1    = (Weight/sum(Weight));
    elseif WeightType == 4   % 权分配（时间差倒数平方）
        Weight = (1./BlockTime).^2;
        Mu1    = (Weight/sum(Weight));
    end
    Mu1 = Mu1 .* (Mu2 * BlockNum);
end

Mu = Mu1;

end 