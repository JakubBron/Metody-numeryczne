function [xsolution,ysolution,iterations,xtab,xdif] = secant_method(a,b,max_iterations,ytolerance,fun)
% a - lewa granica przedziału poszukiwań miejsca zerowego (x0=a)
% b - prawa granica przedziału poszukiwań miejsca zerowego (x1=b)
% max_iterations - maksymalna liczba iteracji działania metody siecznych
% ytolerance - wartość abs(fun(xsolution)) powinna być mniejsza niż ytolerance
% fun - nazwa funkcji, której miejsce zerowe będzie wyznaczane
%
% xsolution - obliczone miejsce zerowe
% ysolution - wartość fun(xsolution)
% iterations - liczba iteracji wykonana w celu wyznaczenia xsolution
% xtab - wektor z kolejnymi kandydatami na miejsce zerowe, począwszy od x2
% xdiff - wektor wartości bezwzględnych z różnic pomiędzy i-tym oraz (i+1)-ym elementem wektora xtab; xdiff(1) = abs(xtab(2)-xtab(1));

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
