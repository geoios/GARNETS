function A2 = NestFunModel(Data,N1,N2,type1,type2)

% Method2  
% first layer fun p1(h) = f(a); 
% second layer fun p2 = g(p1)

n1 = Data.BlockH1;
n2 = Data.BlockH2;
data = Data.Obs;
for j=1:n1
    idx = (j-1)*n2+1:j*n2;
    x = data(idx,2);
    y = data(idx,3);
    if strcmp(type1,'polyn')
        a1 = polyfit(x',y',N1);%% high order
    elseif strcmp(type1,'poly')
        ft1 = fittype( ['poly' num2str(N1)] );% 22 33,45 ...
        opts = fitoptions( ft1 );
%         opts.Lower = [-Inf -Inf -Inf -Inf -Inf -Inf]; 
%         opts.Robust = 'Bisquare';%robustness
%         opts.Upper = [Inf Inf Inf Inf Inf Inf];%
%         opts.Normalize = 'on'; 
        [fitresult, gof] = fit( x, y, ft1, opts );
        a1 = coeffvalues(fitresult);
    elseif strcmp(type1,'mapf')
        str1 = '(1+(a1/(1+(a2/(1+a3)))))/';
        str2  = '(x+(a1/(x+(a2/(x+a3)))))';
        ft1=fittype(['a*' str1 str2],...
                       'dependent',{'y'},'independent',{'x'},...
                       'coefficients',{'a','a1','a2','a3'});
        opts = fitoptions( ft1 );
        opts=fitoptions('Method','NonlinearLeastSquares');
        opts.Lower=[-100 -100 -100 -100];  %范围下限
        opts.StartPoint=[2,-0.05,-0.05,-2];   %开始点
        opts.Upper=[100 100 100 100];  %范围上限
        [fitresult, gof] = fit( x, y, ft1, opts );
        a1 = coeffvalues(fitresult);
    end
    A1(j,:) = a1;
end

x = Data.StartH:Data.EndH;
[m,n3] = size(A1);
for j=1:n3
    y = A1(:,j);
    if strcmp(type2,'polyn') 
        a2 = polyfit(x,y',N2);%% high order
    elseif strcmp(type2,'poly')
        ft1 = fittype( ['poly' num2str(N2)] );% 22 33,45 ...
        opts = fitoptions( ft1 );
%         opts.Lower = [-Inf -Inf -Inf -Inf -Inf -Inf]; 
%         opts.Robust = 'Bisquare';%robustness
%         opts.Upper = [Inf Inf Inf Inf Inf Inf];%
%         opts.Normalize = 'on'; 
          % Fit model to data.
        [fitresult, gof] = fit( x', y, ft1, opts );
        a2 = coeffvalues(fitresult);
    end
    A2(j,:) = a2;
end