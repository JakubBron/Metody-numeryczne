function [numer_indeksu, Edges, I, B, A, b, r] = page_rank()
numer_indeksu = 193208;
d = 0.85;
N = 8;
L1 = 0;
L2 = 2
% added 8->1 and 3->8
Edges = [1,1,2,2,2,3,3,3,4,4,5,5,6,6,7, 8,           mod(L2, 7)+1;
         4,6,3,4,5,5,6,7,5,6,4,6,4,7,6, mod(L1,7)+1, 8           ];
I = speye(N);
B = sparse(Edges(2, :), Edges(1,:), 1, N, N);
A = spdiags(1./sum(B)', 0, N, N);     % 0 = main diagonal

b = zeros(N, 1);
b(:, 1) = (1-d)/N;
M = sparse(I - d*B*A)
% Mr = b   | * M^(-1)
% M * M^(-1) * r = r = b * M(-1) = M\b
r = M\b;

