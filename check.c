#include <stdio.h>
#include <ctype.h>
#include <math.h>
int main()
{
    double x1 = 2, x2 = 3, x3 = 4, x4 = 5, x5 = 6;
    double f, f1, f2, f3, f4, f5;
    f = exp(sin(x1)) + pow(x2, x2) + pow(x3, 2) + pow(4, x4) + log(x3 * x4) + pow(cos(log(2.5 * x5)), 2);
    f1 = cos(x1) * exp(sin(x1));
    f2 = pow(x2, x2) * (log(x2) + 1);
    f3 = 2 * x3 + x4 * (1 / (x3 * x4));
    f4 = pow(4, x4) * log(4) + x3 * (1 / (x3 * x4));
    f5 = 2 * cos(log(2.5 * x5)) * (-sin(log(2.5 * x5))) * (1 / (2.5 * x5)) * 2.5;
    printf("val = %.6g\n", f);
    printf("f-PDF@x1 = %.6g\n", f1);
    printf("f-PDF@x2 = %.6g\n", f2);
    printf("f-PDF@x3 = %.6g\n", f3);
    printf("f-PDF@x4 = %.6g\n", f4);
    printf("f-PDF@x5 = %.6g\n", f5);
    /*
    val = 1073.3
    f-PDF@x1 = -1.03312
    f-PDF@x2 = 56.6625
    f-PDF@x3 = 8.25
    f-PDF@x4 = 1419.77
    f-PDF@x5 = 0.127074
    */
    return 0;
}
