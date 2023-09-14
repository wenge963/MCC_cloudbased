

function [x1 x2]=Crossover(x1,x2)
pos_num= randperm(length(x1),2);
pos = [min(pos_num):max(pos_num)];
a = x1(pos);
x1(pos) = x2(pos);
x2(pos) = a;
if sum(x1)==0
    x1(randperm(length(x1),1))=1;
end
if sum(x2)==0
    x2(randperm(length(x1),1))=1;
end    
end