% zadanie 1
N = 100;
[A,b,x,time_direct,err_norm,index_number] = solve_direct(N);

% zadanie 2
N = 1000:1000:8000;
n = length(N);
vtime_direct = ones(1,n); 
for i = 1:n                 % wywolanie funkcji dla kazdego z rozmiarow macierzy od 1000x1000 do 8000x8000 co 1000
    [A,b,x,vtime_direct(i),err_norm,index_number] = solve_direct(N(i));
end
plot_direct(N,vtime_direct);


% zadanie 3
N = 100;
[A,b,M,bm,x,err_norm,time,iterations,index_number] = solve_Jacobi(N);


% zadanie 4
N = 100;
[A,b,M,bm,x,err_norm,time,iterations,index_number] = solve_Gauss_Seidel(N);

% zadanie 5
N = 1000:1000:8000;
n = length(N);
time_Jacobi = ones(1,n);
time_Gauss_Seidel = 2*ones(1,n);
iterations_Jacobi = 40*ones(1,n);
iterations_Gauss_Seidel = 40*ones(1,n);

for i = 1:n
    [A,b,M,bm,x,err_norm,time_Jacobi(i),iterations_Jacobi(i),index_number] = solve_Jacobi(N(i));
    [A,b,M,bm,x,err_norm,time_Gauss_Seidel(i),iterations_Gauss_Seidel(i),index_number] = solve_Gauss_Seidel(N(i));
end

plot_problem_5(N,time_Jacobi,time_Gauss_Seidel,iterations_Jacobi,iterations_Gauss_Seidel);