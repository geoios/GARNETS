function Val = NestFunVal(A2,N1,N2,H,thet,type2,type1)

% Method2  
% first layer fun p1(h) = f(a)
% second layer fun p2 = g(p1)
[n2,m2]=size(A2);
if strcmp(type2,'polyn')
    for j=1:n2
        p2 = polyval(A2(j,:),H);%
        P2(j) = p2;
    end
end

if strcmp(type2,'poly')
    ft1 = fittype( ['poly' num2str(N2)] );% 22 33,45 ...
    for j=1:n2
        p2 = FittypeVal(ft1,A2(j,:),H);
        P2(j) = p2;
    end
end

if strcmp(type1,'polyn')
    Val = polyval(P2,thet); %    
end

if strcmp(type1,'poly')
%    [m2,n2]=size(P2);
    ft1 = fittype( ['poly' num2str(N1)] );%
    Val = FittypeVal(ft1,P2,thet);
end

if strcmp(type1,'mapf')
   str1 = '(1+(a1/(1+(a2/(1+a3)))))/';
   str2 = '(x+(a1/(x+(a2/(x+a3)))))';
   ft1 = fittype(['a*' str1 str2],...
       'dependent',{'y'},'independent',{'x'},...
       'coefficients',{'a','a1','a2','a3'});
   Val = FittypeVal(ft1,P2,thet);
end