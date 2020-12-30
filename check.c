#include <stdio.h>
#include <ctype.h>
#include <math.h>
int main()
{
    double x1, x2, x3, x4, x5;
    double f, f1, f2, f3, f4, f5;

    x1 = 2;
    x2 = 5;
    f = log(x1) + x1 * x2 - sin(x2);
    f1 = 1 / x1 + x2;
    f2 = x1 - cos(x2);
    printf("样例1：f(x1=2,x2=5):ln(x1)+x1*x2-sin(x2)\n");
    printf("手动计算结果：\n");
    printf("val = %.6g\n", f);
    printf("f-PDF@x1 = %.6g\n", f1);
    printf("f-PDF@x2 = %.6g\n", f2);
    printf("\n");
    /*
    样例1：f(x1=2,x2=5):ln(x1)+x1*x2-sin(x2)
    手动计算结果：
    val = 11.65207145
    f-PDF@x1 = 5.5
    f-PDF@x2 = 1.71634
    */
    x1 = 2;
    x2 = 3;
    f = exp(sin(x1)) + pow(x2, x2) + x1 * pow(x2, 2);
    f1 = cos(x1) * exp(sin(x1)) + pow(x2, 2);
    f2 = (log(x2) + 1) * pow(x2, x2) + 2 * x1 * x2;
    printf("样例2：f(x1=2,x2=3):exp(sin(x1))+x2^x2+x1*x2^2\n");
    printf("手动计算结果：\n");
    printf("val = %.6g\n", f);
    printf("f-PDF@x1 = %.6g\n", f1);
    printf("f-PDF@x2 = %.6g\n", f2);
    printf("\n");
    /*
    样例2：f(x1=2,x2=3):exp(sin(x1))+x2^x2+x1*x2^2
    手动计算结果：
    val = 47.4826
    f-PDF@x1 = 7.96688
    f-PDF@x2 = 68.6625
    */
    x1 = 2;
    x2 = 3;
    x3 = 4;
    x4 = 5;
    x5 = 6;
    f = exp(sin(x1)) + pow(x2, x2) + pow(x3, 2) + pow(4, x4) + log(x3 * x4) + pow(cos(log(2.5 * x5)), 2);
    f1 = cos(x1) * exp(sin(x1));
    f2 = pow(x2, x2) * (log(x2) + 1);
    f3 = 2 * x3 + x4 * (1 / (x3 * x4));
    f4 = pow(4, x4) * log(4) + x3 * (1 / (x3 * x4));
    f5 = 2 * cos(log(2.5 * x5)) * (-sin(log(2.5 * x5))) * (1 / (2.5 * x5)) * 2.5;
    printf("样例3：f(x1=2,x2=3,x3=4,x4=5,x5=6):exp(sin(x1))+x2^x2+x3^2+4^x4+ln(x3*x4)+(cos(ln(2.5*x5)))^2\n");
    printf("手动计算结果：\n");
    printf("val = %.6g\n", f);
    printf("f-PDF@x1 = %.6g\n", f1);
    printf("f-PDF@x2 = %.6g\n", f2);
    printf("f-PDF@x3 = %.6g\n", f3);
    printf("f-PDF@x4 = %.6g\n", f4);
    printf("f-PDF@x5 = %.6g\n\n", f5);
    /*
    样例3：f(x1=2,x2=3,x3=4,x4=5,x5=6):exp(sin(x1))+x2^x2+x3^2+4^x4+ln(x3*x4)+(cos(ln(2.5*x5)))^2
    手动计算结果：
    val = 1073.3
    f-PDF@x1 = -1.03312
    f-PDF@x2 = 56.6625
    f-PDF@x3 = 8.25
    f-PDF@x4 = 1419.77
    f-PDF@x5 = 0.127074
    */
    x1 = 2;
    x2 = 5;
    f = pow(x1, 2) + x1 * x2;
    f1 = 2 * x1 + x2;
    f2 = x1;
    printf("样例4：f(x1=2,x2=5):x1^2+x1*x2\n");
    printf("手动计算结果：\n");
    printf("val = %.6g\n", f);
    printf("f-PDF@x1 = %.6g\n", f1);
    printf("f-PDF@x2 = %.6g\n", f2);
    printf("\n");
    /*
    样例4：f(x1=2,x2=5):x1^2+x1*x2
    手动计算结果：
    val = 14
    f-PDF@x1 = 9
    f-PDF@x2 = 2
    */
    return 0;
}
