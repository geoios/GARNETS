function [HeadItem HeadContent IdxText formats] = SVPFileTemplate()    
HeadItem = {
    'DateUTC'
    'Location'
    'UnCal'
};
HeadContent = {
    ''
    ''
    ''
};
formats = {'%f3\t','%f5\t'};
IdxText = '$ SVP :  Depth Speed';