function PlotResidualdistribution(Ses_Result)
f = figure;
f.Name = 'Coordinate series residual distribution';
Ses_Mean = mean(Ses_Result);
SesDiff  = Ses_Result - Ses_Mean;
NFlu     = SesDiff(:,1:3:end);
EFlu     = SesDiff(:,2:3:end);
UFlu     = SesDiff(:,3:3:end);

% Coordinate series residual distribution
NFluVec = NFlu(:);
EFluVec = EFlu(:);
UFluVec = UFlu(:);

set(gcf,'position',[80 100 550 600])
subplot(3,1,1)
Hist(NFluVec,10,'N')
title('Error bar and normal PDF fitting')

subplot(3,1,2)
Hist(EFluVec,10,'E')

subplot(3,1,3)
Hist(UFluVec,10,'U')

       
