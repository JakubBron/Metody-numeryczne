function [lake_volume, x, y, z, zmin] = zadanie5()
    % Funkcja zadanie5 wyznacza objętość jeziora metodą Monte Carlo.
    %
    %   lake_volume - objętość jeziora wyznaczona metodą Monte Carlo
    %
    %   x - wektor wierszowy, który zawiera współrzędne x wszystkich punktów
    %       wylosowanych w tej funkcji w celu wyznaczenia obliczanej całki.
    %
    %   y - wektor wierszowy, który zawiera współrzędne y wszystkich punktów
    %       wylosowanych w tej funkcji w celu wyznaczenia obliczanej całki.
    %
    %   z - wektor wierszowy, który zawiera współrzędne z wszystkich punktów
    %       wylosowanych w tej funkcji w celu wyznaczenia obliczanej całki.
    %
    %   zmin - minimalna dopuszczalna wartość współrzędnej z losowanych punktów
    N = 1e6;
    zmin = -45;
    x = 100*rand(1,N); % [m]
    y = 100*rand(1,N); % [m]
    z = zmin*rand(1,N);
    lake_volume = 0;

    for i = 1:N
        depth = get_lake_depth(x(i), y(i));
        if z(i) >= depth
            lake_volume = lake_volume + 1;
        end
    end
    lake_volume = 100 * 100*abs(zmin)*lake_volume/N;

end