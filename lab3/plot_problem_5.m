function plot_problem_5(N, time_Jacobi, time_Gauss_Seidel, iterations_Jacobi, iterations_Gauss_Seidel)
    subplot(2,1,1);
    plot(N, time_Jacobi);
    hold on;
    plot(N, time_Gauss_Seidel);
    hold off;
    title 'Czas wykonania metody względem wielkości danych'
    xlabel 'Wielkość macierzy'
    ylabel 'Czas obliczania metodą'
    legend({'Jacobi', 'Gauss-Seidel'}, 'Location', 'eastoutside')
    subplot(2,1,2);
    bar(N, horzcat(iterations_Jacobi', iterations_Gauss_Seidel'))
    title 'Ilość iteracji względem wielkości danych'
    xlabel 'Wielkość macierzy'
    ylabel 'Ilość iteracji'
    legend({'Jacobi', 'Gauss-Seidel'}, 'Location', 'eastoutside')
    
    saveas(gcf, 'zadanie5.png')
end