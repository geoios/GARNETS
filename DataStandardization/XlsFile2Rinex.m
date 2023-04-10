function WriteFilePath = XlsFile2Rinex(iObsFilePath,RowIdx,ColIdx,HeadCol,Suffix,FileTemFun)
%% 标准数据转换
[Obs IdxText] = XlsFileRead(iObsFilePath,RowIdx,ColIdx,HeadCol);

%% 将xls文件内容，存储为标准数据格式
% 定义文件名
[NewFileName,OldFilePath,OldFileName] = FileSuffixChange(iObsFilePath,Suffix);
%%创建文件路径
status = mkdir([OldFilePath OldFileName]);
if ~status
   display('创建文件夹失败')
end
%%创建文件
WriteFilePath = [OldFilePath OldFileName '\' NewFileName];
%%写入文件
Data = Cell2Data(Obs);
% 修改 N E 顺序
DataCol = size(Data,2);
if DataCol == 22
    Data(:,10:11) = Data(:,[11,10]);
    Data(:,17:18) = Data(:,[18,17]);
end

[HeadItem HeadContent IdxText1 formats] = FileTemFun();
%% 可选择使用模板值，即idxText1， 或者继承原文件值
RinexFileWrite(WriteFilePath,HeadItem,HeadContent,IdxText,Data,formats);
end