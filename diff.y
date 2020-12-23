%{
#include <stdio.h>
#include <ctype.h>
#include <math.h>

int yylex();
int yyerror(char *);
double vars[10] = {0.0}; //记录出现了x0到x9的初始值
int i, j;
double aux;
int flag[10] = {0}; //记录出现了x0到x9中的哪些变量
%}

%union
{
    char cv;
    struct
    {
        double val;
        double dval[10];
    } s;
}
%token '(' ')'
%token '+' '-' '*' '/' '^' '='
%token COS SIN LN EXP

%left '='
%left '+' '-'
%left '*' '/'
%left COS SIN LN EXP
%left '^'
%right '(' ')'
%start REV_AutoDiff

%token <s> NUMBER
%token <cv> VAR
%type <s> expr

%%

REV_AutoDiff
    : func_def
        {
            $<s.val>$ = $<s.val>1;
            printf("val = %.6g\n",$<s.val>$);
            for (i = 0; i < 10; i++)
                if (flag[i] == 1)
                {
                   $<s.dval[i]>$ = $<s.dval[i]>1;
                    printf("f-PDF@x%d = %.6g\n", i,$<s.dval[i]>$);
                }
        }
    ;
func_def
    : 'f' '(' var_list ')' ':' expr
        {
            $<s.val>$ = $<s.val>6;
            for (i = 0; i < 10; i++)
                if (flag[i] == 1)
                   $<s.dval[i]>$ = $<s.dval[i]>6;
        }
    ;
var_init
    : VAR '=' NUMBER
        {
            i = $1 - '0';
            if (i >= 0 && i <= 9)
                vars[i] = $<s.val>3;
            else
                vars[0] = $<s.val>3;
            flag[i] = 1;
        }
    ;
var_list
    : var_init
    | var_list ',' var_init
    ;
expr
    : VAR
        {
            i = $1 - '0';
            if (i < 0 || i > 9)
                i = 0;
            $<s.val>$ = vars[i];
            j = i;
            for (i = 0; i < 10; i++)
                if (flag[i] == 1)
                    $<s.dval[i]>$ = 0;
            $<s.dval[j]>$ = 1;
        }
    | NUMBER
        {
            $<s.val>$ = $<s.val>1;
            for (i = 0; i < 10; i++)
                if (flag[i] == 1)
                    $<s.dval[i]>$ = 0;
        }
    | expr '+' expr
        {
            $<s.val>$ = $<s.val>1 + $<s.val>3;
            for (i = 0; i < 10; i++)
                if (flag[i] == 1)
                    $<s.dval[i]>$ = $<s.dval[i]>1 + $<s.dval[i]>3;
        }
    | expr '-' expr
        {
            $<s.val>$ = $<s.val>1 - $<s.val>3;
            for (i = 0; i < 10; i++)
                if (flag[i] == 1)
                    $<s.dval[i]>$ = $<s.dval[i]>1 - $<s.dval[i]>3;
        }
    | expr '*' expr
        {
            $<s.val>$ = $<s.val>1 * $<s.val>3;
            for (i = 0; i < 10; i++)
                if (flag[i] == 1)
                    $<s.dval[i]>$ = $<s.dval[i]>1 * $<s.val>3 + $<s.val>1 * $<s.dval[i]>3;
        }
    | expr '/' expr
        {
            $<s.val>$ = $<s.val>1 / $<s.val>3;
            for (i = 0; i < 10; i++)
                if (flag[i] == 1)
                {
                    aux = $<s.dval[i]>1 * $<s.val>3 - $<s.val>1 * $<s.dval[i]>3;
                    $<s.dval[i]>$ = aux / ($<s.val>3 * $<s.val>3);
                }
        }
    | '-' expr
        {
            $<s.val>$ = - $<s.val>2;
            for (i = 0; i < 10; i++)
                if (flag[i] == 1)
                    $<s.dval[i]>$ = - $<s.dval[i]>2;
        }
    | '(' expr ')'
        {
            $<s.val>$ = $<s.val>2;
            for (i = 0; i < 10; i++)
                if (flag[i] == 1)
                    $<s.dval[i]>$ = $<s.dval[i]>2;
        }
    | expr '^' expr
        {
            $<s.val>$ = pow($<s.val>1, $<s.val>3);
            for (i = 0; i < 10; i++)
                if (flag[i] == 1)
                {
                    {
                        if (fabs($<s.dval[i]>1) <= 1e-15 && fabs($<s.dval[i]>3) <= 1e-15)
                            $<s.dval[i]>$ = 0;
                        else if (fabs($<s.dval[i]>1) <= 1e-15)
                            $<s.dval[i]>$ = $<s.val>$ * log($<s.val>1);

                        else if (fabs($<s.dval[i]>3) <= 1e-15)
                            $<s.dval[i]>$ = $<s.val>3 * pow($<s.val>1, $<s.val>3 - 1) * $<s.dval[i]>1;
                        else
                        {
                            aux = $<s.dval[i]>3 * log($<s.val>1) + ($<s.val>3 / $<s.val>1) * $<s.dval[i]>1;
                            $<s.dval[i]>$ = $<s.val>$ * aux;
                        }
                    }
                }
        }
    | EXP '(' expr ')'
        {
            $<s.val>$ = exp($<s.val>3);
            for (i = 0; i < 10; i++)
                if (flag[i] == 1)
                    $<s.dval[i]>$ = $<s.dval[i]>3 * $<s.val>$;
        }
    | LN '(' expr ')'
        {
            $<s.val>$ = log($<s.val>3);
            for (i = 0; i < 10; i++)
                if (flag[i] == 1)
                    $<s.dval[i]>$ = $<s.dval[i]>3 / $<s.val>3;
        }
    | SIN '(' expr ')'
        {
            $<s.val>$ = sin($<s.val>3);
            for (i = 0; i < 10; i++)
                if (flag[i] == 1)
                    $<s.dval[i]>$ = $<s.dval[i]>3 * cos($<s.val>3);
        }
    | COS '(' expr ')'
        {
            $<s.val>$ = cos($<s.val>3);
            for (i = 0; i < 10; i++)
                if (flag[i] == 1)
                    $<s.dval[i]>$ = - $<s.dval[i]>3 * sin($<s.val>3);
        }
    ;

%%

int yyerror(char *s)
{
    printf("%s\n", s);
    return 1;
}
int main()
{
    yyparse();
    return 0;
}