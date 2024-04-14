function plot_direct(N,vtime_direct)
    % N - wektor zawierający rozmiary macierzy dla których zmierzono czas obliczeń metody bezpośredniej
    % vtime_direct - czas obliczeń metody bezpośredniej dla kolejnych wartości N

    figure;
    plot(N,vtime_direct,'-o');
    title('Czas obliczeń metody bezpośredniej');
    xlabel('Rozmiar macierzy N');
    ylabel('Czas obliczeń [s]');
    grid on;
    saveas(gcf,'zadanie2.png');
end