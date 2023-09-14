clc;
clear;
close all;
load(['G:\OneDrive\rules extraction\generate rule extraction (multi class)\aus.mat']);
load(['G:\OneDrive\rules extraction\generate rule extraction (multi class)\type.mat']);
rand_sample = randperm(size(instance,1),floor(size(instance,1)*0.1));
cd = instance(~ismember([1:size(instance,1)],rand_sample)',:);
varify = instance(rand_sample,:);
clear instance
  %% Parameter Definition
nVar = size(cd,2)-1;    % Location of Decision Variables
level=floor(log10(std(cd(:,1:nVar)))-1);%Location of Decimal Point
Class = 1;
%Class = unique(cd(:,nVar+1));
MaxIt = 10;  % Maximum Number of Iterations
%Length of Tabu List 
tabu_length=3;
%Maximum Length of Rules
MaxrulesNum = 5;  
%% Initialization Data
data1 = cd;
data1(:,nVar+2) = [1:size(cd,1)];
%% Genetic Algorithm Parameters
nPop =80;  % Population Size
pCrossover = 0.8;       % Crossover Percentage
nCrossover = 2*round(pCrossover*nPop/2); % Number of Parnets (Offsprings)

pMutation = 0.8;       % Mutation Percentage
nMutation = round(pMutation*nPop);  % Number of Mutants

mu = 6;     % Mutation Rate
sigma = 2; 
%% Summary Parameters
params.nPop = nPop;
params.nVar = nVar;
params.level = level;
params.MaxrulesNum = MaxrulesNum;
params.Class = Class;
params.type = type;
params.frequency = histc(cd(:,nVar+1),Class); 

%% Initialization

disp('Staring  ...');
empty_individual.Position_selection = zeros(1,nVar);
empty_individual.Position_min_range = [];
empty_individual.Position_max_range = [];
empty_individual.Cost = [];
empty_individual.Rank = [];
empty_individual.DominationSet = [];
empty_individual.DominatedCount = [];
empty_individual.Chosen = 1;
empty_individual.Cover = [];
empty_individual.IoU = [];
empty_individual.Label = [];

operators = repmat(empty_individual, nPop, 1);
%% tabu list generation
tabu.sub_data = [];
tabu_list = repmat(tabu,tabu_length,1);
rules = repmat(empty_individual, 1, 1);
rules(1) =[]; 
best_cover = [];
tabuIt = 12;
cover_set=[];
IoU = 0;
rules_set = empty_individual;
rules_set.IoU = 0;
tic
for t = 1:tabuIt
%% Limitation of Variables
data = data1(~ismember(data1(:  ,nVar+2),best_cover),:);
VarMin = min(data(:,1:nVar));
VarMax = max(data(:,1:nVar));
params.VarMin = VarMin;
params.VarMax = VarMax;

pop = Initialization(operators,params,data);
% Sort Population and Perform Selection
[pop, F] = SortAndSelectPopulation(pop, params);

%% NSGA-II Main Loop
for it = 1:MaxIt
    nPop = numel(pop);
    % Crossover
    popc_1 = repmat(empty_individual, nCrossover/2, 1);
    popc_2 = repmat(empty_individual, nCrossover/2, 1);
    parfor k = 1:nCrossover/2

        i1 = randi([1 nPop]);
        p1 = pop(i1).Position_selection;

        i2 = randi([1 nPop]);
        p2 = pop(i2).Position_selection;

        [popc_1(k).Position_selection, popc_2(k).Position_selection] = Crossover(p1,p2);
        popc_1(k) = pso_sublayer(data,params,popc_1(k));
        popc_2(k) = pso_sublayer(data,params,popc_2(k));
    end
    popc = [popc_1
            popc_2];

    % Mutation
    popm = repmat(empty_individual, nMutation, 1);
    parfor k = 1:nMutation
        i = randi([1 nPop]);
        p = pop(i).Position_selection;
        popm(k).Position_selection = Mutate(p,mu,sigma);
        popm(k)= pso_sublayer(data,params,popm(k));

    end
% 
%     % Merge
    pop = [pop
           popc
           popm]; 
    [pop, F] = SortAndSelectPopulation(pop, params);       
%    
%     % Store F1
%     F1 = pop(F{1});
%     [pop_best,best_cover] = find_best(pop,data);
%     % Show Iteration Information
      disp(['Iteration ' num2str(it) ]);
%     % Plot F1 Costs
%     figure(1);
%     PlotCosts(F1);
end
[rules_set, cover_set, IoU] = rules_select(pop,rules_set,data1,params,0.95,20);
iou(t,:) = IoU
if IoU==1
    break
else
%     if t>=3
%         if iou(t)==iou(t-1) && iou(t-1)==iou(t-2)
%             break
%         end
%     end
    % Tabu List Update
    best_cover = [];
    for i =tabu_length-1:-1:0
        if i==0
            tabu_list(1).sub_data = cover_set;
        else
            tabu_list(i+1).sub_data=tabu_list(i).sub_data;
        end
        best_cover = [best_cover tabu_list(i+1).sub_data];
    end
end
end
IOU = [iou];
t = [1:length(IOU)];
plot(t,IOU)

%% Results

disp('Optimization Terminated.');
toc




