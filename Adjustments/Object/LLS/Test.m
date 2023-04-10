clc
clear all
%% test log class
obj = Log();
te = ones(10,1);
 for i =1:length(te)
     obj.WriteIn('i am test','%s');
     obj.WriteIn(te(i),'%12.8f\n');
 end
 
 