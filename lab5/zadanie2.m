function [nodes_Chebyshev, V, V2, original_Runge, interpolated_Runge, interpolated_Runge_Chebyshev] = zadanie2()
% nodes_Chebyshev - wektor wierszowy zawierający N=16 węzłów Czebyszewa drugiego rodzaju
% V - macierz Vandermonde obliczona dla 16 węzłów interpolacji rozmieszczonych równomiernie w przedziale [-1,1]
% V2 - macierz Vandermonde obliczona dla węzłów interpolacji zdefiniowanych w wektorze nodes_Chebyshev
% original_Runge - wektor wierszowy zawierający wartości funkcji Runge dla wektora x_fine=linspace(-1, 1, 1000)
% interpolated_Runge - wektor wierszowy wartości funkcji interpolującej określonej dla równomiernie rozmieszczonych węzłów interpolacji
% interpolated_Runge_Chebyshev - wektor wierszowy wartości funkcji interpolującej wyznaczonej
%       przy zastosowaniu 16 węzłów Czebyszewa zawartych w nodes_Chebyshev 
    N = 16;
    x_fine = linspace(-1, 1, 1000);
    nodes_Chebyshev = get_Chebyshev_nodes(N);

    V = vandermonde_matrix(N);
    V2 = vandermonde_matrix2(nodes_Chebyshev, N);
    original_Runge = arrayfun(@(x) 1/(1 + (25 * x*x)), x_fine);
    interpolation_nodes = linspace(-1, 1, 16);
    values = arrayfun(@(x) 1/(1 + (25 * x * x)), interpolation_nodes);
    c_runge = V \ values';
    interpolated_Runge = polyval(flipud(c_runge), x_fine);
    subplot(2,1,1);
    plot(x_fine, original_Runge);
    hold on;
    plot(x_fine, interpolated_Runge);
    plot(interpolation_nodes, values, 'o');
    title("Standardowe węzły interpolacji");
    xlabel('x');
    ylabel('y');
    legend('original\_runge', 'interpolated\_Runge');
    hold off;

    subplot(2,1,2);
    values = arrayfun(@(x) 1/(1 + (25 * x*x)), nodes_Chebyshev);
    c_runge = V2 \ values';
    interpolated_Runge_Chebyshev = polyval(flipud(c_runge), x_fine);
     plot(x_fine, original_Runge);
    hold on;
    plot(x_fine, interpolated_Runge_Chebyshev);
    plot(nodes_Chebyshev, values, 'o');
    title("Węzły Czebyszewa");
    xlabel('x');
    ylabel('y');
    legend('original\_runge', 'interpolated\_Runge');
    hold off;
    saveas(gcf, 'zadanie2.png');
end

function nodes = get_Chebyshev_nodes(N)
    % oblicza N węzłów Czebyszewa drugiego rodzaju
    nodes = cos( (0:(N-1)) *pi / (N-1) );
end

function V = vandermonde_matrix2(data, N)
    % Generuje macierz Vandermonde dla N równomiernie rozmieszczonych w przedziale [-1, 1] węzłów interpolacji
    V = ones(N, N);
    for i = 1:N
        for j = 0:(N-1)
            V(i,j+1) = power(data(i), j);
        end
    end
end

function V = vandermonde_matrix(N)
    % Generuje macierz Vandermonde dla N równomiernie rozmieszczonych w przedziale [-1, 1] węzłów interpolacji
    x_coarse = linspace(-1,1,N);
    V = ones(N, N);
    for i = 1:N
        for j = 0:(N-1)
            V(i,j+1) = power(x_coarse(i), j);
        end
    end
end