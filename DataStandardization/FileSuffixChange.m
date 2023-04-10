function [NewFileName OldFilePath OldFileName] = FileSuffixChange(FilePath,Suffix)
[OldFilePath OldFileName ext] = fileparts(FilePath); 
NewFileName = [OldFileName Suffix];
end