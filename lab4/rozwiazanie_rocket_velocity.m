a = 1;
b = 50;
ytolerance = 1e-12;
max_iterations = 100;

[time_bisection,~,iterations_bisection,xtab_bisection,xdif_bisection] = bisection_method(a,b,max_iterations, ytolerance, @rocket_velocity);
[time_secant,~,iterations_secant,xtab_secant,xdif_secant] = secant_method(a,b,max_iterations, ytolerance, @rocket_velocity);

figure
subplot(2,1,1);
plot(xtab_bisection);
hold on
plot(xtab_secant);
hold off
xlabel('iteration')
ylabel('time change')
title('Bisection/Secant time change')
legend({'Bisection', 'Secant'}, 'Location', 'eastoutside')

subplot(2,1,2);
semilogy(xdif_bisection);
hold on
semilogy(xdif_secant);
hold off
xlabel('iteration')
ylabel('time difference')
title('Approximations using bisection/secant method')
legend({'Bisection', 'Secant'}, 'Location', 'eastoutside')
saveas(gcf,'z_4_6.png');



function velocity_delta = rocket_velocity(t)
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


function [xsolution,ysolution,iterations,xtab,xdif] = bisection_method(a,b,max_iterations,ytolerance,fun)
xsolution = [];
ysolution = [];
iterations = [];
xtab = [];
xdif = [];
for i = 1:max_iterations
    xtab = [xtab; (a+b)/2];       % xtab(i) = ci = middle of searched area [a,b]
    if i > 1
        xdif = [xdif; abs(xtab(i) - xtab(i-1))];
    end
    if abs(fun(xtab(i))) < ytolerance || abs(b-a) < ytolerance
        xsolution = xtab(i);
        ysolution = fun(xsolution);
        iterations = i;
        break;
    end
    if fun(a) * fun(xtab(i)) < 0
        b = xtab(i);
    else
        a = xtab(i);
    end
end
end

function [xsolution,ysolution,iterations,xtab,xdif] = secant_method(a,b,max_iterations,ytolerance,fun)
xsolution = [];
ysolution = [];
iterations = [];
xtab = [];
xdif = [];
for i = 1:max_iterations
    xtab = [xtab; b - fun(b) * (b - a) / (fun(b) - fun(a))];       
    % deriviative approximation, f'(x0) = a (angular coefficient) ~= delta_y / delta_x (when 2 points given a line goes through them).
    % next point is x_{k+1} =  x_k - f(x_k) / f'(x_k) = x_k - f(x_k) * (x_k - x_{k-1}) / (f(x_k) - f(x_{k-1}))
    % so x_{k+1} = x_k - f(x_k) * (x_k - x_{k-1}) / (f(x_k) - f(x_{k-1}))
    % here, x_k = b, x_{k-1} = a
    if i > 1
        xdif = [xdif; abs(xtab(i)-xtab(i-1))];
    end
    if abs(fun(xtab(i))) < ytolerance
        xsolution = xtab(i);
        ysolution = fun(xsolution);
        iterations = i;
        break;
    end
    a = b;
    b = xtab(i);
end
end
