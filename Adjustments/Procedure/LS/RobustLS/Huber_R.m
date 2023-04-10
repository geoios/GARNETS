function r = Huber_R(J,q)
%% Huber È¨º¯Êý
for i=1:length(r0)
    r(i) = (1 - J(i,i))^q;
end
