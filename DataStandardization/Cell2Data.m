function Data = Cell2Data(CellData)

[n,m] = size(CellData);
for i = 1 : n
    
    for j = 1 : m
       aij = CellData{i,j};
       if ischar(aij)
           idx = isstrprop(aij,'digit');
           digit = aij(idx);
           digit = str2num(digit);
           Data(i,j) = digit;
       else
           Data(i,j) = CellData{i,j};
       end
    end
end
end