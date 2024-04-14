clear all
close all
format compact

n_max = 200;
a = 10;
r_max = a / 2;

[circles, index_number, circle_areas] = generate_circles(a, r_max, n_max);
plot_circle_areas(circle_areas);
