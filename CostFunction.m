
function [g cover_num cover label] = CostFunction(Var_min,Var_max,data,params)
Class=params.Class;
frequency=params.frequency;
len=size(Var_min,2);
logic=sum(data(:,1:len)>=Var_min,2)+sum(data(:,1:len)<=Var_max,2);
data = data(logic==len*2,:);
if size(data,1)==0
    g=999999999;
    cover=[];
    cover_num=0;
    label=0;
else
    cover = data(:,len+2)';
    for i=1:length(Class)
    cover_num(i) = -sum(data(:,len+1)==Class(i));
    end
    label = find(cover_num==min(cover_num));
    label = label(1);
    cover_num = cover_num(label);
    g = cover_num*100/size(data,1);

end
end
