function [TsNew,IgnIdx] = ReplaceTimeTag(fun,S,xs,Ts,WinWidth,Interval,threshold1,threshold2)

BP   = BreakPointDetect(S,threshold1);
S_BP = S(BP);
IgnIdx = []; %% ignored
k = 0;
n = length(Ts);
for i = 1:n
    T1 = Ts(i);    
    
    %% GNSS data combination
    idx1 = SearchInSeq(S_BP,T1,'ceil');
    if idx1==0; idx1= idx1 + 1; IgnIdx = [IgnIdx i] ; end
    

    T1Idx = round( (T1 - S_BP(idx1))/Interval ) + BP(idx1);

%     T1 - S(T1Idx)
%     S_BP(idx1)
%     BP(idx1)
%     pause
    
    % T1
    T1Idx1 = T1Idx - WinWidth;
    T1Idx2 = T1Idx + WinWidth;
    while T1Idx1 < 1; T1Idx1 = T1Idx1 +1; T1Idx2 =  T1Idx2 + 1 ;end
    
    idx11   = T1Idx1:T1Idx2;
    
    MT1 = mean(S(idx11));
    ts1 = S(idx11) - MT1;
    dt1 = T1 - MT1;
    
    m = length(xs(1,:));
    for s = 1:m
        xxs{s} = xs(idx11,s);
    end
    TsNew(i,1) = T1;
    for s = 1:m
        TsNew(i,s+1) = fun(ts1,xxs{s},dt1); %% 
    end
    if abs(dt1) > threshold2; IgnIdx = [IgnIdx i]; end
end