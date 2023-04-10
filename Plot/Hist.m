% 画频率分布直方图
function Hist(x,xnum,FigName)
[counts,centers] = hist(x,xnum);%柱的个数为5，可根据自己需要调整
x1=centers;%每个柱的中心x坐标
y1=counts / sum(counts);%每个柱的个数（频数）与数据总个数的比值

% 分布参数拟合
[mu,sigma]=normfit(x);%用正态分布拟合出平均值和标准差

% 画已知分布的概率密度曲线
x2 = centers(1)*0.5:((centers(end)-centers(1)))/1000:centers(end)*1.5;
x2 =-centers(end)*1.5:((centers(end)-centers(1)))/1000:centers(end)*1.5;
y2 = pdf('Normal', x2, mu,sigma);%probability density function，求在x2处的pdf值

[hAxes,hBar,hLine]=plotyy(x1,y1,x2,y2,'bar','plot');
set(hLine,'color',[1,0,0],'LineWidth',1,'Marker','o','MarkerSize',2,...
    'MarkerFace','y')
xlabel([FigName '/m'])
ylabel(hAxes(1),'Frequency','FontName','Times New Roman')
ylabel(hAxes(2),'Probability density','FontName','Times New Roman')
% saveas(h1,[FigName '.jpg'])
