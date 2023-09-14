function x = operators_adjust(x,VarMax,VarMin,level)
[particlesize pos_num] = size(x);
pos_num = pos_num/2;
for j = 1 : pos_num
    x(:,j) = roundn(x(:,j),level(j));
    x(:,pos_num+j) = roundn(x(:,pos_num+j),level(j));
    logic = x(:,j)<VarMin(j);
    if sum(logic)~=0
        x(logic,j) = VarMin(j) + (VarMax(j) - VarMin(j)).*rand(sum(logic),1);
    end
    logic = x(:,pos_num+j)>VarMax(j);
    if sum(logic)~=0
        x(logic,pos_num+j) = VarMin(j) + (VarMax(j) - VarMin(j)).*rand(sum(logic),1);
    end
    for i = 1:particlesize
        if x(i,j)>x(i,pos_num+j)        %判定下限比上限大
            if rand(1)>0.5
                x(i,j) = VarMin(j);    %缩放下限
            else
                x(i,pos_num+j) = VarMax(j); %放大上限
            end
        end       
    end
end
end
