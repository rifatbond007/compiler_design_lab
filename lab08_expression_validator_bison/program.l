/*
 * Lab 08 - Flex scanner for the expression validator.
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

[ \t]+         { }
\n             { return '\n'; }

[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)? { yylval.sval = strdup(yytext); return NUMBER; }
[0-9]*\.[0-9]+([eE][+-]?[0-9]+)?    { yylval.sval = strdup(yytext); return NUMBER; }

[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return IDENT; }

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