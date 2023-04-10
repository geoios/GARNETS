function [Items,HeadContent] = Header2Cells(Header)

Items = fieldnames(Header);
DataNum = size(Items,1);

for i = 1:DataNum
    iHeadContent = getfield(Header,Items{i,1});    
    if ~ischar(iHeadContent)
        iHeadContent = num2str(iHeadContent);
    end
    HeadContent{i} = iHeadContent; 
end

end
% HeadContent{1}  = IniStruct.Obs_parameter.DateUTC;
% HeadContent{2}  = IniStruct.Obs_parameter.RefFrame;
% HeadContent{3}  = 'RTK';
% HeadContent{4}  = '5';
% HeadContent{5}  = IniStruct.Obs_parameter.Site_name;
% HeadContent{6}  = num2str([RefLatitude,RefLongitude,RefHeight]);
% HeadContent{7}  = num2str(unique(Data(:,3))');
% HeadContent{8}  = num2str(unique(Data(:,1))');
% HeadContent{9}  = num2str(unique(Data(:,2))');
% HeadContent{10} = num2str(Data(2,9) - Data(1,9));
% HeadContent{11} = num2str(IniStruct.Model_parameter.ANT_to_TD.ATDoffset);
% HeadContent{12} = '0.00';



