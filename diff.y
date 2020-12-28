%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <math.h>

int yylex();
int yyerror(char *);

double vars[10] = {0.0}; //记录出现了x0到x9的初始值
double dvars[10] = {0.0}; //记录出现了x0到x9的初始值
#define True 1
#define False 0
typedef struct CGraphNode{
    double dval;
    int leaf;
    double ledge;
    double redge;
    struct CGraphNode*left;
    struct CGraphNode*right;
    int x;
}CGraphNode,*CGraph;
void calculate(CGraph root);
void grad(CGraphNode *p);
CGraphNode *newNode(double dval,
                    int leaf,
                    double ledge,
                    double redge,
                    CGraphNode *left,
                    CGraphNode *right);
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
        void *posi;
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
            printf("val = %.6g\n",$<s.val>1);
            CGraph root = $<s.posi>1;
            calculate(root);
            for (i = 0; i < 10; i++)
                if (flag[i] == 1)
                    printf("f-PDF@x%d = %.6g\n", i,dvars[i]);
        }
    ;
func_def
    : 'f' '(' var_list ')' ':' expr
        {
            $<s.val>$ = $<s.val>6;
            $<s.posi>$ = newNode(1, False, 1, 0, $<s.posi>6, NULL);
            CGraph root = $<s.posi>$;
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
            CGraphNode *leaf = newNode(0, True, 0, 0, NULL, NULL);
            leaf->x = i;
            $<s.posi>$ = leaf;
        }
    | NUMBER
        {
            $<s.val>$ = $<s.val>1;
        }
    | expr '+' expr
        {
            $<s.val>$ = $<s.val>1 + $<s.val>3;
            $<s.posi>$ = newNode(0, False, 1, 1, $<s.posi>1, $<s.posi>3);
        }
    | expr '-' expr
        {
            $<s.val>$ = $<s.val>1 - $<s.val>3;
            $<s.posi>$ = newNode(0, False, 1, -1, $<s.posi>1, $<s.posi>3);
        }
    | expr '*' expr
        {
            $<s.val>$ = $<s.val>1 * $<s.val>3;
            double ledge,redge;
            ledge = $<s.val>3;
            redge = $<s.val>1;
            $<s.posi>$ = newNode(0, False, ledge, redge, $<s.posi>1, $<s.posi>3);
        }
    | expr '/' expr
        {
            $<s.val>$ = $<s.val>1 / $<s.val>3;
            double ledge,redge;
            ledge = 1 / $<s.val>3;
            redge = - $<s.val>1 / ($<s.val>3 * $<s.val>3);
            $<s.posi>$ = newNode(0, False, ledge, redge, $<s.posi>1, $<s.posi>3);
        }
    | '-' expr
        {
            $<s.val>$ = - $<s.val>2;
            $<s.posi>$ = newNode(0, False, -1, 0, $<s.posi>2, NULL);
        }
    | '(' expr ')'
        {
            $<s.val>$ = $<s.val>2;
            $<s.posi>$ = newNode(0, False, 1, 0, $<s.posi>2, NULL);
        }
    | expr '^' expr
        {
            $<s.val>$ = pow($<s.val>1, $<s.val>3);
            double ledge,redge;
            ledge = $<s.val>3 * pow($<s.val>1, $<s.val>3 - 1);
            redge = log($<s.val>1) * pow($<s.val>1, $<s.val>3);
            $<s.posi>$ = newNode(0, False, ledge, redge, $<s.posi>1, $<s.posi>3);
        }
    | EXP '(' expr ')'
        {
            $<s.val>$ = exp($<s.val>3);
            double ledge = $<s.val>$;
            $<s.posi>$ = newNode(0, False, ledge, 0, $<s.posi>3, NULL);
        }
    | LN '(' expr ')'
        {
            $<s.val>$ = log($<s.val>3);
            double ledge = 1 / $<s.val>3;
            $<s.posi>$ = newNode(0, False, ledge, 0, $<s.posi>3, NULL);
        }
    | SIN '(' expr ')'
        {
            $<s.val>$ = sin($<s.val>3);
            double ledge = cos($<s.val>3);
            $<s.posi>$ = newNode(0, False, ledge, 0, $<s.posi>3, NULL);
        }
    | COS '(' expr ')'
        {
            $<s.val>$ = cos($<s.val>3);
            double ledge = - sin($<s.val>3);
            $<s.posi>$ = newNode(0, False, ledge, 0, $<s.posi>3, NULL);
        }
    ;

%%

CGraphNode *newNode(double dval, int leaf, double ledge, double redge, CGraphNode *left, CGraphNode *right)
{
    CGraphNode *newNode = (CGraphNode *)malloc(sizeof(CGraphNode));
    newNode->dval = dval;
    newNode->leaf = leaf;
    newNode->ledge = ledge;
    newNode->redge = redge;
    newNode->left = left;
    newNode->right = right;
    return newNode;
}

void grad(CGraphNode *p)
{
    CGraphNode *left, *right;
    left = p->left;
    right = p->right;
    if (left)
    {
        left->dval = p->dval * p->ledge;
        grad(left);
    }
    if (right)
    {
        right->dval = p->dval * p->redge;
        grad(right);
    }
    if (p->leaf)
        dvars[p->x] += p->dval;
}

void calculate(CGraph root)
{
    int i;
    CGraphNode *p;
    for (i = 0; i < 10; i++)
        if (flag[i] == 1)
            dvars[i] = 0;
    grad(root);
}

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