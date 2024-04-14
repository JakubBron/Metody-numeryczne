function [A,b,M,bm,x,err_norm,time,iterations,index_number] = solve_Gauss_Seidel(N)
    index_number = 193208;
    L1 = mod(index_number, 10);
    [A,b] = generate_matrix(N, L1);

    x = ones(N, 1);
    err_norm = 21372137;
    iterations = 0;
    L = tril(A, -1);
    D = diag(diag(A));
    U = triu(A,1);
    tic;
    while err_norm > 10^-12
        if iterations > 1000
            break;
        end
        M = -1 * ((L+D)\U);
        bm = (D + L)\b;
        x = M*x + bm;
        iterations = iterations + 1;
        err_norm = norm(A*x-b);
    end
    time = toc;
end