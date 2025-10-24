#include <iostream>
#include <vector>
#include <cmath>
#include <iomanip>
#include <cstdlib>  // for std::atof

// Function f(x) = sin(a * x)
double f(double x, double a) {
    return std::sin(a * x);
}

// Function g(x) = cos(b * x)
double g(double x, double b) {
    return std::cos(b * x);
}

// Print table of x, f(x), g(x)
void print_table(const std::vector<double>& x, const std::vector<double>& f_x, const std::vector<double>& g_x) {
    printf("%10s %10s %10s\n", "x", "f(x)", "g(x)");
    for (int i = 0; i < 101; i++) {
        printf("%10.3f %10.3f %10.3f\n", x[i], f_x[i], g_x[i]);
    }
}

int main(int argc, char* argv[]) {
    // Expect 2 command-line arguments: a and b
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <a> <b>\n";
        return 1;
    }

    double a = std::atof(argv[1]);  // multiplier for sin
    double b = std::atof(argv[2]);  // multiplier for cos

    std::vector<double> x(101), f_x(101), g_x(101);
    double step = 10.0 / 101.0;

    for (int i = 0; i < 101; i++) {
        double x_i = -5.0 + step * i;
        x[i] = x_i;
        f_x[i] = f(x_i, a);
        g_x[i] = g(x_i, b);
    }

    print_table(x, f_x, g_x);
    return 0;
}

