function plot_counts_mean(counts_mean)

axis equal;
plot(counts_mean);
xlabel('i-th circle');
ylabel('Average no. of attempts');
title('Average number of attempts while generating circles');

print -dpng zadanie5.png 