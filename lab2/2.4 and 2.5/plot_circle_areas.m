function plot_circle_areas(circle_areas)

% label, ylabel, title
axis equal;
plot(circle_areas);
xlabel('Circle Index');
ylabel('Area');
title('Circle Areas');


print -dpng zadanie3.png 