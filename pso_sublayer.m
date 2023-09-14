function pop = pso_sublayer(cd,params,first_layer)
pos = find(first_layer.Position_selection==1);
pos_num = length(pos);
nVar = params.nVar;
level = params.level;
VarMin = params.VarMin(:,pos);
VarMax = params.VarMax(:,pos);
data = cd(:,[pos nVar+1 nVar+2]);
frequency = params.frequency;
Class = params.Class;
type = params.type(:,pos);
type_pos = find(type ~=1);
%Pso Parameters
Max_num = 20;
particlesize = 50;
c1 = 1;
c2 = 3;
w = 10;
vc = 2;
vmax=[(VarMax - VarMin)/10 (VarMax - VarMin)/10];%step
%Initialization
%x = [(VarMax - VarMin) (VarMax - VarMin)].*rand(particlesize,2*pos_num)+[VarMin VarMin];
x(:,1:pos_num) = VarMin+0.5*(VarMax - VarMin).*rand(particlesize,pos_num);
x(:,pos_num+1:2*pos_num) = VarMax-0.5*(VarMax - VarMin).*rand(particlesize,pos_num);
for i= 1:pos_num
    if type(i)==1
        x(:,i) = randi([VarMin(i), VarMax(i)],[particlesize,1]);
        x(:,pos_num+i) =  x(:,i);
    end
end 
x = operators_adjust(x,VarMax,VarMin,level);
for i = 1:particlesize
[f(i).g f(i).c f(i).cover f(i).label] = CostFunction(x(i,1:pos_num),x(i,pos_num+1:2*pos_num),data,params);
 personalbest(i).set = f(i).cover;
end
personalbest_x = x;
personalbest_f = [f.g];
personalbest_cover = [f.c];
personalbest_label = [f.label];
cover = find([f.g]==min([f.g]));
i=cover(find([f(cover).c]==min([f(cover).c])));
i=i(1);
groupbest_f = f(i).g;
groupbest_x = x(i,:);
groupbest_cover = f(i).c;
groupbest_set = personalbest(i).set;
groupbest_label = f(i).label;
for j=1:Max_num   
    v=w*[-rand(particlesize,pos_num) rand(particlesize,pos_num)]+c1*rand.*(personalbest_x-x)+c2*rand.*(groupbest_x.*ones(particlesize,2*pos_num)-x);
    for kk = 1:particlesize
        out_range = find((abs(v(kk,:)) >= vmax)==1);
        for r = out_range 
            if v(kk,r)>vmax(r)
                v(kk,r)=vmax(r);
            else
                v(kk,r)=-vmax(r);
            end
        end
    end
    x(:,[type_pos pos_num+type_pos])=x(:,[type_pos pos_num+type_pos])+vc*v(:,[type_pos pos_num+type_pos]);
    x = operators_adjust(x,VarMax,VarMin,level);
    for i = 1:particlesize
        [f(i).g f(i).c f(i).cover f(i).label] = CostFunction(x(i,1:pos_num),x(i,pos_num+1:2*pos_num),data,params);
    end
    for kk=1:particlesize
        if f(kk).g < personalbest_f(kk)
            personalbest_f(kk)=f(kk).g;
            personalbest_x(kk,:)=x(kk,:); 
            personalbest_cover(kk) = f(kk).c;
            personalbest(kk).set = f(kk).cover;
            personalbest_label(kk)=f(kk).label;
        end
    end
    cover = find(personalbest_f==min(personalbest_f));
    i=cover(find(personalbest_cover(cover)==min(personalbest_cover(cover))));
    i=i(1);
    groupbest_f = personalbest_f(i);
    groupbest_x=personalbest_x(i,:);
    groupbest_cover = personalbest_cover(i);
    groupbest_set = personalbest(i).set;
    groupbest_label = personalbest_label(i);
    
    hhh(j) = groupbest_cover;
    ddd(j) = groupbest_f;
    if j>=4
        if ddd(j)==ddd(j-1) && hhh(j)==hhh(j-1) && ddd(j-1)==ddd(j-2) && hhh(j-1)==hhh(j-2) && ddd(j-2)==ddd(j-3) && hhh(j-2)==hhh(j-3)
            break
        end
    end
end
first_layer.Position_min_range = groupbest_x(1:pos_num);
first_layer.Position_max_range = groupbest_x(pos_num+1:2*pos_num);
first_layer.Cost = [groupbest_f,groupbest_cover];
first_layer.Cover = groupbest_set;
if groupbest_label==0
    first_layer.Label= [];
    first_layer.IoU =0;
else
    first_layer.Label= groupbest_label;
    first_layer.IoU = -groupbest_cover/(frequency(groupbest_label)+length(groupbest_set)+groupbest_cover);
end
pop = first_layer;  

end