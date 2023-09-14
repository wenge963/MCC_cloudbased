function pop = Initialization(pop,params,cd)
nVar = params.nVar; 
nPop = params.nPop;
rulesNum=ceil(unifrnd(0, params.MaxrulesNum,nPop,1));
parfor i = 1:nPop
    choose_num = randperm(nVar,rulesNum(i))
    pop(i).Position_selection(choose_num)= 1;
    pop(i) = pso_sublayer(cd,params,pop(i));
end
end