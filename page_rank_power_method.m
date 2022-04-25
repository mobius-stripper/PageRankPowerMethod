clear, close, clc;

% ------------------------
% Loading the data
% ------------------------

% load('Data Sets/wiki-Vote.mat')
% load('Data Sets/soc-Epinions1.mat')
 load('Data Sets/soc-LiveJournal1.mat')

adjMat = Problem.A;

nNodes = size(adjMat,1);
fprintf("Size of adjMat = %d * %d\n", nNodes, nNodes);

% ------------------------
% Checking Sparsity
% ------------------------

ratioNonZero = nnz(adjMat)/numel(adjMat);
fprintf("Percentage of non-zero elements in adjMat = %.2f %%\n", ...
    ratioNonZero*100);
fprintf("------------------------\n\n");

% ------------------------
% Cutting out a subset of the network
% ------------------------

sizeNetwork = 200000;
fprintf("Size of network considered = %d\n", sizeNetwork);
H = adjMat(1:sizeNetwork, 1:sizeNetwork);
    % H is the hyperlink matrix. It is a binary matrix stored as a sparse
    % matrix.

% ------------------------
% Checking Sparsity of cut network
% ------------------------

ratioNonZeroH = nnz(H)/numel(H);
fprintf("Percentage of non-zero elements in H = %.2f %%\n", ...
    ratioNonZeroH*100);
fprintf("------------------------\n\n");

% ------------------------
% Plotting the network
% ------------------------

% Visualizing sparsity pattern
spy(H);
title("Sparsity in hyperlink matrix H");

% This takes a lot of time for large sizeNetwork. Ergo, commenting.
%{
figure
graph = digraph(H(1:sizeNetwork,1:sizeNetwork),'omitselfloops');
plot(graph,'Layout','force');
title("Network")
%}

% ------------------------
% Identifying the number of disconnected nodes
% ------------------------

nDisconnectedNodes = length(intersect(find(sum(H,1) == 0) , ...
    find((sum(H,2) == 0).')));
fprintf("Number of disconnected nodes = %d\n", nDisconnectedNodes);

% ------------------------
% Identifying the dangling nodes and storing this info in vector 'a'
% ------------------------

danglingIndex = find(sum(H,2) == 0);
nDanglingNodes = length(danglingIndex);
% disp(nDanglingNodes);
% disp(size(a));
fprintf("Number of dangling nodes = %d\n", nDanglingNodes);
fprintf("------------------------\n\n");
a = sparse(danglingIndex,ones(1,1),ones(1,1),sizeNetwork,1);

% ------------------------
% Converting the hyperlink matrix H to a probability matrix
% ------------------------

nonZeroIndex = setdiff((1:sizeNetwork).',danglingIndex);
H(nonZeroIndex.',:) = H(nonZeroIndex.',:)./sum(H(nonZeroIndex.',:),2);

% ------------------------
% Damping factor
% ------------------------

dampFact = 0.15;

% ------------------------
% We will now use Power Method to compute left eigen vector of G
% corresponding to eigen-value 1
% ------------------------

pInitial = (1/sizeNetwork)*ones(1,sizeNetwork);
eps = 1e-5;
ctr = 1; % As one run is guaranteed

fprintf("Calculating left eigen vector corresponding to eigen-value 1 of" + ...
    " Google Matrix G\n\n");

tic;
while true

    % p = dampFact*pInitial*H + (dampFact*(pInitial*a) + ...
    % (1 - dampFact)*pInitial*ones(sizeNetwork,1) )*((1/sizeNetwork)* ...
    % ones(1, sizeNetwork));
    % pInitial*ones(sizeNetwork,1) is not needed as we started with from an
    % initial guess whose entries sum to 1 and G is a stochastic matrix.

    p = dampFact*pInitial*H + (dampFact*(pInitial*a) + (1 - dampFact)) ...
        *((1/sizeNetwork)*ones(1, sizeNetwork));

    if norm(p - pInitial, 1) < eps
        break;
    else
        ctr = ctr + 1;
        pInitial = p;
    end

end
time = toc;

fprintf("Number of iterations needed to converge = %d\n", ctr);
fprintf("Time elpased = %.4f\n", time);
fprintf("------------------------\n\n");

% ------------------------
% Finding the highest PageRanked web-page
% ------------------------

[~, pageMaxRank] = max(p);
fprintf("Index of the highest ranking web-page = %d\n", pageMaxRank);

% ------------------------
% Checking if highest ranking web-page is same as the page with most 
% hyperlinks pointed to it
% ------------------------

[~, indexMostLinks] = max(sum(H));
fprintf("Index of the web-page with most inlinks = %d\n", indexMostLinks);

