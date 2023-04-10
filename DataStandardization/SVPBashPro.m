function WriteFilePath = SVPBashPro(SVPFilePath,ConfigFile)

RowIdx  = 1;
ColIdx  = 1;
HeadCol = 1;
FileTemFun = @SVPFileTemplate;
Suffix = '.SVP';
WriteFilePath = XlsFile2Rinex(SVPFilePath,RowIdx,ColIdx,HeadCol,Suffix,FileTemFun);

% 读取观测数据
FileData = ReadNSinex(WriteFilePath);
Data = FileData.Data.depth;

ConfigPar = ReadNSinex(ConfigFile);

RefLatitude  = str2num(ConfigPar.Site_parameter.Latitude0);
RefLongitude = str2num(ConfigPar.Site_parameter.Longitude0);  
RefHeight    = str2num(ConfigPar.Site_parameter.Height0);

HeadContent{1} = ConfigPar.Obs_parameter.DateUTC;
HeadContent{2} = num2str([RefLatitude,RefLongitude,RefHeight]);
HeadContent{3} = '0.00';

[HeadItem,HeadItemValue,IdxText,formats] = SVPFileTemplate();
RinexFileWrite(WriteFilePath,HeadItem,HeadContent,IdxText,Data,formats);

end