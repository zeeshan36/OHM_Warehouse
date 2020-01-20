% Inputs to the Model.
% Nb -> Number of Blocks.
Nb = 4;
% Na -> Number of Aisles.
Na = 10;
% Ns -> Number of Storage Location per Aisle Side.
Ns = 12;
% kx -> Distance between two Subsequent Aisles.
kx = 4;
% ky -> Distance between two Adjacent Picking Positions.
ky = 2;

global bestdis;
global bestroute;
global bestpath;
global pheromone;
global evaprate;
global alpha;
global beta;
global num_Nodes;
global distance;

[n,L,Dist,Path] = CreateGraph(Nb,Na,Ns,kx,ky);
[Dist,Path] = Floyd_Warshall(Dist,Path,n); 
%Node_List=randperm(n,Nodes);
Node_List=[483 272 41 319 332 18 6 119 329 98 190 127 72 373 427 84 152 35 36 7 191 159 154 80 292];
Nodes=Node_List;
Star_Node=1;
num_Nodes=length(Node_List)+1;
Node_List=[Star_Node Node_List];
distance=zeros(num_Nodes);
Visit_Path=cell(num_Nodes);

for i=1:num_Nodes
    for j=1:num_Nodes
        distance(i,j)=Dist(Node_List(i),Node_List(j));
        Visit_Path{i,j}= ReturnPath(Path,Node_List(i),Node_List(j));
    end
end

taboo=ones(num_Nodes);
taboo=taboo-diag(diag(taboo));
nextProb=zeros(1,num_Nodes);
cumulativeProbability=zeros(1,num_Nodes);
itter = 800;
N=30;

pheromone=5;
evaprate=0.1;
tau=ones(num_Nodes);
alpha=1;
beta=1;
bestdis=9999;
bestroute=zeros(1,num_Nodes);
bestpath=int16.empty;

for itt=1:itter

    for ant=1:N
        present_node=1;
        taboo=updatetaboo(taboo,present_node);
        visited=zeros(1,num_Nodes);
        visited_path=[];
        visited(1,1)=present_node;
        for k=2:num_Nodes
            nextProb=prob_mat(tau,taboo,present_node);
    %-------------------------determine next node to go-------------------
            nextNodeProb=rand;
    %-------------------------Roulette wheel selection------------------
    %----------------------determine cumulative probability-----------------

            cumprob = cumsum(nextProb);
            nextnode=find(cumprob>nextNodeProb,1);
            present_node=nextnode;
            taboo=updatetaboo(taboo,present_node);
            visited(1,k)=present_node;
            visited_path=[visited_path Visit_Path{visited(1,k-1),visited(1,k)}];
            l=length(visited_path);
            visited_path(l)=[];

        end
    visited_path=[visited_path Visit_Path{visited(1,k),visited(1,1)}];
    checkbest(visited,visited_path);
    taboo=ones(num_Nodes,num_Nodes);
    taboo=taboo-diag(diag(taboo));
    end
    tau=updatepheromone(tau);
    
    
end
    y=zeros(1,length(bestpath));
    x=zeros(1,length(bestpath));
    for i=1:length(bestpath)
        [x(i),y(i)]=quorem(sym(bestpath(i)),sym(L));
        if y(i)==0
            y(i)=L;
        else
            x(i)=x(i)+1;
        end
    end
    
    figure(1);
    PlotSolutioncheck(x,y);
    pause(0.1);
% figure;
% plot(bestdis,'LineWidth',2);
% xlabel('Iteration');
% ylabel('Best Cost');
% grid on;

disp(['nodes to visit :   ' num2str(Nodes)]);
bestroute=[bestroute Node_List(1)];
disp(['best visiting sequence :   ' num2str(Node_List(bestroute))]);
disp(['best distance :   ' num2str(bestdis)]);
disp("route for visit :");
disp(bestpath);

function t = updatepheromone(ta)

    global evaprate
    global pheromone
    global bestdis
    global bestroute
    global num_Nodes
    
%-----------------------apply evaporation on all the connections------------
    t=zeros(num_Nodes);
    for i = 1:num_Nodes
        for j = 1:num_Nodes
            if i~=j
                t(i,j)=(1-evaprate)*ta(i,j);
            end
        end
        t(i,i)=0;
    end
    for i = 1:num_Nodes-1
        t(bestroute(i),bestroute(i+1)) = ta(bestroute(i),bestroute(i+1))+ pheromone/bestdis;
    end
    t(bestroute(i+1),bestroute(1)) = ta(bestroute(i+1),bestroute(1))+pheromone/bestdis;
end

function taboo = updatetaboo(taboo, present)
%--------------------after every time an ant reaches a new node, this list is updated-----
    taboo(:,present)=0;
end

function Probability = prob_mat(t,taboo,present)
    global distance
    global alpha
    global beta
    global num_Nodes
    
%----------------this needs to be calculated every time an ant is trying to decide which node to go next----
    totaldenom=0;
    Probability=zeros(1,num_Nodes);
    for j =1:num_Nodes
        if taboo(present,j) ==0 
            Probability(j)=0;
        else
            totaldenom = totaldenom+(((t(present,j))^alpha)/(distance(present,j))^beta);
        end
    end

    for j=1:num_Nodes
        if taboo(present,j)==1
            Probability(j)=((t(present,j))^alpha/(distance(present,j))^beta)/totaldenom;
        end
    end
end

function checkbest(visited,visited_path)
    global distance
    global bestdis
    global bestroute
    global bestpath
    global num_Nodes
    
    totaldis=0;
    for i=1:num_Nodes-1
        totaldis=totaldis+distance(visited(i),visited(i+1));
    end
    totaldis=totaldis+distance(visited(i+1),visited(1));
    if totaldis<bestdis
        bestdis=totaldis;
        bestroute=visited;
        bestpath=visited_path;
    end
    if totaldis==0
        error("distance zero in pheromon update");
    end
end