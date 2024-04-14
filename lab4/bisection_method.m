function [xsolution,ysolution,iterations,xtab,xdif] = bisection_method(a,b,max_iterations,ytolerance,fun)
% a - lewa granica przedziału poszukiwań miejsca zerowego
% b - prawa granica przedziału poszukiwań miejsca zerowego
% max_iterations - maksymalna liczba iteracji działania metody bisekcji
% ytolerance - wartość abs(fun(xsolution)) powinna być mniejsza niż ytolerance
% fun - nazwa funkcji, której miejsce zerowe będzie wyznaczane
%
% xsolution - obliczone miejsce zerowe
% ysolution - wartość fun(xsolution)
% iterations - liczba iteracji wykonana w celu wyznaczenia xsolution
% xtab - wektor z kolejnymi kandydatami na miejsce zerowe, począwszy od xtab(1)= (a+b)/2
% xdiff - wektor wartości bezwzględnych z różnic pomiędzy i-tym oraz (i+1)-ym elementem wektora xtab; xdiff(1) = abs(xtab(2)-xtab(1));

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
