function [A,b,M,bm,x,err_norm,time,iterations,index_number] = solve_Jacobi(N)
% A - macierz z równania macierzowego A * x = b
% b - wektor prawej strony równania macierzowego A * x = b
% M - macierz pomocnicza opisana w instrukcji do Laboratorium 3 – sprawdź wzór (5) w instrukcji, który definiuje M jako M_J.
% bm - wektor pomocniczy opisany w instrukcji do Laboratorium 3 – sprawdź wzór (5) w instrukcji, który definiuje bm jako b_{mJ}.
% x - rozwiązanie równania macierzowego
% err_norm - norma błędu residualnego wyznaczona dla rozwiązania x; err_norm = norm(A*x-b)
% time - czas wyznaczenia rozwiązania x
% iterations - liczba iteracji wykonana w procesie iteracyjnym metody Jacobiego
% index_number - Twój numer indeksu
index_number = 193208;
L1 = 8;

[A,b] = generate_matrix(N,L1);
x = ones(N,1);                      % wektor początkowy Nx1, z założeń startowych zawiera same jedynki
M = [];
bm = [];
time = [];
iterations = 1000;
accuracy = 1E-12;
err_norm = 21372137;
iterations = 0;

L = tril(A,-1);
U = triu(A,1);
D = diag(diag(A));                  % diagonalna macierz z elementami z diagonali macierzy A -> m. kwadratowa

tic;
while err_norm > 10^-12
    if iterations > 1000
        break;
    end
    M = -inv(D)*(L+U);              % moge odwrocic macierz D, bo jest to macierz diagonalna
    bm = inv(D)*b;
    x = M*x + bm;
    
    err_norm = norm(A*x-b);
    iterations = iterations + 1;
end
time = toc;                         % mierzy czas wyznaczenia rozwiazania x
err_norm = norm(A*x-b);             % oblicza norme bledu residualnego
end
