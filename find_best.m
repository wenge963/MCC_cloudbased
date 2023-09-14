function [pop_best best_cover] = find_best(pop,data)

pop_fir=pop([pop.Rank]==1,:);
Cost=[pop_fir.Cost];
for i=1:length(Cost)/2
    Rank(i,1) =  Cost(2*i-1);
    Rank(i,2) =  Cost(2*i);
end
rr = find(Rank(:,1)==min(Rank(:,1)));
pop_best = pop_fir(rr(find(Rank(rr,2)==min(Rank(rr,2)))));

Var_min = pop_best.Position_min_range;
Var_max = pop_best.Position_max_range;
Var_pos = pop_best.Position_selection;
pos = find(Var_pos==1);
logic=sum(data(:,pos)>=Var_min(:,pos),2)+sum(data(:,pos)<=Var_max(:,pos),2);
data=data(logic==sum(Var_pos)*2,:);

best_cover = data(:,size(data,2));






end
