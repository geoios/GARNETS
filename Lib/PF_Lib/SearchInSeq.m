function index = SearchInSeq(h,h0,tag)
%% SearchInSeq(h,h0,tag)
%% Function: **************************
%% inputs:
  % + h         %  Depth
  % + h0       %  Given depth
  % + tag      %  (1) ceil - ;(2) flor - 
%% outputs
  % + index   % ***********
  
%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%%
% h =[0
% 0.500000000000000
% 0.700000000000000
% 0.760000000000000
% 0.870000000000000
% 0.930000000000000
% 1.290000000000000
% 1.600000000000000
% 1.900000000000000
% 2000000000000000];     
% h0=0;
%% Output:index = 1
% index = SearchInSeq(h,h0,tag)
    
n  = length(h);    % data length
index = n;
for i  = 1 : n
    hi = h(i);
    if h0 < hi
       break;
    end
end
if strcmp(tag , 'ceil')  %Judge lable
   index = i-1;
else
   index = i;
end