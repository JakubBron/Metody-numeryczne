function [V, original_Runge, original_sine, interpolated_Runge, interpolated_sine] = zadanie1()
    % Rozmiar tablic komórkowych (cell arrays) V, interpolated_Runge, interpolated_sine: [1,4].
    % V{i} zawiera macierz Vandermonde wyznaczoną dla liczby węzłów interpolacji równej N(i)
    % original_Runge - wektor wierszowy zawierający wartości funkcji Runge dla wektora x_fine=linspace(-1, 1, 1000)
    % original_sine - wektor wierszowy zawierający wartości funkcji sinus dla wektora x_fine
    % interpolated_Runge{i} stanowi wierszowy wektor wartości funkcji interpolującej 
    %       wyznaczonej dla funkcji Runge (wielomian stopnia N(i)-1) w punktach x_fine
    % interpolated_sine{i} stanowi wierszowy wektor wartości funkcji interpolującej
    %       wyznaczonej dla funkcji sinus (wielomian stopnia N(i)-1) w punktach x_fine
    N = 4:4:16;
    x_fine = linspace(-1, 1, 1000);
    original_Runge = arrayfun(@(x) 1/(1 + (25 * x*x)), x_fine);

    subplot(2,1,1);
    plot(x_fine, original_Runge);
    hold on;
    for i = 1:length(N)
        V{i} = vandermonde_matrix(N(i));% macierz Vandermonde
        % węzły interpolacji
        interpolation_nodes = linspace(-1, 1, N(i));
        % wartości funkcji interpolowanej w węzłach interpolacji
        values = arrayfun(@(x) 1/(1 + (25 * x * x)), interpolation_nodes);
        c_runge = V{i} \ values'; % współczynniki wielomianu interpolującego

        interpolated_Runge{i} = polyval(flipud(c_runge), x_fine); % interpolacja
        plot(x_fine, interpolated_Runge{i})
    end
    title('Porównanie funkcji Rungego i jej interpolowanych odpowiedników')
    xlabel('x')
    ylabel('y')
    legend('original\_runge', 'interpolated\_runge(4)', 'interpolated\_runge(8)', 'interpolated\_runge(12)', 'interpolated\_runge(16)', 'Location', 'northeastoutside');
    hold off

    original_sine = sin(2 * pi * x_fine);
    subplot(2,1,2);
    plot(x_fine, original_sine);
    hold on;
    for i = 1:length(N)
        interpolation_nodes = linspace(-1, 1, N(i));
        values = sin(2 * pi * interpolation_nodes);
        c_sine = V{i} \ values';
        interpolated_sine{i} = polyval(flipud(c_sine), x_fine);
        plot(x_fine, interpolated_sine{i})
    end
    title('Porównanie funkcji sin(2 * pi * x) i jej interpolowanych odpowiedników')
    xlabel('x')
    ylabel('y')
    legend('original\_sine', 'interpolated\_sine(4)', 'interpolated\_sine(8)', 'interpolated\_sine(12)', 'interpolated\_sine(16)', 'Location', 'northeastoutside');
    hold off

    saveas(gcf, 'zadanie1.png');
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