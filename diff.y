%{
#include <stdio.h>
#include <ctype.h>
#include <math.h>
///////
int yylex();
int yyerror(char *);
double vars[10]={0.0};
double last=0;
long var;
int i;
int flag=1;
%}

%token <s> NUMBER
%token <cv> VAR
%type <s> expr


%union
{
  double dv;
  char cv;
  struct {
        double val;
        double dval;
    } s;
}
%token '(' ')'
%token '+' '-' '*' '/' '^' '='
%token COS SIN LN EXP

%left '='
%left '+' '-'
%left '*' '/' '%'
%left COS SIN LN EXP
%left '^'
%right '(' ')'
%start REV_AutoDiff
//////////////






// need to choose token type from union above



%%

REV_AutoDiff
    : func_def
        {
            $<s.val>$ = $<s.val>1;
            printf("val = %.4lf\n",$<s.val>$);
        }
    ;
func_def
    : 'f' '(' var_list ')' ':' expr
        { $<s.val>$ = $<s.val>6; }
    ;
var_init
    : VAR '=' NUMBER
        {
            i = $1 - '0';
            if (i>=0 && i<=9)
                vars[i] = $<s.val>3;
            else
 			    vars[0] = $<s.val>3;
			flag =1;
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
            if (i>=0 && i<=9)
                $<s.val>$ = vars[i];
            else
                $<s.val>$ = vars[0];
		}
    | NUMBER
        { $<s.val>$ = $<s.val>1; }
    | expr '+' expr
        { $<s.val>$ = $<s.val>1 + $<s.val>3; }
    | expr '-' expr
        { $<s.val>$ = $<s.val>1 - $<s.val>3; }
    | expr '*' expr
        { $<s.val>$ = $<s.val>1 * $<s.val>3; }
    | expr '/' expr
        { $<s.val>$ = $<s.val>1 / $<s.val>3; }
    | '-' expr
        { $<s.val>$ = - $<s.val>2; }
    | '(' expr ')'
        { $<s.val>$ = $<s.val>2; }
    | expr '^' expr
        { $<s.val>$ = pow($<s.val>1, $<s.val>3); }
    | EXP '(' expr ')'
        { $<s.val>$ = exp($<s.val>3); }
    | LN '(' expr ')'
        { $<s.val>$ = log($<s.val>3); }
    | SIN '(' expr ')'
        { $<s.val>$ = sin($<s.val>3); }
    | COS '(' expr ')'
        { $<s.val>$ = cos($<s.val>3); }
    ;


%%
int yyerror(char *s)
{
  printf("%s\n", s);
  return 1;
}
int main() {
    yyparse();
    return 0;
}