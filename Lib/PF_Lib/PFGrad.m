function PF = PFGrad(PF,w,ord)
[m,n] = size(PF);
cp = ceil(w/2);
k = 1;
for i=1:m - w + 1
    PFWin = PF(i:i+w-1,:);
    if i == 1
       for s = 1:cp
           x = Grad1(PFWin,s,ord);
           a(k,:) = x;
           k = k +1;
       end
    elseif i == m - w + 1  
        for s = 1:w - cp + 1
            x = Grad1(PFWin,cp+s-1,ord); %% for i = m-w+cp;i-m+w=cp;
            a(k,:) = x;
            k = k +1;
        end
    else
       x = Grad1(PFWin,cp,ord);
       a(k,:) = x;
       k = k+1;
    end
end
for i=1:m-1
    z(i,:) = PF(i+1,1) - PF(i,1);
end
z(m,:)  = z(m-1,:);
PF(:,3) = z;
PF(:,4:3+length(x)) = a;