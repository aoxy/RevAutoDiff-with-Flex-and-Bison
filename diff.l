%{
#include <stdlib.h>
#include <math.h>
#include "diff.tab.h"
extern int yyerror(const char *);
%}

%%

[" "; \t]   		                        { }
(0(\.[0-9]+)?)|([1-9][0-9]*(\.[0-9]+)?)     { yylval.s.val = strtod(yytext,0);return NUMBER;}
x[0-9]                                      { yylval.cv = *(yytext+1);  return VAR;}
[f\-+*=/()^,:\n]		                    {return *yytext;}
"exp"		                                {return EXP;}
"ln"		     		                    {return LN;}
"sin"                                       {return SIN;}
"cos"                                       {return COS;}

%%

int yywrap()
{
    return 1;
}