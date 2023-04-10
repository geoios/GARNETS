function PlotPositionRes(Ses_Result,SesTime,TimeInf,SPNoInf)
f = figure;
f.Name = 'Positioning solutions';
Ses_Mean = mean(Ses_Result);
SesDiff  = Ses_Result - Ses_Mean;
NFlu     = SesDiff(:,1:3:end);
EFlu     = SesDiff(:,2:3:end);
UFlu     = SesDiff(:,3:3:end);

MedianTime    = (sum(SesTime)/2)';
DataUTC       = TimeInf.Date;
ReferenceTime = [DataUTC(2) DataUTC(3) 0 0 0];
TimeNum = size(MedianTime,1);
for i = 1:TimeNum
    Date = Sec2Date(ReferenceTime,MedianTime(i));
    x(i,:) = datenum(DataUTC(2),Date(1),Date(2),Date(3),Date(4),Date(5));
    RecordData(i,:) = Date;
end

sign    ={'r-*' 'g-^' 'b-h', 'm-o','r--*' 'g--^' 'b--h', 'm--o'};
ColPans = {[1 0 0]
           [0 1 0]
           [0 0 1]
           [1 0 1]
           [1 0 0]
           [0 1 0]
           [0 0 1]
           [1 0 1]}; 
% Error series of positioning 
SPNoNum = size(Ses_Result,2)/3;
hold on
for i = 1:SPNoNum
    subplot(3,1,1)
    hold on
    plot(x,NFlu(:,i),sign{i},'LineWidth',1,'MarkerEdgeColor',ColPans{i})

    subplot(3,1,2)
    hold on
    plot(x,EFlu(:,i),sign{i},'LineWidth',1,'MarkerEdgeColor',ColPans{i})
    
    subplot(3,1,3)
    hold on
    plot(x,UFlu(:,i),sign{i},'LineWidth',1,'MarkerEdgeColor',ColPans{i})
end    

for j = 1:SPNoNum
    StnLegend{j} = ['M',num2str(SPNoInf(j))];
end       
legend(StnLegend,'orientation','horizontal','Location','best','NumColumns',4, ...
'Position',[0.324166669183307 0.925073570748209 0.395555550522273 0.0726666646798452],'FontSize',12)

subplot(3,1,1);
set(gca,'FontSize',16);grid on;
dateaxis('x',15)
xlabel('Date (Hour/Day)','FontWeight','bold','FontSize',15.4,'FontName','Times New Roman');
ylabel('N (m)','FontWeight','bold','FontSize',15.4,'FontName','Times New Roman');

subplot(3,1,2);
set(gca,'FontSize',16);grid on;
dateaxis('x',15)
xlabel('Date (Hour/Day)','FontWeight','bold','FontSize',15.4,'FontName','Times New Roman');
ylabel('E (m)','FontWeight','bold','FontSize',15.4,'FontName','Times New Roman');

subplot(3,1,3);
set(gca,'FontSize',16);grid on;
dateaxis('x',15)
xlabel('Date (Hour/Day)','FontWeight','bold','FontSize',15.4,'FontName','Times New Roman');
ylabel('U (m)','FontWeight','bold','FontSize',15.4,'FontName','Times New Roman');

set(gcf,'position',[80 100 550 600]) 
hold off

