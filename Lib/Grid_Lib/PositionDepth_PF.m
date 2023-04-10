function  PFRow = PositionDepth_PF(PF,H)
DataNum = size(PF,1);

for i = 1 : DataNum
    z = PF(i,1);
    if z >= H
        PFRow = i;
        break
    end
end

end