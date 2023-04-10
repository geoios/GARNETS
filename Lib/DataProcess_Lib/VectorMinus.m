function dif = VectorMinus(A,B)
for i = 1:length(A)
    dif(i) = Minus(A(i),B(i));
end
end