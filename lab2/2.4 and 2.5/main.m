clear all
close all
format compact

n_max = 200;
a = 10;
r_max = a / 2;

[circles, index_number, circle_areas, rand_counts, counts_mean] = generate_circles(a, r_max, n_max);
