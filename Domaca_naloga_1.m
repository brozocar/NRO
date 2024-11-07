% 1. Naloga

ime_datoteke_1 = 'naloga1_1.txt';

stevilo_zacetnih_vrstic = 2;

delilec_podatkov = ' ';

t = importdata(ime_datoteke_1, delilec_podatkov, stevilo_zacetnih_vrstic).data();

% 2.1 Naloga

ime_datoteke_2 = 'naloga1_2.txt';
  
 % datoteko odprem za branje -> "r"
fid = fopen(ime_datoteke_2,"r"); 

stevilo_vrstice = fgetl(fid);

 % razdelim prvo vrstico in dobim število podatkov
razdeljena_vrstica = strsplit(stevilo_vrstice, ": ");
stevilo_podatkov = str2double(razdeljena_vrstica(2));

 % pripravim vektor moči (P)
P = zeros(0, stevilo_podatkov);

for i = 1:stevilo_podatkov
    vrstica = fgetl(fid);
    P(i) = str2double(vrstica);
end

 % zaprem datoteko
fclose(fid);

% 2.2 Naloga -> izris grafa P(t)

plot(t, P);
title("Graf P(t)");
xlabel("t[s]");
ylabel("P[W]");
axis([0, max(t)*1.1, 0, max(P)*1.1]);

% 3. Naloga

 % integracija s trapezno metodo (lastna koda)
integral = 0;
for i = 1:(stevilo_podatkov-1)
    Dt = t(i+1) - t(i); 
    clen = Dt/2 * (P(i) + P(i+1));
    integral = integral + clen;
end

 % primerjava s funkcijo trapz
odstopanje = trapz(t,P)-integral;
