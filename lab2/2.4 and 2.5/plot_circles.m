function [] = plot_circles(a, circles, index_number);

axis equal;
axis([0 a 0 a]);
hold on;
for i = 1:length(circles)
    circle = circles(i, :);  % [X, Y, R]
    plot_circle(circle(3), circle(1), circle(2));
    % pause(0.1) 
end
hold off