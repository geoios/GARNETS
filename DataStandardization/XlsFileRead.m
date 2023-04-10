function [Obs,IdxText,TextData] = XlsFileRead(XlsFile,RowIdx,ColIdx,HeadCol)

[NumData,TextData,Obs] = xlsread(XlsFile);

%% Text file pathname
IdxCell = TextData(HeadCol,RowIdx:end);
IdxText = '$ ';
for i = 1:length(IdxCell)
    if i > ColIdx
        IdxText = [IdxText ' ' IdxCell{i}];
    else
        if i~= ColIdx
            IdxText = [IdxText IdxCell{i} '_'];
        else
            IdxText = [IdxText IdxCell{i} ' : '];
        end
    end
end
Obs = Obs(RowIdx+1:end,HeadCol:end);
end
% Obs2Sinex(TxtFileName,IdxText,Obs);
