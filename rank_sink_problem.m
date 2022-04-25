% This script illustrates the problem of rank sink on a toy network.

clear, close, clc;

nNodes = 6;
nodes = {'1' '2' '3' '4' '5' '6'};
pInitial = (1/nNodes)*ones(1,nNodes);
eps = 1e-5;

%% %% PageRank Vector Iterates Using Hyperlink Matrix H

H = [0 1/2 1/2  0 0 0 ; 0 0 0 0 0 0 ; ...
    1/3 1/3 0 0 1/3 0 ; 0 0 0 0 1/2 1/2 ; ...
    0 0 0 1/2 0 1/2 ; 0 0 0 1 0 0];

graph = digraph(H,nodes);
figure
plot(graph,'Layout','force');
title("Network given by H")

fprintf("Iterates using H :-\n");
fprintf("-------------------------------------------------\n");

for i = 1:nNodes
    fprintf("Node %d  ", i);
end
fprintf("\n");

fprintf("-------------------------------------------------\n");

for i = 1:nNodes
    fprintf("%.4f  ", pInitial(i));
end
fprintf("\n");

%{
nSteps = 3;
for i = 1:nSteps
    p = pInitial*adjMat;
    for j = 1:nNodes
        fprintf("%.4f  ", p(j));
    end
    fprintf("\n");
end
%}

%
while true
   
    p = pInitial*H;

    for i = 1:nNodes
        fprintf("%.4f  ", p(i));
    end
    fprintf("\n");

    if norm(p - pInitial) < eps
        break;
    else
        pInitial = p;
    end

end
%}

%{
Page 4,5 and 6 accumulate more and more PageRank at each iteration.,
monopolizing the scores and refusing to share.
%}

%% PageRank Vector Iterates Using Google Matrix G

pInitial = (1/nNodes)*ones(1,nNodes);
p = 0;
dampFact = 0.15;

danglingIndex = find(sum(H,2) == 0);
nDanglingNodes = length(danglingIndex);
a = zeros(nNodes,1);
a(danglingIndex) = 1;

G = dampFact*H + dampFact*((1/nNodes)*a*ones(1,nNodes)) + (1-dampFact)*(1/nNodes)* ...
    ones(nNodes,1)*ones(1,nNodes);

graph = digraph(G,nodes);
figure
plot(graph,'Layout','force');
title("Network given by G")


fprintf("-------------------------------------------------\n");
fprintf("Iterates using G :-\n");
fprintf("-------------------------------------------------\n");

for i = 1:nNodes
    fprintf("Node %d  ", i);
end
fprintf("\n");

fprintf("-------------------------------------------------\n");

while true
   
    p = pInitial*G;

    for i = 1:nNodes
        fprintf("%.4f  ", p(i));
    end
    fprintf("\n");

    if norm(p - pInitial) < eps
        break;
    else
        pInitial = p;
    end

end

%{
We notice, the problem of rank sink has declined. It shows that hyperlinks
reduce the amount of PageRank captured by rank sinks.
%}


