% This script shows how the matrix H does not necessarily guarantee
% convergence

clear, close, clc;

H = [0 1 ; 1 0];
Nodes = {'1' '2'};
G = digraph(H,Nodes);
plot(G,'Layout','force');

pInitial = [1 0];
eps = 1e-5;

fprintf("Iterates :-\n");
fprintf("-------------------------------------------------\n");
fprintf("Node %d    Node %d\n", 1, 2);
fprintf("-------------------------------------------------\n");

% This will be an infinite loop.
while true

    p = pInitial*H;
    fprintf("%.4f   %.4f\n", p(1), p(2));

    if norm(p - pInitial) < eps
        break;
    else
        pInitial = p;
    end

end

