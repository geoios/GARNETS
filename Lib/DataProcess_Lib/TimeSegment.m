function [BlockIdx,MeanSecTime] = TimeSegment(BreakPoint,CutTime,TimeSerial)

BPNum = length(BreakPoint);
Iter = 0;
for i = 1:BPNum - 1
    iSecIdx = BreakPoint(i):BreakPoint(i+1) - 1;
    iSecTime = TimeSerial(iSecIdx); 
    StartTime = iSecTime(1);
    Endtime   = iSecTime(end);
    iSubNum  = ceil((Endtime - StartTime)/CutTime);  
    if iSubNum == 0
        iSubNum = 1;
    end
    for j =1:iSubNum
        Iter = Iter + 1;
        BlockTime = StartTime + CutTime;
        AccordSerial = find(iSecTime >= StartTime & iSecTime < BlockTime);
        
        BlockIdx{Iter,:} = iSecIdx(AccordSerial);
        
%         if ~isempty(find(BlockIdx{Iter,:}==1471))
%             a= 1
%         end
        
        MeanSecTime(Iter,:) = mean(TimeSerial(iSecIdx(AccordSerial)));
        StartTime = BlockTime;
    end
end

end