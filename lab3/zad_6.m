% Zadanie 6
load("filtr_dielektryczny.mat");
max_iterations = 1000;
accuracy = 1E-12;
N = length(b);

time_direct = [];
err_norm_direct = [];
time_Jacobi = [];
err_norm_Jacobi = 21372137;
err_norm_Jacobi_tab = zeros(1, max_iterations);
iterations_Jacobi = 0;
time_GS = [];
err_norm_GS = 21372137;
err_norm_GS_tab = zeros(1, max_iterations);
iterations_GS = 0;

% metoda bezposrednia
x = [];
tic;                            % start timera
x = A \ b;                      % wyznaczam rozwiazanie, \ - Matlab sam wybiera metode rozwiazywania
time_direct = toc;              % stop timera
err_norm_direct = norm(A*x-b);
fprintf('Metoda bezposrednia\n');
fprintf('Czas [s]: %f\n', time_direct);
fprintf('Blad: %.15f\n', err_norm_direct);


% metoda Jacobiego
x = ones(N,1);                      % wektor początkowy Nx1, z założeń startowych zawiera same jedynki
M = [];
bm = [];
L = tril(A,-1);
U = triu(A,1);
D = diag(diag(A));
M = -inv(D)*(L+U);              % moge odwrocic macierz D, bo jest to macierz diagonalna
bm = inv(D)*b;
tic;
for i=1:max_iterations
    x = M*x + bm;
    err_norm_Jacobi = norm(A*x-b);
    err_norm_Jacobi_tab(i) = err_norm_Jacobi;
    iterations_Jacobi = iterations_Jacobi + 1;
    if (err_norm_Jacobi < accuracy || isinf(err_norm_Jacobi))
        break
    end
end
time_Jacobi = toc;                         % mierzy czas wyznaczenia rozwiazania x
err_norms_Jacobi_tab = resize(err_norm_Jacobi_tab, iterations_Jacobi);
fprintf('Metoda Jacobiego\n');
fprintf('Czas [s]: %f\n', time_Jacobi);
fprintf('Blad: %.15f\n', err_norm_Jacobi);
fprintf('Liczba iteracji: %d / %d\n', iterations_Jacobi, max_iterations);

% metoda Gaussa-Seidela
L = tril(A,-1);
U = triu(A,1);
D = diag(diag(A));
x = ones(length(b), 1);
M = -1 * ((L+D)\U);
bm = (D + L)\b;

err_norm_GS = Inf;
iterations_GS = 0;
err_norm_GS_tab = zeros(1, max_iterations);
tic
for i=1:max_iterations
    x = M*x + bm;
    iterations_GS = iterations_GS + 1;
    err_norm_GS = norm(A*x-b);
    err_norms_GS_tab(i) = err_norm_GS;
    if (err_norm_GS < accuracy || isinf(err_norm_GS))
        break
    end
end
time_GS = toc;
err_norms_GS_tab = resize(err_norm_GS_tab, iterations_GS);
fprintf('Metoda Gaussa-Seidela\n');
fprintf('Czas [s]: %f\n', time_GS);
fprintf('Blad: %.15f\n', err_norm_GS);
fprintf('Liczba iteracji: %d / %d\n', iterations_GS, max_iterations);

% wykres
plot(err_norm_Jacobi_tab);
ylim([-1000 1000])
hold on;
plot(err_norm_GS_tab);
ylim([-1000 1000])
hold off;
title 'Normy błędu metod iteracyjnych'
xlabel 'Ilość iteracji'
ylabel 'Norma błędu'
legend({'Jacobi', 'Gauss-Seidel'}, 'Location', 'eastoutside')
saveas(gcf, 'zadanie6.png')