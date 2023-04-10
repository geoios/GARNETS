function Str = StandareStr(Str)
Mark1 = ['.','+','(',')','[',']','{','}', ''''];
MarkNum = length(Mark1);

Loop = 0;
ContainIdx = [];
for i = 1:MarkNum
    iMark = Mark1(i);
    SearchContain = strfind(Str,iMark);
    if ~isempty(SearchContain)
        Loop = Loop + 1;
        ContainIdx = [ContainIdx;SearchContain];
    end
end
Str(ContainIdx) = []; 

Mark2 = '-';
Str = strrep(Str,Mark2,'_');
end