% 读取配置文件并返回全局变量（GlobalPar）
%% ReadSeafloorNetSolution-->Seafloor network Solution exchange format
function GlobalPar = ReadNSinex(StandardFile) 

% 读取制定的配置文件
fid = fopen(StandardFile);
GlobalPar.FileName = StandardFile;
StorageName = 'GlobalPar.';
DataFlag =  0;
while ~feof(fid)
    tline = fgetl(fid);   % 读取每行数据 
    if strfind(tline,'[')
        ModelName = StandareStr(tline);
        ModelName = [StorageName ModelName,'.'];
        while 1
            tline = fgetl(fid);   % 读取每行数据
            % 行内容为空时跳出模块读取
            if isempty(tline)     
                break
            end
            if tline == -1
                break
            else
                StrInf = split(tline,' = ');
            end
            % 行内容为':'时重新进行分割
            if length(StrInf) == 1     
                StrInf  = split(tline,' : ');
                VarName = StrInf{1};
                VarName = StandareStr(VarName);
                  if  StrInf{1}(1)  == '$'  % $ : Data      %% 枝干
                                            % # : Struct 
                      DataFlag = 1;
                      Jumps = 1;            % 准备跳行
                      Data = [];
                      DataFieldStr = [ModelName StandareStr( StrInf{1}(3:end) ) ' = Data;'];
                  elseif StrInf{1}(1)  == '#'  %% 枝干
                      DataFlag = 2;
                      StructFieldStr = [ModelName StandareStr( StrInf{1}(3:end) )];
%                   else
%                       DataFlag = 3;  %% 叶子
%                       StructFieldStr = [StructFieldStr '.' StandareStr( StrInf{1}(2:end) )];
                  end
                if DataFlag == 2
                  tline = fgetl(fid);
                  StrInf = split(tline,' = ');
                elseif  DataFlag == 1
                  if Jumps
                     tline = fgetl(fid);
                     Jumps = 0;
                  end
                  StrInf = split(tline,' = ');
                end
            else
                if DataFlag ~= 2 && DataFlag ~= 1
                   StructFieldStr = [ModelName StandareStr( StrInf{1}(2:end) )];
                end
            end
            if DataFlag == 1
                VarName = StrInf{1};
                Data = [Data; str2num(VarName)];
                eval(DataFieldStr);
            else
                VarName = StrInf{1};
                VarName = StandareStr(VarName);
                VarInf  = StrInf{2};
    %             VarInf  = strrep(VarInf,'-',' -');
                %% 日期中存在 -，因此，需要特殊处理
                IsMinus = strfind(VarInf,' -');
                %%
                [StrPer,NumPer] = StrAnalisy(VarInf);
                if NumPer == 1  & IsMinus    %
                    VarInf = str2num(VarInf);
                end
                if DataFlag == 2  %% # 下结构体数据
                    eval([StructFieldStr '.' VarName  '= VarInf;']);
                else              %% [ 下的直接数据
                    eval([StructFieldStr  '= VarInf;']);
                end
            end
        end
    end
end
% eval(['GlobalPar' ,'=' , StorageName ';']);
fclose(fid);