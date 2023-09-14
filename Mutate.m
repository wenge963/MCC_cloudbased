
function x =Mutate(x,mu,sigma)
nVar = length(x);
Mu_num = abs(round(normrnd(mu,sigma)));
target = randperm(nVar,Mu_num);
x(target)=x(target)+1~=1; 
if sum(x)==0
    x(randperm(length(x),1))=1;
end

end
