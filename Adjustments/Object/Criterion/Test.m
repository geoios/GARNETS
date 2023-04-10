clc
clear all

FM = LM([1 2;3 4;5 6])
SM = EW(ones(3,1))
OM = OM(FM,SM,ones(3,1))

[te Les] = OM.Error([1;2])

Criterion(OM,[1;2],2)