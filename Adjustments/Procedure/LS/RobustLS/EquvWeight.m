function p = EquvWeight(V,p0,sig,RobPar)

%% standarized residual
v = V / sig;
n = length(v);
%% stucture factors

if ~isfield(RobPar,'Type1')
    r = ones(n,1);
else
    J = RobPar.J;
    q = RobPar.q;
    if strcmp(RobPar.Type1,'Huber')
       r = Huber_R(J,q);
    elseif strcmp(RobPar.Type1,'Koch')
       r = Koch_R(J,q);
    end
end
%% observation factors
type2 = RobPar.Type2;
if strcmp(type2,'IGG1')
   for i=1:n
       s(i) = IGG1_w(RobPar.RobustK1*r(i),RobPar.RobustK2*r(i),v(i));
   end
end
if strcmp(type2,'IGG2')
   for i=1:n
       s(i) = IGG2_w(RobPar.RobustK1*r(i),v(i));
   end
end
if strcmp(type2,'IGG3')
   for i=1:n
       s(i) = IGG3_w(RobPar.RobustK1*r(i),RobPar.RobustK2*r(i),v(i));
   end
end
if strcmp(type2,'IGG4')
   for i=1:n
       s(i) = IGG4_w(RobPar.RobustK1*r(i),RobPar.RobustK2*r(i),v(i));
   end
end
if strcmp(type2,'IGG8')
   for i=1:n
       s(i) = IGG8_w(RobPar.RobustK1*r(i),RobPar.RobustK2*r(i),v(i));
   end
end

if strcmp(type2,'Huber')
   for i=1:n
       s(i) = Huber_w(RobPar.RobustK1*r(i),v(i));
   end
end

if strcmp(type2,'Hampel')
   for i=1:n
       s(i) = Hampel_w(RobPar.RobustK1*r(i),...
                       RobPar.RobustK2*r(i),...
                       RobPar.RobustK3*r(i),v(i));
   end
end

if strcmp(type2,'Tukey')
   for i=1:n
       s(i) = Tukey(RobPar.RobustK1*r(i),v(i));
   end
end

if strcmp(type2,'Krarup')
   for i=1:n
       s(i) =  Krarup_w(RobPar.RobustK1*r(i),v(i),RobPar.RobustK2,RobPar.RobustK3);
   end
end

for i=1:n
    p(i) =  p0(i) * s(i);
end