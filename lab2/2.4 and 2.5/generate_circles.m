function [circles, index_number, circle_areas, rand_counts, counts_mean] = generate_circles(a, r_max, n_max)
index_number = 193208; % numer Twojego indeksu
L1 = 8;
L2 = 0;

circles = zeros(n_max, 3);
circle_areas = zeros(1, n_max);
rand_counts = zeros(1, n_max);
counts_mean = zeros(1, n_max);
counter = 0;
round_counter = 0;
while counter < n_max
    round_counter = round_counter + 1;
    x = rand() * a;
    y = rand() * a;
    r = rand() * r_max;
    
    circle = [x;y;r];
    isValidCircle = 0;
    if x - r >= 0 && x + r <= a && y - r >= 0 && y + r <= a
        isValidCircle = 1;
    end 

    if isValidCircle
        isOverlap = false;
        for j = 1:counter
            prevCircle = circles(j, :);
            prevX = prevCircle(1);
            prevY = prevCircle(2);
            prevR = prevCircle(3);
                
            distance = sqrt((x - prevX)^2 + (y - prevY)^2);
            if distance <= r + prevR
                isOverlap = true;
                break;
            end
        end
            
        if ~isOverlap
            counter = counter + 1;
            circles(counter, :) = circle;
            circle_areas(counter) = circle(3)^2 * pi;
            rand_counts(counter) = round_counter;
            round_counter = 0;
        end
    end
end

circle_areas = cumsum(circle_areas);
for i = 1:n_max
    counts_mean(i) = mean(rand_counts(1:i));
end
