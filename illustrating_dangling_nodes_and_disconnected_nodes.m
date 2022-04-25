% This script creates a network with nNodes (>=6) noes and creates dangling
% nodes (rows of all zero) and disconnected nodes (row and column with same
% index being all zero) and plots it.

clear, close, clc;
rng default
nNodes = 7;

A = ones(nNodes);
A = A - diag(diag(A));
index = randperm(nNodes*nNodes);
A(index(1:10)) = 0;

A(2,:) = 0;
A(6,:) = 0;
A(:,6) = 0;

fprintf('H =\n');
disp(A);

G = digraph(A);
plot(G,'Layout','force');