
function [rules_set, cover_set, iou] = rules_select(pop,rules_set,data,params,acc_par,num_min)
assem=[pop.Cost];
pos=assem(1:2:end)<=-acc_par*100&assem(2:2:end)<=-num_min;
pop = [rules_set
       pop(pos)];
pop = pop([pop.Rank]<=3);
nVar = params.nVar;
IoU_set = [pop.IoU];
rules_set = rules_set(1);
k = 1;
Class = params.Class;
iou = zeros(1,length(Class));
cover=zeros(length(data),length(Class));
while numel(pop)>1
    [IoU_max loc] = max(IoU_set);
    label=pop(loc).Label;
    cover_sel = pop(loc).Cover;
    instance = (ismember(data(:,nVar+2),cover_sel)+cover(:,label))>=1;  %covered instances
    target = data(instance,nVar+1);
    iou_new = sum(target==params.Class(label))/(params.frequency(label)+length(target)-sum(target==params.Class(label)));
    if iou_new > iou(label)
        cover(:,label) = instance;
        iou(label)=iou_new;
        rules_set(k,:) = pop(loc);
        k=k+1;
    end
    IoU_set(loc) = [];
    pop(loc) = [];
end
cover_set=[];
for j=1:length(Class)
all_covered=data(cover(:,j)==1,nVar+1:nVar+2);
cover_set = [all_covered(all_covered(:,1)==Class(j),2) 
             cover_set];
end
cover_set=unique(cover_set)';
end

