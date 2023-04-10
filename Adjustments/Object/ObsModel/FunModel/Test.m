syms fx
syms x1 x2 a1 a2
x = [x1 x2];
a = [a1 a2];

NLM('fx = x(3)*x(1) + x(4)*x(2)',fx,x,a,[1:2],[3 4;5 6]);

LM([1 2;3 4;5 6]);