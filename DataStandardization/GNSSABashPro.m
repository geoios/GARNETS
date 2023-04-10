function WriteFilePath = GNSSABashPro(ObsFilePath,ConfigFile)
%% ITRF
%% 数据原始转换
%% 数据原始转换
RowIdx = 2;
ColIdx = 3;
HeadCol = 2;
FileTemFun = @GNSSAFileTemplate;
Suffix = '.GNSSA';
WriteFilePath = XlsFile2Rinex(ObsFilePath,RowIdx,ColIdx,HeadCol,Suffix,FileTemFun);

%% 读取观测数据
FileData = ReadNSinex(WriteFilePath);
Data = FileData.Data.SET_LN_MT;
[n,m] = size(Data);

%% 读取配置文件
GlobalPar = ReadNSinex(ConfigFile);

% %% 坐标系统统一 
% % 获取转换参考点信息
RefLatitude  = str2num(GlobalPar.Site_parameter.Latitude0);
RefLongitude = str2num(GlobalPar.Site_parameter.Longitude0);  
RefHeight    = str2num(GlobalPar.Site_parameter.Height0);
% RefBLH  = [RefLatitude/180*pi,RefLongitude/180*pi,RefHeight];
% %% 保持5位 【ToDo】
% type = GlobalPar.Obs_parameter.RefFrame; %% 
% %%
% for i = 1:n
%     Data(i,10:12) = NEU2BLH_RefBLH(RefBLH,[Data(i,11) Data(i,10) Data(i,12)],type);
%     Data(i,17:19) = NEU2BLH_RefBLH(RefBLH,[Data(i,18) Data(i,17) Data(i,19)],type);
% end

HeadContent{1}  = GlobalPar.Obs_parameter.DateUTC;
HeadContent{2}  = GlobalPar.Obs_parameter.RefFrame;
HeadContent{3}  = 'RTK';
HeadContent{4}  = '5';
HeadContent{5}  = GlobalPar.Obs_parameter.Site_name;
HeadContent{6}  = num2str([RefLatitude,RefLongitude,RefHeight]);
HeadContent{7}  = num2str(unique(Data(:,3))');
HeadContent{8}  = num2str(unique(Data(:,1))');
HeadContent{9}  = num2str(unique(Data(:,2))');
HeadContent{10} = num2str(Data(2,9) - Data(1,9));
HeadContent{11} = num2str(GlobalPar.Model_parameter.ANT_to_TD.ATDoffset);
HeadContent{12} = '0.00';
HeadContent{13} = '-1500.000';
HeadContent{14} = 'inf  inf  inf  inf  inf  inf  inf inf  inf';

[HeadItem,HeadItemValue,IdxText,formats] = GNSSAFileTemplate();
RinexFileWrite(WriteFilePath,HeadItem,HeadContent,IdxText,Data,formats);


