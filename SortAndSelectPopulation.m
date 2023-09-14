function [pop, F] = SortAndSelectPopulation(pop, params)

    [pop, F] = NonDominatedSorting(pop);
    
    nPop = params.nPop;
    if numel(pop) == nPop
        return;
    end
    
    
    newpop = [];
    for l=1:numel(F)
        pop_F = delMup(pop(F{l}));
        if numel(newpop) + numel(pop_F) > nPop
            LastFront = F{l};
            break;
        end
        
        newpop = [newpop; pop_F];   %#ok
    end
    
    
    
%     while true
%         
% 
%         
%     end
    
    [pop, F] = NonDominatedSorting(newpop);
    
end