function Sim = simplex_0828(A,B,C,D,delta)
%% ssimplex(A,B,C,D)
%% Function:实现单纯形法判定最优解
%% inputs:
% A % 约束函数的系数矩阵
% B % 约束函数的常数列向量
% C % 目标函数的系数向量
% D % 求最大值为1，求最小值为0
% delta % 迭代的次数
%% outputs:
% X % 目标函数的最优解
% Z % 目标函数的极值
%%%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%%
% A=[1 2 1 0 0;4 0 0 1 0;0 4 0 0 1];
% B=[8;16;12];
% C=[2 3 0 0 0];
% D=1;
% delta=0;
%%
a=1;
Z=0;Zn=[];
[m,n] = size(A);
Bi = n-m+1:n;         %基向量的下标
if D==0
    C=-C;         %求最小值需将目标函数系数取反
end
if (n < m)
    disp('系数矩阵错误')
else
    while a
        Cb = C(Bi);
        Zi = (Cb)*A;
        Ri =C-Zi;                   %检验数
        X = zeros(1,n);
        
        for i=1:m
            X(Bi(i))=B(i);     
        end
        for i=1:n
            Z=Z+(C(i)*X(i));
        end
        Zn = [Zn;Z];
        Z=0;
        
        if max(Ri)<=0               %判断检验数
            for i=1:m
                X(Bi(i))=B(i);     %当前X值即为最优解，输出
            end
            for i=1:n
                Z=Z+(C(i)*X(i));
            end
            a = 0;
            %                fprintf('迭代次数为:%d\n',delta);
            %                disp('已找到最优解：')
            %                delta;
            break;
        else
            delta = delta+1;
            [~, k1] = max(Ri);     %获得换入基变量的位置，将Rj最大值的位置索引赋给k1
            for i=1:m
                if A(i,k1)>0
                    P(i)=B(i)/A(i,k1);
                else
                    P(i)=inf;
                end
            end
            [~, k2]=min(P);    %找到换出变量的位置并赋予k2
            Bi(k2)=k1;         %新的基变量
            F=[B,A];           %将B,A合成新矩阵进行初等变换操作
            F(k2,:)=F(k2,:)/F(k2,k1+1); %将A中k2行，除于A中k2行，k1列；更新E
            for i=1:m
                if(i==k2)
                    continue;
                end
                while 1
                    F(i,:)= F(i,:)-F(i,k1+1)*F(k2,:);  %对F进行初等行换
                    if(F(i,k1+1)==0)
                        break;
                    end
                end
                B=F(1:m,1);
                A=F(1:m,2:n+1);
            end
        end
    end
end

Sim.X = X;
Sim.Z = Z;
Sim.Inter = delta;


