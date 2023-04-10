function [ObsData,StnObsData] = StandardData1(Data)

ObsData    = Data.Data.SET_LN_MT;
FilePath   = Data.FileName;
AllObsData = Data.Data.SET_LN_MT;
S_Inf = str2num(Data.Header.Sessions);  
L_Inf = str2num(Data.Header.Lines);  
M_Inf = str2num(Data.Header.Site_No);  

SesNum = length(S_Inf);
SPNoNum   = length(M_Inf);

for i = 1:SPNoNum
    idxExtra = [S_Inf',inf*ones(SesNum,1),M_Inf(i)*ones(SesNum,1)];
    Suffix = ['_S_' num2str(idxExtra(:,1)') '_L_' num2str(idxExtra(:,2)') '_M_' num2str(idxExtra(:,3)') '.GNSSA'];
    Suffix = strrep(Suffix,' ','');
    idxs = MatchIdx(AllObsData(:,1:3),idxExtra);
    SubData = AllObsData(idxs,:);
    
    %% 需求数据标准格式生成
    [NewFileName, StorageFilePath,OldFileName] = FileSuffixChange(FilePath,Suffix);
    iFilePath = [StorageFilePath,'\',NewFileName];
    [~ ,~ ,IdxText ,formats] = GNSSAFileTemplate();
    [HeadItem,HeadContent] = Header2Cells(Data.Header);
    RinexFileWrite(iFilePath,HeadItem,HeadContent,IdxText,SubData,formats);
    
    iObsData = ReadNSinex(iFilePath);
    iObsData = iObsData.Data.SET_LN_MT;
    StnObsData{i} = iObsData;
    delete(iFilePath)
end

end