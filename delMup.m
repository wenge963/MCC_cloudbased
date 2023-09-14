function pop = delMup(pop)
pop(1).Chosen = 1;
for i = 1:numel(pop)
    for j = i+1:numel(pop)
        if size(pop(i).Cover,2)==size(pop(j).Cover,2)
            if sum(pop(i).Cover==pop(j).Cover)==length(pop(i).Cover)
                pop(j).Chosen = 0;
            end                
        end
    end
end
 pop=pop([pop.Chosen]==1,:);
end

    
