function velocity_delta = rocket_velocity(t)
% velocity_delta - różnica pomiędzy prędkością rakiety w czasie t oraz zadaną prędkością M
% t - czas od rozpoczęcia lotu rakiety dla którego ma być wyznaczona prędkość rakiety
M = 750; % [m/s]
m0 = 150000; % [kg]
g = 1.622; % [m/s^2]
u = 2000; % [m/s]
q = 2700; % [kg/s]

if t <= 0
    error('t must be > 0!');
end

% log(x) = ln(x)
v = u * log( m0 / (m0 - q*t) )  - g*t;
velocity_delta = v - M;


end
