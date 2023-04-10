function index = SearchDeSeq(h,h0,tag)
%% SearchDeSeq(h,h0,tag)
%% Function: return the index around the location of h(i)>h0>h(j) for a decreased sequence 
%% inputs:
  % + h        %  Depth
  % + h0       %  Given depth
  % + tag      %  (1) ceil - ;(2) flor - 
%% outputs
  % + index    % index of the position for h(i)>h0>h(j)

%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%%
% h =[10;9;8];     
% h0 = 8.5;
%% Output:index = 2  % 
% index = SearchDeSeq(h,h0,'ceil')
%% Output:index = 3  % 
% index = SearchDeSeq(h,h0,'flor')
  
  n = length(h);          %Data length
  index = n;
  for i = 1 : n
      hi = h(i);
      if h0 > hi
          break;
      end
  end
  if strcmp(tag , 'ceil')   %Judge lable 
     index = i-1;
  else
     index = i;
  end