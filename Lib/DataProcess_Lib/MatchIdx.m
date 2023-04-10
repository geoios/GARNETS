function Idx = MatchIdx(mat,idx)
[n,m]  = size(mat);
idxNum = size(idx,1);

Idx = [];

for j = 1:idxNum
    k = 1;
    idxs = [];
    jidx = idx(j,:);
    for i=1:n
        minus = VectorMinus(mat(i,:),jidx);
        if sum(abs(minus)) == 0
            idxs(k) = i;
            k = k + 1;
        end
    end
    Idx = [Idx;idxs']; 
end

end