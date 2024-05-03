function impedance_delta = impedance_magnitude(omega)

R = 525;
C = 7 * 10^(-5);
L = 3;
M = 75; % docelowa wartość modułu impedancji

if omega <= 0
    error("Omega should be > 0!");
end

denominator = sqrt( 1/R^2 + (omega*C - 1/(omega*L) )^2 )

Z = 1 / denominator;


impedance_delta = Z - M;
end
