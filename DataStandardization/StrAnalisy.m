function [StrPercentage,NumPercentage] = StrAnalisy(Str)
Str = strrep(Str,' ','');  % È¥³ý×Ö·û´®µÄ¿Õ¸ñ
StrNum = length(Str);      % ×Ö·û´®³¤¶È
NumChar   = '0123456789.e-+ ';

Nums = 0;
Strs = 0;
for i = 1:StrNum
    iStr = Str(i);
    ContainIdx = strfind(NumChar,iStr);
    
    if ~ isempty(ContainIdx)
        Nums = Nums + 1;
    else
        Strs = Strs + 1;      
    end   
end
StrPercentage = Strs / StrNum;
NumPercentage = Nums / StrNum;
end