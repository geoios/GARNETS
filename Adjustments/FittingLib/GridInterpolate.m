function Error = GridInterpolate(Data,H,thet,type)

%[ToDo:adjusting window size]
%% read the create grid file
data = Data.Obs;
%IdxH1 = SearchInSeq(Data.StartH : Data.StepH : Data.EndH, H,'ceil')
% for enhence the search efficiency

IdxH1 = ceil((H - Data.StartH)/Data.StepH);

IdxH2 = IdxH1 + 1;

Idx1 = (IdxH1-1)*Data.BlockH2+1 : IdxH1*Data.BlockH2;
Idx2 = (IdxH2-1)*Data.BlockH2+1 : IdxH2*Data.BlockH2;

data1 = data(Idx1,:);
data2 = data(Idx2,:);

%Index1 = SearchDeSeq(data1(:,2),thet,'ceil')
thetDgree = acos(thet)/pi*180;
Index1 = ceil((thetDgree - Data.StartAng)/Data.StepA);
%Index2 = SearchDeSeq(data2(:,2),thet,'ceil'); %% The same with index1
% Index1
% data1(:,2)
if Index1 ==0;Index1 = Index1 + 1 ; end
Point1 = data1(Index1,:);
Point2 = data1(Index1+1,:);
Point3 = data2(Index1,:);
Point4 = data2(Index1+1,:);
if strcmp(type,'Mean')
   Error = (Point1(3)+Point2(3)+Point3(3)+Point4(3))/4;
elseif strcmp(type,'InvDisMean')
   %[ToDo]
elseif strcmp(type,'BiLinear')
   %[ToDo]
end
