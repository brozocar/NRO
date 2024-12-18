#define _USE_MATH_DEFINES
#include <cmath>
#include <iostream>


//ArcTan in Taylorjeva vrsta

double arctan(double* x, int * N_steps) {
    double resitev = 0.0;
    for (int k = 0; k < *N_steps; ++k) {
        resitev += pow(-1, k) * pow(*x, 2 * k + 1) / (2 * k + 1);
    }
    return resitev;
}

double integral(double x) {
    return exp(3 * x) * arctan(new double(x / 2), new int(10));
}

//Trapezna metoda

double trapezna_metoda(double x1, double x2, int k) {
    double diferencial = (x2 - x1) / k;
    double suma = 0.5 * (integral(x1) + integral(x2));

    for (int i = 1; i < k; ++i) {
        double r = x1 + i * diferencial;
        suma += integral(r);
    }

    return diferencial * suma;
}

//Izpis vrednosti

int main() {
    double sp = 0.0, zg = M_PI / 4;
    int delitev = 10000;

    double resitev = trapezna_metoda(sp, zg, delitev);

    std::cout << "Aproksimirana vrednost integrala: " << resitev <<" .";

    return 0;
}