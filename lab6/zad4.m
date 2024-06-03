function [country, source, degrees, x_coarse, x_fine, y_original, y_yearly, y_approximation, mse, msek] = zadanie4(energy)
% Głównym celem tej funkcji jest wyznaczenie danych na potrzeby analizy dokładności aproksymacji wielomianowej.
% 
% energy - struktura danych wczytana z pliku energy.mat
% country - [String] nazwa kraju
% source  - [String] źródło energii
% x_coarse - wartości x danych aproksymowanych
% x_fine - wartości, w których wyznaczone zostaną wartości funkcji aproksymującej
% y_original - dane wejściowe, czyli pomiary produkcji energii zawarte w wektorze energy.(country).(source).EnergyProduction
% y_yearly - wektor danych rocznych
% y_approximation - tablica komórkowa przechowująca wartości nmax funkcji aproksymujących dane roczne.
%   - nmax = length(y_yearly)-1
%   - y_approximation{1,i} stanowi aproksymację stopnia i
%   - y_approximation{1,i} stanowi wartości funkcji aproksymującej w punktach x_fine
% mse - wektor mający nmax wierszy: mse(i) zawiera wartość błędu średniokwadratowego obliczonego dla aproksymacji stopnia i.
%   - mse liczony jest dla aproksymacji wyznaczonej dla wektora x_coarse
% msek - wektor mający (nmax-1) wierszy: msek zawiera wartości błędów różnicowych zdefiniowanych w treści zadania 4
%   - msek(i) porównuj aproksymacje wyznaczone dla i-tego oraz (i+1) stopnia wielomianu
%   - msek liczony jest dla aproksymacji wyznaczonych dla wektora x_fine

country = 'Poland';
source = 'Coal';
degrees = [1, 2, 3, 4];
x_coarse = [];
x_fine = [];
y_original = [];
y_yearly = [];
y_approximation = [];
mse = [];
msek = [];

% Sprawdzenie dostępności danych
if isfield(energy, country) && isfield(energy.(country), source)
    % Przygotowanie danych do aproksymacji
    dates = energy.(country).(source).Dates;
    y_original = energy.(country).(source).EnergyProduction;

    % Obliczenie danych rocznych
    n_years = floor(length(y_original) / 12);
    y_cut = y_original(end-12*n_years+1:end);
    y4sum = reshape(y_cut, [12 n_years]);
    y_yearly = sum(y4sum,1)';

    % degrees = 

    N = length(y_yearly);
    P = (N-1)*10+1;
    x_coarse = linspace(-1, 1, N)';
    x_fine = linspace(-1, 1, P)';

    % Pętla po wielomianach różnych stopni
    for i = 1:N-1
        p = my_polyfit(x_coarse, y_yearly, i);
        y_approximation{i} = polyval(p, x_fine);
        y_coarse = polyval(p, x_coarse);
        mse(i) = mean((y_yearly - y_coarse).^2);

        if i > 1
            msek(i-1) = mean((y_approximation{i} - y_approximation{i-1}).^2);
        end
    end

    mse = mse';
    msek = msek';

    subplot(3,1,1);
    plot(x_coarse, y_yearly, 'DisplayName', 'Dane oryginalne');
    hold on
    for i = 1:length(degrees)
        plot(x_fine, y_approximation{degrees(i)}, 'DisplayName', string(degrees(i)))
    end
    hold off
    xlabel('x')
    ylabel('Produkcja energii [TWh]')
    title(['Produkcja energii elektrycznej w kraju: ', country, ', źródło: ', source])
    legend('location', 'eastoutside');

    subplot(3,1,2);
    semilogy(mse);
    xlabel('Stopień wielomianu');
    ylabel('Błąd średniokwadratowy (log)');
    title('Błąd średniokwadratowy aproksymacji (MSE)');

    subplot(3,1,3);
    semilogy(msek);
    xlabel('Stopień wielomianu');
    ylabel('Błąd różnicowy (log)');
    title('Błąd różnicowy aproksymacji (MSEK)');

    saveas(gcf, 'zadanie4.png');
else
    disp(['Dane dla (country=', country, ') oraz (source=', source, ') nie są dostępne.']);
end

end

function p = my_polyfit(x, y, deg)
    X = zeros(length(x), deg + 1);

    for i = 0:deg
        X(:, deg-i+1) = x.^i;
    end
    
    p = (X'*X)\(X'*y);
end