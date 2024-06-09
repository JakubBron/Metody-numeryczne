function [integration_error, Nt, ft_5, integral_1000] = zadanie1()
    % Numeryczne całkowanie metodą prostokątów.
    % Nt - wektor zawierający liczby podprzedziałów całkowania
    % integration_error - integration_error(1,i) zawiera błąd całkowania wyznaczony
    %   dla liczby podprzedziałów równej Nt(i). Zakładając, że obliczona wartość całki
    %   dla Nt(i) liczby podprzedziałów całkowania wyniosła integration_result,
    %   to integration_error(1,i) = abs(integration_result - reference_value),
    %   gdzie reference_value jest wartością referencyjną całki.
    % ft_5 - gęstość funkcji prawdopodobieństwa dla n=5
    % integral_1000 - całka od 0 do 5 funkcji gęstości prawdopodobieństwa
    %   dla 1000 podprzedziałów całkowania

    reference_value = 0.0473612919396179; % wartość referencyjna całki

    Nt = 5:50:10^4;
    integration_error = [];
    for i = 1:length(Nt)
		integration_error(i) = abs(rectanglular_integration(@f, Nt(i)) - reference_value);
	end

    ft_5 = f(5);
    integral_1000 = rectanglular_integration(@f, 1000);

    figure;
    loglog(Nt, integration_error);
    title('Błąd całkowania w zależności od liczby podprzedziałów');
    xlabel('Liczba podprzedziałów całkowania');
    ylabel('Błąd całkowania');
    saveas(gcf, 'zadanie1.png');

end

function d = f(t)
	sigma = 3;
	u = 10;
	d = 1/(sigma*sqrt(2*pi)) * exp(-((t-u).^2)/(2*sigma^2));
end

function result = rectanglular_integration(f, N)
    a = 0;
    b = 5;
    h = (b-a)/N;
    result = 0;
    for i = 1:N
        x = a + (i-1)*h + a + i*h
        result = result + f(x/2);
    end
    result = result*h;
end