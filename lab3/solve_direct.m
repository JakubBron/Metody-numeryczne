function [A,b,x,time_direct,err_norm,index_number] = solve_direct(N)
% A - macierz z równania macierzowego A * x = b
% b - wektor prawej strony równania macierzowego A * x = b
% x - rozwiązanie równania macierzowego
% time_direct - czas wyznaczenia rozwiązania x
% err_norm - norma błędu residualnego wyznaczona dla rozwiązania x; err_norm = norm(A*x-b);
% index_number - Twój numer indeksu
index_number = 193208;
L1 = 8;


x = [];
time_direct = [];
[A,b] = generate_matrix(N, L1); % generowanie macierzy A i wektora b
tic;                            % start timera
x = A \ b;                      % wyznaczam rozwiazanie, \ - Matlab sam wybiera metode rozwiazywania
time_direct = toc;              % stop timera

err_norm = norm(A*x-b);
end