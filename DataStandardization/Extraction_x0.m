function x0s = Extraction_x0(GlobalPar)
% 提取坐标初值
X0Par = GlobalPar.Model_parameter.MT_Pos;
StrName = fieldnames(X0Par);
CellNum = size(StrName,1);
X0Inf = struct2cell(X0Par);
Loop = 0;
for i = 1:CellNum
    iCell = StrName{i};
    if contains(iCell,'M')
        SPNo = iCell(2:3);
        Loop = Loop + 1;
        x0s(Loop,:) = X0Inf{i}(1:3);
    end
end
end