/*
 * Lab 10 - Flex scanner for the simple calculator.
 *
 * Author: riftbond007
 */

%{
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
%}

%%

[ \t\r]+       { }
\n             { return '\n'; }

[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)? { yylval.dval = atof(yytext); return NUMBER; }
[0-9]*\.[0-9]+([eE][+-]?[0-9]+)?    { yylval.dval = atof(yytext); return NUMBER; }

"+" { return '+'; }
"-" { return '-'; }
"*" { return '*'; }
"/" { return '/'; }
"(" { return '('; }
")" { return ')'; }

.   { return YYUNDEF; }

%%

int yywrap(void)
{
    return 1;
}