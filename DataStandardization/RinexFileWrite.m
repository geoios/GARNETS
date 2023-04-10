function RinexFileWrite(WriteFile,HeadItem,HeadContent,IdxText,DataContent,formats)

fid = fopen(WriteFile,'w+');

%% 写入头文件
HeadNum = length(HeadItem);
if HeadNum>1 && iscell(HeadItem)
    fprintf(fid,'%s\n','[Header]');    

    for i = 1:HeadNum
        fprintf(fid,'%s\n',[' ',HeadItem{i},' = ',HeadContent{i}]);
    end
    fprintf(fid,'%s\n','');
end
%% 写入数据内容
fprintf(fid,'%s\n','[Data]');
fprintf(fid,'%s\t\n',IdxText);

DataNum = size(DataContent);
for i = 1:DataNum
    iContent = DataContent(i,:);
    for j = 1 : length(iContent)
       fprintf(fid,formats{j},iContent(j));
    end
    fprintf(fid,'%s\n','');
end
fclose(fid);
end