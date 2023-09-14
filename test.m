cover = ismember(data1(:,nVar+2),cover_set);
pre = sum(data1(cover,nVar+1))/size(cover_set,2);
disp(['train data result pre is ' num2str(pre) ]);

varify(:,nVar+2) = [1:size(varify,1)];
result = [];

for i = 2:numel(rules_set)
    pos = [rules_set(i).Position_selection==1 true true];
    test = varify(:,pos);
    len = size(test,2)-2;
    logic = sum(test(:,1:len)>=rules_set(i).Position_min_range,2)+sum(test(:,1:len)<=rules_set(i).Position_max_range,2);
    cover_varify = test(logic==len*2,len+1:len+2);
    disp([num2str(i-1) ' iteration varify number is ' num2str(sum(cover_varify(:,1)))])
    result = [result; cover_varify(:,2)];
   
end
sum(varify(ismember(varify(:,nVar+1),unique(result)),nVar+1))

sum(varify(:,nVar+1))