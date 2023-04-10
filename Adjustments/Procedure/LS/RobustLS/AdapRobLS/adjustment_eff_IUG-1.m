function eff = adjustment_eff_IUG1(siga,k1,k2)

eff1 = erf(k2/sqrt(2));

step=0.00001;
eff2=0;
for i=k2:step:k1
    eff2 = eff2 + 1/i/sqrt(2*pi) * exp(-i^2/2)*step;
end
eff = eff1 + 2 * eff2;
end