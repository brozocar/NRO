% Najprej uvozimo podatke iz dokumentov

podatki = readmatrix("vozlisca_temperature_dn2.txt", "NumHeaderLines",4);
x = podatki(:,1);
y = podatki(:,2);
T = podatki(:,3);

celice = readmatrix("celice_dn2.txt", "NumHeaderLines",2);

% Temperaturo računamo pri naslednjih vrednostih:

x_r = 0.403;
y_r = 0.503;

% 1. Uporaba funkcije scatteredInterpolant

tic;
F1 = scatteredInterpolant(x, y, T, "linear");
T1 = F1(x_r, y_r);
cas_1 = toc;

% 2. Uporaba funkcije griddedInterpolant

x_bp = unique(x);
y_bp = unique(y);
[X, Y] = ndgrid(x_bp, y_bp); 
matrika = reshape(T, length(x_bp), length(y_bp));
tic;
F2 = griddedInterpolant(X, Y, matrika, "linear");
T2 = F2(x_r, y_r);
cas_2 = toc;

% 3. Uporaba lastne funkcije za bilinearno interpolacijo

tic; 
%cell_found = false; % Spremenljivka za preverjanje, ali smo našli celico

for i = 1:size(celice, 1)

    % Preberemo indekse celice

    pt1 = celice(i, 1);
    pt2 = celice(i, 2);
    pt3 = celice(i, 3);
    pt4 = celice(i, 4);

    % Koordinate in temperature na vogalih celice

    x1 = x(pt1);
    y1 = y(pt1);
    T11 = T(pt1);

    x2 = x(pt2);
    y2 = y(pt2);
    T21 = T(pt2);

    x3 = x(pt3);
    y3 = y(pt3);
    T22 = T(pt3);

    x4 = x(pt4);
    y4 = y(pt4);
    T12 = T(pt4);

    % Preverimo, ali je točka znotraj celice

    if x_r >= x1 && x_r <= x2 && y_r >= y1 && y_r <= y3

        % Bilinearna interpolacija po x-osi

        K1 = (x2 - x_r) / (x2 - x1) * T11 + (x_r - x1) / (x2 - x1) * T21;
        K2 = (x2 - x_r) / (x2 - x1) * T12 + (x_r - x1) / (x2 - x1) * T22;

        % Bilinearna interpolacija po y-osi

        T3 = (y3 - y_r) / (y3 - y1) * K1 + (y_r - y1) / (y3 - y1) * K2;
        break;
    end
end

cas_3 = toc;

% Določimo največjo temperaturo in vozlišče, v katerem se pojavi

T_max = max(T);
indeks = find(T==T_max);
x_max = x(indeks);
y_max = y(indeks);

% Izpis rezultatov

fprintf('Bilinearna interpolacija: T = %.8f (čas izračuna: %.6f s)\n', T3, cas_3);
fprintf('Interpolacija s scatteredInterpolant: T = %.8f (čas izračuna: %.6f s)\n', T1, cas_1);
fprintf('Interpolacija s griddedInterpolant: T = %.8f (čas izračuna: %.6f s)\n', T2, cas_2);
fprintf('Največja temperatura: %.4f \n', T_max);
fprintf('Koordinate pripadajočega vozlišča: (%.2f, %.2f)\n', x_max, y_max);