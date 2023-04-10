function PlotDelaySeries(ObsData,Delay,TimeInf)

ZenithDelay = Delay{1};
HorDelay    = Delay{2};
NDelay      = HorDelay(:,1);
EDelay      = HorDelay(:,2);

ZenMeanTime = TimeInf.BlockZen;
ZenTimeNum  = length(ZenMeanTime);
HorMeanTime = TimeInf.BlockHor;
HorTimeNum  = length(HorMeanTime);

ReferenceTime = [0 0 0 0 0];
RefSec        = ObsData.Data.SET_LN_MT(1,9);

for i = 1:ZenTimeNum
    Date_Zen = Sec2Date(ReferenceTime,ZenMeanTime(i)-RefSec);
    x_Zen(i,:) = datenum(0,Date_Zen(1),Date_Zen(2),Date_Zen(3),Date_Zen(4),Date_Zen(5));
    RecordData(i,:) = Date_Zen;
end

for i = 1:HorTimeNum
    Date_Hor = Sec2Date(ReferenceTime,HorMeanTime(i)-RefSec);
    x_Hor(i,:) = datenum(0,Date_Hor(1),Date_Hor(2),Date_Hor(3),Date_Hor(4),Date_Hor(5));

end

XTimeStart = 0;
XTimeEnd   = (RecordData(end,2)*24 + RecordData(end,3)) + 1;
Loop = 0;
for j = XTimeStart:2:XTimeEnd
    Loop = Loop + 1;
    XAxisDate(Loop,:) = datenum(0,0,0,j,0,0); 
end


f = figure;
f.Name = 'Zenith Delay series';
y    = ZenithDelay(:,1);
Name = 'U';
set(gcf,'position',[80 100 1100 550])
plot(x_Zen,y,'MarkerSize',4,'Marker','diamond','LineStyle','none',...
    'Color',[1 0 0]);
xlabel('Date (HH:MM)','FontWeight','bold','FontSize',15.4,'FontName','Times New Roman');
ylabel('U (m)','FontWeight','bold','FontSize',15.4,'FontName','Times New Roman');
xticks(XAxisDate)
dateaxis('x',15)


% N方向延迟
f = figure;
f.Name = 'N Delay series';
y    = NDelay;
Name = 'N';
set(gcf,'position',[80 100 1100 550])
plot(x_Hor,y,'MarkerSize',4,'Marker','diamond','LineStyle','none',...
    'Color',[0 1 0]);
xlabel('Date (HH:MM)','FontWeight','bold','FontSize',15.4,'FontName','Times New Roman');
ylabel('N (m)','FontWeight','bold','FontSize',15.4,'FontName','Times New Roman');
xticks(XAxisDate)
dateaxis('x',15)


% E方向延迟
f = figure;
f.Name = 'E Delay series';
y    = EDelay;
Name = 'E';
set(gcf,'position',[80 100 1100 550])
plot(x_Hor,y,'MarkerSize',4,'Marker','diamond','LineStyle','none',...
    'Color',[0 0 1]);
xlabel('Date (HH:MM)','FontWeight','bold','FontSize',15.4,'FontName','Times New Roman');
ylabel('E (m)','FontWeight','bold','FontSize',15.4,'FontName','Times New Roman');
xticks(XAxisDate)
dateaxis('x',15)
